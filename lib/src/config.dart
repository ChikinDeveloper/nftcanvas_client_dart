class Config {
  const Config({
    this.programId = '5mmFdCFD2csnoCS1XcnTvpFGsWW6JvCRVxtCr91mtSKb',
    this.rentSysvarId = 'SysvarRent111111111111111111111111111111111',
    this.systemProgramId = '11111111111111111111111111111111',
    this.tokenProgramId = 'TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA',
    this.associatedTokenProgramId =
        'ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL',
    this.tokenMintId = '8s9FCz99Wcr3dHpiauFRi6bLXzshXfcGTfgQE7UEopVx',
    this.teamTokenAccountId = 'Esi6Z7reZt9NjZ2TeTFRXcTez1XA7764dE9bZoKCdjTb',
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
