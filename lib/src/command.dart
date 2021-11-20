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
      AccountMeta.writeable(pubKey: pixelAccountId, isSigner: false),
      AccountMeta.readonly(pubKey: ownerWallet, isSigner: true),
    ],
    data: NftCanvasInstructionUpdatePixelColor(color: color).pack(),
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
      AccountMeta.readonly(pubKey: config.tokenProgramId, isSigner: false),
      AccountMeta.writeable(pubKey: pixelAccountId, isSigner: false),
      AccountMeta.readonly(pubKey: config.teamTokenAccountId, isSigner: false),
      AccountMeta.readonly(pubKey: tradePoolId, isSigner: false),
      AccountMeta.writeable(
        pubKey: await utils.getTokenAccountId(
            tokenProgramId: config.tokenProgramId,
            associatedTokenProgramId: config.associatedTokenProgramId,
            tokenMintId: config.ckcTokenMintId,
            ownerId: tradePoolId),
        isSigner: false,
      ),
      AccountMeta.readonly(pubKey: pixelOwnerId, isSigner: true),
      AccountMeta.writeable(
        pubKey: await utils.getTokenAccountId(
            tokenProgramId: config.tokenProgramId,
            associatedTokenProgramId: config.associatedTokenProgramId,
            tokenMintId: config.ckcTokenMintId,
            ownerId: pixelOwnerId),
        isSigner: false,
      ),
    ],
    data: NftCanvasInstructionSellPixel(price: price).pack(),
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
      AccountMeta.readonly(pubKey: config.tokenProgramId, isSigner: false),
      AccountMeta.writeable(pubKey: pixelAccountId, isSigner: false),
      AccountMeta.writeable(pubKey: config.teamTokenAccountId, isSigner: false),
      AccountMeta.readonly(pubKey: tradePoolId, isSigner: false),
      AccountMeta.writeable(
        pubKey: await utils.getTokenAccountId(
            tokenProgramId: config.tokenProgramId,
            associatedTokenProgramId: config.associatedTokenProgramId,
            tokenMintId: config.ckcTokenMintId,
            ownerId: tradePoolId),
        isSigner: false,
      ),
      AccountMeta.readonly(pubKey: pixelOwnerId, isSigner: false),
      AccountMeta.writeable(
        pubKey: await utils.getTokenAccountId(
            tokenProgramId: config.tokenProgramId,
            associatedTokenProgramId: config.associatedTokenProgramId,
            tokenMintId: config.ckcTokenMintId,
            ownerId: pixelOwnerId),
        isSigner: false,
      ),
      AccountMeta.readonly(pubKey: buyerWalletId, isSigner: true),
      AccountMeta.writeable(
        pubKey: await utils.getTokenAccountId(
            tokenProgramId: config.tokenProgramId,
            associatedTokenProgramId: config.associatedTokenProgramId,
            tokenMintId: config.ckcTokenMintId,
            ownerId: buyerWalletId),
        isSigner: false,
      ),
    ],
    data: NftCanvasInstructionBuyPixel(price: price, directOnly: directOnly).pack(),
  );
}

Future<Instruction> initStakePool({
  required Config config,
  required int rewardAmountPerTick,
  required int tickDurationSeconds,
}) async {
  final stakePoolId = await utils.getStakePoolId(programId: config.programId);
  final stakePoolTokenAccountId = await utils.getTokenAccountId(
      tokenProgramId: config.tokenProgramId,
      associatedTokenProgramId: config.associatedTokenProgramId,
      tokenMintId: config.ckcTokenMintId,
      ownerId: stakePoolId);
  return Instruction(
    programId: config.programId,
    accounts: [
      AccountMeta.readonly(pubKey: config.systemProgramId, isSigner: false),
      AccountMeta.readonly(pubKey: config.tokenProgramId, isSigner: false),
      AccountMeta.readonly(
          pubKey: config.associatedTokenProgramId, isSigner: false),
      AccountMeta.readonly(pubKey: config.rentSysvarId, isSigner: false),
      AccountMeta.readonly(pubKey: config.clockSysvarId, isSigner: false),
      AccountMeta.writeable(pubKey: config.teamWalletId, isSigner: true),
      AccountMeta.readonly(pubKey: config.ckcTokenMintId, isSigner: false),
      AccountMeta.readonly(pubKey: stakePoolId, isSigner: false),
      AccountMeta.readonly(pubKey: stakePoolTokenAccountId, isSigner: false),
    ],
    data: NftCanvasInstructionInitStakePool(
      rewardAmountPerTick: rewardAmountPerTick,
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

Future<Instruction> stake({
  required Config config,
  required String owner,
  required int x,
  required int y,
  required int width,
  required int pixelCount,
}) async {
  final programAuthorityId =
      await utils.getProgramAuthorityId(programId: config.programId);
  final stakePoolId = await utils.getStakePoolId(programId: config.programId);
  final nftMintId = await utils.getStakedPixelsNftMintIdV2(
      programId: config.programId, x: x, y: y);
  final ownerNftTokenAccountId = await utils.getTokenAccountId(
      tokenProgramId: config.tokenProgramId,
      associatedTokenProgramId: config.associatedTokenProgramId,
      tokenMintId: nftMintId,
      ownerId: owner);
  final stakedPixelsId = await utils.getStakedPixelsId(
      programId: config.programId, nftMint: nftMintId);
  final nftMetadataAccountId = await utils.getNftMetadataAccountId(
      metaplexTokenMetadataProgramId: config.metaplexTokenMetadataProgramId,
      nftMint: nftMintId);
  final pixelIdList = await utils.getSelectionPixelsV2(
      programId: config.programId,
      x: x,
      y: y,
      width: width,
      offset: 0,
      count: pixelCount);
  return Instruction(
    programId: config.programId,
    accounts: [
      AccountMeta.readonly(pubKey: config.systemProgramId, isSigner: false),
      AccountMeta.readonly(pubKey: config.tokenProgramId, isSigner: false),
      AccountMeta.readonly(
          pubKey: config.associatedTokenProgramId, isSigner: false),
      AccountMeta.readonly(
          pubKey: config.metaplexTokenMetadataProgramId, isSigner: false),
      AccountMeta.readonly(pubKey: config.rentSysvarId, isSigner: false),
      AccountMeta.readonly(pubKey: config.clockSysvarId, isSigner: false),
      AccountMeta.readonly(pubKey: programAuthorityId, isSigner: false),
      AccountMeta.writeable(pubKey: stakePoolId, isSigner: false),
      AccountMeta.writeable(pubKey: owner, isSigner: true),
      AccountMeta.writeable(pubKey: ownerNftTokenAccountId, isSigner: false),
      AccountMeta.writeable(pubKey: nftMintId, isSigner: false),
      AccountMeta.writeable(pubKey: nftMetadataAccountId, isSigner: false),
      AccountMeta.writeable(pubKey: stakedPixelsId, isSigner: false),
      ...pixelIdList
          .map((e) => AccountMeta.writeable(pubKey: e, isSigner: false)),
    ],
    data: NftCanvasInstructionStake(
            x: x, y: y, width: width, pixelCount: pixelCount)
        .pack(),
  );
}

Future<Instruction> unstake({
  required Config config,
  required String owner,
  required StakedPixels stakedPixelsState,
}) async {
  final nftMint = await stakedPixelsState.nftMint(config.programId);

  final stakePoolId = await utils.getStakePoolId(programId: config.programId);
  final stakePoolTokenAccountId = await utils.getTokenAccountId(
      tokenProgramId: config.tokenProgramId,
      associatedTokenProgramId: config.associatedTokenProgramId,
      tokenMintId: config.ckcTokenMintId,
      ownerId: stakePoolId);
  final ownerNftTokenAccountId = await utils.getTokenAccountId(
      tokenProgramId: config.tokenProgramId,
      associatedTokenProgramId: config.associatedTokenProgramId,
      tokenMintId: nftMint,
      ownerId: owner);
  final ownerRewardTokenAccountId = await utils.getTokenAccountId(
      tokenProgramId: config.tokenProgramId,
      associatedTokenProgramId: config.associatedTokenProgramId,
      tokenMintId: config.ckcTokenMintId,
      ownerId: owner);
  final stakedPixelsId = await utils.getStakedPixelsId(
      programId: config.programId, nftMint: nftMint);
  final pixelIdList = await stakedPixelsState.pixels(config.programId);
  return Instruction(
    programId: config.programId,
    accounts: [
      AccountMeta.readonly(pubKey: config.tokenProgramId, isSigner: false),
      AccountMeta.readonly(pubKey: config.clockSysvarId, isSigner: false),
      AccountMeta.writeable(pubKey: stakePoolId, isSigner: false),
      AccountMeta.writeable(pubKey: stakePoolTokenAccountId, isSigner: false),
      AccountMeta.writeable(pubKey: owner, isSigner: true),
      AccountMeta.writeable(pubKey: ownerNftTokenAccountId, isSigner: false),
      AccountMeta.writeable(pubKey: ownerRewardTokenAccountId, isSigner: false),
      AccountMeta.writeable(pubKey: nftMint, isSigner: false),
      AccountMeta.writeable(pubKey: stakedPixelsId, isSigner: false),
      ...pixelIdList
          .map((e) => AccountMeta.writeable(pubKey: e, isSigner: false)),
    ],
    data: NftCanvasInstructionUnstake().pack(),
  );
}

Future<Instruction> harvest({
  required Config config,
  required String owner,
  required String nftMint,
}) async {
  final stakePoolId = await utils.getStakePoolId(programId: config.programId);
  final stakePoolTokenAccountId = await utils.getTokenAccountId(
      tokenProgramId: config.tokenProgramId,
      associatedTokenProgramId: config.associatedTokenProgramId,
      tokenMintId: config.ckcTokenMintId,
      ownerId: stakePoolId);
  final ownerNftTokenAccountId = await utils.getTokenAccountId(
      tokenProgramId: config.tokenProgramId,
      associatedTokenProgramId: config.associatedTokenProgramId,
      tokenMintId: nftMint,
      ownerId: owner);
  final ownerRewardTokenAccountId = await utils.getTokenAccountId(
      tokenProgramId: config.tokenProgramId,
      associatedTokenProgramId: config.associatedTokenProgramId,
      tokenMintId: config.ckcTokenMintId,
      ownerId: owner);
  final stakedPixelsId = await utils.getStakedPixelsId(
      programId: config.programId, nftMint: nftMint);
  return Instruction(
    programId: config.programId,
    accounts: [
      AccountMeta.readonly(pubKey: config.tokenProgramId, isSigner: false),
      AccountMeta.readonly(pubKey: config.clockSysvarId, isSigner: false),
      AccountMeta.writeable(pubKey: stakePoolId, isSigner: false),
      AccountMeta.writeable(pubKey: stakePoolTokenAccountId, isSigner: false),
      AccountMeta.writeable(pubKey: owner, isSigner: true),
      AccountMeta.writeable(pubKey: ownerNftTokenAccountId, isSigner: false),
      AccountMeta.writeable(pubKey: ownerRewardTokenAccountId, isSigner: false),
      AccountMeta.writeable(pubKey: nftMint, isSigner: false),
      AccountMeta.writeable(pubKey: stakedPixelsId, isSigner: false),
    ],
    data: NftCanvasInstructionHarvest().pack(),
  );
}

Future<Instruction> updateStakingPixels({
  required Config config,
  required String owner,
  required StakedPixelsV2 stakedPixelsState,
  required int pixelCount,
}) async {
  final nftMint = await stakedPixelsState.nftMint(config.programId);
  final stakePoolId = await utils.getStakePoolId(programId: config.programId);
  final stakePoolTokenAccountId = await utils.getTokenAccountId(
      tokenProgramId: config.tokenProgramId,
      associatedTokenProgramId: config.associatedTokenProgramId,
      tokenMintId: config.ckcTokenMintId,
      ownerId: stakePoolId);
  final ownerNftTokenAccountId = await utils.getTokenAccountId(
      tokenProgramId: config.tokenProgramId,
      associatedTokenProgramId: config.associatedTokenProgramId,
      tokenMintId: nftMint,
      ownerId: owner);
  final ownerRewardTokenAccountId = await utils.getTokenAccountId(
      tokenProgramId: config.tokenProgramId,
      associatedTokenProgramId: config.associatedTokenProgramId,
      tokenMintId: config.ckcTokenMintId,
      ownerId: owner);
  final stakedPixelsId = await utils.getStakedPixelsId(
      programId: config.programId, nftMint: nftMint);
  final pixelIdList = (pixelCount > 0)
      ? await utils.getSelectionPixelsV2(
          programId: config.programId,
          x: stakedPixelsState.x,
          y: stakedPixelsState.y,
          width: stakedPixelsState.width,
          offset: stakedPixelsState.pixelCount,
          count: pixelCount.abs())
      : await utils.getSelectionPixelsV2(
          programId: config.programId,
          x: stakedPixelsState.x,
          y: stakedPixelsState.y,
          width: stakedPixelsState.width,
          offset: stakedPixelsState.pixelCount - pixelCount.abs(),
          count: pixelCount.abs());
  return Instruction(
    programId: config.programId,
    accounts: [
      AccountMeta.readonly(pubKey: config.tokenProgramId, isSigner: false),
      AccountMeta.readonly(pubKey: config.clockSysvarId, isSigner: false),
      AccountMeta.writeable(pubKey: stakePoolId, isSigner: false),
      AccountMeta.writeable(pubKey: stakePoolTokenAccountId, isSigner: false),
      AccountMeta.writeable(pubKey: owner, isSigner: true),
      AccountMeta.writeable(pubKey: ownerNftTokenAccountId, isSigner: false),
      AccountMeta.writeable(pubKey: ownerRewardTokenAccountId, isSigner: false),
      AccountMeta.writeable(pubKey: nftMint, isSigner: false),
      AccountMeta.writeable(pubKey: stakedPixelsId, isSigner: false),
      ...pixelIdList
          .map((e) => AccountMeta.writeable(pubKey: e, isSigner: false)),
    ],
    data: NftCanvasInstructionHarvest().pack(),
  );
}
