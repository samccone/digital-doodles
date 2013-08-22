density   = window.devicePixelRatio || 1
width     = window.innerWidth * density
height    = window.innerHeight * density
colors    = ["#f9d100", "#a1fa00", "#f9be83", "#cc9cde", "#ece78c", "#40a3e5"]
circuits  = []

window.onload = ->
  thread = 0

  canvas = document.createElement 'canvas'
  canvas.setAttribute 'width', width
  canvas.setAttribute 'height', height
  canvas.style.width = width/density + "px"
  canvas.style.height= height/density + "px"

  document.body.appendChild canvas

  ctx = canvas.getContext '2d'

  tick = ->
    if @last and (@last.x > width || @last.y > height || @last.y < 0) and ++thread
      @last = undefined

    @last = new Cicuit(@last, ctx, thread)
    circuits.push(@last.draw(ctx))
  setInterval tick, 100


class Cicuit
  orbSize: ->
    Math.random() * 3 + 2 * density

  constructor: (last, ctx, thread) ->

    if last
      @connectToLast(last, ctx)
    else
      @x        = 0
      @y        = Math.random() * height

    @thread   = thread
    @orbs     = [@orbSize(), @orbSize()]
    @distance = 10 * density + 10 * density

  posNeg: ->
    if ~~(Math.random() * 2) then 1 else -1

  connectNear: (ctx) ->
    for i in [0...circuits.length]
      c = circuits[i]
      if @thread != c.thread and Math.abs(@x - c.x) < 50 * density and  Math.abs(@y - c.y) < 50 * density
        ctx.strokeStyle = "rgba(0, 0, 0, 0.1)"
        ctx.beginPath()
        ctx.moveTo(@x, @y)
        ctx.lineTo(c.x, c.y)
        ctx.stroke()
        ctx.closePath()

  connectToLast: (last, ctx) ->
    lastEnd     = last.x + last.distance + last.orbs[1]

    shift = Math.random() * 40 * density
    seperation  =
      x: shift
      y: shift * @posNeg()

    nextStart   =
      x: lastEnd + seperation.x
      y: last.y + last.orbs[1] + seperation.y

    @drawLine(ctx, lastEnd, last.y, seperation.x, seperation.y)
    @x        = nextStart.x
    @y        = nextStart.y


  drawOrb: (x, y, rad, ctx) ->
    ctx.beginPath()
    switch ~~(Math.random() * 4)
      when 0 #simple dot
        ctx.arc x, y, rad, 2 * Math.PI, 0
        ctx.fillStyle = colors[~~(Math.random()*colors.length)]
        ctx.fill()
      when 1 #simple square
        ctx.rect x - rad / 2, y - rad/2, rad, rad
        ctx.strokeStyle = colors[~~(Math.random()*colors.length)]
        ctx.fillStyle = colors[~~(Math.random()*colors.length)]
        ctx.stroke()
        ctx.fill()
      when 2 #nested dot
        ctx.arc x, y, rad, 2 * Math.PI, 0
        ctx.fillStyle = colors[~~(Math.random()*colors.length)]
        ctx.fill()
        ctx.closePath()
        ctx.beginPath()
        ctx.arc x, y, rad * .7, 2 * Math.PI, 0
        ctx.fillStyle = colors[~~(Math.random()*colors.length)]
        ctx.fill()
      when 3 #square outline
        ctx.strokeStyle = colors[~~(Math.random()*colors.length)]
        ctx.lineWidth = density
        ctx.rect x - rad / 2, y - rad/2, rad, rad
        ctx.stroke()
        ctx.lineWidth = 0.5 * density
        # ctx.fill()

    ctx.closePath()

  draw: (ctx) ->
    @drawLine(ctx, @x, @y, @distance)

    for i in [0...2]
      @drawOrb @x + @distance * i, @y, @orbs[i]*density, ctx

    @connectNear(ctx)
    @

  drawLine: (ctx, x, y, distanceX, distanceY=0) ->
    ctx.lineWidth = 0.5 * density
    ctx.beginPath()
    ctx.moveTo x, y
    ctx.lineTo x+distanceX, y+distanceY
    ctx.strokeStyle = "rgba(0,0,0,0.2)"
    ctx.stroke()
    ctx.closePath()

