run_ day:
  time smalltalk --core-dump --no-gc-message {{day}}/main.st

run day:
  just run_ $(printf 'day%02d' {{day}});

watch day:
  nodemon --exec 'clear && just run {{day}}' -e .st

runall:
  find . -iname 'day*' | sort | xargs -i just run_ {}
