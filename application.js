function Canvas(element) {
  this.el = element;
  this.ctx = element.getContext('2d');
  this.fitToScreen = function() {
    this.el.width = window.innerWidth;
    this.el.height = window.innerHeight;
  }
}

var canvas;
var mousedown = false;

window.onload = function() {
  canvas = new Canvas($('#main')[0]);
  canvas.fitToScreen();
  $('#main').on('mousedown', function() { mousedown = true });
  $('#main').on('mouseup', function() { mousedown = false; });
  $
  ('#main').on('mousemove', function(e) {
    if(mousedown) {
      canvas.ctx.fillRect(e.offsetX, e.offsetY, 10, 10);
    }
  });
}