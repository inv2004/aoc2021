import sequtils

type T = seq[seq[int]]

var f = toSeq(lines("in/d11.in")).mapIt(it.mapIt(int(it)-int('0')))

# proc `$`(f: T): string =
#    f.mapIt(it.join()).join("\n") & "\n"

proc step(f: var T): int =
  for r in f.mitems:
    for x in r.mitems:
      if x in 0..9:
        inc x

  var changed = true
  while changed:
    changed = false
    for j, r in f:
      for i, x in r:
        if x == 10:
          f[j][i] = 0
          inc result
          for y in -1..1:
            for x in -1..1:
              if x == 0 and y == 0:
                continue
              if i+x in 0..r.high and j+y in 0..f.high and f[j+y][i+x] in 1..9:
                inc f[j+y][i+x]
                changed = true

var flashes = 0

for i in 1..10000:
  flashes += step f
  if i == 100:
    echo flashes
  if f.foldl(a&b).countIt(it == 0) == 100:
    echo i
    break
