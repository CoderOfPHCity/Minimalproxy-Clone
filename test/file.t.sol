// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/File.sol";

contract SecureNFTTest is Test {
    File public nft;
    address public user1 = address(0x1);
    address public user2 = address(0x2);

    function setUp() public {
        nft = new File();
    }

    function testRedeem() public {
        vm.deal(user1, 1 ether);
        vm.startPrank(user1);

        nft.mint{value: 1 ether}(user1);

        nft.redeem(1);

        vm.stopPrank();
    }
}
