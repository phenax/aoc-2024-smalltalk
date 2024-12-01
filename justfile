run day:
  smalltalk --core-dump --no-gc-message day{{day}}/main.st

watch day:
  bunx nodemon --exec 'clear && just run {{day}}' -e .st
