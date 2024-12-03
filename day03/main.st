FileStream fileIn: 'utils.st'.
ctx := (Context new: 'day03')
  testSolutions: #(161 48);
  solutions: #(174960292 56275602);
  useTestInput: true.

Challenge subclass: Day3 [
  |expressions|

  loadInput: inputFile [
    expressions := self parse: inputFile contents readStream.
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

  "I refuse to use regex even if it costs me my soul"
  parse: stream [
    |parser|
    parser := Parser new: stream.

    ^parser inject: {} into: [:exprs|
      |op args|
      op := parser takeUntil: [:c| c isLetter | (c == $') ].

      args := parser betweenChars: $( and: $)
        parse: [ self parseArgList: parser ].

      exprs, {self tokensToExpr: {op . args}}
    ].
  ]

  parseArgList: parser [
    |args|
    args := parser seperatedByChar: $, parse: [ self parseArg: parser ].
    ^(args reject: #isEmpty proc) collect: #asNumber proc.
  ]

  parseArg: parser [
    (parser peek == $)) ifTrue: [^nil].
    ^(parser takeUntil0: #isDigit proc) ifEmpty: [nil].
  ]

  tokensToExpr: tokens [
    ^(MulExpr fromTokens: tokens ifInvalid: [ ^ParserError signal: 'Invalid args for mul' ])
      ifNil: [ DoExpr fromTokens: tokens ifInvalid: [ ^ParserError signal: 'Invalid args for do' ] ]
      ifNil: [ DontExpr fromTokens: tokens ifInvalid: [ ^ParserError signal: 'Invalid args for don''t' ] ]
      ifNil: [ ^ParserError signal: 'Invalid method' ]
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
  MulExpr class >> opName [ ^'mul' ]
  MulExpr class >> new: nums [ ^super new initialize: nums. ]
  MulExpr class >> fromTokens: tokens ifInvalid: block [
    (tokens first = self opName) ifFalse: [^nil].
    (tokens second size = 2) ifFalse: [^block value].
    ^MulExpr new: tokens second
  ]

  initialize: nums [ num1 := nums first. num2 := nums second. ]
  evaluate: state [
    (state enabled) ifTrue:
      [ state result: state result + (num1 * num2) ].
  ]
]

Expr subclass: DoExpr [
  DoExpr class >> opName [ ^'do' ]
  DoExpr class >> fromTokens: tokens ifInvalid: block [
    (tokens first = self opName) ifFalse: [^nil].
    (tokens second size = 0) ifFalse: [^block value].
    ^DoExpr new
  ]

  evaluate: state [ state enabled: true. ]
]

Expr subclass: DontExpr [
  DontExpr class >> opName [ ^'don''t' ]
  DontExpr class >> fromTokens: tokens ifInvalid: block [
    (tokens first = self opName) ifFalse: [^nil].
    (tokens second size = 0) ifFalse: [^block value].
    ^DontExpr new
  ]

  evaluate: state [ state enabled: false ]
]

ctx solve: Day3.
