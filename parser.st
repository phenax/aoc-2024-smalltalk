
Error subclass: ParserError [
  ParserError class >> signal: message [
    ^self new messageText: message; signal.
  ]
]

Object subclass: Parser [
  |stream|

  Parser class >> new: inputStream [ ^super new initialize: inputStream ]
  initialize: inputStream [ stream := inputStream ]

  close [ ^stream close ]
  peek [ ^stream peek ]
  next [ ^stream next ]
  atEnd [ ^stream atEnd ]

  inject: init into: block [
    |state|
    state := init.
    [self atEnd] whileFalse: [
      self withRecovery: [ state := block value: state. ].
    ].
    self close.
    ^state.
  ]

  takeUntil0: block [
    |break acc|
    break := false.
    acc := ''.
    [break not] whileTrue: [
      (stream atEnd not and: [block value: self peek])
        ifTrue: [ acc := acc, self peek asString. self next. ]
        ifFalse: [ break := true ].
    ].
    ^acc
  ]
  takeUntil: block [
    ^self takeUntil: block onEmpty: [ParserError signal: 'take until empty']
  ]
  takeUntil: block onEmpty: err [
    ^(self takeUntil0: block) ifEmpty: err
  ]

  seperatedByChar: sep parse: parse [
    ^self seperatedBy: [:ch| ch = sep] parse: parse
  ]

  seperatedBy: isSep parse: parse [
    |break results|
    results := OrderedCollection new.
    break := false.
    [break] whileFalse: [
      |result|
      result := parse value.
      result
        ifNil: [break := true]
        ifNotNil: [
          (isSep value: self peek)
            ifTrue: [ self next ].
          results add: result.
        ].
    ].
    ^results asArray
  ]

  between: pStart and: pEnd parse: block [
    |result|
    pStart value.
    result := block value.
    pEnd value.
    ^result
  ]
  betweenChars: cStart and: cEnd parse: block [
    ^self between: [self char: cStart] and: [self char: cEnd]
      parse: block.
  ]

  char: ch [
    (self next = ch) ifFalse: [^ParserError signal: 'char parse error']
  ]

  withRecovery: block [
    |oldStream|
    oldStream := stream copy.
    [
      block value.
      oldStream close.
    ] on: ParserError do: [:e|
      stream close.
      stream := oldStream.
      self next.
    ].
  ]
]
