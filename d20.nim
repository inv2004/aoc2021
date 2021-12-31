import sequtils, strutils

let input = toSeq(lines("in/d20.in"))
let enc = input[0]
var img = input[2..^1]

proc `$`(img: seq[string]): string =
  img.join("\n")

proc ench(img: seq[string], c: char): seq[string] =
  result.add c.repeat img[0].len+2
  result.add img.mapIt(c & it & c)
  result.add c.repeat img[0].len+2

iterator n4(img: seq[string], x, y: int, inverted: bool): int =
  for yy in -1..1:
    for xx in -1..1:
      if x+xx in 0..img[0].high and y+yy in 0..img.high:
        yield int(img[y+yy][x+xx] == '#')
      else:
        yield int(inverted)

proc f(img: seq[string], inverted: bool): seq[string] =
  let c = if inverted: '#' else: '.'
  let imgB = ench(img, c)
  result = imgB.mapIt(c.repeat(it.len))
  for y in 0..imgB.high:
    for x in 0..imgB[0].high:
      result[y][x] = enc[parseBinInt toSeq(n4(imgB, x, y, inverted)).join()]

var inverted = false
for i in 1..50:
  img = img.f(inverted)
  if i in [2, 50]:
    echo img.mapIt(it.count('#')).foldl(a+b)
  if enc[0] == '#':
    inverted = not inverted
