Object subclass: Context [
  |ctxName testInput|

  Context class >> new: name useTestInput: test [
    ^super new initialize: name useTestInput: test
  ]

  initialize: name useTestInput: test [
    ctxName := name.
    testInput := test.
  ]

  withInputFile: block [
    |file res|
    file := self openInputFile.
    res := block value: file.
    file close.
    ^res
  ]

  inputFileName [
    |fileName|
    fileName := testInput ifTrue: ['/test-input.txt'] ifFalse: ['/input.txt'].
    ^ ctxName, fileName.
  ]

  openInputFile [
    ^FileStream open: self inputFileName mode: FileStream read
  ]
]
