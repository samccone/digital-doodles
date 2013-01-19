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
  size          = 400
  pixelData     = undefined
  clock         = 80
  colors        = []

  for i in [0 ... 256]
    colors.push hsvToRgb i/256, 1, 1

  run = ->
    width             = size
    height            = size
    elm               = document.createElement 'canvas'
    pixelDensity      = window.devicePixelRatio || 1
    elm.style.width   = width + "px"
    elm.style.height  = height + "px"
    xOffset           = (width * pixelDensity / 2)
    elm.setAttribute 'width', width * pixelDensity
    elm.setAttribute 'height', height * pixelDensity
    ctx       = elm.getContext '2d'
    pixelData = ctx.getImageData(0,0,size,size)
    for val, i in pixelData.data
      pixelData.data[i]  = 255
    document.body.appendChild elm
    tick()

  tick = ->
    for x in [0 ... size]
      for y in [0 ... size]
        index = (y * size + x) << 2
        color = (clock + (128 * Math.sin(x / 16.0)) +
                   + (128 *Math.sin(y / 8.0)) +
                   + (128 *Math.sin((x + y) / 16.0)) +
                   + (128 * Math.sin(Math.sqrt(x * x + y * y) / 8.0))) & 254
        pixelData.data[index]    = colors[color][0]
        pixelData.data[index+1]  = colors[color][1]
        pixelData.data[index+2]  = colors[color][2]

    ctx.putImageData pixelData, 0, 0
    ++clock
    requestAnimationFrame tick
  run()

hsvToRgb = (h, s, v) ->
  i = Math.floor(h * 6)
  f = h * 6 - i
  p = v * (1 - s)
  q = v * (1 - f * s)
  t = v * (1 - (1 - f) * s)

  switch i % 6
    when 0 then r = v; g = t; b = p;
    when 1 then r = q; g = v; b = p;
    when 2 then r = p; g = v; b = t;
    when 3 then r = p; g = q; b = v;
    when 4 then r = t; g = p; b = v;
    when 5 then r = v; g = p; b = q;

  [r * 255, g * 255, b * 255]