class Config {
  const Config({
    this.programId = '5mmFdCFD2csnoCS1XcnTvpFGsWW6JvCRVxtCr91mtSKb',
    this.rentSysvarId = 'SysvarRent111111111111111111111111111111111',
    this.clockSysvarId = 'SysvarC1ock11111111111111111111111111111111',
    this.systemProgramId = '11111111111111111111111111111111',
    this.tokenProgramId = 'TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA',
    this.associatedTokenProgramId =
        'ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL',
    this.metaplexTokenMetadataProgramId =
        'metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s',
    this.ckcTokenMintId = '8s9FCz99Wcr3dHpiauFRi6bLXzshXfcGTfgQE7UEopVx',
    this.teamWalletId = 'DkmfiWSC4mnPvfMXZY2CkT4skvFkGr4u5DwRX2htRvJ2',
    this.teamTokenAccountId = 'Esi6Z7reZt9NjZ2TeTFRXcTez1XA7764dE9bZoKCdjTb',
    this.mintPoolWalletId = 'ARamwbZzoaRjiEnHM2oVmD5bqPpGPNuxUuXWRzsacgaz',
  });

  final String programId;
  final String rentSysvarId;
  final String clockSysvarId;
  final String systemProgramId;
  final String tokenProgramId;
  final String associatedTokenProgramId;
  final String metaplexTokenMetadataProgramId;
  final String ckcTokenMintId;
  final String teamWalletId;
  final String teamTokenAccountId;
  final String mintPoolWalletId;

  static const mainnet = Config();

  static const devnet = Config(
    programId: 'C68zxDpmRxYCCkV1tNkkYHAtw2PK2mzoD1wt5aGofEwC',
    ckcTokenMintId: '7XUka7j8G1HbdQPu2WTfFitQ2dr4w6CqS7yPyV15UZqH',
    teamTokenAccountId: '7WmS8RztXa6S6qNgUp3T3A2SMzF76i5k2PwsGRqy63gR',
    mintPoolWalletId: 'ARamwbZzoaRjiEnHM2oVmD5bqPpGPNuxUuXWRzsacgaz',
  );
}
