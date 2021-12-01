import strutils
import sequtils

var n = toSeq(lines("d1.in")).map(parseInt)

func countInc(x: openArray[int]): int =
  toSeq(x[0..^2]).zip(x[1..^1]).mapIt(it[1] > it[0]).count(true)

echo countInc n
echo countInc toSeq(0..<n.len-2).mapIt(foldr(n[it..it+2], a+b))
