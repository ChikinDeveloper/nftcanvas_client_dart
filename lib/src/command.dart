import 'package:chikin_nft_canvas_client/src/config.dart';
import 'package:chikin_nft_canvas_client/src/model.dart';
import 'package:solana/solana.dart';

import 'utils.dart' as utils;

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
  required Config config,
  required int index,
  required String ownerWallet,
  required List<int> color,
}) async {
  final pixelAccountId =
      await utils.getPixelAccountId(programId: config.programId, index: index);
  return Instruction(
    programId: config.programId,
    accounts: [
      AccountMeta.readonly(pubKey: config.programId, isSigner: false),
      AccountMeta.writeable(pubKey: pixelAccountId, isSigner: false),
      AccountMeta.readonly(pubKey: ownerWallet, isSigner: true),
    ],
    data: NftCanvasInstructionUpdatePixelColor(
      index: index,
      color: color,
    ).pack(),
  );
}

Future<Instruction> sellPixel({
  required Config config,
  required int index,
  required String ownerWallet,
  required int price,
}) async {
  final pixelAccountId =
      await utils.getPixelAccountId(programId: config.programId, index: index);

  final tradePoolId = await utils.getTradePoolId(programId: config.programId);
  final pixelOwnerId = ownerWallet;

  return Instruction(
    programId: config.programId,
    accounts: [
      AccountMeta.readonly(pubKey: config.programId, isSigner: false),
      AccountMeta.readonly(pubKey: config.tokenProgramId, isSigner: false),
      AccountMeta.writeable(pubKey: pixelAccountId, isSigner: false),
      AccountMeta.readonly(pubKey: config.teamTokenAccountId, isSigner: false),
      AccountMeta.readonly(pubKey: tradePoolId, isSigner: false),
      AccountMeta.readonly(
        pubKey: await utils.getTokenAccountId(
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
  required Config config,
  required String buyerWalletId,
  required int index,
  required String ownerWallet,
  required int price,
  required bool directOnly,
}) async {
  final pixelAccountId =
      await utils.getPixelAccountId(programId: config.programId, index: index);

  final tradePoolId = await utils.getTradePoolId(programId: config.programId);
  final pixelOwnerId = ownerWallet;

  return Instruction(
    programId: config.programId,
    accounts: [
      AccountMeta.readonly(pubKey: config.programId, isSigner: false),
      AccountMeta.readonly(pubKey: config.tokenProgramId, isSigner: false),
      AccountMeta.writeable(pubKey: pixelAccountId, isSigner: false),
      AccountMeta.readonly(pubKey: config.teamTokenAccountId, isSigner: false),
      AccountMeta.readonly(pubKey: tradePoolId, isSigner: false),
      AccountMeta.readonly(
        pubKey: await utils.getTokenAccountId(
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

Future<Instruction> initStakePool({
  required Config config,
  required int rewardAmountPerPixelPerTick,
  required int tickDurationSeconds,
}) async {
  final stakePoolId = await utils.getStakePoolId(programId: config.programId);
  final stakePoolTokenAccountId = await utils.getTokenAccountId(
      tokenProgramId: config.tokenProgramId,
      associatedTokenProgramId: config.associatedTokenProgramId,
      tokenMintId: config.tokenMintId,
      ownerId: stakePoolId);
  return Instruction(
    programId: config.programId,
    accounts: [
      AccountMeta.readonly(pubKey: config.programId, isSigner: false),
      AccountMeta.readonly(pubKey: config.systemProgramId, isSigner: false),
      AccountMeta.readonly(pubKey: config.tokenProgramId, isSigner: false),
      AccountMeta.readonly(pubKey: config.associatedTokenProgramId, isSigner: false),
      AccountMeta.readonly(pubKey: config.rentSysvarId, isSigner: false),
      AccountMeta.readonly(pubKey: config.tokenMintId, isSigner: false),
      AccountMeta.writeable(pubKey: config.teamWalletId, isSigner: true),
      AccountMeta.readonly(pubKey: stakePoolId, isSigner: false),
      AccountMeta.readonly(pubKey: stakePoolTokenAccountId, isSigner: false),
    ],
    data: NftCanvasInstructionInitStakePool(
      rewardAmountPerPixelPerTick: rewardAmountPerPixelPerTick,
      tickDurationSeconds: tickDurationSeconds,
    ).pack(),
  );
}

Future<Instruction> updateStakePool({
  required Config config,
  required int rewardAmountPerPixelPerTick,
  required int tickDurationSeconds,
}) async {
  final stakePoolId = await utils.getStakePoolId(programId: config.programId);
  return Instruction(
    programId: config.programId,
    accounts: [
      AccountMeta.readonly(pubKey: config.programId, isSigner: false),
      AccountMeta.readonly(pubKey: config.clockSysvarId, isSigner: false),
      AccountMeta.writeable(pubKey: config.teamWalletId, isSigner: true),
      AccountMeta.writeable(pubKey: stakePoolId, isSigner: false),
    ],
    data: NftCanvasInstructionUpdateStakePool(
      rewardAmountPerPixelPerTick: rewardAmountPerPixelPerTick,
      tickDurationSeconds: tickDurationSeconds,
    ).pack(),
  );
}

Future<Instruction> initStakeClient({
  required Config config,
  required String stakeClientOwner,
}) async {
  final stakePoolId = await utils.getStakePoolId(programId: config.programId);
  final stakeClientId = await utils.getStakeClientId(programId: config.programId, owner: stakeClientOwner);
  final stakeClientTokenAccountId = await utils.getTokenAccountId(
      tokenProgramId: config.tokenProgramId,
      associatedTokenProgramId: config.associatedTokenProgramId,
      tokenMintId: config.tokenMintId,
      ownerId: stakeClientOwner);
  return Instruction(
    programId: config.programId,
    accounts: [
      AccountMeta.readonly(pubKey: config.programId, isSigner: false),
      AccountMeta.readonly(pubKey: config.systemProgramId, isSigner: false),
      AccountMeta.readonly(pubKey: config.tokenProgramId, isSigner: false),
      AccountMeta.readonly(pubKey: config.associatedTokenProgramId, isSigner: false),
      AccountMeta.readonly(pubKey: config.rentSysvarId, isSigner: false),
      AccountMeta.readonly(pubKey: config.tokenMintId, isSigner: false),
      AccountMeta.readonly(pubKey: stakePoolId, isSigner: false),
      AccountMeta.writeable(pubKey: stakeClientOwner, isSigner: true),
      AccountMeta.writeable(pubKey: stakeClientId, isSigner: false),
      AccountMeta.writeable(pubKey: stakeClientTokenAccountId, isSigner: false),
    ],
    data: NftCanvasInstructionInitStakeClient().pack(),
  );
}

Future<Instruction> stake({
  required Config config,
  required String stakeClientOwner,
  required int x,
  required int y,
  required int width,
  required int height,
}) async {
  final stakePoolId = await utils.getStakePoolId(programId: config.programId);
  final stakeClientId = await utils.getStakeClientId(programId: config.programId, owner: stakeClientOwner);
  return Instruction(
    programId: config.programId,
    accounts: [
      AccountMeta.readonly(pubKey: config.programId, isSigner: false),
      AccountMeta.readonly(pubKey: config.tokenProgramId, isSigner: false),
      AccountMeta.readonly(pubKey: config.clockSysvarId, isSigner: false),
      AccountMeta.writeable(pubKey: stakePoolId, isSigner: false),
      AccountMeta.writeable(pubKey: stakeClientOwner, isSigner: true),
      AccountMeta.writeable(pubKey: stakeClientId, isSigner: false),
    ],
    data: NftCanvasInstructionStake(
      x: x, y: y, width: width, height: height,
    ).pack(),
  );
}

Future<Instruction> unstake({
  required Config config,
  required String stakeClientOwner,
}) async {
  final stakePoolId = await utils.getStakePoolId(programId: config.programId);
  final stakePoolTokenAccountId = await utils.getTokenAccountId(
      tokenProgramId: config.tokenProgramId,
      associatedTokenProgramId: config.associatedTokenProgramId,
      tokenMintId: config.tokenMintId,
      ownerId: stakePoolId);
  final stakeClientId = await utils.getStakeClientId(programId: config.programId, owner: stakeClientOwner);
  final stakeClientTokenAccountId = await utils.getTokenAccountId(
      tokenProgramId: config.tokenProgramId,
      associatedTokenProgramId: config.associatedTokenProgramId,
      tokenMintId: config.tokenMintId,
      ownerId: stakeClientOwner);
  return Instruction(
    programId: config.programId,
    accounts: [
      AccountMeta.readonly(pubKey: config.programId, isSigner: false),
      AccountMeta.readonly(pubKey: config.tokenProgramId, isSigner: false),
      AccountMeta.readonly(pubKey: config.clockSysvarId, isSigner: false),
      AccountMeta.writeable(pubKey: stakePoolId, isSigner: false),
      AccountMeta.writeable(pubKey: stakePoolTokenAccountId, isSigner: false),
      AccountMeta.writeable(pubKey: stakeClientOwner, isSigner: true),
      AccountMeta.writeable(pubKey: stakeClientId, isSigner: false),
      AccountMeta.writeable(pubKey: stakeClientTokenAccountId, isSigner: false),
    ],
    data: NftCanvasInstructionUnstake().pack(),
  );
}

Future<Instruction> harvest({
  required Config config,
  required String stakeClientOwner,
}) async {
  final stakePoolId = await utils.getStakePoolId(programId: config.programId);
  final stakePoolTokenAccountId = await utils.getTokenAccountId(
      tokenProgramId: config.tokenProgramId,
      associatedTokenProgramId: config.associatedTokenProgramId,
      tokenMintId: config.tokenMintId,
      ownerId: stakePoolId);
  final stakeClientId = await utils.getStakeClientId(programId: config.programId, owner: stakeClientOwner);
  final stakeClientTokenAccountId = await utils.getTokenAccountId(
      tokenProgramId: config.tokenProgramId,
      associatedTokenProgramId: config.associatedTokenProgramId,
      tokenMintId: config.tokenMintId,
      ownerId: stakeClientOwner);
  return Instruction(
    programId: config.programId,
    accounts: [
      AccountMeta.readonly(pubKey: config.programId, isSigner: false),
      AccountMeta.readonly(pubKey: config.tokenProgramId, isSigner: false),
      AccountMeta.readonly(pubKey: config.clockSysvarId, isSigner: false),
      AccountMeta.writeable(pubKey: stakePoolId, isSigner: false),
      AccountMeta.writeable(pubKey: stakePoolTokenAccountId, isSigner: false),
      AccountMeta.writeable(pubKey: stakeClientOwner, isSigner: true),
      AccountMeta.writeable(pubKey: stakeClientId, isSigner: false),
      AccountMeta.writeable(pubKey: stakeClientTokenAccountId, isSigner: false),
    ],
    data: NftCanvasInstructionHarvest().pack(),
  );
}

