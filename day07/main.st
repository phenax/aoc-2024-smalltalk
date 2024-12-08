Challenge subclass: Day7 [
  setup [
    context useTestInput: true;
      testSolutions: #(3749 11387);
      solutions: #(8401132154762 95297119227552).
  ]
]

Day7 extend [
  |input operations|

  loadInput: inputFile [
    input := inputFile lines upToEnd collect: (#parseLine: on: self).
  ]

  solve1 [ ^self totalCalibrationResult: {#mul . #sum} ]

  solve2 [ ^self totalCalibrationResult: {#mul . #sum . #concat} ]

  totalCalibrationResult: opSet [
    ^input inject: 0 into: [:sum :input|
      |result values isValid|
      result := input first.
      values := input second.
      isValid := (self generateOperationsList: values size operations: opSet)
        anySatisfy: [:ops| result = (self evaluate: values operations: ops) ].

      isValid ifTrue: [sum + result] ifFalse: [sum].
    ].
  ]

  evaluate: values operations: ops [
    ^ (1 to: values size) inject: 0 into: [:result :index|
      (index = 1)
        ifTrue: [values at: index]
        ifFalse: [
          self operate: result
               with: (values at: index)
               operation: (ops at: (index - 1)).
        ]
    ].
  ]

  operate: v1 with: v2 operation: op [
    ^op caseOf: {
      #mul -> [v1 * v2].
      #sum -> [v1 + v2].
      #concat -> [
        "(v1 asString, v2 asString) asInteger."
        (v1 * (10 raisedToInteger: ((v2 log: 10) floor + 1))) + v2
      ].
    }
  ]

  generateOperationsList: operandCount operations: opSet [
    |totalCombinations raisedTo opSetSize|
    opSetSize := opSet size.
    totalCombinations := opSetSize raisedToInteger: operandCount - 1.
    raisedTo := (0 to: operandCount - 2) collect: [:op| opSetSize raisedToInteger: op].

    ^(1 to: totalCombinations) collect: [:count|
      (0 to: operandCount - 2) collect: [:op|
        |index|
        index := count - 1 // (raisedTo at: op + 1) \\ opSetSize + 1.
        opSet at: index
      ].
    ].
  ]

  parseLine: line [
    |parts numbers|
    parts := line tokenize: ':\s*'.
    numbers := (parts second tokenize: '\s+') collect: #asNumber proc.
    ^{parts first asNumber . numbers}.
  ]
]
