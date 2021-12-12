import sequtils, strutils, tables, itertools, sugar, algorithm

type T = Table[system.string, seq[TaintedString]]

let pp = toSeq(lines("d12.in")).mapIt(it.split("-")).mapIt(@[(it[0], it[1]), (it[1], it[0])]).foldl(a&b)
# echo pp
let p = toSeq(pp.groupBy(x => x[0])).mapIt((it.k, it.v.mapIt(it[1]).sorted())).toTable

proc go(p: T, c: Table[string, int], room = "start"): seq[string] =
  var pVar = p
  var cVar = c
  if room == "end":
    return @[room]
  let rooms = p[room]
  if cVar[room] > 0:
    dec cVar[room]
  for x in rooms:
    if cVar[x] == 0:
      continue
    for y in go(pVar, cVar, x):
      result.add room & "," & y

proc calc(p: T): seq[string] =
  var c = initTable[string, int]()
  for k in p.keys:
    if k in ["start", "end"]: c[k] = 1
    elif k in "a".."z": c[k] = 1
    else: c[k] = -1
  echo c
  go(p, c)

echo calc(p).len
