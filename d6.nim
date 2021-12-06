import sequtils
import strutils
import algorithm

var s = readFile("d6.in").split(",").map(parseInt)

proc play(days: int): int =
  var t = newSeq[int](9)
  for x in s:
    inc t[x]

  for i in 1..days:
    rotateLeft(t, 1)
    t[6] += t[8]

  t.foldr(a+b)

echo play 80
echo play 256
