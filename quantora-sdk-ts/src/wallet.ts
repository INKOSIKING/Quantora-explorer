import { Wallet, utils as EthUtils } from 'ethers';

export class QuantoraWallet {
  wallet: Wallet;

  static createRandom() {
    return new QuantoraWallet(Wallet.createRandom());
  }
  static fromMnemonic(mnemonic: string) {
    return new QuantoraWallet(Wallet.fromMnemonic(mnemonic));
  }
  static fromPrivateKey(pk: string) {
    return new QuantoraWallet(new Wallet(pk));
  }
  constructor(wallet: Wallet) {
    this.wallet = wallet;
  }
  address() {
    return this.wallet.address;
  }
  signTx(tx: any) {
    return this.wallet.signTransaction(tx);
  }
  exportMnemonic() {
    return this.wallet.mnemonic?.phrase;
  }
  // Hardware wallet, QR, Ledger support: TODO
}