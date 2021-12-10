import sequtils
import strutils

const sz = 1000

type M = array[sz,array[sz,int]]

let n = toSeq(lines("d5.in")).mapIt(it.split(" -> ")).mapIt(it.mapIt(it.split(",").map(parseInt))).mapIt(it[0][0..1]&it[1][0..1])

proc `$`(x: M): string =
  x.mapIt(it.mapIt(if it == 0: '.' else: char(int('0')+it)).join()).join("\n")

proc draw(d: bool): M =
  for x in n:
    var x0 = x[0]
    var y0 = x[1]
    let x1 = x[2]
    let y1 = x[3]
    if d and x0 != x1 and y0 != y1:
      continue
    while x0 != x1 or y0 != y1:
      inc result[y0][x0]
      if x0 < x1: inc x0
      elif x0 > x1: dec x0
      if y0 < y1: inc y0
      elif y0 > y1: dec y0
    inc result[y0][x0]

echo draw(true).mapIt(it.mapIt(it >= 2).count(true)).foldl(a+b)
echo draw(false).mapIt(it.mapIt(it >= 2).count(true)).foldl(a+b)

