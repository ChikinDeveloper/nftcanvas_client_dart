import 'dart:typed_data';

import 'package:test/scaffolding.dart';
import 'dart:math' as math;

int unpackUInt(List<int> data, {Endian endian = Endian.little}) {
  var slice = List.of(data);
  if (endian == Endian.big) {
    slice = slice.reversed.toList();
  }
  var result = 0;
  var pow = 0;
  for (final e in slice) {
    result += e * math.pow(2, pow).toInt();
    pow += 8;
  }
  return result;
}

List<int> packUInt(int data, int byteCount, {Endian endian = Endian.little}) {
  assert(data >= 0);
  var result = List.generate(byteCount, (index) {
    return (data ~/ math.pow(2, 8*index)) % 256;
  });
  if (endian == Endian.big) {
    result = result.reversed.toList();
  }
  return result;
}

void main() {
  test('pack unpack uint', () async {
    var endian = Endian.little;
    var value = 100000000000;
    var packed = packUInt(value, 8, endian: endian);
    var unpacked = unpackUInt(packed, endian: endian);
    print('endian=$endian');
    print('value=$value');
    print('packed=$packed');
    print('unpacked=$unpacked');

    endian = Endian.big;
    value = 100000000000;
    packed = packUInt(value, 8, endian: endian);
    unpacked = unpackUInt(packed, endian: endian);
    print('endian=$endian');
    print('value=$value');
    print('packed=$packed');
    print('unpacked=$unpacked');
  });
}