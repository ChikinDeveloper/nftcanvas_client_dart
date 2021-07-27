import 'package:chikin_nft_canvas_client/src/command.dart' as command;
import 'package:chikin_nft_canvas_client/src/config.dart' as cfg;
import 'package:solana/solana.dart' as solana;
import 'package:solana/src/crypto/ed25519_hd_keypair.dart';
import 'package:test/test.dart';

void main() {
  final defaultTimeoutDuration = Duration(seconds: 90);

  var _logIndex = 0;
  final debugPrint = () {
    print('test_init_pixel.debugPrint : ${_logIndex++}');
  };

  test('test_init_pixel', () async {
    final rpcUrl = 'http://localhost:8899';
    final rpcClient = solana.RPCClient(rpcUrl);
    final config = cfg.Config();

    final teamWallet = await Ed25519HDKeyPair.fromMnemonic('salut');
    final pixelIndex = 2;

    var transactionSignature = await rpcClient.signAndSendTransaction(
      solana.Message(
        instructions: [
          await command.mintPixel(
            config: config,
            ownerWalletId: teamWallet.address,
            index: pixelIndex,
            color: [0, 0, 0],
            sellPrice: 0,
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

    // Init twice : should fail

    try {
      transactionSignature = await rpcClient.signAndSendTransaction(
        solana.Message(
          instructions: [
            await command.mintPixel(
              config: config,
              ownerWalletId: teamWallet.address,
              index: pixelIndex,
              color: [0, 0, 0],
              sellPrice: 0,
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
      throw Exception('Did not fail');
    } catch (e) {
      print('DID FAIL WITH ERROR : $e');
    }


  }, timeout: Timeout(defaultTimeoutDuration));
}
