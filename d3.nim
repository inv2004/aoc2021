import sequtils
import bitops
import strformat
import math

const h = 63

func toBit(x: string): uint64 =
  for i, x in x:
    if x == '1':
      result.setBit(h-i)

converter toStr(x: seq[bool]): string =
  for x in x:
    let s = if x: "1" else: "0"
    result = s & result

var s = toSeq(lines("in/d3.in"))
let m = s[0].len
let n = s.mapIt(fmt"{it:0>64}").map(toBit)

proc calc(n: seq[uint64]): seq[bool] =
  var r = newSeq[int](h+1)
  for x in n:
    for i in 0..h:
      if x.testBit(i):
        inc r[i]
      else:
        dec r[i]
  return r.mapIt(it.cmp(-1) > 0)

let r = calc(n)

let p = toBit(r)
var e = p
e.flipMask(uint64(2^m-1))
echo p*e

var ox = n
var co = n
for i in countdown(m-1, 0):
  if ox.len > 1:
    let b = calc(ox)
    ox = ox.filterIt(it.testBit(i) == b[i])
  if co.len > 1:
    let b = calc(co)
    co = co.filterIt(it.testBit(i) != b[i])
  if ox.len == 1 and co.len == 1:
    break

echo ox[0]*co[0]
