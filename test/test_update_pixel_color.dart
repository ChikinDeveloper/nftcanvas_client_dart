import 'package:chikin_nft_canvas_client/src/command.dart' as command;
import 'package:chikin_nft_canvas_client/src/config.dart' as cfg;
import 'package:solana/solana.dart' as solana;
import 'package:test/test.dart';

import 'utils/test_user.dart';

void main() {
  final defaultTimeoutDuration = Duration(seconds: 90);

  var _logIndex = 0;
  final debugPrint = () {
    print('test_init_pixel.debugPrint : ${_logIndex++}');
  };

  test('test_init_pixel', () async {
    final rpcUrl = 'http://localhost:8899';
    final rpcClient = solana.RPCClient(rpcUrl);
    final config = cfg.Config.defaultValue;

    final funder = await TestUser.create(rpcClient: rpcClient, config: config);

    final message = solana.Message(
      instructions: [
        await command.mintPixel(
          config: config,
          ownerWalletId: funder.wallet.address,
          index: 0,
          color: [0, 0, 0],
          sellPrice: 0,
        ),
      ],
    );

    final transactionSignature = await rpcClient.signAndSendTransaction(
      message,
      [funder.wallet],
      feePayer: funder.wallet.address,
      commitment: solana.Commitment.finalized,
    );

    debugPrint();
    await rpcClient.waitForSignatureStatus(
        transactionSignature, solana.Commitment.finalized,
        timeout: defaultTimeoutDuration);

    debugPrint();
  }, timeout: Timeout(defaultTimeoutDuration));
}
