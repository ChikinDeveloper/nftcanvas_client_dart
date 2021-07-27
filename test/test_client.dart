import 'package:chikin_nft_canvas_client/chikin_nft_canvas_client.dart' as client;
import 'package:test/scaffolding.dart';
import 'package:solana/solana.dart' as solana;

void main() {
  test('test_client', () async {
    final rpcUrl = 'http://localhost:8899';
    final rpcClient = solana.RPCClient(rpcUrl);
    final config = client.Config.defaultValue;
    final pixelIndex = 2;

    final pixel = await client.getPixel(config: config, rpcClient: rpcClient, index: pixelIndex);
    print('index=${pixel?.index}');
    print('color=${pixel?.color}');
    print('ownerWallet=${pixel?.ownerWallet}');
    print('sellPrice=${pixel?.sellPrice}');
    print('bestBuyInfo=${pixel?.bestBuyInfo}');
  });
}