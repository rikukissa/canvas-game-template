angle = 0
ctx = false
$(document).ready () ->
  cnv = $('#main')[0]
  ctx = cnv.getContext '2d'
  draw(ctx)
draw = (ctx) ->
  ctx.canvas.width = window.innerWidth
  ctx.canvas.height = window.innerHeight
  ctx.save()
  ctx.fillStyle = '#FFF'
  ctx.fillRect 0, 0, ctx.canvas.width, ctx.canvas.height
  ctx.translate ctx.canvas.width / 2, ctx.canvas.height / 2

  ctx.save()
  ctx.beginPath()
  ctx.moveTo 0, 0
  ctx.lineTo 50 * Math.sin(Math.PI/180 * angle), 50 * Math.cos(Math.PI/180 * angle)
  ctx.stroke()
  ctx.restore()
  
  ctx.save()
  ctx.fillStyle = 'blue'
  ctx.translate 50 * Math.sin(Math.PI/180 * angle), 50 * Math.cos(Math.PI/180 * angle)
  ctx.fillRect -10, -10, 20, 20

  ctx.restore()
  
  

  ctx.restore()

$(window).on 'keydown', (e) ->
  if e.keyCode == 39
    angle += 5
  if e.keyCode == 37
    angle -= 5
  draw ctx