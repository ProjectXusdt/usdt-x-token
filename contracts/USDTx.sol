// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract USDTx is ERC20, Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    address public constant USDT_ADDRESS = 0x55d398326f99059fF775485246999027B3197955;

    /// @dev стартовая эмиссия (без decimals)
    uint256 public constant INITIAL_SUPPLY_CONTRACT = 500_000; // сколько минтить контракту
    uint256 public constant INITIAL_SUPPLY_OWNER    = 500_000; // сколько минтить владельцу

    IERC20Metadata public immutable usdtMeta;
    IERC20 public immutable usdt;
    uint8 private immutable _usdtDecimals;

    error UsdtAddressIsZero();

    event MintedWithUSDT(address indexed payer, address indexed to, uint256 amount);
    event RedeemedToUSDT(address indexed from, address indexed to, uint256 amount);
    event OwnerMint(address indexed to, uint256 amount);

    constructor()
        ERC20("USDT.x", "USDT.x")
        Ownable(msg.sender)
    {
        if (USDT_ADDRESS == address(0)) {
            revert UsdtAddressIsZero();
        }

        usdtMeta = IERC20Metadata(USDT_ADDRESS);
        usdt = IERC20(USDT_ADDRESS);
        _usdtDecimals = usdtMeta.decimals();

        // ======= ДОПОЛНИЛИ НАЧАЛЬНУЮ ЭМИССИЮ =======

        // Минтим контракту — будет видно в BscScan под "Token Holdings"
        uint256 supplyContract = INITIAL_SUPPLY_CONTRACT * (10 ** _usdtDecimals);
        _mint(address(this), supplyContract);

        // Минтим владельцу
        uint256 supplyOwner = INITIAL_SUPPLY_OWNER * (10 ** _usdtDecimals);
        _mint(owner(), supplyOwner);
    }

    function decimals() public view override returns (uint8) {
        return _usdtDecimals;
    }

    function mintWithUSDT(uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be > 0");
        usdt.safeTransferFrom(msg.sender, address(this), amount);
        _mint(msg.sender, amount);
        emit MintedWithUSDT(msg.sender, msg.sender, amount);
    }

    function redeemToUSDT(uint256 amount) external nonReentrant {
        require(amount > 0, "Amount must be > 0");
        uint256 bal = usdt.balanceOf(address(this));
        require(bal >= amount, "Not enough USDT liquidity");

        _burn(msg.sender, amount);
        usdt.safeTransfer(msg.sender, amount);

        emit RedeemedToUSDT(msg.sender, msg.sender, amount);
    }

    function contractUSDTBalance() external view returns (uint256) {
        return usdt.balanceOf(address(this));
    }

    /// @notice Дополнительная эмиссия, владелец выбирает куда минтить
    function ownerMint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
        emit OwnerMint(to, amount);
    }
}
