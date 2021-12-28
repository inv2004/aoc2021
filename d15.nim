import sequtils

const mul = 5

var c = toSeq(lines("in/d15.in")).mapIt(it.mapIt(int(it)-int('0')))

proc m(c: seq[seq[int]]): seq[seq[int]] =
  result = newSeqWith(c.len*mul, newSeq[int](c[0].len*mul))
  for xx in 0..<mul:
    for yy in 0..<mul:
      for x in 0..c[0].high:
        for y in 0..c.high:
          var v = c[y][x] + xx+yy
          if v > 9:
            v = v mod 10 + 1
          result[y+(c.len*yy)][x+(c[0].len*xx)] = v

iterator n4(x, y: int): (int, int, int) =
  for (xx, yy) in [(x-1,y),(x+1,y),(x,y-1),(x,y+1)]:
    if xx in 0..c[0].high and yy in 0..c.high:
      yield (xx, yy, c[yy][xx])

proc bfs(): int =
  var cache = newSeqWith(c.len, newSeqWith[int](c[0].len, 100000))
  cache[0][0] = 0
  var q = @[(0,0)]
  while q.len > 0:
    let x = q[0][0]
    let y = q[0][1]
    q.delete 0
    for (nx, ny, nr) in n4(x, y):
      if cache[ny][nx] > cache[y][x] + nr:
        cache[ny][nx] = cache[y][x] + nr
        q.add((nx, ny))
  cache[^1][^1]

echo bfs()
c = m(c)
echo bfs()