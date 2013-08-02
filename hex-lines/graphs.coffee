window.requestAnimationFrame ||=
  window.webkitRequestAnimationFrame ||
  window.mozRequestAnimationFrame    ||
  window.oRequestAnimationFrame      ||
  window.msRequestAnimationFrame     ||
  (callback, element) ->
    window.setTimeout( ->
      callback(+new Date())
    , 1000 / 60)


window.onmousemove = (e) ->
  @mouse =
    x: e.x * @pixelDensity
    y: e.y * @pixelDensity

class Particle
  constructor: ->
    velocityMax = 1
    @x    = ~~(Math.random() * width)
    @y    = ~~(Math.random() * height)
    @xVel = velocityMax * Math.random() * if ~~(Math.random() * 2) then -1 else 1
    @yVel = velocityMax * Math.random() * if ~~(Math.random() * 2) then -1 else 1
    @radius = 2.5 * window.pixelDensity

  tick: ->
    if window.mouse? and Math.abs(@x - window.mouse.x) < 50  and Math.abs(@y - window.mouse.y) < 50
      @xVel *= 1.1
      @yVel *= 1.1

    if (@x + @xVel <= 0 or @x + @xVel >= window.width) then @xVel *= -0.9
    if (@y + @yVel <= 0 or @y + @yVel >= window.height) then @yVel *= -0.9

    @x += @xVel
    @y += @yVel
    @

  draw: (ctx) ->
    ctx.beginPath()
    ctx.arc @x, @y, @radius, 0, 6.283185307179586, 0
    ctx.stroke()
    ctx.closePath()
    @

window.onload = ->
  ctx           = undefined
  elm           = undefined
  pixelDensity  = undefined
  clock         = 0
  xOffset       = 100
  yOffset       = 100
  particles     = []

  run = ->
    elm               = document.createElement 'canvas'
    @pixelDensity     = pixelDensity = window.devicePixelRatio || 1
    @width            = width  = window.innerWidth * @pixelDensity
    @height           = height = 500 * @pixelDensity
    elm.style.width   = width / @pixelDensity   + "px"
    elm.style.height  = height / @pixelDensity  + "px"
    xOffset           = (width * pixelDensity / 2)
    elm.setAttribute 'width', width
    elm.setAttribute 'height', height

    ctx     = elm.getContext '2d'
    ctx.lineWidth = 1;
    document.body.appendChild elm

    for i in [0 .. 100]
      particles.push new Particle

    tick()

  drawParticles = ->
    ctx.strokeStyle = "#FFFFFF"
    for i in [0 ... particles.length]
      particles[i].draw(ctx).tick()

  connectNearParticles = ->
    ctx.strokeStyle = "rgba(255, 255, 255, 0.3)"

    for i in [0 ... particles.length]
      for j in [0 ... particles.length]
        if particles[i] != particles[j]
          if Math.abs(particles[i].x - particles[j].x) < 120 and Math.abs(particles[i].y - particles[j].y) < 200
            ctx.beginPath()
            ctx.moveTo(particles[i].x, particles[i].y)
            ctx.lineTo(particles[j].x, particles[j].y)
            ctx.stroke()
            ctx.closePath()

  tick = ->
    ctx.clearRect(0, 0, width*pixelDensity, height*pixelDensity)
    drawParticles()
    connectNearParticles()
    requestAnimationFrame tick

  run()
