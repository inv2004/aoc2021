import sequtils, strutils, algorithm

let s = toSeq(lines("d9.in")).mapIt(it.mapIt(int(it)-int('0')))

# proc `$`(n: seq[seq[int]]): string =
#   n.mapIt(it.join()).join("\n")

proc find2(nn: seq[seq[int]], j, i: int): int =
  var n = nn
  n[j][i] = -1
  var changed = true
  while changed:
    changed = false
    for j, y in n:
      for i, x in y:
        if x < 0:
          if (i-1) in 0..y.high and y[i-1] in 0..8: # left
            n[j][i-1] = -1
            changed = true
          if (i+1) in 0..y.high and y[i+1] in 0..8: # right
            n[j][i+1] = -1
            changed = true
          if (j-1) in 0..n.high and n[j-1][i] in 0..8: # up
            n[j-1][i] = -1
            changed = true
          if (j+1) in 0..n.high and n[j+1][i] in 0..8: # down
            n[j+1][i] = -1
            changed = true

  n.mapIt(it.countIt(it < 0)).foldl(a+b)

proc find1(n: seq[seq[int]]): (int, int) =
  var pools:seq[int] = @[]

  for j, y in n:
    for i, x in y:
      let l = (i-1) notin 0..y.high or x < y[i-1] # left
      let r = (i+1) notin 0..y.high or x < y[i+1] # right
      let u = (j-1) notin 0..n.high or x < n[j-1][i] # up
      let d = (j+1) notin 0..n.high or x < n[j+1][i] # down
      if l and r and u and d:
        result[0] += 1+x
        pools.add find2(n, j, i)

  pools.sort(order = Descending)
  result[1] = pools[0..2].foldl(a*b)

echo find1(s)
