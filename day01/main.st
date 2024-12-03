FileStream fileIn: 'utils.st'.
ctx := (Context new: 'day01')
  testSolutions: #(11 31);
  solutions: #(2430334 28786472);
  useTestInput: true.

Challenge subclass: Day1 [
  |idList1 idList2|

  loadInput: inputFile [
    |lists inputPairs|
    inputPairs := inputFile lines collect: (#parseLine: on: self).
    lists := inputPairs upToEnd transposed.
    idList1 := lists first sorted.
    idList2 := lists second sorted.
  ]

  solve1 [
    "Total distance between the 2 lists of location ids"
    ^self distances sum
  ]

  solve2 [
    "Similarity score between the 2 lists of location ids"
    ^self occuranceCounts sum
  ]

  distances [
    ^idList1 with: idList2 collect: [:id1 :id2| (id1 - id2) abs]
  ]

  occuranceCounts [
    |count|
    ^idList1 collect: [:id1|
      count := idList2 count: [:id2| id1 = id2].
      id1 * count.
    ]
  ]

  parseLine: line [
    ^(line tokenize: '\s+') collect: #asNumber proc
  ]
]

ctx solve: Day1.
