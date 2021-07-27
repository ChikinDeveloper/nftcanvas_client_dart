import 'package:chikin_nft_canvas_client/src/config.dart';
import 'package:solana/solana.dart' as solana;
import 'package:solana/src/crypto/ed25519_hd_keypair.dart';
import 'package:cryptography/cryptography.dart' as crypto;
import 'package:solana/src/spl_token/spl_token.dart' as spl_token;

class TestToken {
  final solana.SplToken splToken;
  final Ed25519HDKeyPair authority;
  final String mintId;

  TestToken._({
    required this.splToken, 
    required this.authority, 
    required this.mintId,
  });

  static Future<TestToken> create({
    required solana.RPCClient rpcClient,
    required Config config,
    required String mintId,
  }) async {
    final authority = await Ed25519HDKeyPair.random();
    final splToken = await rpcClient.initializeMint(owner: authority, decimals: 6);
    return TestToken._(splToken: splToken, authority: authority, mintId: mintId);
  }
}
