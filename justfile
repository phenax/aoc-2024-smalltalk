main *args:
  smalltalk --no-gc-message main.st -a {{args}}

run day:
  time just main {{day}}

watch day:
  nodemon --exec 'clear && just run {{day}}' -e .st

runall:
  find . -iname 'day*' | sed 's/^.*day0*//' | sort | xargs -i just run {}
