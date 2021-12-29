let w = 150..171
let h = -129..(-70)

proc f(inX, inY: int, my: var int): bool =
  var x, y = 0
  var (xx, yy) = (inX, inY)
  while y >= h.a:
    (x, y) = (x + xx, y + yy)
    my = my.max(y)
    if x in w and y in h: return true
    xx = (xx-1).max 0
    dec yy

var my, mmy: int
var s = 0

for y in -500..500:
  for x in 1..500:
    if f(x, y, my):
      inc s
      mmy = mmy.max(my)

echo mmy
echo s
