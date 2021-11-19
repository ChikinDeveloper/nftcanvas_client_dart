import 'dart:math';

import 'utils.dart' as utils;

// Instruction

abstract class NftCanvasInstruction {
  static const packedSize = 17;

  NftCanvasInstruction._();

  List<int> pack();

  static List<int> formatPacked(List<int> data) {
    assert(data.length <= NftCanvasInstruction.packedSize);
    data.addAll(List.filled(NftCanvasInstruction.packedSize - data.length, 0));
    return data;
  }
}

class NftCanvasInstructionMintPixel extends NftCanvasInstruction {
  final int index;
  final List<int> color;
  final int sellPrice;

  NftCanvasInstructionMintPixel({
    required this.index,
    required this.color,
    required this.sellPrice,
  }) : super._();

  @override
  List<int> pack() {
    final result = [
      0,
      ...utils.packUInt(index, 4),
      ...color,
      ...utils.packUInt(sellPrice, 8),
    ];
    return NftCanvasInstruction.formatPacked(result);
  }
}

class NftCanvasInstructionUpdatePixelColor extends NftCanvasInstruction {
  final int index;
  final List<int> color;

  NftCanvasInstructionUpdatePixelColor({
    required this.index,
    required this.color,
  }) : super._();

  @override
  List<int> pack() {
    final result = [
      1,
      ...utils.packUInt(index, 4),
      ...color,
    ];
    return NftCanvasInstruction.formatPacked(result);
  }
}

class NftCanvasInstructionSellPixel extends NftCanvasInstruction {
  final int index;
  final int price;

  NftCanvasInstructionSellPixel({
    required this.index,
    required this.price,
  }) : super._();

  @override
  List<int> pack() {
    final result = [
      2,
      ...utils.packUInt(index, 4),
      ...utils.packUInt(price, 8),
    ];
    return NftCanvasInstruction.formatPacked(result);
  }
}

class NftCanvasInstructionBuyPixel extends NftCanvasInstruction {
  final int index;
  final int price;
  final bool directOnly;

  NftCanvasInstructionBuyPixel({
    required this.index,
    required this.price,
    required this.directOnly,
  }) : super._();

  @override
  List<int> pack() {
    final result = [
      3,
      ...utils.packUInt(index, 4),
      ...utils.packUInt(price, 8),
      (directOnly) ? 1 : 0,
    ];
    return NftCanvasInstruction.formatPacked(result);
  }
}

class NftCanvasInstructionInitStakePool extends NftCanvasInstruction {
  final int rewardAmountPerTick;
  final int tickDurationSeconds;

  NftCanvasInstructionInitStakePool({
    required this.rewardAmountPerTick,
    required this.tickDurationSeconds,
  }) : super._();

  @override
  List<int> pack() {
    final result = [
      4,
      ...utils.packUInt(rewardAmountPerTick, 8),
      ...utils.packUInt(tickDurationSeconds, 8),
    ];
    return NftCanvasInstruction.formatPacked(result);
  }
}

class NftCanvasInstructionUpdateStakePool extends NftCanvasInstruction {
  final int rewardAmountPerPixelPerTick;
  final int tickDurationSeconds;

  NftCanvasInstructionUpdateStakePool({
    required this.rewardAmountPerPixelPerTick,
    required this.tickDurationSeconds,
  }) : super._();

  @override
  List<int> pack() {
    final result = [
      5,
      ...utils.packUInt(rewardAmountPerPixelPerTick, 8),
      ...utils.packUInt(tickDurationSeconds, 8),
    ];
    return NftCanvasInstruction.formatPacked(result);
  }
}

class NftCanvasInstructionStake extends NftCanvasInstruction {
  final int x;
  final int y;
  final int width;
  final int pixelCount;

  NftCanvasInstructionStake({
    required this.x,
    required this.y,
    required this.width,
    required this.pixelCount,
  }) : super._();

  @override
  List<int> pack() {
    final result = [
      6,
      ...utils.packUInt(x, 4),
      ...utils.packUInt(y, 4),
      ...utils.packUInt(width, 4),
      ...utils.packUInt(pixelCount, 4),
    ];
    return NftCanvasInstruction.formatPacked(result);
  }
}

class NftCanvasInstructionUnstake extends NftCanvasInstruction {
  NftCanvasInstructionUnstake() : super._();

  @override
  List<int> pack() {
    final result = [7];
    return NftCanvasInstruction.formatPacked(result);
  }
}

class NftCanvasInstructionHarvest extends NftCanvasInstruction {
  NftCanvasInstructionHarvest() : super._();

  @override
  List<int> pack() {
    final result = [8];
    return NftCanvasInstruction.formatPacked(result);
  }
}

class NftCanvasInstructionUpdateStakingPixels extends NftCanvasInstruction {
  final int pixelCount;

  NftCanvasInstructionUpdateStakingPixels({
    required this.pixelCount,
  }) : super._();

  @override
  List<int> pack() {
    final result = [
      9,
      ...utils.packInt(pixelCount, 4),
    ];
    return NftCanvasInstruction.formatPacked(result);
  }
}

// State

class Pixel {
  static const packedSize = 88;

  final int index;
  final List<int> color;
  final List<int> ownerWallet;
  final int sellPrice;
  final PixelBuyInfo? bestBuyInfo;

  Pixel({
    required this.index,
    required this.color,
    required this.ownerWallet,
    required this.sellPrice,
    required this.bestBuyInfo,
  });

  static Pixel unpack(List<int> data) {
    assert(data.length == packedSize, '${data.length} != $packedSize');
    return Pixel(
      index: utils.unpackUInt(data.sublist(0, 4)),
      color: data.sublist(4, 7),
      ownerWallet: data.sublist(7, 39),
      sellPrice: utils.unpackUInt(data.sublist(39, 47)),
      bestBuyInfo: (data[47] == 0)
          ? null
          : PixelBuyInfo(
              price: utils.unpackUInt(data.sublist(48, 56)),
              buyerWallet: data.sublist(56, 88),
            ),
    );
  }
}

class PixelBuyInfo {
  final int price;
  final List<int> buyerWallet;

  PixelBuyInfo({
    required this.price,
    required this.buyerWallet,
  });
}

class StakePool {
  static const packedSize = 56;

  final int pixelCount;
  final int lpTokenAmount;
  final int time0;
  final int rewardAmountPerTick;
  final int tickDurationSeconds;
  final int harvestableAmount;
  final int lastHarvestableAmountUpdateTime;

  StakePool({
    required this.pixelCount,
    required this.lpTokenAmount,
    required this.time0,
    required this.rewardAmountPerTick,
    required this.tickDurationSeconds,
    required this.harvestableAmount,
    required this.lastHarvestableAmountUpdateTime,
  });

  factory StakePool.unpack(List<int> data) {
    assert(data.length == packedSize, '${data.length} != $packedSize');
    return StakePool(
      pixelCount: utils.unpackUInt(data.sublist(0, 8)),
      lpTokenAmount: utils.unpackUInt(data.sublist(8, 16)),
      time0: utils.unpackUInt(data.sublist(16, 24)),
      rewardAmountPerTick: utils.unpackUInt(data.sublist(24, 32)),
      tickDurationSeconds: utils.unpackUInt(data.sublist(32, 40)),
      harvestableAmount: utils.unpackUInt(data.sublist(40, 48)),
      lastHarvestableAmountUpdateTime: utils.unpackUInt(data.sublist(48, 56)),
    );
  }
}

abstract class StakedPixels {
  StakedPixels();

  factory StakedPixels.unpack(List<int> data) {
    if (data.length == StakedPixelsV1.packedSize) {
      return StakedPixelsV1.unpack(data);
    } else if (data.length == StakedPixelsV2.packedSize) {
      return StakedPixelsV2.unpack(data);
    } else {
      throw Exception();
    }
  }

  int version();

  int getX();
  int getY();
  int getWidth();
  int getHeight();
  int getLockTime();
  int getPixelCount();

  Future<String> nftMint(String programId);
  List<Point<int>> pixelPositions();

  List<int> pixelIndices() {
    return pixelPositions().map((e) => utils.pixelPositionToIndex(e.x, e.y)).toList();
  }

  Future<List<String>> pixels(String programId) async {
    final result = <String>[];
    for (final index in pixelIndices()) {
      result.add(await utils.getPixelAccountId(programId: programId, index: index));
    }
    return result;
  }
}

class StakedPixelsV1 extends StakedPixels {
  static const packedSize = 28;

  final int x;
  final int y;
  final int width;
  final int height;
  final int nonce;
  final int lockTime;

  StakedPixelsV1({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.nonce,
    required this.lockTime,
  });

  static StakedPixelsV1 unpack(List<int> data) {
    assert(data.length == packedSize, '${data.length} != $packedSize');
    return StakedPixelsV1(
      x: utils.unpackUInt(data.sublist(0, 4)),
      y: utils.unpackUInt(data.sublist(4, 8)),
      width: utils.unpackUInt(data.sublist(8, 12)),
      height: utils.unpackUInt(data.sublist(12, 16)),
      nonce: utils.unpackUInt(data.sublist(16, 20)),
      lockTime: utils.unpackUInt(data.sublist(20, 28)),
    );
  }

  int lpTokenAmount() => width * height * lockTime;

  @override
  int version() => 1;

  @override
  int getX() => x;

  @override
  int getY() => y;

  @override
  int getWidth() => width;

  @override
  int getHeight() => height;

  @override
  int getLockTime() => lockTime;

  @override
  int getPixelCount() => width * height;

  @override
  Future<String> nftMint(String programId) => utils.getStakedPixelsNftMintIdV1(programId: programId, x: x, y: y, width: width, height: height, nonce: nonce);

  @override
  List<Point<int>> pixelPositions() {
    return utils.getSelectionPixelsV1Positions(x: x, y: y, width: width, height: height);
  }
}

class StakedPixelsV2 extends StakedPixels {
  static const packedSize = 24;

  final int x;
  final int y;
  final int width;
  final int pixelCount;
  final int lockTime;

  StakedPixelsV2({
    required this.x,
    required this.y,
    required this.width,
    required this.pixelCount,
    required this.lockTime,
  });

  static StakedPixelsV2 unpack(List<int> data) {
    assert(data.length == packedSize, '${data.length} != $packedSize');
    return StakedPixelsV2(
      x: utils.unpackUInt(data.sublist(0, 4)),
      y: utils.unpackUInt(data.sublist(4, 8)),
      width: utils.unpackUInt(data.sublist(8, 12)),
      pixelCount: utils.unpackUInt(data.sublist(12, 16)),
      lockTime: utils.unpackUInt(data.sublist(16, 24)),
    );
  }

  int lpTokenAmount() => pixelCount * lockTime;

  @override
  int version() => 2;

  @override
  int getX() => x;

  @override
  int getY() => y;

  @override
  int getWidth() => width;

  @override
  int getHeight() => 1 + (pixelCount ~/ width);

  @override
  int getLockTime() => lockTime;

  @override
  int getPixelCount() => pixelCount;

  @override
  Future<String> nftMint(String programId) => utils.getStakedPixelsNftMintIdV2(programId: programId, x: x, y: y);

  @override
  List<Point<int>> pixelPositions() {
    return utils.getSelectionPixelsV2Positions(x: x, y: y, width: width, offset: 0, count: pixelCount);
  }
}
