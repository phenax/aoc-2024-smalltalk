Challenge subclass: Day9 [
  setup [
    context useTestInput: true;
      testSolutions: #(1928 2858);
      solutions: #(6211348208140 6239783302560).
  ]
]

Day9 extend [
  |blockFormat blockStructure|

  loadInput: inputFile [
    self parseInput: inputFile contents.
  ]

  solve1 [
    |compactFormat|
    compactFormat := self makeCompact: blockFormat.
    ^(1 to: compactFormat size) sumWith: [:index|
      |fileId|
      fileId := compactFormat at: index.
      fileId ifNil: [0] ifNotNil: [index - 1 * fileId]
    ]
  ]

  solve2 [
    ^self checksum: (self makeCompactWithoutFragmentation: blockStructure).
  ]

  makeCompactWithoutFragmentation: blockStructure [
    |blocks|
    blocks := blockStructure deepCopy.
    blocks size to: 1 by: -1 do: [:index|
      (blocks at: index) isNotFree
        ifTrue: [ self replaceFreeBlocks: blocks withIndex: index ].
    ].
    ^blocks.
  ]

  makeCompact: blockFormat [
    |blocks|
    blocks := blockFormat deepCopy.
    [
      |freeSpaceIndex lastItemIndex|
      1 to: blocks size do: [:index|
        |item|
        item := blocks at: index.
        (freeSpaceIndex isNil & item isNil) ifTrue: [freeSpaceIndex := index].
        item isNil ifFalse: [lastItemIndex := index].
      ].
      (freeSpaceIndex > lastItemIndex)
        ifTrue: [^blocks]
        ifFalse: [blocks swap: freeSpaceIndex with: lastItemIndex]
    ] repeat.
  ]

  replaceFreeBlocks: blocks withIndex: blockIndex [
    |freeBlock block|
    block := blocks at: blockIndex.
    1 to: blockIndex do: [:index|
      |item diff|
      item := blocks at: index.
      ((item isFree) & (item size >= block size)) ifTrue: [
        diff := item size - block size.

        "Swap without swapping (in-place update blocks)"
        item isFree: false; fileId: block fileId; size: block size.
        block isFree: true.

        "Add the free space back in after moved block"
        freeBlock := (Block new) fileId: 0; size: diff; isFree: true.
        blocks add: freeBlock afterIndex: index.
        ^self.
      ].
    ].
  ]

  checksum: blocks [
    |sum position|
    position := 0.
    sum := 0.
    blocks do: [:block|
      block isFree ifFalse: [
        1 to: block size do: [:pos|
          sum := sum + ((position + pos - 1) * block fileId).
        ].
      ].
      position := position + block size.
    ].
    ^sum.
  ]

  parseInput: input [
    blockFormat := OrderedCollection new.
    blockStructure := OrderedCollection new.
    1 to: input size do: [:index|
      |size isFree id|
      size := input at: index.
      isFree := index even.
      id := index // 2.
      size isDigit ifTrue: [
        blockStructure add:
          ((Block new) size: size digitValue; fileId: id; isFree: isFree).
        (1 to: size digitValue) do: [:n|
          blockFormat add: (isFree ifTrue: [nil] ifFalse: [id]).
        ].
      ].
    ].
  ]
]

Object subclass: Block [
  |size fileId isFree|

  isNotFree [ ^isFree not ]

  printOn: stream [
    "stream nextPutAll:
      ('Block[id=',fileId asString,'; size=',size asString,'',(isFree ifFalse: [''] ifTrue: ['; FREE']),']').
    "
    stream nextPutAll: '['.
    1 to: size do: [:x| stream nextPutAll: (isFree ifTrue: ['.'] ifFalse: [fileId asString]) ].
    stream nextPutAll: ']'.
  ]
]
Block createAccessor: #size;
      createAccessor: #fileId;
      createAccessor: #isFree.
