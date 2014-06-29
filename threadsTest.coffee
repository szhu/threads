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

