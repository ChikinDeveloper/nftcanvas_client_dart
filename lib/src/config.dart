class Config {
  const Config({
    this.programId = 'C68zxDpmRxYCCkV1tNkkYHAtw2PK2mzoD1wt5aGofEwC',
    this.rentSysvarId = 'SysvarRent111111111111111111111111111111111',
    this.systemProgramId = '11111111111111111111111111111111',
    this.tokenProgramId = 'TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA',
    this.associatedTokenProgramId = 'ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL',
    this.tokenMintId = '9teanB35j1TtCwY9F6GDfCrqr4mNyBw1HsS5QMC6S7EE',
    this.teamTokenAccountId = '4AErJr6ibhF82kRiSKgat6qmdtnwwAz55BynDmi8RCTv',
    this.mintPoolWalletId = 'ARamwbZzoaRjiEnHM2oVmD5bqPpGPNuxUuXWRzsacgaz',
  });

  final String programId;
  final String rentSysvarId;
  final String systemProgramId;
  final String tokenProgramId;
  final String associatedTokenProgramId;
  final String tokenMintId;
  final String teamTokenAccountId;
  final String mintPoolWalletId;

  static const defaultValue = Config();
}
