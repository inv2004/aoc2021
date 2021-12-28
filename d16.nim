import sequtils, strutils, streams, bitops

type T = object
  s: StringStream
  buf: uint
  bufLen: int
  vers: uint
  done: int

proc b(s: var T, n: int): uint =
  while n > s.bufLen:
    if s.s.atEnd():
      return 0
    s.buf = s.buf shl 8 or s.s.readUint8
    s.bufLen += 8
  result = s.buf.bitsliced((s.bufLen-n)..<s.bufLen)
  s.bufLen -= n
  s.done += n

proc l(s: var T): uint =
  var buf: uint = 0b10000
  while buf.bitsliced(4..4) == 1:
    buf = s.b(5)
    result = result shl 4 or buf.bitsliced(0..3)

proc p(s: var T, printVer = false): uint

proc sp(s: var T): seq[uint] =
  case s.b(1)
  of 0:
    let l = s.done + int(s.b(15))
    while s.done < l:
      result.add s.p()
  of 1:
    for i in 1..int(s.b(11)):
      result.add s.p()
  else:
    doAssert false
    
proc p(s: var T, printVer = false): uint =
  let ver = s.b(3)
  s.vers += ver
  case s.b(3)
  of 0: result = s.sp().foldl(a+b)
  of 1: result = s.sp().foldl(a*b)
  of 2: result = s.sp().min()
  of 3: result = s.sp().max()
  of 4: result = s.l()
  of 5: result = s.sp().foldl(uint a>b)
  of 6: result = s.sp().foldl(uint a<b)
  of 7: result = s.sp().foldl(uint a==b)
  else: doAssert false
  if printVer:
    echo s.vers

proc ps(x: string) =
  var s = T(s: newStringStream parseHexStr x)
  echo p(s, true)

ps toSeq(lines("in/d16.in"))[0]