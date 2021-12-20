import sequtils, strutils, tables, itertools, sugar, algorithm, times

type T = Table[string, (int, seq[string])]

let pp = toSeq(lines("in/d12.in")).mapIt(it.split("-")).mapIt(@[(it[0], it[1]), (it[1], it[0])]).foldl(a&b)
var p = toSeq(pp.groupBy(x => x[0])).mapIt((it.k, ((if it.k[0] in 'a'..'z': 1 else: -1), it.v.mapIt(it[1]).filterIt(it != "start").sorted()))).toTable
var p2 = p

proc go(p: var T, two: bool, room = "start"): int =
  if room == "end":
    return 1
  dec p[room][0]
  for r in p[room][1]:
    if p[r][0] != 0:
      result += go(p, two, r)
      inc p[r][0]
    elif two:
      inc p[r][0]
      result += go(p, false, r)

var t = cpuTime()
echo go(p, false)
echo cpuTime() - t

t = cpuTime()
echo go(p2, true)
echo cpuTime() - t
