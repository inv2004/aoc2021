import sequtils
import strutils

let f = open("d4.in")
var line: string

assert readLine(f, line)
let r = line.split(",").map(parseInt)

# echo r

type Bingo = seq[seq[int]]

var bb: seq[Bingo] = @[]

while readLine(f, line):
  var b1: Bingo = @[]
  for i in 0..4:
    assert readLine(f, line)
    b1.add line.split(" ").filterIt(it.len > 0).map(parseInt)
  bb.add b1

proc set(b: var Bingo, n: int): bool =
  var okcol = [true, true, true, true, true]
  for y in b.mitems:
    var okrow = true
    for i, x in y:
      if x == n:
        y[i] = y[i] - 100
      if y[i] >= 0:
        okrow = false
        okcol[i] = false
    if okrow:
      return true
  okcol.anyIt(it)

proc calc(b: Bingo): int =
  for y in b:
    for x in y:
      if x >= 0:
        result += x

iterator ff(): int =
  var ok: seq[bool] = newSeq[bool](bb.len)
  for x in r:
    for i, _ in bb:
      if ok[i]:
        continue
      if bb[i].set(x):
        yield x*calc(bb[i])
        ok[i] = true
        if ok.allIt(it):
          yield x*calc(bb[i])

let res = toSeq(ff())
echo res[0]
echo res[^1]


