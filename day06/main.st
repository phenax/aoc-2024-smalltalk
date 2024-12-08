Challenge subclass: Day6 [
  setup [
    context useTestInput: true;
      testSolutions: #(41 6);
      solutions: #(5131 nil).
  ]
]

Day6 extend [
  |grid guardStartPosition guardStartDirection|

  loadInput: inputFile [
    grid := inputFile lines upToEnd.
    guardStartPosition := 0.
    guardStartDirection := #up.

    1 to: grid size do: [:row|
      |col|
      col := (grid at: row) indexOf: $^.
      col > 0 ifTrue: [guardStartPosition := {row . col}]
    ].
  ]

  solve1 [
    "Number of points visited by the guard"
    |visited|
    visited := Set new.

    self walkThroughGrid: grid
      do: [:pos :dir :stop| visited add: pos].

    ^visited size.
  ]

  solve2 [
    "Number of points to place an obstruction that cause the guards path to become a loop"
    |loopedObstructions|
    loopedObstructions := Set new.

    self walkThroughGrid: grid do: [:position :direction :stop|
      |obstructedGrid nextPos|
      nextPos := self move: position inDirection: direction.
      obstructedGrid := self withAddedObstruction: grid at: nextPos.
      (self isLooped: obstructedGrid)
        ifTrue: [ loopedObstructions add: nextPos ].
    ].

    ^loopedObstructions size.
  ]

  withAddedObstruction: grid at: pos [
    |newGrid|
    (self isOutOfBounds: grid at: pos) ifTrue: [^grid].
    (self isObstructed: grid at: pos) ifTrue: [^grid].

    ^grid deepCopy row: pos first column: pos second put: $#.
  ]

  isLooped: grid [
    |visited|
    visited := Set new.
    self walkThroughGrid: grid do: [:position :direction :stop|
      (visited includes: (position,{direction}))
        ifTrue: [^true].
      visited add: (position,{direction}).
    ].

    ^false.
  ]

  walkThroughGrid: grid do: onVisit [
    |direction position stop|
    direction := guardStartDirection.
    position := guardStartPosition.

    stop := [^nil].

    onVisit value: position value: direction value: stop.

    [true] whileTrue: [
      |nextPos|
      nextPos := self move: position inDirection: direction.
      (self isOutOfBounds: grid at: nextPos) ifTrue: stop.

      (self isObstructed: grid at: nextPos)
        ifTrue: [ direction := self rotate: direction ]
        ifFalse: [
          onVisit value: nextPos value: direction value: stop.
          position := nextPos.
        ].
    ].
  ]

  isObstructed: grid at: pos [
    ^(grid row: (pos first) column: (pos second)) = $#.
  ]

  isOutOfBounds: grid at: pos [
    ^((pos first between: 1 and: grid size) and: [pos second between: 1 and: grid size]) not.
  ]

  move: pos inDirection: dir [
    ^dir caseOf: {
      #up    -> [{pos first - 1 . pos second}].
      #down  -> [{pos first + 1 . pos second}].
      #left  -> [{pos first     . pos second - 1}].
      #right -> [{pos first     . pos second + 1}].
    }.
  ]

  rotate: dir [
    ^dir caseOf: {
      #up    -> [#right].
      #right -> [#down].
      #down  -> [#left].
      #left  -> [#up].
    }.
  ]

  printGrid: grid [
    grid do: [:row|
      row do: #display proc.
      '' displayNl.
    ].
    '' displayNl.
  ]
]
