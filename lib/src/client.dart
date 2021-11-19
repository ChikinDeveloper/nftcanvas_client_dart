import 'dart:convert';

import 'package:chikin_nft_canvas_client/src/config.dart';
import 'package:chikin_nft_canvas_client/src/model.dart';
import 'package:solana/solana.dart';

import 'utils.dart' as utils;

Future<Pixel?> getPixelByIndex({
  required Config config,
  required RPCClient rpcClient,
  required int index,
}) async {
  final accountId =
      await utils.getPixelAccountId(programId: config.programId, index: index);
  final account = await rpcClient.getAccountInfo(accountId);
  if (account == null) return null;
  final dataBytes = base64.decode(account.data[0]);
  return Pixel.unpack(dataBytes);
}

Future<List<Pixel?>> getPixelsByIndex({
  required Config config,
  required RPCClient rpcClient,
  required List<int> indexList,
}) async {
  final accountIdList = <String>[];
  for (final index in indexList) {
    final accountId = await utils.getPixelAccountId(
        programId: config.programId, index: index);
    accountIdList.add(accountId);
  }
  final accountList = await rpcClient.getMultipleAccounts(accountIdList);
  return accountList.map((account) {
    if (account == null) return null;
    final dataBytes = base64.decode(account.data[0]);
    return Pixel.unpack(dataBytes);
  }).toList();
}

Future<StakedPixels?> getStakedPixels(
    {required RPCClient rpcClient, required String accountId}) async {
  final account = await rpcClient.getAccountInfo(accountId);
  if (account == null) return null;
  final dataBytes = base64.decode(account.data[0]);
  if (dataBytes.length == StakedPixelsV1.packedSize) {
    return StakedPixelsV1.unpack(dataBytes);
  } else if (dataBytes.length == StakedPixelsV2.packedSize) {
    return StakedPixelsV2.unpack(dataBytes);
  } else {
    throw Exception();
  }
}

Future<StakedPixelsV1?> getStakedPixelsV1(
    {required RPCClient rpcClient, required String accountId}) async {
  final account = await rpcClient.getAccountInfo(accountId);
  if (account == null) return null;
  final dataBytes = base64.decode(account.data[0]);
  return StakedPixelsV1.unpack(dataBytes);
}

Future<StakedPixelsV2?> getStakedPixelsV2(
    {required RPCClient rpcClient, required String accountId}) async {
  final account = await rpcClient.getAccountInfo(accountId);
  if (account == null) return null;
  final dataBytes = base64.decode(account.data[0]);
  return StakedPixelsV2.unpack(dataBytes);
}

Future<List<Pixel>> listPixels({
  required Config config,
  required RPCClient rpcClient,
  String? owner,
}) async {
  final rawResult = await rpcClient.getProgramAccounts(
    programId: config.programId,
    filters: [
      {'dataSize': Pixel.packedSize},
      if (owner != null)
        {
          'memcmp': {
            'offset': 7,
            'bytes': owner,
          }
        }
    ],
  );
  final result = <Pixel>[];
  for (final item in rawResult) {
    final dataStr = item['account']['data'][0];
    final data = base64Decode(dataStr);
    final pixel = Pixel.unpack(data);
    result.add(pixel);
  }
  return result;
}
