import 'package:chikin_nft_canvas_client/chikin_nft_canvas_client.dart'
    as client;
import 'package:chikin_nft_canvas_client/src/config.dart';
import 'package:test/test.dart';

void main() {
  test('test_get_id', () async {
    final program = 'ALaYfBMScNrJxKTfgpfFYDQSMYJHpzuxGq15TM2j6o8E';
    final tokenMint = 'kzD48EzsC5bcdZkXP2ET4BqKKHb8jij3DutuNhgNsND';
    final teamWallet = 'CDwPMvrqcvtmLYCCAdaBPD8yWTpr7WG6eRA6vw4XCcxo';
    final teamTokenAccount = await client.getTokenAccountId(
        tokenProgramId: Config.defaultValue.tokenProgramId,
        associatedTokenProgramId:
        Config.defaultValue.associatedTokenProgramId,
        tokenMintId: tokenMint,
        ownerId: teamWallet);
    final tradePool = await client.getTradePoolId(programId: program);
    final pixel0 = await client.getPixelAccountId(programId: program, index: 0);
    final pixel1 = await client.getPixelAccountId(programId: program, index: 1);
    final pixel54 = await client.getPixelAccountId(programId: program, index: 54);

    print('program=$program');
    print('tokenMint=$tokenMint');
    print('teamWallet=$teamWallet');
    print('teamTokenAccount=$teamTokenAccount');
    print('tradePool=$tradePool');
    print('pixel0=$pixel0');
    print('pixel1=$pixel1');
    print('pixel54=$pixel54');
  }, timeout: Timeout(Duration(minutes: 2)));
}
