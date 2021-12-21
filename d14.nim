import strutils, tables, sequtils

let fl = open("in/d14.in")
var t: string
assert readLine(fl, t)

echo t

var m = initTable[string, string]()

var line: string
assert readLine(fl, line)
while readLine(fl, line):
  let p = line.split(" -> ")
  m[p[0]] = p[0][0] & p[1][0] & p[0][1]

echo m

proc f(t: string): string =
  let h = t.high - 1
  for i in 0..h:
    let k = t[i..i+1]
    if i < h:
      result.add m[k][0..1]
    else:
      result.add m[k]

for i in 1..40:
  echo i
  t = f(t)

let tc = t.toCountTable
echo tc.largest[1] - tc.smallest[1]