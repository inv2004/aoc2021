import strutils, sequtils, algorithm

type T = array[7, bool]

echo toSeq(lines("d8.in")).mapIt(it.split(" | ")[1].split().mapIt(it.len)).foldr(a&b).countIt(it in [2,4,3,7])

proc strToArr(s: string): T =
  for x in s:
    result[int(x)-int('a')] = true

let accepted = ["abcefg", "cf", "acdeg", "acdfg", "bcdf", "abdfg", "abdefg", "acf", "abcdefg", "abcdfg"].map(strToArr)

proc arrToNum(a: T): int =
  for i, x in accepted:
    if x == a:
      return i

# proc `$`(x: T): string =
#   $arrToNum(x)

proc find(s: string): int =
  let left = s.split(" | ")[0].split().map(strToArr)
  let right = s.split(" | ")[1].split().map(strToArr)

  var p = [0, 1, 2, 3, 4, 5, 6]

  while p.nextPermutation():
    var found = true
    for x in left:
      let newP = [x[p[0]], x[p[1]], x[p[2]], x[p[3]], x[p[4]], x[p[5]], x[p[6]]]
      if not (newP in accepted):
        found = false
        break

    if found:
      for x in right:
        result = result * 10
        result += arrToNum [x[p[0]], x[p[1]], x[p[2]], x[p[3]], x[p[4]], x[p[5]], x[p[6]]]
      break

echo toSeq(lines("d8.in")).map(find).foldr(a+b)
