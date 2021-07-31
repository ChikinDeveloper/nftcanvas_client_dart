import 'package:chikin_nft_canvas_client/src/config.dart';
import 'package:chikin_nft_canvas_client/src/model.dart';
import 'package:solana/solana.dart';

import 'utils.dart' as utils;
import 'client.dart' as client;

Future<Instruction> mintPixel({
  required Config config,
  required String ownerWalletId,
  required int index,
  required List<int> color,
  required int sellPrice,
}) async {
  final pixelAccountId =
      await utils.getPixelAccountId(programId: config.programId, index: index);
  return Instruction(
    programId: config.programId,
    accounts: [
      AccountMeta.readonly(pubKey: config.programId, isSigner: false),
      AccountMeta.readonly(pubKey: config.systemProgramId, isSigner: false),
      AccountMeta.readonly(pubKey: config.rentSysvarId, isSigner: false),
      AccountMeta.writeable(pubKey: config.mintPoolWalletId, isSigner: false),
      AccountMeta.writeable(pubKey: pixelAccountId, isSigner: false),
      AccountMeta.writeable(pubKey: ownerWalletId, isSigner: true),
    ],
    data: NftCanvasInstructionMintPixel(
      index: index,
      color: color,
      sellPrice: sellPrice,
    ).pack(),
  );
}

Future<Instruction> updatePixelColor({
  required RPCClient rpcClient,
  required Config config,
  required int index,
  required List<int> color,
}) async {
  final pixelAccountId =
      await utils.getPixelAccountId(programId: config.programId, index: index);
  final pixelAccountState = await client.getPixel(config: config, rpcClient: rpcClient, index: index);
  if (pixelAccountState == null) throw Exception('Pixel not found index=$index');
  return Instruction(
    programId: config.programId,
    accounts: [
      AccountMeta.readonly(pubKey: config.programId, isSigner: false),
      AccountMeta.writeable(pubKey: pixelAccountId, isSigner: false),
      AccountMeta.readonly(
          pubKey: base58encode(pixelAccountState.ownerWallet), isSigner: true),
    ],
    data: NftCanvasInstructionUpdatePixelColor(
      index: index,
      color: color,
    ).pack(),
  );
}

Future<Instruction> sellPixel({
  required RPCClient rpcClient,
  required Config config,
  required int index,
  required int price,
}) async {
  final pixelAccountId =
      await utils.getPixelAccountId(programId: config.programId, index: index);
  final pixelAccountState = await client.getPixel(config: config, rpcClient: rpcClient, index: index);
  if (pixelAccountState == null) throw Exception('Pixel not found index=$index');

  final tradePoolId = await utils.getTradePoolId(programId: config.programId);
  final pixelOwnerId = base58encode(pixelAccountState.ownerWallet);

  return Instruction(
    programId: config.programId,
    accounts: [
      AccountMeta.readonly(pubKey: config.programId, isSigner: false),
      AccountMeta.readonly(pubKey: config.tokenProgramId, isSigner: false),
      AccountMeta.writeable(pubKey: pixelAccountId, isSigner: false),
      AccountMeta.readonly(pubKey: config.teamTokenAccountId, isSigner: false),
      AccountMeta.readonly(pubKey: tradePoolId, isSigner: false),
      AccountMeta.readonly(
        pubKey:
            await utils.getTokenAccountId(
                tokenProgramId: config.tokenProgramId,
                associatedTokenProgramId: config.associatedTokenProgramId,
                tokenMintId: config.tokenMintId,
                ownerId: tradePoolId),
        isSigner: false,
      ),
      AccountMeta.readonly(pubKey: pixelOwnerId, isSigner: true),
      AccountMeta.readonly(
        pubKey: await utils.getTokenAccountId(
            tokenProgramId: config.tokenProgramId,
            associatedTokenProgramId: config.associatedTokenProgramId,
            tokenMintId: config.tokenMintId,
            ownerId: pixelOwnerId),
        isSigner: false,
      ),
    ],
    data: NftCanvasInstructionSellPixel(
      index: index,
      price: price,
    ).pack(),
  );
}

Future<Instruction> buyPixel({
  required RPCClient rpcClient,
  required Config config,
  required String buyerWalletId,
  required int index,
  required int price,
  required bool directOnly,
}) async {
  final pixelAccountId =
      await utils.getPixelAccountId(programId: config.programId, index: index);
  final pixelAccountState = await client.getPixel(config: config, rpcClient: rpcClient, index: index);
  if (pixelAccountState == null) throw Exception('Pixel not found index=$index');

  final tradePoolId = await utils.getTradePoolId(programId: config.programId);
  final pixelOwnerId = base58encode(pixelAccountState.ownerWallet);

  return Instruction(
    programId: config.programId,
    accounts: [
      AccountMeta.readonly(pubKey: config.programId, isSigner: false),
      AccountMeta.readonly(pubKey: config.tokenProgramId, isSigner: false),
      AccountMeta.writeable(pubKey: pixelAccountId, isSigner: false),
      AccountMeta.readonly(pubKey: config.teamTokenAccountId, isSigner: false),
      AccountMeta.readonly(pubKey: tradePoolId, isSigner: false),
      AccountMeta.readonly(
        pubKey:
            await utils.getTokenAccountId(
                tokenProgramId: config.tokenProgramId,
                associatedTokenProgramId: config.associatedTokenProgramId,
                tokenMintId: config.tokenMintId,
                ownerId: tradePoolId),
        isSigner: false,
      ),
      AccountMeta.readonly(pubKey: pixelOwnerId, isSigner: false),
      AccountMeta.readonly(
        pubKey: await utils.getTokenAccountId(
            tokenProgramId: config.tokenProgramId,
            associatedTokenProgramId: config.associatedTokenProgramId,
            tokenMintId: config.tokenMintId,
            ownerId: pixelOwnerId),
        isSigner: false,
      ),
      AccountMeta.readonly(pubKey: buyerWalletId, isSigner: true),
      AccountMeta.readonly(
        pubKey: await utils.getTokenAccountId(
            tokenProgramId: config.tokenProgramId,
            associatedTokenProgramId: config.associatedTokenProgramId,
            tokenMintId: config.tokenMintId,
            ownerId: pixelOwnerId),
        isSigner: false,
      ),
    ],
    data: NftCanvasInstructionBuyPixel(
      index: index,
      price: price,
      directOnly: directOnly,
    ).pack(),
  );
}
