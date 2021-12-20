import strutils
import sequtils

var n = toSeq(lines("in/d2.in"))
  .mapIt(split(it, " "))
  .mapIt((it[0][0], it[1].parseInt))

var f, d, a = 0

for x in n:
  case x[0]
  of 'f': f += x[1]
  of 'u': d -= x[1]
  of 'd': d += x[1]
  else: assert false

echo f * d

(f, d) = (0, 0)

for x in n:
  case x[0]
  of 'f': f += x[1]; d += a * x[1]
  of 'u': a -= x[1]
  of 'd': a += x[1]
  else: assert false

echo f * d
