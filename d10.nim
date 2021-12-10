import sequtils, strutils, algorithm

proc pair(c: char): char =
  case c
  of ')': return '('
  of ']': return '['
  of '}': return '{'
  of '>': return '<'
  else: assert false

proc scoreErr(c: char): int =
  case c
  of ')': return 3
  of ']': return 57
  of '}': return 1197
  of '>': return 25137
  else: assert false

proc scoreComp(s: string): int =
  for c in s:
    result *= 5
    case c
    of '(': result += 1
    of '[': result += 2
    of '{': result += 3
    of '<': result += 4
    else: assert false

proc check(s: string): (int, int) =
  var r = ""
  for i, x in s:
    case x
    of '[', '(', '{', '<':
      r.add x
    of ']', ')', '}', '>':
      if r[^1] == pair(x):
        r.setLen(r.len - 1)
      else:
        return (scoreErr x, 0)
    else:
      assert false

  return (0, scoreComp r.reversed().join())

echo toSeq(lines("d10.in")).map(check).mapIt(it[0]).foldr(a+b)
let r = toSeq(lines("d10.in")).map(check).mapIt(it[1]).filterIt(it > 0).sorted()
echo r[r.len div 2]