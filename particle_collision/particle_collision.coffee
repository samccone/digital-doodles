window.requestAnimationFrame ||=
  window.webkitRequestAnimationFrame ||
  window.mozRequestAnimationFrame    ||
  window.oRequestAnimationFrame      ||
  window.msRequestAnimationFrame     ||
  (callback, element) ->
    window.setTimeout( ->
      callback(+new Date())
    , 1000 / 60)

class orb
  constructor: (width, height, pixelDensity) ->
    @height = height * pixelDensity
    @width = width * pixelDensity
    @radius = 10
    @x = ~~((Math.random() * (width)) * pixelDensity) + @radius
    @y = ~~(Math.random() * height * pixelDensity)
    @velocity =
      y: ~~(Math.random() * 5 + 4) * (if ~~(Math.random() * 2) then -1 else 1)
      x: ~~(Math.random() * 5 + 4) * (if ~~(Math.random() * 2) then -1 else 1)
    @

  checkCollisons: (particles) ->
    for p in particles
      if p != @
        dx = p.x - @x
        dy = p.y - @y - @velocity.y
        radii = @radius + @radius
        if ( ( dx * dx ) + ( dy * dy ) < Math.pow radii, 2 )
          @velocity.y *= -0.95
          p.velocity.y *= -0.95
          @velocity.x *= -0.95
          p.velocity.x *= -0.95

  draw: (ctx, particles) ->
    @checkCollisons particles
    ctx.strokeStyle = "#FFF"
    ctx.beginPath();
    ctx.arc @x, @y, @radius, 2 * Math.PI, 0
    if @y >= @height - @radius * 2 - @velocity.y or @y + @velocity.y <= 0  then @velocity.y *= -1
    if @x >= @width - @radius * 2 - @velocity.x or @x + @velocity.x <= 5 then @x *= -1
    @y += @velocity.y
    @x += @velocity.x

    ctx.stroke()
    ctx.closePath()

window.onload = ->
  ctx           = undefined
  elm           = undefined
  pixelDensity  = undefined
  particles     = []

  run = ->
    width             = window.innerWidth
    height            = window.innerHeight
    elm               = document.createElement 'canvas'
    pixelDensity      = window.devicePixelRatio || 1
    elm.style.width   = width + "px"
    elm.style.height  = height + "px"
    xOffset           = (width * pixelDensity / 2)
    elm.setAttribute 'width', width * pixelDensity
    elm.setAttribute 'height', height * pixelDensity

    ctx     = elm.getContext '2d'
    document.body.appendChild elm
    for i in [0 .. 200]
      particles.push new orb width, height, pixelDensity
    tick()

  window.onresize = ->
    width             = window.innerWidth
    height            = window.innerHeight
    elm               = document.getElementsByTagName('canvas')[0]
    pixelDensity      = window.devicePixelRatio || 1
    elm.style.width   = width + "px"
    elm.style.height  = height + "px"
    xOffset           = (width * pixelDensity / 2)
    elm.setAttribute 'width', width * pixelDensity
    elm.setAttribute 'height', height * pixelDensity
    particles = []
    for i in [0 .. 200]
      particles.push new orb width, height, pixelDensity

  drawParticles = ->
    for p in particles
      p.draw ctx, particles

  tick = ->
    ctx.clearRect 0, 0, elm.width * pixelDensity, elm.height * pixelDensity
    drawParticles()
    requestAnimationFrame tick

  run()