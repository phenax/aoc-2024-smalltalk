"Extensions to the standard library"

Symbol extend [
  proc [ ^[:obj| obj perform: self] ]
  with: arg [
    ^[:obj| obj perform: self withArguments: {arg}]
  ]
  on: obj [
    ^[:arg| obj perform: self withArguments: {arg}]
  ]
]

String extend [
  padStartWith: padd toSize: size [
    ^ (1 to: (size - self size)) inject: self into: [:s :x| padd,s].
  ]
]

Object extend [
  tap: block [ block value: self ]
  ifNil: a ifNil: b [ ^(self ifNil: a) ifNil: b ]
  ifNil: a ifNil: b ifNil: c [ ^(self ifNil: a ifNil: b) ifNil: c ]

  invoke: value [
    ((self respondsTo: #value:) and: [self numArgs > 0])
      ifTrue: [^self value: value].
    (self respondsTo: #value:) ifTrue: [^self value].
    ^self.
  ]

  caseOf: pattern [
    |fallback match|
    match := [:key|
      ((key respondsTo: #value:) or: [key respondsTo: #value])
        ifTrue: [key invoke: self]
        ifFalse: [key = self]
    ].
    pattern collect: [:assoc|
      (match value: assoc key) ifTrue: [^(assoc value) invoke: self].
      (assoc key = #_) ifTrue: [fallback := assoc value].
    ].
    ^fallback ifNotNil: [fallback invoke: self]
  ]
]

Behavior extend [
  createAccessor: sym [ self createGetter: sym; createSetter: sym. ]
  createSetter: sym [ self createSetMethod: (sym asString) ]
  createGetter: sym [ self createGetMethod: (sym asString) ]
]

Iterable extend [
  sumWith: block [ ^(self collect: block) sum ]
  sum [ ^self inject: 0 into: [:sum :item| sum + item] ]
  product [ ^self inject: 1 into: [:sum :item| sum * item] ]
  combinations: block [
    |res|
    res := self class new.
    self do: [:item1|
      self do: [:item2|
        item1 ~= item2
          ifTrue: [ res add: (block value: item1 value: item2) ].
      ].
    ].
    ^res.
  ]
]

Stream extend [
  nextTill: block [
    |collected|
    collected := OrderedCollection new.
    [self atEnd] whileFalse: [
      (block value: self peek)
        ifTrue: [ collected add: self next ]
        ifFalse: [ ^collected ]
    ].
    ^collected.
  ]
]

ArrayedCollection extend [
  ifEmpty: block [ ^self isEmpty ifTrue: block ifFalse: [self] ]
  ifNotEmpty: block [ ^self isNotEmpty ifTrue: block ifFalse: [self] ]
  isEmpty [ ^(self size == 0) ]
  isNotEmpty [ ^(self size == 0) not ]

  row: row column: col [ ^(self at: row) at: col ]
  row: row column: col put: value [
    |arr|
    arr := self at: row.
    arr at: col put: value.
  ]

  transposed [
    ^1 to: self first size collect: [:c|
      1 to: self size collect: [:r| self row: r column: c] ]
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

  copySafely: from [ ^self copySafelyFrom: from to: from ]
  copySafelyFrom: from to: to [
    self size < to ifTrue: [^self class new].
    ^self copyFrom: from to: to.
  ]
]

Boolean extend [
  or: a or: b [ ^(self or:a) or:b ]
  or: a or: b or: c [ ^(self or:a or:b) or:c ]
  or: a or: b or: c or: d [ ^(self or:a or:b or:c) or:d ]
]
