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
      packUInt32(index),
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

List<int> packUInt32(int data, {Endian endian = Endian.little}) {
  return Uint8List(4)..buffer.asByteData().setUint32(0, data, endian);
}

List<int> packUInt64(int data, {Endian endian = Endian.little}) {
  return Uint8List(8)..buffer.asByteData().setUint64(0, data, endian);
}
