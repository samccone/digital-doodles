window.requestAnimationFrame ||=
  window.webkitRequestAnimationFrame ||
  window.mozRequestAnimationFrame    ||
  window.oRequestAnimationFrame      ||
  window.msRequestAnimationFrame     ||
  (callback, element) ->
    window.setTimeout( ->
      callback(+new Date())
    , 1000 / 60)


window.onload = ->
  ctx           = undefined
  elm           = undefined
  pixelDensity  = undefined
  clock         = 0
  direction     = 1
  color         = "#EA80B0"
  @points       = [0 , 0]
  cursor        = []


  window.addEventListener "mousemove",
    (e) -> @points = [e.layerX, e.layerY]
  , false

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
                if x + 10 > points[0] and x - 10 < points[0] and
                   y + 10 > points[1] and y - 10 < points[1]
                   then Math.abs(x - points[0]) + 1 else 2,
                0, (2 * Math.PI), 0
    ctx.fill()
    ctx.closePath()
    clock += 0.1
    requestAnimationFrame tick

  run()
