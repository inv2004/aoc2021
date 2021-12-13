import sequtils, strutils, sets

type T = HashSet[(int, int)]

let input = toSeq(lines("d13.in")).filterIt(it.len > 0).mapIt(it.split(","))
let d = input.filterIt(it.len == 2).mapIt(it.map(parseInt)).mapIt((it[0], it[1])).toHashSet
let f = input.filterIt(it.len == 1).mapIt((it[0][11], it[0][13..^1].parseInt))

func wh(ps: T): (int, int) =
  (ps.mapIt(it[0]).max(), ps.mapIt(it[1]).max())

func `$`(ps: T): string =
  let (w, h) = ps.wh()
  result = repeat(repeat(' ', 1+w) & "\n", 1+h)
  for (x, y) in ps:
    result[(2+w)*y+x] = '#'

func fold(ps: T, f: (char, int)): T =
  let (w, h) = ps.wh()
  for (x, y) in ps:
    if f[0] == 'y' and y > f[1]:
      result.incl (x, h - y)
    elif f[0] == 'x' and x > f[1]:
      result.incl (w - x, y)
    else:
      result.incl (x, y)

echo d.fold(f[0]).len
echo f.foldl(a.fold(b), d)
