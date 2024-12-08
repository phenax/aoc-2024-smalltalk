FileStream fileIn: 'extns.st'.
FileStream fileIn: 'utils.st'.
FileStream fileIn: 'parser.st'.

Object subclass: AOCEnvorinment [
  |context command|

  AOCEnvorinment class >> new [ ^super new initialize ]
  initialize [
    command := self parseArgs.
  ]

  run [
    command first caseOf: {
      #new -> [self createFromTemplate: command second].
      #run -> [self runChallenge: command second].
    }
  ]

  createFromTemplate: day [
    |templateFile contents dirName dir|
    templateFile := FileStream open: 'template.st' mode: FileStream read.
    contents := templateFile contents.
    templateFile close.

    dirName := './day', (self dayPadded: day).
    dir := File path: dirName.
    dir isDirectory
      ifTrue: [^self error: 'Already exists']
      ifFalse: [dir createDirectory].

    contents := contents copyReplacingAllRegex: '\{%aocDay%\}' with: day.

    ((dir / 'main.st') writeStream) nextPutAll: contents; close.
    (dir / 'input.txt') touch.
    (dir / 'test-input.txt') touch.

    ('Created ', dirName,' successfully') displayNl.
  ]

  runChallenge: day [
    |challengeClass dayPadded|
    dayPadded := self dayPadded: day.
    context := Context new: 'day',dayPadded.

    challengeClass := Autoload
      class: ('Day', day)
      asSymbol from: ('day', dayPadded, '/main.st').
    context solve: challengeClass.
  ]

  dayPadded: day [ ^day padStartWith: '0' toSize: 2 ]

  parseArgs [
    ^(Smalltalk arguments first) caseOf: {
      'new' -> [{ #new . Smalltalk arguments second }].
      [:s| s allSatisfy: #isDigit proc] -> [:first| { #run . first }].
    }
  ]
]

AOCEnvorinment new run.
