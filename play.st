a := 'foobar'.
b := (5 > 2) ifTrue: ['yes'] ifFalse: ['no'].
Transcript show: a; space; show: b; cr.

c := #(1 2 3 4 5 6 7 8) select: [:x | x > 3 and: [x < 8]].
c at: 1 put: -1.
c := c collect: [:x | x + 1].
c := c perform: #collect: withArguments: (Array with: [:x | x + 1]).
Transcript show: c printString; cr.

d := 5@(-2@-5).
Transcript show: d printString; cr.

Object subclass: Animal [
  |name age|

  Animal class >> new: n age: a [
    ^super new initialize: n age: a.
  ]
  Animal class >> new: n [
    ^super new initialize: n age: 0.
  ]

  printOn: stream [
    super printOn: stream.
    stream nextPutAll: ' named '.
    stream nextPutAll: name.
    stream nextPutAll: ' who is '.
    stream nextPutAll: age printString.
    stream nextPutAll: ' years old'.
  ]

  initialize: n age: a [
    name := n.
    age := a.
  ]
]

Animal subclass: Dog [
  bark [
    Transcript show: '"Bark!" - '; show: name; cr.
  ]
]

|dog|
dog := Dog new: 'Ozzy' age: 3.

Transcript show: dog printString; cr.

dog bark.

