import strutils, tables, sequtils

let fl = open("in/d14.in")
var t: string
assert readLine(fl, t)

var m = initTable[string, char]()

var line: string
assert readLine(fl, line)
while readLine(fl, line):
  let p = line.split(" -> ")
  m[p[0]] = p[1][0]

var cache = initTable[(string, int), CountTable[char]]()

proc pair(k: string, til: int, d = 1): CountTable[char] =
  if (k, d) in cache:
    return cache[(k, d)]
  let v = m[k]
  result.inc (v)
  if d < til:
    result.merge(pair(k[0]&v, til, d+1))
    result.merge(pair(v&k[1], til, d+1))
  cache[(k, d)] = result

proc f(t: string, lvl: int): int =
  var ct = initCountTable[char]()
  ct.inc t[^1]
  for i in 0..<t.high:
    ct.inc t[i]
    ct.merge pair(t[i..i+1], lvl)
  ct.largest[1] - ct.smallest[1]

echo f(t, 10)
cache.clear()
echo f(t, 40)
