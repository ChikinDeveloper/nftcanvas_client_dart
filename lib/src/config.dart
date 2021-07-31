class Config {
  const Config({
    this.programId = 'C68zxDpmRxYCCkV1tNkkYHAtw2PK2mzoD1wt5aGofEwC',
    this.rentSysvarId = 'SysvarRent111111111111111111111111111111111',
    this.systemProgramId = '11111111111111111111111111111111',
    this.tokenProgramId = 'TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA',
    this.associatedTokenProgramId = 'ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL',
    this.tokenMintId = '7XUka7j8G1HbdQPu2WTfFitQ2dr4w6CqS7yPyV15UZqH',
    this.teamTokenAccountId = '7WmS8RztXa6S6qNgUp3T3A2SMzF76i5k2PwsGRqy63gR',
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
