import 'dart:convert';
import 'dart:math' as math;
import 'dart:math';
import 'dart:typed_data';

import 'package:chikin_nft_canvas_client/chikin_nft_canvas_client.dart';
import 'package:solana/solana.dart' as solana;
import 'package:solana_js/solana_js.dart';

Future<String> getPixelAccountId({
  required String programId,
  required int index,
}) {
  return SolanaJsUtils.findProgramAddress(
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
  return SolanaJsUtils.findProgramAddress(
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
  return SolanaJsUtils.findProgramAddress(
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
  return SolanaJsUtils.findProgramAddress(
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
  return SolanaJsUtils.findProgramAddress(
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
  return SolanaJsUtils.findProgramAddress(
    seeds: [
      solana.base58decode(programId),
      solana.base58decode(nftMint),
      utf8.encode('staked_pixels'),
    ],
    programId: programId,
  );
}

Future<String> getStakedPixelsNftMintIdV1({
  required String programId,
  required int x,
  required int y,
  required int width,
  required int height,
  required int nonce,
}) {
  return SolanaJsUtils.findProgramAddress(
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

Future<String> getStakedPixelsNftMintIdV2({
  required String programId,
  required int x,
  required int y,
}) {
  return SolanaJsUtils.findProgramAddress(
    seeds: [
      solana.base58decode(programId),
      packUInt(x, 4),
      packUInt(y, 4),
      utf8.encode('staked_pixels_nft_mint_v2'),
    ],
    programId: programId,
  );
}

Future<String> getNftMetadataAccountId({
  required String metaplexTokenMetadataProgramId,
  required String nftMint,
}) {
  return SolanaJsUtils.findProgramAddress(
    seeds: [
      utf8.encode('metadata'),
      solana.base58decode(metaplexTokenMetadataProgramId),
      solana.base58decode(nftMint),
    ],
    programId: metaplexTokenMetadataProgramId,
  );
}

List<Point<int>> getSelectionPixelsV1Positions({
  required int x,
  required int y,
  required int width,
  required int height,
}) {
  final pixels = <Point<int>>[];
  for (var j = y; j < y + height; j++) {
    for (var i = x; i < x + width; i++) {
      pixels.add(Point(i, j));
    }
  }
  return pixels;
}

Future<List<String>> getSelectionPixelsV1({
  required String programId,
  required int x,
  required int y,
  required int width,
  required int height,
}) async {
  final result = <String>[];
  for (final position in getSelectionPixelsV1Positions(
      x: x, y: y, width: width, height: height)) {
    final index = pixelPositionToIndex(position.x, position.y);
    result.add(await getPixelAccountId(programId: programId, index: index));
  }
  return result;
}

List<Point<int>> getSelectionPixelsV2Positions({
  required int x,
  required int y,
  required int width,
  required int offset,
  required int count,
}) {
  final pixels = <Point<int>>[];
  for (var index = offset; index < offset + count; index++) {
    final i = index % width;
    final j = index ~/ width;
    pixels.add(Point(i + x, j + y));
  }
  return pixels;
}

Future<List<String>> getSelectionPixelsV2({
  required String programId,
  required int x,
  required int y,
  required int width,
  required int offset,
  required int count,
}) async {
  final result = <String>[];
  for (final position in getSelectionPixelsV2Positions(
      x: x, y: y, width: width, offset: offset, count: count)) {
    final index = pixelPositionToIndex(position.x, position.y);
    result.add(await getPixelAccountId(programId: programId, index: index));
  }
  return result;
}

int pixelPositionToIndex(int i, int j) => i + 1000 * j;

Point<int> pixelIndexToPosition(int index) =>
    Point(index % 1000, index ~/ 1000);

int unpackUInt(
  List<int> data, {
  Endian endian = Endian.little,
  int maxFragmentValue = 256,
}) {
  var slice = List.of(data);
  if (endian == Endian.big) {
    slice = slice.reversed.toList();
  }
  var result = 0;
  var pow = 0;
  for (final e in slice) {
    result += e * math.pow(maxFragmentValue, pow).toInt();
    pow += 1;
  }
  return result;
}

List<int> packUInt(
  int data,
  int byteCount, {
  Endian endian = Endian.little,
  int maxFragmentValue = 256,
}) {
  if (data < 0) throw Exception();
  var result = List.generate(byteCount, (index) {
    return (data ~/ math.pow(maxFragmentValue, index)) % maxFragmentValue;
  });
  if (endian == Endian.big) {
    result = result.reversed.toList();
  }
  return result;
}

List<int> packInt(
  int data,
  int byteCount, {
  Endian endian = Endian.little,
  int maxFragmentValue = 256,
}) {
  final result = packUInt(data.abs(), byteCount,
      endian: endian, maxFragmentValue: maxFragmentValue);
  if (data < 0) {
    if (endian == Endian.little) {
      result[result.length - 1] = 1;
    } else {
      result[0] = 1;
    }
  }
  return result;
}

class StakedPixelsNftMintInfo {
  final int version;
  final String mint;

  StakedPixelsNftMintInfo(this.version, this.mint);
}

Future<StakedPixelsNftMintInfo> findCheckedStakedPixelsNftMint({
  required String programId,
  required String stakedPixelsId,
  required StakedPixels stakedPixels,
}) async {
  final nftMint = await stakedPixels.nftMint(programId);
  final resStakedPixelsId =
      await getStakedPixelsId(programId: programId, nftMint: nftMint);
  if (stakedPixelsId != resStakedPixelsId) {
    throw Exception();
  }
  return StakedPixelsNftMintInfo(stakedPixels.version(), nftMint);
}

const base62Alphabet =
    '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

String packStakedPixelsNftMintCode(int x, int y) {
  final index = pixelPositionToIndex(x, y);
  final indexBytes =
      packUInt(index, 4, maxFragmentValue: 62, endian: Endian.big);
  final result = StringBuffer();
  for (final byte in indexBytes) {
    result.write(base62Alphabet[byte]);
  }
  return result.toString();
}

Point<int> unpackStakedPixelsNftMintCode(String code) {
  final indexBytes =
      code.split('').map((e) => base62Alphabet.indexOf(e)).toList();
  final index =
      unpackUInt(indexBytes, maxFragmentValue: 62, endian: Endian.big);
  return pixelIndexToPosition(index);
}
