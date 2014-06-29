# Methods are all fat arrow so that they can be passed as callback functions.

class Thread
  # Creates a new Thread environment.
  constructor: (@name) ->
    @vars = {}
    @running = false

  # Begins execution of a series of functions
  run: (@functions, @errorFunction) =>
    @functions = [@functions]  unless @functions instanceof Array
    throw new Error "Cannot run empty thread"  if @functions[0] is undefined
    @i = 0
    @_unfinish()
    @continue()

  # Executes the next function.
  continue: (args...) =>
    if @i < @functions.length  then @functions[@i++](args...)
    else @_finish()

  # Terminates execution and calls the error function.
  error: (args...) =>
    console.warn "Error function doesn't exist for thread"
    @errorFunction args...
    @_finish()

  # Terminates execution without doing anything else.
  done: =>
    @_finish()

  # Not meant to be called directly.
  _unfinish: ->
    @running = true
    current = @.constructor.current
    current.push @

  # Not meant to be called directly.
  _finish: ->
    unless @running  then throw new Error "Can't continue terminated thread."
    @running = false
    current = @.constructor.current
    if (t = current.indexOf @) > -1  then current[t..t] = []
    else  throw new Error "Internal error: Can't remove from unfinished list. Have thread.running or Thread.current been manually modified?"

  # Adds functions to be run when current functions are done.
  queue: (functions) =>
    functions = [functions]  unless functions instanceof Array
    @functions.push functions...

  # In most cases, @continue is done right after @queue.
  queueAndContinue: (functions) =>
    @queue functions
    @continue()

  # Adds functions to be run next.
  stack: (functions) =>
    functions = [functions]  unless functions instanceof Array
    @functions.splice @i, 0, functions...

  # In most cases, @continue is done right after @stack.
  stackAndContinue: (functions) =>
    @stack functions
    @continue()

  @current = []

module.exports = Thread
