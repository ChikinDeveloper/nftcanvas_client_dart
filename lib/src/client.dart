import 'dart:convert';

import 'package:chikin_nft_canvas_client/src/config.dart';
import 'package:chikin_nft_canvas_client/src/model.dart';
import 'package:solana/solana.dart';

import 'utils.dart' as utils;

Future<Pixel?> getPixel({
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
