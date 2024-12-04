FileStream fileIn: 'utils.st'.
ctx := (Context new: 'day04')
  testSolutions: #(18 9);
  solutions: #(2344 1815);
  useTestInput: true.

Challenge subclass: Day4 [
  |lines rowSize colSize|

  loadInput: inputFile [
    lines := inputFile lines upToEnd.
    rowSize := lines size.
    colSize := lines first size.
  ]

  solve1 [
    "Number of times XMAS appears in the input (horizontal + veritical + diagonal)"
    ^(1 to: rowSize) sumWith: [:row|
      (1 to: colSize) sumWith: [:col|
        self countXMASAt: row column: col ] ].
  ]

  solve2 [
    "Number of times 2 MAS appears in the input in the shape of an X"
    ^(1 to: rowSize) sumWith: [:row|
      (1 to: colSize) count: [:col|
        self isMASCrossAt: row column: col ] ].
  ]

  countXMASAt: row column: col [
    ((self chatAt: row column:col) = $X) ifFalse: [ ^0 ].

    ^(-1 to: 1) sumWith: [:rdir|
      (-1 to: 1) count: [:cdir|
        self isMASInDirection: (rdir@cdir) row: row column: col ] ].
  ]

  isMASInDirection: dir row: row column: col [
    ((0 = dir x) & (0 = dir y)) ifTrue: [ ^false ].

    ^self checkSequence: {
      { $M . row + dir x       . col + dir y } .
      { $A . row + (2 * dir x) . col + (2 * dir y) } .
      { $S . row + (3 * dir x) . col + (3 * dir y) }
    }.
  ]

  isMASCrossAt: row column: col [
    |patterns|
    ((self chatAt: row column:col) = $A) ifFalse: [ ^false ].

    patterns := {
      {
        { { $M . row + 1 . col + 1 }. { $S . row - 1 . col - 1 }. }.
        { { $M . row - 1 . col - 1 }. { $S . row + 1 . col + 1 }. }.
      }.
      {
        { { $M . row - 1 . col + 1 }. { $S . row + 1 . col - 1 }. }.
        { { $M . row + 1 . col - 1 }. { $S . row - 1 . col + 1 }. }.
      }.
    }.

    ^patterns allSatisfy: [:pattern|
      pattern anySatisfy: (#checkSequence: on: self) ]
  ]

  checkSequence: steps [
    ^steps allSatisfy: [:step|
      |char row col|
      char := step first. row := step second. col := step third.
      (self isInBounds: row column: col)
        and: [ (self chatAt: row column: col) = char ]
    ].
  ]

  chatAt: row column: col [ ^lines row: row column: col ]

  isInBounds: r column: c [
    ^(r between: 1 and: rowSize) & (c between: 1 and: colSize)
  ]
]

ctx solve: Day4.
