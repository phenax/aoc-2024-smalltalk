Challenge subclass: Day2 [
  setup [
    context useTestInput: true;
      testSolutions: #(2 4);
      solutions: #(524 569).
  ]
]

Day2 extend [
  |reports|

  loadInput: inputFile [
    |inputLines|
    inputLines := inputFile lines collect: (#parseLine: on: self).
    reports := inputLines upToEnd.
  ]

  solve1 [
    "Number of safe reports"
    ^reports count: (#isReportSafe: on: self)
  ]

  solve2 [
    "Number of safe reports with problem dampener"
    ^reports count: (#isReportSafeWithDampener: on: self)
  ]

  isReportSafe: report [
    ^(self graduallyIncreasing: report) or: [self graduallyDecreasing: report].
  ]

  isReportSafeWithDampener: report [
    ^(1 to: report size)
      anySatisfy: [:index| self isReportSafe: (report withIndexRemoved: index) ].
  ]

  graduallyIncreasing: report [
    ^(self changesIn: report)
      allSatisfy: [:change | change >= 0 and: [change between: 1 and: 3]]
  ]

  graduallyDecreasing: report [
    ^(self changesIn: report)
      allSatisfy: [:change | change <= 0 and: [change between: -3 and: -1]]
  ]

  changesIn: report [
    ^report slidingWindow: 2 collect: [:nums| nums first - nums second]
  ]

  parseLine: line [
    ^(line tokenize: '\s+') collect: #asNumber proc
  ]
]
