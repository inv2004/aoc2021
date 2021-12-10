import sequtils, algorithm, tables

const pair = {')': '(', ']': '[', '}': '{', '>': '<'}.toTable
const errScore = {')': 3, ']': 57, '}': 1197, '>': 25137}.toTable
const compScore = {'(': 1, '[': 2, '{': 3, '<': 4}.toTable

proc check(s: string): (int, int) =
  var r = ""
  for i, x in s:
    if x in "[({<":
      r.add x
    elif r[^1] == pair[x]:
        r.setLen(r.len - 1)
    else:
      return (errScore[x], 0)
  return (0, r.reversed().foldl(a*5+compScore[b], 0))

echo toSeq(lines("d10.in")).map(check).mapIt(it[0]).foldr(a+b)
let r = toSeq(lines("d10.in")).map(check).mapIt(it[1]).filterIt(it > 0).sorted()
echo r[r.len div 2]