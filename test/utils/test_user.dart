import 'dart:io';

import 'package:chikin_nft_canvas_client/src/config.dart';
import 'package:chikin_nft_canvas_client/src/utils.dart' as utils;
import 'package:solana/solana.dart' as solana;
import 'package:solana/src/associated_token_account_program/associated_token_account_program.dart'
    as associated_token_account_program;
import 'package:solana/src/crypto/ed25519_hd_keypair.dart';

class TestUser {
  final Ed25519HDKeyPair wallet;
  final String tokenAccount;

  TestUser._({
    required this.wallet,
    required this.tokenAccount,
  });

  static Future<TestUser> create({
    required solana.RPCClient rpcClient,
    required Config config,
    int lamports = 10000000,
  }) async {
    var _logIndex = 0;
    final debugPrint = () {
      print('TestClaimer.create.debugPrint : ${_logIndex++}');
    };

    debugPrint();
    final wallet = await _newAccountWithLamports(rpcClient: rpcClient);
    debugPrint();
    final tokenAccountId = await utils.getTokenAccountId(
      tokenProgramId: config.tokenProgramId,
      associatedTokenProgramId: config.associatedTokenProgramId,
      tokenMintId: config.tokenMintId,
      ownerId: wallet.address,
    );

    // Create token account
    debugPrint();
    final message = solana.Message(instructions: [
      associated_token_account_program.AssociatedTokenAccountInstruction(
        funder: wallet.address,
        address: tokenAccountId,
        owner: wallet.address,
        mint: config.tokenMintId,
      ),
    ]);
    debugPrint();
    await rpcClient.signAndSendTransaction(message, [
      wallet,
    ]);

    debugPrint();
    return TestUser._(
      wallet: wallet,
      tokenAccount: tokenAccountId,
    );
  }

  static Future<Ed25519HDKeyPair> _newAccountWithLamports({
    required solana.RPCClient rpcClient,
    int lamports = 10000000,
  }) async {
    final keypair = await Ed25519HDKeyPair.random();

    for (var i = 0; i < 30; i++) {
      await rpcClient.requestAirdrop(
        address: keypair.address,
        lamports: lamports,
      );
      final balance = await rpcClient.getBalance(keypair.address);
      if (balance == lamports) {
        break;
      }
      sleep(Duration(milliseconds: 500));
    }

    final balance = await rpcClient.getBalance(keypair.address);
    assert(balance == lamports);
    return keypair;
  }
}
