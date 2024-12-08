Challenge subclass: Day3 [
  setup [
    context useTestInput: true;
      testSolutions: #(161 48);
      solutions: #(174960292 56275602).
  ]
]

FileStream fileIn: 'day03/expr.st'.

Day3 extend [
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
