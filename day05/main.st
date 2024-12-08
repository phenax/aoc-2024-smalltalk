Challenge subclass: Day5 [
  setup [
    context useTestInput: true;
      testSolutions: #(143 123);
      solutions: #(6267 5184).
  ]
]

Day5 extend [
  |rules updates correctedUpdates|

  loadInput: inputFile [
    |contents|
    contents := inputFile lines splitAt: ''.
    rules := contents first collect: [:r| (r tokenize: '\|') collect: #asNumber proc ].
    updates := contents second collect: [:r| (r tokenize: ',') collect: #asNumber proc ].
  ]

  solve1 [
    "Sum of middle pages for all the updates that follow the rules"
    ^self sumOfMiddlePages: self validUpdates.
  ]

  solve2 [
    "Sum of middle pages for the invalid updates after being correctly sorted"
    ^self sumOfMiddlePages: self correctedInvalidUpdates.
  ]

  validUpdates [
    ^self correctedUpdates with: updates collect: [:corrected :update|
      (corrected ~= update) ifTrue: [nil] ifFalse: [update] ].
  ]

  correctedInvalidUpdates [
    ^self correctedUpdates with: updates collect: [:corrected :update|
      (corrected = update) ifTrue: [nil] ifFalse: [corrected] ].
  ]

  correctedUpdates [
    correctedUpdates ifNotNil: [^correctedUpdates].

    ^correctedUpdates := updates collect: [:update|
      update sorted: [:a :b| rules includes: {a . b}] ].
  ]

  sumOfMiddlePages: pageUpdates [
    ^pageUpdates sumWith: [:update|
      update
        ifNil: [0]
        ifNotNil: [update at: (1 + update size // 2)]
    ]
  ]
]
