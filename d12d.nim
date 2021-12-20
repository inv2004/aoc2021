import sequtils, strutils, tables, itertools, sugar, algorithm, times

let pp = toSeq(lines("in/d12.in")).mapIt(it.split("-")).mapIt(@[(it[0], it[1]), (it[1], it[0])]).foldl(a&b)
var p = toSeq(pp.groupBy(x => x[0])).filterIt(it.k != "end").mapIt((it.k, (it.v.mapIt(it[1]).filterIt(it != "start").sorted()))).toTable

proc f(a: var seq[seq[string]]): bool =
  for i in 0..a.high:
    if a[i].len > 0 and a[i][^1] != "end":
      for xx in p[a[i][^1]]:
        if not (xx[0] in 'a'..'z' and xx in a[i]):
          a.add a[i]&xx
          result = true
      a[i].setLen 0

proc ff(a: var seq[seq[string]]): bool =
  for i in 0..a.high:
    if a[i].len > 0 and a[i][^1] != "end":
      let s = a[i].toCountTable
      var c = false
      for k, v in s:
        if k[0] in 'a'..'z' and v == 2:
          c = true
      for xx in p[a[i][^1]]:
        if not (xx[0] in 'a'..'z' and c and xx in s):
          a.add a[i]&xx
          result = true
      a[i].setLen 0

var a = @[@["start"]]
var t = cpuTime()
while f(a):
  discard
a.keepItIf(it.len > 0)
echo cpuTime()-t
echo a.len

a = @[@["start"]]
t = cpuTime()
while ff(a):
  discard

a.keepItIf(it.len > 0)
echo cpuTime()-t
echo a.len
