run:
  smalltalk --core-dump --no-gc-message day_1/main.st

watch:
  bunx nodemon --exec 'clear && just run' -e .st
