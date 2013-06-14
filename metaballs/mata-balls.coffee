MAX_THRESHOLD = 1
MIN_THRESHOLD = 0.93
canvas        = null
balls         = []
ctx           = null

class Metaball
  constructor: (x, y, rad) ->
    @x    = x
    @y    = y
    @rad  = rad
    @generateVelocity()

  generateVelocity: ->
    @vx = if ~~(Math.random() * 2) then -1 * Math.random() else Math.random()
    @vy = if ~~(Math.random() * 2) then -1 * Math.random() else Math.random()

  tick: ->
    @x += @vx
    @y += @vy

  calc: (x, y) -> @rad / ( (@x-x)*(@x-x) + (@y-y)*(@y-y) ) 

drawPixel = (x, y) ->
  ctx.fillRect(x, y, 1, 1);

build = ->
  for i in [0...3]
    balls.push new Metaball canvas.width * Math.random(), canvas.height * Math.random(), 2000

  drawMetaballs()

drawMetaballs = ->
  ctx.clearRect(0, 0, canvas.width, canvas.height)
  ctx.fillStyle = "rgb(255, 255, 255)"
  sum = 0

  #Iterate over every pixel on the screen 
  for y in [0 ... canvas.height]
    for x in [0 ... canvas.width]
      sum = 0
      #Iterate through every Metaball in the world 
      for i in [0 ... balls.length]
        if balls[i]?
          sum += balls[i].calc(x,y)
          #Decide whether to draw a pixel 
          if sum >= MIN_THRESHOLD and sum <= MAX_THRESHOLD
            drawPixel(x, y, sum)

  for i in [0 ... balls.length]
    balls[i].tick()

  requestAnimationFrame(drawMetaballs)



# kick it all off
window.onload = ->
  gui = new dat.GUI()
  gui.add(@, "MAX_THRESHOLD", 0.01, 2).step(0.01)
  gui.add(@, "MIN_THRESHOLD", 0.01, 1).step(0.01)

  canvas = document.createElement 'canvas'
  canvas.setAttribute 'width', 800
  canvas.setAttribute 'height', 400
  ctx = canvas.getContext '2d'
  document.body.appendChild canvas
  build()


window.requestAnimationFrame ||=
  window.webkitRequestAnimationFrame ||
  window.mozRequestAnimationFrame    ||
  window.oRequestAnimationFrame      ||
  window.msRequestAnimationFrame     ||
  (callback, element) ->
    window.setTimeout( ->
      callback(+new Date())
    , 1000 / 60)

