Symbol extend [
  proc [ ^[:obj| obj perform: self] ]
  with: arg [
    ^[:obj| obj perform: self withArguments: {arg}]
  ]
  on: obj [
    ^[:arg| obj perform: self withArguments: {arg}]
  ]
]

Object extend [
  tap: block [ block value: self ]
  ifNil: a ifNil: b [ ^(self ifNil: a) ifNil: b ]
  ifNil: a ifNil: b ifNil: c [ ^(self ifNil: a ifNil: b) ifNil: c ]
]

Behavior extend [
  createAccessor: sym [ self createGetter: sym; createSetter: sym. ]
  createSetter: sym [ self createSetMethod: (sym asString) ]
  createGetter: sym [ self createGetMethod: (sym asString) ]
]

Iterable extend [
  sum [ ^self inject: 0 into: [:sum :item| sum + item] ]
  product [ ^self inject: 1 into: [:sum :item| sum * item] ]
]

ArrayedCollection extend [
  ifEmpty: block [ ^self isEmpty ifTrue: block ifFalse: [self] ]
  ifNotEmpty: block [ ^self isNotEmpty ifTrue: block ifFalse: [self] ]
  isEmpty [ ^(self size == 0) ]
  isNotEmpty [ ^(self size == 0) not ]

  transposed [
    ^1 to: self first size collect: [:c|
      1 to: self size collect: [:r| (self at: r) at: c] ]
  ]

  slidingWindow: window [ ^self slidingWindow: window collect: [:x|x] ]
  slidingWindow: window collect: block [
    ^(1 to: self size) inject: {} into: [:list :start|
      |end|
      end := start + window - 1.
      (end <= self size)
        ifTrue: [ list copyWith: (block value: (self copyFrom: start to: end)). ]
        ifFalse: [ list ]
    ]
  ]

  withIndexRemoved: index [
    ^(self first: index - 1), (self copyFrom: index + 1 to: self size).
  ]
]
