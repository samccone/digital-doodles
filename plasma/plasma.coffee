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
    size = 400
    pixelData = ctx.getImageData(0,0,size,size)
    for x in [0 ... size]
      for y in [0 ... size]
        index = (y * size + x) * 4
        pixelData.data[index]    = (Math.sin(x*y/5 + clock/16)) * 255
        pixelData.data[index+1]  = (Math.sin(x*y + clock/4)) * 255
        pixelData.data[index+2]  = (Math.cos(x*y * 4 + clock/5)) * 255
        pixelData.data[index+3]  = 255
    ctx.putImageData pixelData, 0, 0
    ++clock
    requestAnimationFrame tick

  run()