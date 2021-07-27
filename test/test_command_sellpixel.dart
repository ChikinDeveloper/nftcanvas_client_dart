import 'dart:math';

import 'package:chikin_nft_canvas_client/src/command.dart' as command;
import 'package:chikin_nft_canvas_client/src/config.dart' as cfg;
import 'package:solana/solana.dart' as solana;
import 'package:solana/src/crypto/ed25519_hd_keypair.dart';
import 'package:test/test.dart';

void main() {
  final defaultTimeoutDuration = Duration(seconds: 90);

  var _logIndex = 0;
  final debugPrint = () {
    print('test_command_sellPixel.debugPrint : ${_logIndex++}');
  };

  test('test_command_sellPixel', () async {
    final rpcUrl = 'http://localhost:8899';
    final rpcClient = solana.RPCClient(rpcUrl);
    final config = cfg.Config();

    final teamWallet = await Ed25519HDKeyPair.fromMnemonic('salut');
    final pixelIndex = 2;

    var transactionSignature = await rpcClient.signAndSendTransaction(
      solana.Message(
        instructions: [
          await command.sellPixel(
            rpcClient: rpcClient,
            config: config,
            index: pixelIndex,
            price: 1000 * pow(10, 6).toInt(),
          ),
        ],
      ),
      [teamWallet],
      feePayer: teamWallet.address,
      commitment: solana.Commitment.processed,
    );
    await rpcClient.waitForSignatureStatus(
        transactionSignature, solana.Commitment.processed,
        timeout: defaultTimeoutDuration);

    debugPrint();
  }, timeout: Timeout(defaultTimeoutDuration));
}
