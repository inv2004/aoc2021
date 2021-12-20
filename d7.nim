import sequtils, strutils, math, sugar

let n = readFile("in/d7.in").split(",").map(parseInt)

let a = toSeq(0..n.high).map(i => n.map(x => abs(x - i)))

echo a.mapIt(it.sum()).min()
echo a.mapIt(it.mapIt(it * (it+1) div 2).sum()).min()