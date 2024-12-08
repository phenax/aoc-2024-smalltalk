Object subclass: Challenge [
  |context|
  Challenge class >> new: context [ ^super new initialize: context ]
  initialize: ctx_ [
    context := ctx_.
    self setup.
    context withInputFile: (#loadInput: on: self).
  ]

  solve [
    |s1 s2|
    (self respondsTo: #solve1) ifTrue: [
      s1 := self solve1.
      'Part 1: ' display. s1 printNl.
      (context solutions first) ifNotNil: [
        self expect: s1 toEqual: context solutions first ].
    ].

    (self respondsTo: #solve2) ifTrue: [
      s2 := self solve2.
      'Part 2: ' display. s2 printNl.
      (context solutions second) ifNotNil: [
        self expect: s2 toEqual: context solutions second ].
    ].
  ]

  expect: left toEqual: right [
    (left == right)
      ifFalse: [^self error: left printString, ' is not equal to ', right printString].
  ]
]

Object subclass: Context [
  |ctxName useTestInput solutions testSolutions|

  Context class >> new: name [ ^super new initialize: name. ]
  initialize: name [ ctxName := name. ]

  solve: challenge [
    [(challenge new: self) solve]
      on: Error do: [:ex|
        Transcript cr; show: 'Error: ', ex messageText; cr; cr; flush.
        ex signalingContext backtrace.
        ObjectMemory quit: 1.
      ]
  ]

  solutions [
    ^(useTestInput ifTrue: [testSolutions] ifFalse: [solutions])
       ifNil: [#(nil nil)]
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
    fileName := useTestInput ifTrue: ['/test-input.txt'] ifFalse: ['/input.txt'].
    ^ctxName, fileName.
  ]

  openInputFile [
    ^FileStream open: self inputFileName mode: FileStream read
  ]
]
Context createSetter: #testSolutions;
        createSetter: #solutions;
        createSetter: #useTestInput.
