import sequtils, strutils, strformat, re

let nn = toSeq lines("in/d18.in")

func numL(s: string, off: int): int =
  var i = off
  var numStr = ""
  while i > 0 and s[i].isDigit:
    numStr = s[i] & numStr
    dec i
  parseInt numStr

proc dip(s: string): string =
  var d = 0
  for c in s:
    case c
    of '[': inc d; result.add $d
    of ']': result.add $d; dec d
    of ',': result.add c
    else: result.add 'n'

proc explode(res: var string): bool =
  let n = res
  let d = dip n
  let (idx, idxB) = d.findBounds(re"5n+,n+5")
  var matches = ["", ""]
  if 0 <= idx:
    # echo "explode: ", n
    # echo "      d: ", d
    res = ""
    discard n.find(re"\[(\d+),(\d+)\]", matches, idx)
    let (a, b) = (parseInt matches[0], parseInt matches[1])
    # echo fmt"{a} {b}"
    let idxL = d.rfind("n", 0, idx)
    if idxL >= 0:
      # echo "left - ok"
      let l = numL(n, idxL)
      res.add n[0..idxL-len($l)]
      res.add $(a + l)
      res.add n[idxL+1..<idx]
    else:
      res.add n[0..<idx]
    res.add "0"
    let idxR = d.find("n", idxB+1)
    if idxR >= 0:
      # echo "right - ok"
      discard n.find(re"(\d+)", matches, idxR)
      let r = parseInt matches[0]
      res.add n[idxB+1..<idxR]
      res.add $(b + r)
      res.add n[idxR+len($r)..^1]
    else:
      res.add n[idxB+1..^1]
    # echo "     <-: ", res, fmt" {len(res)}"
    return true

proc split(res: var string): bool =
  let n = res
  let d = dip n
  let pat = "nn"
  let idx = d.find pat
  if 0 <= idx:
    res = ""
    # echo "split: ", n
    var matches = [""]
    discard n.find(re"(\d+)", matches, idx)
    let x = parseInt matches[0]
    res.add n[0..<idx]
    res.add fmt"[{x div 2},{x - x div 2}]"
    res.add n[idx+pat.len..^1]
    return true

proc reduce(n: string): string =
  result = n
  while true:
    # echo "IN:  ", result
    # echo "     ", dip result
    var changed = true
    while changed:
      changed = false
      if explode(result):
        changed = true
      elif split(result):
        changed = true
    # echo "OUT: ", result
    if not changed:
      return result
    # return result

proc addN(a, b: string): string =
  reduce fmt"[{a},{b}]"

proc mag(n: string): int =
  var res = n
  var matches = ["", ""]
  while true:
    let (idx, idxB) = res.findBounds(re"\[(\d+),(\d+)\]", matches)
    if idx < 0:
      break
    let (a, b) = (parseInt matches[0], parseInt matches[1])
    res = res[0..<idx] & $(a*3 + b*2) & res[idxB+1..^1]
  result = parseInt res

doAssert "[[[[0,9],2],3],4]" == reduce "[[[[[9,8],1],2],3],4]"
doAssert "[7,[6,[5,[7,0]]]]" == reduce "[7,[6,[5,[4,[3,2]]]]]"
doAssert "[[6,[5,[7,0]]],3]" == reduce "[[6,[5,[4,[3,2]]]],1]"
doAssert "[[3,[2,[8,0]]],[9,[5,[7,0]]]]" == reduce reduce "[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]"
doAssert "[5,5]" == reduce "10"
doAssert "[5,6]" == reduce "11"
doAssert "[6,6]" == reduce "12"

doAssert "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]" == addN("[[[[4,3],4],4],[7,[[8,4],9]]]", "[1,1]")

doAssert "[[[[1,1],[2,2]],[3,3]],[4,4]]" == toSeq(1..4).mapIt(fmt"[{it},{it}]").foldl(addN(a,b))
doAssert "[[[[3,0],[5,3]],[4,4]],[5,5]]" == toSeq(1..5).mapIt(fmt"[{it},{it}]").foldl(addN(a,b))
doAssert "[[[[5,0],[7,4]],[5,5]],[6,6]]" == toSeq(1..6).mapIt(fmt"[{it},{it}]").foldl(addN(a,b))

echo mag nn.foldl(addN(a,b))

var mm = 0
for i in 0..nn.high:
  for j in 0..nn.high:
    if i == j:
      continue
    mm = mm.max mag addN(nn[i], nn[j])
echo mm
