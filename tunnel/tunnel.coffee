window.requestAnimationFrame ||=
  window.webkitRequestAnimationFrame ||
  window.mozRequestAnimationFrame    ||
  window.oRequestAnimationFrame      ||
  window.msRequestAnimationFrame     ||
  (callback, element) ->
    window.setTimeout( ->
      callback(+new Date())
    , 1000 / 60)


ctx           = undefined
elm           = undefined
pixelDensity  = undefined
textureHeight = 256
textureWidth  = 256
texture       = []
distanceTable = []
angleTable    = []
width         = null
height        = null
imageData     = null

window.onload = ->
  width             = window.innerWidth
  height            = window.innerHeight
  elm               = document.createElement 'canvas'
  pixelDensity      = window.devicePixelRatio || 1
  elm.style.width   = width + "px"
  elm.style.height  = height + "px"
  xOffset           = (width * pixelDensity / 2)
  elm.setAttribute 'width', width * pixelDensity
  elm.setAttribute 'height', height * pixelDensity
  ctx               = elm.getContext '2d'
  imageData         = ctx.createImageData(width, height)

  document.body.appendChild elm
  buildTexture()
  buildTransformTable()
  tick()


pSet = (imageData, x, y, r, g, b) ->
  index = (x + y * imageData.width) * 4
  imageData.data[index+0] = r
  imageData.data[index+1] = g
  imageData.data[index+2] = b
  imageData.data[index+3] = 255

buildTransformTable = ->
  distanceTable = new Array(width)
  angleTable    = new Array(width)
  ratio         = 32

  for x in [0..width]
    distanceTable[x] = new Array
    angleTable[x] = new Array
    for y in [0..height]
      distance = ~~(ratio * textureHeight / Math.sqrt((x - width / 2.0) * (x - width / 2.0) + (y - height / 2.0) * (y - height / 2.0)) % textureHeight)
      angle    = ~~(0.5 * textureWidth * Math.atan2(y - height / 2.0, x - width / 2.0) / Math.PI)
      distanceTable[x][y] = distance
      angleTable[x][y]    = angle

buildTexture = ->
  texture = new Array(width)

  for i in [0..width]
    texture[i] = new Array()
    for j in [0..height]
      texture[i][j] = (i * 256 / textureWidth) ^ (j * 256 / textureHeight)

tick = ->
  animation = (new Date).getTime() / 1000
  shiftX = ~~(textureWidth * 1.0 * animation)
  shiftY = ~~(textureHeight * 0.25 * animation)
  for x in [0..width]
    for y in [0..height]
      color = texture[~~(distanceTable[x][y] + shiftX) % textureWidth][~~(angleTable[x][y] + shiftY) % textureHeight]
      pSet(imageData, x, y, color, 0, 0)
  ctx.putImageData imageData, 0, 0
  requestAnimationFrame tick