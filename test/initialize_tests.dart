import 'dart:io';

import 'package:chikin_nft_canvas_client/chikin_nft_canvas_client.dart' as client;
import 'package:solana/solana.dart' as solana;
import 'package:solana/src/crypto/ed25519_hd_keypair.dart';
import 'package:solana/src/spl_token/spl_token.dart' as spl_token;
import 'package:test/test.dart';

void main() {
  test('initialize_tests', () async {
    final rpcUrl = 'http://localhost:8899';
    final rpcClient = solana.RPCClient(rpcUrl);
    final config = client.Config.defaultValue;

    final teamWalletMnemonic = 'salut';
    final teamWallet = await Ed25519HDKeyPair.fromMnemonic(teamWalletMnemonic);

    // print('teamWalletBalance = ${await rpcClient.getBalance(teamWallet.address)}');
    // var txSignature = await rpcClient.requestAirdrop(address: teamWallet.address, lamports: 1000000000, commitment: solana.Commitment.processed);
    // await rpcClient.waitForSignatureStatus(txSignature, solana.Commitment.processed);
    // sleep(Duration(seconds: 10));
    // print('teamWalletBalance = ${await rpcClient.getBalance(teamWallet.address)}');

    final splToken =
        await rpcClient.initializeMint(owner: teamWallet, decimals: 6);

    print('teamWalletBalance = ${await rpcClient.getBalance(teamWallet.address)}');
    print('tokenMintId=${splToken.mint}');
    print('teamWalletMnemonic=$teamWalletMnemonic');
    print('teamWalletId=${teamWallet.address}');
    print('teamTokenAccountId=${await client.getTokenAccountId(
        tokenProgramId: config.tokenProgramId,
        associatedTokenProgramId: config.associatedTokenProgramId,
        tokenMintId: config.tokenMintId,
        ownerId: teamWallet.address)}');
  }, timeout: Timeout(Duration(minutes: 2)));
}

// Add to
// - client.config
// - program.config
// - client.test
// - program.test
