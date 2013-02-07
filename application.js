// http://paulirish.com/2011/requestanimationframe-for-smart-animating/
window.requestAnimFrame = (function(){
  return  window.requestAnimationFrame       || 
          window.webkitRequestAnimationFrame || 
          window.mozRequestAnimationFrame    || 
          window.oRequestAnimationFrame      || 
          window.msRequestAnimationFrame     || 
          function( callback ){
            window.setTimeout(callback, 1000 / 60);
          };
})();

function Canvas(element) {
  this.el = element;
  this.ctx = element.getContext('2d');
  this.fitToScreen = function() {
    this.el.width = window.innerWidth;
    this.el.height = window.innerHeight;
  }
}

function Player() {
  this.w = 70;
  this.h = 150;
  this.x = 100;
  this.y = 0;
  this.render = function(ctx) {
    ctx.fillRect(this.x + this.w / 2, ctx.canvas.height - this.h, this.w, this.h)
  }
}

var canvas, player;
function tick() {
  player.render(canvas.ctx);
}

function mainLoop() {
  canvas.ctx.clearRect(0, 0, canvas.el.width, canvas.el.height)
  tick();
  window.requestAnimFrame(mainLoop);
}


window.onload = function() {
  canvas = new Canvas(document.getElementById('main'));
  canvas.fitToScreen();
  player = new Player();
  mainLoop();
}