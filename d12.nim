import sequtils, strutils, tables, itertools, sugar, algorithm

type T = Table[system.string, seq[TaintedString]]

let pp = toSeq(lines("d12.in")).mapIt(it.split("-")).mapIt(@[(it[0], it[1]), (it[1], it[0])]).foldl(a&b)
let p = toSeq(pp.groupBy(x => x[0])).mapIt((it.k, it.v.mapIt(it[1]).sorted())).toTable

proc go(p: T, c: Table[string, int], room = "start"): seq[string] =
  var pVar = p
  var cVar = c
  if room == "end":
    return @[room]
  let rooms = p[room]
  if cVar.contains(room) and cVar[room] > 0:
    dec cVar[room]
  for x in rooms:
    if x == "start":
      continue
    if cVar.contains(x) and cVar[x] == 0:
      continue
    for y in go(pVar, cVar, x):
      result.add room & "," & y

proc calc(p: T, repeats: int): seq[string] =
  var c = initTable[string, int]()
  for k in p.keys:
    if k notin ["start", "end"] and k[0] in 'a'..'z':
      c[k] = 1
  for i in 0..<c.len:
    var cc = c
    cc[toSeq(cc.keys)[i]] = repeats
    result = deduplicate result & go(p, cc)
  
echo calc(p, 1).len
echo calc(p, 2).len
