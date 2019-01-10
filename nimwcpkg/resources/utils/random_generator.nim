import strutils, random, sequtils

const
  rlAscii  = toSeq('a'..'z')
  rhAscii  = toSeq('A'..'Z')
  rDigit   = toSeq('0'..'9')
  rSpecial = ["!", ",", "$", "/", "(", ")", "?", "_"]
randomize()

proc randomString*(length: int): string =
  ## Generate random number with special chars, alpha and digits.
  ## The length is specified as parameter.
  for i in countUp(1, length):
    var runRandom = rand(3)

    case runRandom
    of 0:
      result.add(rand(rlAscii))
    of 1:
      result.add(rand(rhAscii))
    of 2:
      result.add(rand(rDigit))
    of 3:
      result.add(rand(rSpecial))
    else:
      discard


proc randomStringAlpha*(length: int): string =
  ## Generate random number with alpha.
  ## The length is specified as parameter.
  for i in countUp(1, length):
    var runRandom = rand(1)

    case runRandom
    of 0:
      result.add(rand(rlAscii))
    of 1:
      result.add(rand(rhAscii))
    else:
      discard


proc randomStringDigit*(length: int): string =
  ## Generate random number with digits.
  ## The length is specified as parameter.
  for i in countUp(1, length):
    result.add(rand(rDigit))


proc randomStringDigitAlpha*(length: int): string =
  ## Generate random number with alpha and digits.
  ## The length is specified as parameter.
  for i in countUp(1, length):
    var runRandom = rand(2)

    case runRandom
    of 0:
      result.add(rand(rlAscii))
    of 1:
      result.add(rand(rhAscii))
    of 2:
      result.add(rand(rDigit))
    else:
      discard
