import sequtils, strutils

type T = seq[(int, int)]

let input = toSeq(lines("d13.in")).mapIt(it.split(","))
let d = input.filterIt(it.len == 2).mapIt(it.map(parseInt)).mapIt((it[0], it[1]))
let f = input.filterIt(it.len == 1 and it[0].startsWith("fold ")).mapIt((it[0][11], it[0][13..^1].parseInt))

func wh(ps: T): (int, int) =
  (ps.mapIt(it[0]).max(), ps.mapIt(it[1]).max())

func `$`(ps: T): string =
  let (w, h) = ps.wh()
  result = repeat(repeat(' ', 1 + w) & "\n", 1+h)
  for (x, y) in ps:
    result[(2+w)*y+x] = '#'

func count(ps: T): int =
  deduplicate(ps).len

func fold(ps: T, f: (char, int)): T =
  let (w, h) = ps.wh()
  for (x, y) in ps:
    if f[0] == 'y' and y > f[1]:
      result.add (x, h - y)
    elif f[0] == 'x' and x > f[1]:
      result.add (w - x, y)
    else:
      result.add (x, y)

echo d.fold(f[0]).count
echo f.foldl(a.fold(b), d)
