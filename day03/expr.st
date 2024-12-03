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
