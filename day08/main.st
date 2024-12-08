Challenge subclass: Day8 [
  setup [
    context useTestInput: true;
      testSolutions: #(14 34);
      solutions: #(289 1030).
  ]
]

Day8 extend [
  |antennasByFrequencyLabel rows columns|

  loadInput: inputFile [
    self parseInputLines: inputFile lines upToEnd.
  ]

  solve1 [
    "Number of first-harmonic antinodes between pairs of antennas with the same frequency"
    ^self firstHarmonicAntinodes size
  ]

  solve2 [
    "Number of n-harmonic antinodes between pairs of antennas with the same frequency"
    ^self allHarmonicAntinodes size
  ]

  allHarmonicAntinodes [
    ^self foldAntennasPairs: Set new into: [:antinodes :a1 :a2|
      antinodes
        + ((a1 harmonicAntinodesWith: a2) nextTill: (#isInBounds: on: self))
        + ((a2 harmonicAntinodesWith: a1) nextTill: (#isInBounds: on: self))
    ].
  ]

  firstHarmonicAntinodes [
    ^self foldAntennasPairs: Set new into: [:antinodes :a1 :a2|
      |antinodes1 antinodes2|
      antinodes1 := (a1 harmonicAntinodesWith: a2) skip: 1; next: 1.
      antinodes2 := (a2 harmonicAntinodesWith: a1) skip: 1; next: 1.
      antinodes
        + (antinodes1 select: (#isInBounds: on: self))
        + (antinodes2 select: (#isInBounds: on: self)).
    ].
  ]

  foldAntennasPairs: init into: block [
    |result visited|
    result := init.
    visited := Set new.
    antennasByFrequencyLabel keysAndValuesDo: [:name :antennas|
      antennas combinations: [:a1 :a2|
        (visited includes: {a1 . a2}) ifFalse: [
          result := block value: result value: a1 value: a2.
          visited add: {a2 . a1}.
        ]
      ].
    ].
    ^result.
  ]

  isInBounds: pos [
    ^(pos x between: 1 and: columns) & (pos y between: 1 and: rows).
  ]

  parseInputLines: lines [
    rows := lines size.
    columns := lines first size.
    antennasByFrequencyLabel := LookupTable new.
    1 to: rows do: [:row|
      1 to: columns do: [:col|
        |name|
        name := lines row: row column: col.
        name ~= $. ifTrue: [
          |antennas|
          antennas := (antennasByFrequencyLabel at: name ifAbsent: [Set new.])
            tap: (#add: with: (Antenna new: name at: col@row)).
          antennasByFrequencyLabel add: name->antennas.
        ].
      ].
    ].
  ]
]

Object subclass: Antenna [
  |label position|
  Antenna class >> new: label at: position [ ^super new initialize: label at: position ]
  initialize: l at: p [ label := l. position := p ]

  harmonicAntinodesWith: antenna [
    |lastAntinode|
    lastAntinode := position.
    ^Generator on: [:generator|
      [true] whileTrue: [
        generator yield: lastAntinode.
        lastAntinode := lastAntinode + (position - antenna position).
      ].
    ]
  ]
]
Antenna createGetter: #label; createGetter: #position.
