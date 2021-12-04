import sequtils
import strutils

let f = open("d4.in")
var line: string

assert readLine(f, line)
let r = line.split(",").map(parseInt)

echo r

type Bingo = seq[seq[int]]

var b: seq[Bingo] = @[]

while readLine(f, line):
  var b1: Bingo = @[]
  for i in 0..4:
    assert readLine(f, line)
    b1.add line.split(" ").filterIt(it.len > 0).map(parseInt)
  b.add b1

proc set(b: var Bingo, n: int): bool =
  for y in b.mitems:
    var okrow = true
    for i, x in y:
      if x == n:
        y[i] = 100 + y[i]
      if x < 100:
        okrow = false
    if okrow:
      return true

echo b[0]
b[0].set(22)
b[0].set(13)
echo b[0]
