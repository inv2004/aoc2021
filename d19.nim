import strutils, sets, tables, options
import zero_functional

type T = (int,int,int)

var s = newSeq[seq[T]]()

let f = open("in/d19.in")
var line: string
while readLine(f, line):
  if line.startsWith "---":
    s.add newSeq[T]()
  elif line.len > 0:
    let xyz = line.split(",")
    s[^1].add (parseInt xyz[0], parseInt xyz[1], parseInt xyz[2])

proc rotate(x: seq[T], i: int): seq[T] =
  case i
  of 0: return x-->map((it[0],it[1],it[2]))
  of 1: return x-->map((-it[1],it[0],it[2]))
  of 2: return x-->map((-it[0],-it[1],it[2]))
  of 3: return x-->map((it[1],-it[0],it[2]))
  of 4: return x-->map((it[1],-it[2],-it[0]))
  of 5: return x-->map((it[2],it[1],-it[0]))
  of 6: return x-->map((-it[1],it[2],-it[0]))
  of 7: return x-->map((-it[2],-it[1],-it[0]))
  of 8: return x-->map((-it[2],it[0],-it[1]))
  of 9: return x-->map((-it[0],-it[2],-it[1]))
  of 10: return x-->map((it[2],-it[0],-it[1]))
  of 11: return x-->map((it[0],it[2],-it[1]))
  of 12: return x-->map((-it[0],it[1],-it[2]))
  of 13: return x-->map((-it[1],-it[0],-it[2]))
  of 14: return x-->map((it[0],-it[1],-it[2]))
  of 15: return x-->map((it[1],it[0],-it[2]))
  of 16: return x-->map((it[1],it[2],it[0]))
  of 17: return x-->map((-it[2],it[1],it[0]))
  of 18: return x-->map((-it[1],-it[2],it[0]))
  of 19: return x-->map((it[2],-it[1],it[0]))
  of 20: return x-->map((it[2],it[0],it[1]))
  of 21: return x-->map((-it[0],it[2],it[1]))
  of 22: return x-->map((-it[2],-it[0],it[1]))
  of 23: return x-->map((it[0],-it[2],it[1]))
  else: doAssert false

proc cmp(a: HashSet[T], b: seq[T]): Option[(HashSet[T], T)] =
  for i in 0..23:
    var c = initCountTable[T]()
    let b = b.rotate(i)
    for (ax, ay, az) in a:
      for (bx, by, bz) in b:
        c.inc((ax-bx,ay-by,az-bz))
    if c.largest[1] >= 12:
      let (dx, dy, dz) = c.largest[0]
      return some((a + toHashSet(b-->map((it[0]+dx, it[1]+dy, it[2]+dz))), c.largest[0]))

proc find(a: HashSet[T], s: seq[seq[T]], diffs: seq[T]): (HashSet[T], seq[T]) =
  if s.len == 0:
    return (a, diffs)
  let res = cmp(a, s[0])
  if res.isSome:
    find(res.get[0], s[1..^1], diffs & res.get[1])
  else:
    find(a, s[1..^1] & s[0], diffs)

proc mmax(x: seq[T]): int =
  for j, (x2,y2,z2) in x:
    for i, (x1,y1,z1) in x:
      if j != i:
        result = result.max abs(x2-x1)+abs(y2-y1)+abs(z2-z1)

let (found, diffs) = find(s[0].toHashSet, s[1..^1], @[(0,0,0)])
echo found.len
echo mmax(diffs)
      
