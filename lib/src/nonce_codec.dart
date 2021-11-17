String encodeNonce(int nonce) {
  final result = StringBuffer();
  while (result.length < 6) {
    final index = nonce % maxIndex;
    result.write(nonceIndexToChar(index));
    nonce = nonce ~/ maxIndex;
  }
  return result.toString();
}

int decodeNonce(String str) {
  var nonce = 0;
  var mul = 1;
  final chars =
      List.generate(str.length, (index) => str[str.length - 1 - index])
          .reversed;
  for (final c in chars) {
    final index = nonceCharToIndex(c);
    nonce += index * mul;
    mul *= maxIndex;
  }
  return nonce;
}

const int maxIndex = 62;

String nonceIndexToChar(int index) {
  if (index < 10) {
    return String.fromCharCode(index + 48);
  }
  index -= 10;
  if (index < 26) {
    return String.fromCharCode(index + 97);
  }
  index -= 26;
  if (index < 26) {
    return String.fromCharCode(index + 65);
  }
  throw Exception();
}

int nonceCharToIndex(String char) {
  final codeUnits = char.codeUnits;
  if (codeUnits.length != 1) throw Exception();
  final code = codeUnits.first;
  if (code >= 48 && code < 58) {
    return code - 48;
  }
  if (code >= 97 && code < 123) {
    return code - 97;
  }
  if (code >= 65 && code < 91) {
    return code - 65;
  }
  throw Exception();
}
