// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "forge-std/console.sol";

contract File is ERC721, ERC721Burnable {
    uint256 private _tokenIdCounter;

    constructor() ERC721("GameItem", "ITM") {}

    function mint(address _recipient) external payable {
        require(msg.value == 1e18, "Mint requires 1 ether");

        _safeMint(_recipient, ++_tokenIdCounter);
    }

    function redeem(uint256 _tokenId) external {
        safeTransferFrom(msg.sender, address(this), _tokenId);
        _burn(_tokenId);

        (bool success, bytes memory data) = msg.sender.call{value: 1e18}("");
        require(success, "Transfer failed.");
        console.logBytes32(bytes32(data));
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        returns (bytes4)
    {
        return this.onERC721Received.selector;
    }
}
