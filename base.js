// Generated by CoffeeScript 1.4.0
(function(){window.requestAnimFrame=function(e){return window.requestAnimationFrame||window.webkitRequestAnimationFrame||window.mozRequestAnimationFrame||window.oRequestAnimationFrame||window.msRequestAnimationFrame||function(e){return window.setTimeout(e,1e3/60)}}();window.World=function(){function e(){this.size={x:50,y:50};this.bodies=[]}e.prototype.createBody=function(e){e.parent=this;return this.bodies.push(e)};return e}();window.Keys=function(){function e(){this.up=!1;this.down=!1;this.left=!1;this.right=!1;this.commands={37:"left",38:"up",39:"right",40:"down"};this.loadEvents()}e.prototype.loadEvents=function(){var e=this;return $(window).bind("keydown keyup",function(t){if(e.commands.hasOwnProperty(t.keyCode))return e[e.commands[t.keyCode]]=t.type==="keydown"})};return e}();window.Assets=function(){function e(e){this.arr=e;this.asset={};this.loaded=0}e.prototype.load=function(e){var t,n,r,i,s,o=this;if(this.arr.length===0||!this.assets){e();return}i=this.arr;s=[];for(n=0,r=i.length;n<r;n++){t=i[n];this.asset[t]=new Image;this.asset[t].onload=function(){o.loaded++;if(o.loaded===o.arr.length)return e()};s.push(this.asset[t].src=t)}return s};return e}();window.Camera=function(){function e(e){this.canvas=e;this.ctx=this.canvas.getContext("2d");this.position={x:0,y:0};this.translation={x:0,y:0};this.scale=64;this.angle=Math.PI/4;this.loadEvents()}e.prototype.move=function(){this.position.x+=this.translation.x;this.position.y+=this.translation.y;return this.ctx.translate(this.position.x,this.position.y)};e.prototype.loadEvents=function(){var e=this;window.addEventListener("mousemove",function(t){t.offsetX<50?e.translation.x=10:t.offsetX>e.canvas.width-50?e.translation.x=-10:e.translation.x=0;return t.offsetY<50?e.translation.y=10:t.offsetY>e.canvas.height-50?e.translation.y=-10:e.translation.y=0});return window.addEventListener("mouseout",function(){e.translation.y=0;return e.translation.x=0})};return e}();window.Body=function(){function e(){this.position={x:0,y:0,z:0};this.dimensions={w:0,d:0,h:0};this.fixtures=[];this.type="static"}e.prototype.createFixture=function(e){e.parent=this;return this.fixtures.push(e)};return e}();window.Fixture=function(){function e(){this.position={x:0,y:0,z:0};this.dimensions={w:0,d:0,h:0}}return e}()}).call(this);