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

Future<String> getProgramAuthorityId({
  required String programId,
}) {
  return solana.findProgramAddress(
    seeds: [
      solana.base58decode(programId),
      utf8.encode('authority'),
    ],
    programId: programId,
  );
}

Future<String> getStakePoolId({
  required String programId,
}) {
  return solana.findProgramAddress(
    seeds: [
      solana.base58decode(programId),
      utf8.encode('stake_pool'),
    ],
    programId: programId,
  );
}

Future<String> getStakedPixelsId({
  required String programId,
  required String nftMint,
}) {
  return solana.findProgramAddress(
    seeds: [
      solana.base58decode(programId),
      solana.base58decode(nftMint),
      utf8.encode('staked_pixels'),
    ],
    programId: programId,
  );
}

Future<String> getStakedPixelsNftMintId({
  required String programId,
  required int x,
  required int y,
  required int width,
  required int height,
  required int nonce,
}) {
  return solana.findProgramAddress(
    seeds: [
      solana.base58decode(programId),
      packUInt(x, 4),
      packUInt(y, 4),
      packUInt(width, 4),
      packUInt(height, 4),
      packUInt(nonce, 4),
      utf8.encode('staked_pixels_nft_mint'),
    ],
    programId: programId,
  );
}

Future<List<String>> listPixelIds({
  required String programId,
  required int x,
  required int y,
  required int width,
  required int height,
}) async {
  final pixels = <String>[];
  for (var j = y; j < y + height; j++) {
    for (var i = x; i < x + width; i++) {
      pixels.add(await getPixelAccountId(programId: programId, index: pixelPositionToIndex(i, j)));
    }
  }
  return pixels;
}

int pixelPositionToIndex(int i, int j) => i + 1000 * j;

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
    return (data ~/ math.pow(2, 8 * index)) % 256;
  });
  if (endian == Endian.big) {
    result = result.reversed.toList();
  }
  return result;
}
