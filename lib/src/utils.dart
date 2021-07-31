import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:solana/solana.dart' as solana;

Future<String> getPixelAccountId({
  required String programId,
  required int index,
}) {
  return solana.findProgramAddress(
    seeds: [
      solana.base58decode(programId),
      utf8.encode('pixel'),
      packUInt(index, 4),
    ],
    programId: programId,
  );
}

Future<String> getTradePoolId({
  required String programId,
}) {
  return solana.findProgramAddress(
    seeds: [
      solana.base58decode(programId),
      utf8.encode('trade_pool'),
    ],
    programId: programId,
  );
}

Future<String> getTokenAccountId({
  required String tokenProgramId,
  required String associatedTokenProgramId,
  required String tokenMintId,
  required String ownerId,
}) async {
  return solana.findProgramAddress(
    seeds: [
      solana.base58decode(ownerId),
      solana.base58decode(tokenProgramId),
      solana.base58decode(tokenMintId),
    ],
    programId: associatedTokenProgramId,
  );
}

int unpackUInt(List<int> data, {Endian endian = Endian.little}) {
  var slice = List.of(data);
  if (endian == Endian.big) {
    slice = slice.reversed.toList();
  }
  var result = 0;
  var pow = 0;
  for (final e in slice) {
    result += e * math.pow(2, pow).toInt();
    pow += 8;
  }
  return result;
}

List<int> packUInt(int data, int byteCount, {Endian endian = Endian.little}) {
  var result = List.generate(byteCount, (index) {
    return (data ~/ math.pow(2, 8*index)) % 256;
  });
  if (endian == Endian.big) {
    result = result.reversed.toList();
  }
  return result;
}
