import sequtils, strutils, tables, itertools, sugar, algorithm, times

type T = Table[string, seq[string]]

let pp = toSeq(lines("d12.in")).mapIt(it.split("-")).mapIt(@[(it[0], it[1]), (it[1], it[0])]).foldl(a&b)
var p = toSeq(pp.groupBy(x => x[0])).filterIt(it.k != "end").mapIt((it.k, (it.v.mapIt(it[1]).filterIt(it != "start").sorted()))).toTable

proc check(v: openArray[string], n: string): int =
  for x in v:
    if x == n:
      inc result

proc go(p: var T, two: int): int =
  var tt = two
  var v = newSeq[string]()
  var i = newSeq[int]()
  v.add "start"
  i.add 0
  while true:
    if v.len == 0:
      break
    let room = v[^1]
    let idx = i[^1]
    if room == "end":
      inc result
      v.setLen(v.len - 1)
      i.setLen(i.len - 1)
    elif idx > p[room].high:
      v.setLen(v.len - 1)
      i.setLen(i.len - 1)
    elif p[room][idx][0] in 'a'..'z' and v.check(p[room][idx]) in 1..tt:
      inc i[^1]
      tt = 1
    else:
      v.add(p[room][idx])
      inc i[^1]
      i.add 0

var t = cpuTime()
echo go(p, 1)
echo cpuTime() - t
# echo go(p, 2)
