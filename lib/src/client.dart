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
  final result =
      account.data?.mapOrNull(fromBytes: (value) => Pixel.unpack(value.bytes));
  if (result == null) {
    throw Exception(
        'client.getPixelByIndex : Failed to unpack account ${account.data?.runtimeType}');
  }
  return result;
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
  return accountList.map<Pixel?>((account) {
    if (account == null) return null;
    final result = account.data
        ?.mapOrNull(fromBytes: (value) => Pixel.unpack(value.bytes));
    if (result == null) {
      throw Exception(
          'client.getPixelsByIndex : Failed to unpack account ${account.runtimeType}');
    }
    return result;
  }).toList();
}

Future<StakedPixels?> getStakedPixels(
    {required RPCClient rpcClient, required String accountId}) async {
  final account = await rpcClient.getAccountInfo(accountId);
  if (account == null) return null;

  final result = account.data?.mapOrNull(fromBytes: (value) {
    if (value.bytes.length == StakedPixelsV1.packedSize) {
      return StakedPixelsV1.unpack(value.bytes);
    } else if (value.bytes.length == StakedPixelsV2.packedSize) {
      return StakedPixelsV2.unpack(value.bytes);
    } else {
      throw Exception();
    }
  });
  if (result == null) {
    throw Exception(
        'client.getStakedPixels : Failed to unpack account ${account.data?.runtimeType}');
  }
  return result;
}

Future<StakedPixelsV1?> getStakedPixelsV1(
    {required RPCClient rpcClient, required String accountId}) async {
  final account = await rpcClient.getAccountInfo(accountId);
  if (account == null) return null;
  final result = account.data
      ?.mapOrNull(fromBytes: (value) => StakedPixelsV1.unpack(value.bytes));
  if (result == null) {
    throw Exception(
        'client.getStakedPixelsV1 : Failed to unpack account ${account.data?.runtimeType}');
  }
  return result;
}

Future<StakedPixelsV2?> getStakedPixelsV2(
    {required RPCClient rpcClient, required String accountId}) async {
  final account = await rpcClient.getAccountInfo(accountId);
  if (account == null) return null;
  final result = account.data
      ?.mapOrNull(fromBytes: (value) => StakedPixelsV2.unpack(value.bytes));
  if (result == null) {
    throw Exception(
        'client.getStakedPixelsV2 : Failed to unpack account ${account.data?.runtimeType}');
  }
  return result;
}

Future<List<Pixel>> listPixels({
  required Config config,
  required RPCClient rpcClient,
  String? owner,
}) async {
  final rawResult = await rpcClient.getProgramAccounts(
    config.programId,
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
    final pixel = item.account.data
        ?.mapOrNull(fromBytes: (value) => Pixel.unpack(value.bytes));
    if (pixel == null) {
      throw Exception(
          'client.getStakedPixelsV2 : Failed to unpack account ${item.account.data?.runtimeType}');
    }
    result.add(pixel);
  }
  return result;
}
