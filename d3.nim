import sequtils
import bitops
import strformat
import math

const h = 63

func toBit(x: string): uint64 =
  for i, x in x:
    if x == '1':
      result.setBit(h-i)

proc `$$`(x: seq[int]): string =
  for x in x:
    result = $x & result

proc flipBit(x: uint64, s: int): uint64 =
  result = x
  result.flipMask(uint64(2^s-1))

var s = toSeq(lines("d3.in"))
let m = s[0].len
let n = s.mapIt(fmt"{it:0>64}").map(toBit)

proc calc(n: seq[uint64]): seq[int] =
  result = newSeq[int](h+1)
  for x in n:
    for i in 0..h:
      if x.testBit(i):
        inc result[i]
      else:
        dec result[i]

  result.applyIt(it.cmp(-1).max(0))

let r = calc(n)

let p = toBit($$r)

echo p*flipBit(p, m)

proc calc2(n: seq[uint64], m: int): (uint64, uint64) =
  var nn = n
  var nnn = n
  for i in countdown(m-1, 0):
    if nn.len > 1:
      let b = calc(nn).mapIt(it > 0)
      nn = nn.filterIt(it.testBit(i) == b[i])
    if nnn.len > 1:
      let b = calc(nnn).mapIt(it > 0)
      nnn = nnn.filterIt(it.testBit(i) != b[i])
    if nn.len == 1 and nnn.len == 1:
      return (nn[0], nnn[0])

let (a, b) = calc2(n, m)
echo a*b
