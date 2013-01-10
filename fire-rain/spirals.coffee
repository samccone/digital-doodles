
generateLineInfo = (x, y) ->
  x: x
  y: y
  xVelocity: Math.random() * 20 * (if (~~(Math.random() * 2) == 1) then -1 else 1)
  yVelocity: Math.random() * 10 * (if (~~(Math.random() * 2) == 1)then -1 else 1)


window.onload = () ->
  width             = window.innerWidth
  height            = window.innerHeight
  elm               = document.createElement 'canvas'
  pixelDensity      = window.devicePixelRatio || 1
  lines             = []
  colors            = ["#FF7A43", "#F24B4B", "#DB5139"];
  operations        = ["sin", "cos"]
  elm.style.width   = width + "px"
  elm.style.height  = height + "px"
  frameCount        = 0
  explosion         = 60 * 5

  elm.setAttribute 'width', width * pixelDensity
  elm.setAttribute 'height', height * pixelDensity

  ctx     = elm.getContext '2d'
  document.body.appendChild elm

  generateExplosion = () ->
    lines.length = 0
    for i in [0 ... 50]
      lines.push(generateLineInfo(width, height), generateLineInfo(width, height))


  window.addEventListener 'resize', () ->
    width   = window.innerWidth
    height  = window.innerHeight
    elm.setAttribute('width', width * pixelDensity)
    elm.setAttribute('height', height * pixelDensity)
    elm.style.width   = width + "px"
    elm.style.height  = height + "px"
    console.log "resize"

  drawAndMove= (line, i) ->
    ctx.strokeStyle = colors[i%colors.length]
    ctx.beginPath()
    ctx.moveTo line.x, line.y
    ctx.lineTo (line.x+=  line.xVelocity), line.y +=Math[operations[i%operations.length]](line.x) * 10 +line.yVelocity
    if line.xVelocity > 0
      line.xVelocity -= 0.2
    else
      line.xVelocity += 0.2

    ctx.stroke()
    ctx.closePath()

  tick = ->
    if !(++frameCount % explosion)
      generateExplosion()
      explosion = (~~(Math.random() * 8)+2) * 60

    if (frameCount %explosion < 10)
      ctx.fillStyle = "rgba(242,72,72,0.05)"
    else
      ctx.fillStyle = "rgba(0,0,0,0.05)"
    ctx.rect 0, 0, elm.width, elm.height
    ctx.fill();
    drawAndMove line, i for line, i in lines
    requestAnimFrame(tick)

  generateExplosion()
  tick()