// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenGaming is ERC20, Ownable, ERC20Burnable
{
    mapping(string => uint) public itemPrices;
    event ItemRedeem(address indexed player, string item);

    constructor() ERC20("Degen Token", "DGT") 
    {
        mintTokens(msg.sender, 100*10**decimals());
    }

    function mintTokens(address to, uint amount) public onlyOwner
    {
        _mint(to, amount);
    }

    function transferTokens(address receiver, uint amount) external
    {
        require(balanceOf(msg.sender) >= amount, "You do not have enough funds");
        approve(msg.sender, amount);
        transferFrom(msg.sender, receiver, amount);
    }

    function checkBalance() external view returns(uint)
    {
       return balanceOf(msg.sender);
    }

    function addItem(string memory item, uint price) public onlyOwner 
    {
        require(price > 0, "Price cannot be zero");
        itemPrices[item] = price;
    }

    function getPrice(string memory item) public view returns (uint) 
    {
        return itemPrices[item];
    }

    function burnTokens(uint amount) external
    {
        require(balanceOf(msg.sender) >= amount, "Insufficient Funds");
        _burn(msg.sender, amount);
    }

    function redeem(string memory item) public 
    {
        require(itemPrices[item] > 0, "Item not available for redemption");
        require(balanceOf(msg.sender) >= itemPrices[item], "Insufficient balance");

        _transfer(msg.sender, owner(), itemPrices[item]);
        emit ItemRedeem(msg.sender, item);
    }

    
}
