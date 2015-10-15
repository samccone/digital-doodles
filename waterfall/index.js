var canvas = document.createElement('canvas');

canvas.setAttribute('height', window.innerHeight);
canvas.setAttribute('width', window.innerWidth);

document.body.appendChild(canvas);

var ctx = canvas.getContext('2d');

function render() {
  ctx.fillStyle = '#34333E';
  ctx.fillRect(0,0, canvas.width, canvas.height);

  sky();
  waterfall();
  trees();

  requestAnimationFrame(render);
}

function sky() {
  var g = ctx.createLinearGradient(0, 0, 0, canvas.height / 2);
  g.addColorStop(0, '#d3aa7d');
  g.addColorStop(1, '#cba4c5');
  ctx.fillStyle = g;

  ctx.beginPath();
  ctx.moveTo(0, 0);
  ctx.lineTo(0, canvas.height / 2);
  ctx.lineTo(canvas.width / 2 + canvas.width / 9,
      canvas.height / 2 + canvas.height / 18);
  ctx.lineTo(canvas.width, canvas.height / 2);
  ctx.lineTo(canvas.width, 0);
  ctx.lineTo(0, 0);

  ctx.fill();
  ctx.closePath();
}

function r(v) {
  return Math.random() * v * (~~(Math.random() * 2) ? 1 : -1);
}

function trees() {
  ctx.fillStyle = '#34333E';
  ctx.beginPath();

  ctx.moveTo(100, canvas.height / 2 + canvas.height / 17);
  ctx.lineTo(150, canvas.height / 2 - canvas.height / 15);
  ctx.lineTo(180, canvas.height / 2 + canvas.height / 18);

  ctx.fill();
  ctx.closePath();
}

function waterfall() {
  ctx.fillStyle = 'rgba(255, 255, 255, 0.2)';
  var height = canvas.height - (canvas.height / 2 + canvas.height / 18);
  var width = 30;

  for (var x = 0; x < width; ++x) {
    for (var y = 0; y < height; ++y) {
      if (Math.random() * height > y) {
        var _x = canvas.width / 2 + canvas.width / 9 + Math.random() * r(y / x);
        var _y = (canvas.height / 2 + canvas.height / 18) + y;

        ctx.fillRect(_x, _y, 1, 1);
      }
    }
  }
}

render();
