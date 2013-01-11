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
  xOffset       = 100
  yOffset       = 100
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
      particles.push
        x: ~~(Math.random() * width * pixelDensity)
        y: ~~(Math.random() * height * pixelDensity)
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
      particles.push
        x: ~~(Math.random() * width * pixelDensity)
        y: ~~(Math.random() * height * pixelDensity)

  drawParticles = ->
    ctx.strokeStyle = "#FFF"
    for p in particles
      ctx.beginPath();
      ctx.moveTo p.x, p.y
      ctx.lineTo p.x, p.y + 1
      if p.y > elm.height * pixelDensity then p.y = -10
      p.y += 10
      ctx.stroke();

  tick = ->
    clock += 0.3
    ctx.clearRect 0, 0, elm.width * pixelDensity, elm.height * pixelDensity
    ctx.strokeStyle = "#FFF"
    for offset in [0 ... 4]
      x = 0;
      ctx.beginPath();
      for i in [0 ... 500]
        ctx.lineTo  x + xOffset , i * elm.height/19 + yOffset
        ctx.lineTo  x + xOffset , i * elm.height/19+1 + yOffset
        x += Math.sin(i * 50+(clock+(offset*10))/6) * 25
      ctx.stroke();

    drawParticles()
    requestAnimationFrame tick

  run()