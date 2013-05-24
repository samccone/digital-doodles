window.requestAnimationFrame ||=
  window.webkitRequestAnimationFrame ||
  window.mozRequestAnimationFrame    ||
  window.oRequestAnimationFrame      ||
  window.msRequestAnimationFrame     ||
  (callback, element) ->
    window.setTimeout( ->
      callback(+new Date())
    , 1000 / 60)


class Ball
  constructor: (context) ->
    @ctx  = context
    @rad  = 20
    @x    = window.innerWidth/2 - @rad/2
    @y    = window.innerHeight/5 - @rad/2
    @velocity = [(if ~~(Math.random() * 2) then Math.random()*100 else Math.random()*-100), 15]
  draw: ->
    @y+= (@velocity[1] += 9.8)
    if @y + @rad >= window.innerHeight
      @velocity[0] *= 0.9
      @velocity[1] *= -0.8
      @y = window.innerHeight - @rad

    @x+= @velocity[0]
    if @x + @rad >= window.innerWidth or @x <= 0
      @velocity[0] *= -0.9
      if @x <= 0
        @x = 0
      else
        @x = window.innerWidth - @rad

    @ctx.beginPath()
    @ctx.arc @x, @y, @rad, 0 , 2 * Math.PI, 0
    @ctx.fill()
    @ctx.closePath()

window.onload = ->
  ctx           = undefined
  elm           = undefined
  pixelDensity  = undefined
  clock         = 0
  direction     = 1
  color         = "#EA80B0"
  ball          = null

  run = ->
    width             = window.innerWidth
    height            = window.innerHeight
    elm               = document.createElement 'canvas'
    pixelDensity      = window.devicePixelRatio || 1
    elm.style.width   = width + "px"
    elm.style.height  = height + "px"
    xOffset           = (width * pixelDensity / 2)
    document.body.appendChild elm

    elm.setAttribute 'width', width * pixelDensity
    elm.setAttribute 'height', height * pixelDensity
    ctx     = elm.getContext '2d'
    ctx.fillStyle = color
    ball          = new Ball(ctx)
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

  tick = ->
    w = window.innerWidth
    h = window.innerHeight
    s = Math.sin(clock)
    c = Math.cos(clock)
    ctx.clearRect 0, 0, w, h
    ctx.beginPath()
    for x in [0 .. w] by 10
      for y in [0 .. h] by 10
        ctx.arc x,
                y,
                2,
                0, (2 * Math.PI), 0
    ctx.fill()
    ctx.closePath()
    ball.draw()
    clock += 0.1
    requestAnimationFrame tick

  run()
