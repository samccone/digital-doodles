pixelDensity = window.devicePixelRatio || 1
width        = 400
height       = 400
lineCount    = 200
lines        = []
media        = NaN
canvasFrame  = NaN
videoData    = []
art          = document.createElement 'canvas'
artCtx       = NaN
frameCount   = 0

createVideoStreamer = (stream) ->
  media       = document.createElement 'video'
  canvasFrame = document.createElement 'canvas'
  elements    = [media, canvasFrame]

  sizeElement element for element in elements

  media.src = URL.createObjectURL stream
  media.play()
  webkitRequestAnimationFrame grabFrame
  kickOffArt()

grabFrame = () ->
  webkitRequestAnimationFrame grabFrame
  canvasFrame.getContext('2d').drawImage(media, 0, 0);

sizeElement = (element) ->
  element.setAttribute 'width', width * pixelDensity + "px"
  element.setAttribute 'height', width * pixelDensity + "px"
  element.style.width   = width + "px"
  element.style.height  = height + "px"


generateLineInfo = (x, y) ->
  x: x
  y: y
  yVelocity: ~~(Math.random() * 30 * (if (~~(Math.random() * 2) == 1)then -1 else 1))

generateExplosion = () ->
  spacing = ~~(width*2 / lineCount)
  for i in [0 ... lineCount]
    lines.push generateLineInfo spacing * i, height

drawAndMove= (line, i) ->
  (line.y+line.yVelocity <= 0 or line.y+line.yVelocity >= art.height) && line.yVelocity*=-1
  position = (((width) * line.y) + line.x) * 4
  strokeColor = "pink"
  red   = videoData.data[position]
  green = videoData.data[position + 1]
  blue  = videoData.data[position + 2]
  alpha = videoData.data[position + 3]
  if alpha != undefined then (strokeColor = "rgba(#{red}, #{green}, #{blue}, #{alpha})")

  artCtx.strokeStyle = strokeColor
  artCtx.beginPath()
  artCtx.moveTo line.x, line.y
  artCtx.lineTo line.x, (line.y+=line.yVelocity)

  artCtx.stroke()
  artCtx.closePath()

tick = ->
  artCtx.fillStyle = "rgba(0,0,0,0.01)"
  artCtx.rect 0, 0, art.width, art.height
  artCtx.fill();
  videoData = canvasFrame.getContext('2d').getImageData 0, 0, width*pixelDensity, height*pixelDensity
  drawAndMove line, i for line, i in lines
  webkitRequestAnimationFrame tick


kickOffArt = ->
  document.getElementById('sample').style.display = "none"
  sizeElement art
  artCtx = art.getContext '2d'
  document.body.appendChild art
  generateExplosion()
  tick()

if !navigator.webkitGetUserMedia
  alert "come back in chrome!"

navigator.webkitGetUserMedia {video: true}, createVideoStreamer