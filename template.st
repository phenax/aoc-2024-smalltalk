Challenge subclass: Day{%aocDay%} [
  setup [
    context useTestInput: true;
      testSolutions: #(nil nil);
      solutions: #(nil nil).
  ]
]

Day{%aocDay%} extend [
  loadInput: inputFile [
    "load input"
  ]

  solve1 [
    ^0
  ]

  solve2 [
    ^0
  ]
]
