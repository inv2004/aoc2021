import sequtils, strutils, strformat, parseutils

let nn = toSeq lines("in/d18.in")

func num(c: char): int =
  int(c) - int('0')

proc dip(s: string): string =
  var d = 0
  for c in s:
    case c
    of '[': inc d; result.add $d
    of ']': result.add $d; dec d
    of ',': result.add c
    else: result.add 'n'

# echo nn[0], "\n", dip nn[0], "\n"

proc reduce(x: string): string =
  var n = x
  while true:
    result = ""
    let d = dip n
    echo "reduce:  ", n
    echo "         ", d
    let pat = "5n,n5"

    # let pat = "5n,n5"
    let idx = d.find pat
    if 0 <= idx:
      let (a, b) = (num n[idx+1], num n[idx+3])
      # echo fmt"{a} {b}"
      # echo "explode: "
      let idxL = d.rfind("n", 0, idx)
      if idxL >= 0:
        # echo "left - ok "
        result.add n[0..<idxL]
        result.add $(a + num n[idxL])
        let s = n[idxL+2..<idx]
        result.add ","
        if s.len > 0:
          result.add s
        result.add "0"
      else:
        result.add n[0..<idx]
        result.add "0,"
      let idxR = d.find("n", idx+pat.len)
      if idxR >= 0:
        # echo "right - ok "
        if idxL >= 0:
          result.add n[idx+pat.len..<idxR]
        result.add $(b + num n[idxR])
        result.add n[idxR+1..^1]
      else:
        # echo "bbb"
        # result.add ",0"
        result.add n[idx+pat.len..^1]

    let pat2 = "nn"
    let idx2 = d.find pat2
    if idx < 0 and 0 <= idx2:
      # echo "split"
      let x = parseInt n[idx2..idx2+1]
      result.add n[0..<idx2]
      result.add fmt"[{x div 2},{(x - x div 2)}]"
      result.add n[idx2+pat2.len..^1]

    if not (idx >= 0 or idx2 >= 0):
      return n
    echo "R: ", result
    n = result
    # return result

proc add(a, b: string): string =
  reduce &"[{a},{b}]"

# doAssert "[[[[0,9],2],3],4]" == reduce "[[[[[9,8],1],2],3],4]"
# doAssert "[7,[6,[5,[7,0]]]]" == reduce "[7,[6,[5,[4,[3,2]]]]]"
# doAssert "[[6,[5,[7,0]]],3]" == reduce "[[6,[5,[4,[3,2]]]],1]"
# doAssert "[[3,[2,[8,0]]],[9,[5,[7,0]]]]" == reduce reduce "[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]"
# doAssert "[5,5]" == reduce "10"
# doAssert "[5,6]" == reduce "11"
# doAssert "[6,6]" == reduce "12"

let a = "[[[[4,3],4],4],[7,[[8,4],9]]]"
let b = "[1,1]"
# doAssert "[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]" == add(a,b)
# doAssert "[[[[0,7],4],[7,[[8,4],9]]],[1,1]]" == reduce add(a,b)
# doAssert "[[[[0,7],4],[15,[0,13]]],[1,1]]" == reduce reduce add(a,b)
# doAssert "[[[[0,7],4],[[7,8],[0,13]]],[1,1]]" == reduce reduce reduce add(a,b)
# doAssert "[[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]" == reduce reduce reduce reduce add(a,b)
# doAssert "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]" == add(a,b)

# doAssert "[[[[3,0],[5,3]],[4,4]],[5,5]]" == toSeq(1..5).mapIt(fmt"[{it},{it}]").foldl(add(a,b))
echo toSeq(1..5).mapIt(fmt"[{it},{it}]").foldl(add(a,b))
# echo nn.foldl(add(a,b))

