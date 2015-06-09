function toRad(deg) {
  return deg * Math.PI / 180;
}

var canvas = document.createElement('canvas');
canvas.setAttribute('width', window.innerWidth);
canvas.setAttribute('height', window.innerHeight);

var ctx = canvas.getContext('2d');
var scalar = 90;
var length = 2;
var angle = 30;
ctx.strokeStyle = 'red';

function draw(x, y) {
  ctx.save();
  //center
  ctx.translate(x, y);
  ctx.save();
  ctx.beginPath();
  ctx.moveTo(0, 0);
  //center down
  ctx.lineTo(0, length * scalar);

  // left bottom
  ctx.lineTo(
    -length * scalar * Math.cos(toRad(angle)),
    (Math.sin(toRad(angle)) * length * scalar));

  // left top
  ctx.translate(
    -length * scalar * Math.cos(toRad(angle)),
    -(scalar * length) + (Math.sin(toRad(angle)) * length * scalar));

  ctx.lineTo(0, 0);

  ctx.lineTo(
    length * scalar * Math.cos(toRad(angle)),
    (Math.sin(toRad(angle)) * length * scalar));

  ctx.moveTo(0, 0);

  // top face left
  ctx.translate(
    length * scalar * Math.cos(toRad(-angle)),
    (Math.sin(toRad(-angle)) * length * scalar));
  ctx.lineTo(0, 0);

  // top face center
  ctx.translate(
    length * scalar * Math.cos(toRad(angle)),
    (Math.sin(toRad(180 - angle)) * length * scalar));
  ctx.lineTo(0, 0);
  ctx.save();

  // top face right
  ctx.translate(
    -length * scalar * Math.cos(toRad(-angle)),
    -(Math.sin(toRad(-angle)) * length * scalar));
  ctx.lineTo(0, 0);

  // right face right
  ctx.restore();
  ctx.moveTo(0, 0);
  ctx.lineTo(0, length * scalar);
  ctx.restore();
  ctx.lineTo(0, length * scalar);
  ctx.stroke();
  ctx.restore();
  ctx.endPath();
}
document.body.appendChild(canvas);

canvas.addEventListener('click', function(e) {
  draw(e.pageX, e.pageY);
});
