FileStream fileIn: 'utils.st'.
ctx := (Context new: 'day03')
  testSolutions: #(161 48);
  solutions: #(174960292 56275602);
  useTestInput: true.

Challenge subclass: Day3 [
  |expressions|

  loadInput: inputFile [
    expressions := self parse: (inputFile contents).
  ]

  solve1 [
    "Evaluate all `mul` instructions"
    ^self evaluateAll result
  ]

  solve2 [
    "Evaluate `mul` instructions only if enabled (controlled via do & don't instructions)"
    ^self evaluateIfEnabled result
  ]

  evaluateAll [
    ^State new alwaysEnabled tap:
      [:state| expressions do: (#evaluate: with: state) ]
  ]

  evaluateIfEnabled [
    ^State new tap:
      [:state| expressions do: (#evaluate: with: state) ]
  ]

  parse: expression [
    |exprs|
    exprs := OrderedCollection new: 0.
    expression allOccurrencesOfRegex: '(mul|do|don['']t)(\(\)|\((\d+(,\d+)*)\))' do: [:result|
      exprs add: (self tokensToExpr: result asArray).
    ].
    ^exprs reject: #isNil proc
  ]

  tokensToExpr: tokens [
    ^(MulExpr fromTokens: tokens)
      ifNil: [DoExpr fromTokens: tokens]
      ifNil: [DontExpr fromTokens: tokens]
  ]
]

Object subclass: State [
  |result enabled alwaysEnabled|
  State class >> new [ ^super new initialize ]
  initialize [
    enabled := true.
    result := 0.
    alwaysEnabled := false.
  ]
  alwaysEnabled [ alwaysEnabled := true ]
  enabled [ ^alwaysEnabled | enabled ]
]
State createSetter: #enabled;
      createAccessor: #result.

Object subclass: Expr []

Expr subclass: MulExpr [
  |num1 num2|
  MulExpr class >> fromTokens: tokens [
    ^(tokens first = 'mul' and: [tokens size >= 3]) ifTrue: [
      |nums|
      nums := (tokens third tokenize: ',') collect: #asNumber proc.
      (nums size == 2) ifTrue: [ MulExpr new: nums ]
    ]
  ]
  MulExpr class >> new: nums [ ^super new initialize: nums. ]
  initialize: nums [ num1 := nums first. num2 := nums second. ]

  evaluate: state [
    (state enabled)
      ifTrue: [ state result: state result + (num1 * num2) ].
  ]
]

Expr subclass: DoExpr [
  DoExpr class >> fromTokens: tokens [
    ^(tokens first = 'do') ifTrue: [ DoExpr new ]
  ]
  evaluate: state [ state enabled: true. ]
]

Expr subclass: DontExpr [
  DontExpr class >> fromTokens: tokens [
    ^(tokens first = 'don''t') ifTrue: [ DontExpr new ]
  ]
  evaluate: state [ state enabled: false ]
]

ctx solve: Day3.
