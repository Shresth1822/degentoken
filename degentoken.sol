// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    mapping(string => uint256) private _itemPrices;
    event ItemRedeemed(address indexed player, string item);

    constructor() ERC20("Degen token", "DGT") {
        _mint(msg.sender, 100 * 10**decimals());
    }

    function mintTokens(address recipient, uint256 amount) public onlyOwner {
        _mint(recipient, amount);
    }

    function transferTokens(address receiver, uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient funds");
        approve(msg.sender, amount);
        transferFrom(msg.sender, receiver, amount);
    }

    function checkAccountBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function addItemToStore(string memory itemName, uint256 price) public onlyOwner {
        require(price > 0, "Price cannot be zero");
        _itemPrices[itemName] = price;
    }

    function getItemPrice(string memory itemName) public view returns (uint256) {
        return _itemPrices[itemName];
    }

    function burnToken(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient funds");
        _burn(msg.sender, amount);
    }

    function redeemItem(string memory itemName) public {
        require(_itemPrices[itemName] > 0, "Item not available for redemption");
        require(balanceOf(msg.sender) >= _itemPrices[itemName], "Insufficient balance");

        _transfer(msg.sender, owner(), _itemPrices[itemName]);
        emit ItemRedeemed(msg.sender, itemName);
    }
}
