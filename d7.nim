import sequtils, strutils, math, sugar

let n = readFile("d7.in").split(",").map(parseInt)

echo toSeq(0..n.high).map(i => n.map(x => abs(x - i)).map(x => x * (x+1) div 2).sum()).min()