threads
=======

Stateful JavaScript serial async management.

Threads gives functions in a serial async chain control of the entire flow with a `Thread` object and access to a thread-wide namespace, `Thread#vars`. Threads gives you a superset of controls that are possible with callbacks, but it plays nicely with callbacks too. Simply pass `Thread#continue` as a callback to traditional async functions.

```coffee
fetchSomeDataWithCallback = (who, callback) ->
  if who == 'you'  then callback 'pretty cool'
  else  callback 'not as cool'

t = new Thread
t.run [
  # STEP 1
  ->
    setTimeout ->
      t.vars.who = 'you'
      t.continue()
    , 500
  # STEP 2
  ->
    fetchSomeDataWithCallback(t.vars.who, t.continue)
  # STEP 3
  (returnedData) ->
    console.log "results of computation: #{t.vars.who}: #{returnedData}"
    t.continue()
]
```

Always forgetting to write callbacks? Threads keeps track of unfinished threads, allowing you to figure out which callbacks are missing.

```coffee
t = new Thread 'thread-that-forgot-to-finish'
t.run -> # do nothing, conveniently forgetting to t.continue()

# Hm, did we forget to finish executing any threads?
console.log "#{Thread.current.length} threads haven't finished!"
console.log "The first one is named #{Thread.current[0]?.name}."
console.log "Perhaps you should go fix that."
```

Threads is curently written in CoffeeScript, but of course you can compile it all to JavaScript.
