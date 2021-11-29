import 'package:chikin_nft_canvas_client/src/config.dart';
import 'package:chikin_nft_canvas_client/src/model.dart';
import 'package:solana/solana.dart';
import 'package:solana/src/rpc/dto/account_data/binary_account_data.dart';
import 'package:solana/src/rpc/dto/filter.dart';

import 'utils.dart' as utils;

Future<Pixel?> getPixelByIndex({
  required Config config,
  required RpcClient rpcClient,
  required int index,
}) async {
  final accountId =
      await utils.getPixelAccountId(programId: config.programId, index: index);
  final account = await rpcClient.getAccountInfo(accountId, encoding: Encoding.base64);
  if (account == null) return null;
  final result = Pixel.unpack((account.data as BinaryAccountData).data);
  return result;
}

Future<List<Pixel?>> getPixelsByIndex({
  required Config config,
  required RpcClient rpcClient,
  required List<int> indexList,
}) async {
  final accountIdList = <String>[];
  for (final index in indexList) {
    final accountId = await utils.getPixelAccountId(
        programId: config.programId, index: index);
    accountIdList.add(accountId);
  }
  final accounts = await rpcClient.getMultipleAccounts(
    accountIdList,
    encoding: Encoding.base64,
  );
  return accounts.map<Pixel?>((account) {
    if (account == null) return null;
    final result = Pixel.unpack((account.data as BinaryAccountData).data);
    return result;
  }).toList();
}

Future<StakedPixels?> getStakedPixels(
    {required RpcClient rpcClient, required String accountId}) async {
  final account = await rpcClient.getAccountInfo(accountId, encoding: Encoding.base64);
  if (account == null) return null;

  final data = account.data as BinaryAccountData;
  if (data.data.length == StakedPixelsV1.packedSize) {
    return StakedPixelsV1.unpack(data.data);
  } else if (data.data.length == StakedPixelsV2.packedSize) {
    return StakedPixelsV2.unpack(data.data);
  } else {
    throw Exception();
  }
}

Future<StakedPixelsV1?> getStakedPixelsV1(
    {required RpcClient rpcClient, required String accountId}) async {
  final account = await rpcClient.getAccountInfo(accountId, encoding: Encoding.base64);
  if (account == null) return null;
  final result =
      StakedPixelsV1.unpack((account.data as BinaryAccountData).data);
  return result;
}

Future<StakedPixelsV2?> getStakedPixelsV2(
    {required RpcClient rpcClient, required String accountId}) async {
  final account = await rpcClient.getAccountInfo(accountId, encoding: Encoding.base64);
  if (account == null) return null;
  final result =
      StakedPixelsV2.unpack((account.data as BinaryAccountData).data);
  return result;
}

Future<List<Pixel>> listPixels({
  required Config config,
  required RpcClient rpcClient,
  String? owner,
}) async {
  final rawResult = await rpcClient.getProgramAccounts(
    config.programId,
    filters: [
      Filter.dataSize(Pixel.packedSize),
      if (owner != null) Filter.memcmp(offset: 7, bytes: owner),
    ],
    encoding: Encoding.base64,
  );
  final result = <Pixel>[];
  for (final item in rawResult) {
    final pixel = Pixel.unpack((item.account.data as BinaryAccountData).data);
    result.add(pixel);
  }
  return result;
}
