Challenge subclass: Day11 [
  setup [
    context useTestInput: false;
      testSolutions: #(55312 nil);
      solutions: #(186175 220566831337810).
  ]
]

Day11 extend [
  |stones memoizedBlinks|
  loadInput: inputFile [
    stones := (inputFile contents tokenize: '\s+') collect: #asNumber proc.
    memoizedBlinks := LookupTable new.
  ]

  solve1 [
    ^self blinkTimes: 25.
  ]

  solve2 [
    ^self blinkTimes: 75.
  ]

  blinkTimes: times [
    |newStones|
    newStones := (1 to: times) inject: stones into: [:stones :n| self blink: stones].
    ^newStones size.
  ]

  blink: stones [
    ^stones
      injectWith: Bag new
      flattenedInto: (#blinkStoneMemoized: on: self)
  ]

  blinkStoneMemoized: stone [
    memoizedBlinks at: stone ifPresent: [:value| ^value].
    ^(self blinkStone: stone) tap: [:result|
      memoizedBlinks at: stone put: result.
    ].
  ]

  blinkStone: stone [
    ^stone caseOf: {
      0 -> [1].
      [stone asString size even] -> [self splitDigits: stone].
      #_ -> [stone * 2024].
    }.
  ]

  splitDigits: num [
    |numDigits div|
    numDigits := num asString size.
    div := 10 raisedToInteger: (numDigits / 2).
    ^ { num // div . num \\ div }.
  ]
]
