# USDT.x (USDTx) — Official Token Information

**Contract Address:** `0xAc6DFd5D00bb1f8822fE444368749D7aB9927089`  
**Network:** BNB Smart Chain (BSC)  
**Standard:** BEP-20  
**Symbol:** USDT.x  
**Name:** USDT.x  

USDT.x (USDTx) is a BEP-20 token deployed on the BNB Smart Chain.  
The token uses the same decimal precision as native BSC USDT and supports controlled supply management, including a fixed initial issuance and optional owner-controlled minting.  

The contract also includes a 1:1 mint/redeem mechanism backed by USDT (0x55d398326f99059fF775485246999027B3197955), enabling seamless interaction with stable liquidity.

---

## Token Features

- Fixed initial supply minted at deployment  
- Additional minting available only to the contract owner  
- Decimals automatically match BSC USDT  
- Secure mint and redeem operations  
- Built using audited OpenZeppelin libraries  
- Open-source and BscScan-verified  

---

## Source Code

The full smart-contract source is located in this repository:  
```
contracts/USDTz.sol
```

Primary contract:
```
contract USDTx is ERC20, Ownable, ReentrancyGuard { ... }
```

---

## Links

- **BscScan Token Page:** https://bscscan.com/token/0xAc6DFd5D00bb1f8822fE444368749D7aB9927089  
- **Contract Code:** https://bscscan.com/address/0xAc6DFd5D00bb1f8822fE444368749D7aB9927089#code  
- **GitHub Repository:** https://github.com/ProjectXusdt/usdt-x-token  

---

## Contact

**Email:** Usdt.x_Project@protonmail.com
