class Thread
  # Creates a new Thread environment.
  constructor: ->
    @vars = {}

  # Begins execution of a series of functions
  run: (@functions, @error) ->
    @functions = [@functions] unless @functions instanceof Array
    throw new Error 'Cannot run empty thread'  if @functions[0] is undefined
    @i = 0
    @continue()

  # Executes the next function.
  continue: (args...) =>
    if @i < @functions.length
      @functions[@i++](args...)
      true
    else
      false

  # Adds functions to be run when current functions are done.
  queue: (functions) ->
    functions = [functions]  unless functions instanceof Array
    @functions.push functions...

  queueAndContinue: (functions) ->
    @queue functions
    @continue()

  # Adds functions to be run next.
  stack: (functions) ->
    functions = [functions]  unless functions instanceof Array
    @functions.splice @i, 0, functions...
    @continue()

  stackAndContinue: (functions) ->
    @stack functions
    @continue()

module.exports = Thread
