// TODO handle window resize by calling size_canvas and smash.

var WIDTH = 800;                // Overridden in size_canvas
var HEIGHT = 800;               // Ditto
var MIN_WIDTH = 40;
var MIN_HEIGHT = 40;
var UP = 0;
var DOWN = 1;
var LEFT = 2;
var RIGHT = 3;

function debug(x, y, w, h) {
  console.log('[' + x + ',' + y + ',' + w + ',' + h + ']');
}

function size_canvas() {
  WIDTH = document.documentElement.clientWidth - 30;
  HEIGHT = document.documentElement.clientHeight - 30;
  var screen = document.getElementById('screen');
  screen.width = WIDTH;
  screen.height = HEIGHT;
}

function rnd(n) {
  return Math.floor(n * Math.random());
}

var current_x;
var current_y;

// See https://developer.mozilla.org/en/Canvas_tutorial/Drawing_shapes
function qc(context, cpx, cpy, x, y) {
  var cp1x = current_x + 2.0/3.0*(cpx - current_x);
  var cp1y = current_y + 2.0/3.0*(cpy - current_y);
  var cp2x = cp1x + (x - current_x)/3.0;
  var cp2y = cp1y + (y - current_y)/3.0;
  context.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, x, y);
  current_x = x;
  current_y = y;
}

function oval(context, x, y, w, h) {
  context.beginPath();
  var radius = Math.min(w, h);
  context.moveTo(x, y+h/2);
  current_x = x;
  current_y = y+h/2;
  qc(context, x, y, x+w/2, y);
  qc(context, x+w, y, x+w, y+h/2);
  qc(context, x+w, y+h, x+w/2, y+h);
  qc(context, x, y+h, x, y+h/2);
  context.closePath();
  context.fill();
}

function triangle(context, x, y, w, h) {
  context.beginPath();
  switch (rnd(4)) {
  case UP:
    context.moveTo(x, y+h);
    context.lineTo(x + w/2, y);
    context.lineTo(x + w, y+h);
    break;
  case DOWN:
    context.moveTo(x, y);
    context.lineTo(x + w/2, y + h);
    context.lineTo(x + w, y);
    break;
  case LEFT:
    context.moveTo(x+w, y);
    context.lineTo(x, y + h/2);
    context.lineTo(x + w, y + h);
    break;
  case RIGHT:
    context.moveTo(x, y);
    context.lineTo(x + w, y + h/2);
    context.lineTo(x, y + h);
    break;
  }
  context.closePath();
  context.fill();
}

function diamond(context, x, y, w, h) {
  context.beginPath();
  context.moveTo(x, y+h/2);
  context.lineTo(x+w/2, y);
  context.lineTo(x+w, y+h/2);
  context.lineTo(x+w/2, y+h);
  context.closePath();
  context.fill();
}

function star(context, x, y, w, h) {
  context.beginPath();
  context.moveTo(x+w*.2, y+h, 4, 4);
  context.lineTo(x+w/2, y, 4, 4);
  context.lineTo(x+w*.75, y+h, 4, 4);
  context.lineTo(x+w*.1, y+h*.3, 4, 4);
  context.lineTo(x+w-w*.1, y+h*.3, 4, 4);
  context.closePath();
  context.fill();
}

function rectangle(context, x, y, w, h) {
  context.fillRect(x, y, w, h);
}

var SHAPE_FUNCS = [oval, triangle, diamond, star, rectangle];

function smash() {
  var screen = document.getElementById('screen');
  var context = screen.getContext('2d');
  context.fillStyle = "rgb(" + rnd(255) + ", " + rnd(255) + ", " + rnd(255) + ")";

  var x = 0, y = 0, w = 0, h = 0;
  while (w < MIN_WIDTH && h < MIN_HEIGHT) {
    w = MIN_WIDTH + rnd(WIDTH - MIN_WIDTH);
    h = MIN_HEIGHT + rnd(HEIGHT - MIN_HEIGHT);
    x = rnd(WIDTH - w);
    y = rnd(HEIGHT - h);
  }
  SHAPE_FUNCS[rnd(5)](context, x, y, w, h);
}

window.onload = function() {
  size_canvas();
  document.onkeydown = smash;
  document.onmousedown = smash;
  smash();
}
