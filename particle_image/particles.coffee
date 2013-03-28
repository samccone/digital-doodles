window.requestAnimationFrame ||=
  window.webkitRequestAnimationFrame ||
  window.mozRequestAnimationFrame    ||
  window.oRequestAnimationFrame      ||
  window.msRequestAnimationFrame     ||
  (callback, element) ->
    window.setTimeout( ->
      callback(+new Date())
    , 1000 / 60)


window.flockingDots = []

abs = (n) ->
  (n^(n>>31))-(n>>31)

generateFlockingDots  = ->
  canvas = document.createElement 'canvas'
  canvas.setAttribute 'width', mask.width
  canvas.setAttribute 'height', mask.height
  canvas.style.position = "absolute"
  canvas.style['z-index'] = "-1"

  ctx = canvas.getContext '2d'
  ctx.drawImage mask, 0, 0
  data = ctx.getImageData 0, 0, mask.width, mask.height
  for y in [0 ... mask.height]
    for x in [0 ... mask.width]
      index = (y * mask.width + x) * 4
      if data.data[index + 3]
        flockingDots.push
          x: x
          y: y

  run()

mask = new Image

mask.onload = generateFlockingDots

run = () ->
  width             = mask.width
  height            = mask.height
  elm               = document.createElement 'canvas'
  pixelDensity      = window.devicePixelRatio || 1
  particles         = []
  elm.style.width   = width + "px"
  elm.style.height  = height + "px"

  elm.setAttribute 'width', width * pixelDensity
  elm.setAttribute 'height', height * pixelDensity

  ctx     = elm.getContext '2d'
  document.body.appendChild elm

  step = 90
  for i in [0 ... flockingDots.length] by step
    step = ~~(Math.random() * 70) + 30
    particles.push new Particle ctx, width, height, pixelDensity, i, 'rgba(254, 252, 0'
    particles.push new Particle ctx, width, height, pixelDensity, i, 'rgba(0, 143, 164'

  tick = ->
    requestAnimationFrame(tick)
    ctx.clearRect 0, 0, width * pixelDensity, height * pixelDensity
    for p in particles
      p.tick()

  tick()


class Particle
  constructor: (ctx, width, height, pixelDensity, i, color, velocity) ->
    @opacity  = 0
    @ctx      = ctx
    @x        = ~~(Math.random() * mask.width)
    @y        = ~~(Math.random() * mask.height)
    @idealSpot =
      x: flockingDots[i].x
      y: flockingDots[i].y
    @velocity =
      x: ((Math.random() * 3.5)+0.5) * @plusMinus @x, @idealSpot.x
      y: ((Math.random() * 3.5)+0.5) * @plusMinus @y, @idealSpot.y
    @color         = color
    @

  plusMinus: (from, to) ->
    if from > to then -1 else 1

  draw: ->
    @ctx.beginPath()
    @ctx.fillStyle = @color + ", #{if @opacity < 0.4 then @opacity+=0.0025})"
    @ctx.arc @x, @y, 2, 0, 2 * Math.PI
    @ctx.fill()
    @ctx.closePath()
    @

  tick: ->
    if abs(@x - @idealSpot.x) < 6
      @x = @idealSpot.x
      @velocity.x = 0
    else if abs(@y - @idealSpot.y) < 6
      @y = @idealSpot.y
      @velocity.y = 0
    else
      @x += @velocity.x
      @y += @velocity.y

    @draw()
    @

mask.src = "hex.png"