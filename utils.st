Object subclass: #Utils.
Utils class extend []

Symbol extend [
  proc [
    ^[:x| x perform: self]
  ]

  on: obj [
    ^[:x| obj perform: self withArguments: (Array with: x)]
  ]
]

Array extend [
  sum [
    ^self inject: 0 into: [:sum :item| sum + item]
  ]

  transposed [
    ^1 to: self first size collect: [:c|
      1 to: self size collect: [:r| (self at: r) at: c] ]
  ]
]

Object subclass: Challenge [
  |ctx|
  Challenge class >> new: ctx [ ^super new initialize: ctx ]
  initialize: ctx_ [
    ctx := ctx_.
    ctx withInputFile: (#loadInput: on: self).
  ]

  solve [
    |s1 s2|
    (self respondsTo: #solve1) ifTrue: [
      s1 := self solve1.
      'Part 1: ' display. s1 printNl.
      self expect: s1 toEqual: ctx solutions first.
    ].

    (self respondsTo: #solve2) ifTrue: [
      s2 := self solve2.
      'Part 2: ' display. s2 printNl.
      self expect: s2 toEqual: ctx solutions second.
    ].
  ]

  expect: left toEqual: right [
    (left == right) ifFalse: [^self error: left printString, ' is not equal to ', right printString].
  ]
]

Object subclass: Context [
  |ctxName testInput solutions testSolutions|

  Context class >> new: name [ ^super new initialize: name. ]
  initialize: name [ ctxName := name. ]
  useTestInput: test [ testInput := test. ]
  solutions: sol [ solutions := sol ]
  testSolutions: testSol [testSolutions := testSol ]

  solve: challenge [ (challenge new: self) solve. ]

  solutions [
    ^(testInput ifTrue: [testSolutions] ifFalse: [solutions])
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
    fileName := testInput ifTrue: ['/test-input.txt'] ifFalse: ['/input.txt'].
    ^ ctxName, fileName.
  ]

  openInputFile [ ^FileStream open: self inputFileName mode: FileStream read ]
]
