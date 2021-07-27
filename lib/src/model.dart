import 'utils.dart' as utils;

// Instruction

abstract class NftCanvasInstruction {
  static const packedSize = 16;

  NftCanvasInstruction._();

  List<int> pack();
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
      ...utils.packUInt32(index),
      ...color,
      ...utils.packUInt64(sellPrice),
    ];
    assert(result.length <= NftCanvasInstruction.packedSize);
    result.addAll(
        List.filled(NftCanvasInstruction.packedSize - result.length, 0));
    return result;
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
      ...utils.packUInt32(index),
      ...color,
    ];
    assert(result.length <= NftCanvasInstruction.packedSize);
    result.addAll(
        List.filled(NftCanvasInstruction.packedSize - result.length, 0));
    return result;
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
      ...utils.packUInt32(index),
      ...utils.packUInt64(price),
    ];
    assert(result.length <= NftCanvasInstruction.packedSize);
    result.addAll(
        List.filled(NftCanvasInstruction.packedSize - result.length, 0));
    return result;
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
      ...utils.packUInt32(index),
      ...utils.packUInt64(price),
      (directOnly) ? 1 : 0,
    ];
    assert(result.length <= NftCanvasInstruction.packedSize);
    result.addAll(
        List.filled(NftCanvasInstruction.packedSize - result.length, 0));
    return result;
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
