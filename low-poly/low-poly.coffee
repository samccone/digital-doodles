camera = mesh = scene = renderer = fillLight = undefined

drawStars = () ->
  canvas = document.createElement 'canvas'
  canvas.setAttribute 'width', window.innerWidth
  canvas.setAttribute 'height', window.innerHeight
  canvas.setAttribute 'id', "stars"
  ctx = canvas.getContext '2d'
  ctx.fillStyle = "#ffffff"
  for i in [0 .. 500]
    ctx.beginPath()
    sizeRandom = Math.random() * 2
    ctx.arc Math.random() * window.innerWidth, Math.random() * window.innerHeight, sizeRandom, 0, 2*Math.PI, 0
    ctx.fill()
    ctx.closePath()

  document.body.appendChild canvas
window.onload = () ->
  drawStars()
  camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1, 10000)
  camera.position.z = 1000

  scene           = new THREE.Scene
  geometryBase    = new THREE.SphereGeometry(400, 50, 56)
  terranGeom      = new THREE.SphereGeometry(398, 30, 30)
  terranHighGeom  = new THREE.SphereGeometry(390, 20, 20)

  baseMat      = new THREE.MeshLambertMaterial
                    color: 0x76acda
                    shading: THREE.FlatShading

  material     = new THREE.MeshLambertMaterial
                    color: 0xb8b658
                    shading: THREE.FlatShading

  highTerranMat= new THREE.MeshLambertMaterial
                    color: 0xe3c97f
                    shading: THREE.FlatShading

  geometryBase.vertices.forEach (v) ->
    v[["x","y","z"][~~(Math.random() * 3)]] += Math.random() * 10

  [terranHighGeom.vertices, terranGeom.vertices].forEach (g) ->
    g.forEach (v) ->
      v[["x","y","z"][~~(Math.random() * 3)]] += Math.random() * 40

  base = new THREE.Mesh geometryBase, baseMat
  terran = new THREE.Mesh terranGeom, material
  highTerran = new THREE.Mesh terranHighGeom, highTerranMat

  scene.add base
  base.add terran
  base.add highTerran

  light = new THREE.DirectionalLight( 0xffffff )
  light.position.set( 1, 1, 1 )
  scene.add( light )

  fillLight = new THREE.AmbientLight( 0x2e1527 )
  scene.add( fillLight )

  try
    renderer = new THREE.WebGLRenderer()
  catch e
    renderer = new THREE.CanvasRenderer()
    alert "come back in chrome or firefox! or enable webgl"

  renderer.setSize window.innerWidth, window.innerHeight


  document.body.appendChild renderer.domElement


  animate = () ->
      base.rotation.y += 0.00125

      requestAnimationFrame animate
      renderer.render scene, camera


  animate()
