Thread = require './threads'

# In both examples, the numbers should be logged in ascending order.

t = new Thread 'test1'
t.run [
  ->
    console.log 1
    t.queue [
      ->
        console.log 5
        t.continue()
      ->
        console.log 6
        t.continue()
    ]
    t.stack ->
      console.log 2
      t.continue()
    t.continue()
  ->
    console.log 3
    t.stackAndContinue ->
      console.log 4
      t.continue()
]


console.log '----------'


t = new Thread 'test2'
t.run [
  ->
    console.log 1
    t.stackAndContinue [
      ->
        console.log 2
        t.continue()
      ->
        console.log 3
        t.continue()
    ]
]
try
  # Shouldn't be able to continue already terminated thread.
  t.continue()
catch e
  console.log e


console.log '----------'


t = new Thread 'thread-that-forgot-to-finish'
t.run ->

# Hm, did we forget to finish executing any threads?
console.log "#{Thread.current.length} threads haven't finished!"


console.log '----------'

fetchSomeDataWithCallback = (who, callback) ->
  if who == 'you'  then callback 'pretty cool'
  else  callback 'not as cool'

t = new Thread 'features-demo'
t.run [
  ->
    setTimeout ->
      t.vars.who = 'you'
      t.continue()
    , 500
  ->
    fetchSomeDataWithCallback(t.vars.who, t.continue)
  (returnedData) ->
    console.log "results of computation: #{t.vars.who}: #{returnedData}"
    t.continue()
]

