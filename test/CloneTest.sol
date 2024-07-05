// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/ERC20Token.sol";
import "../src/MinimalProxyFactory.sol";

contract MinimalProxyFactoryTest is Test {
    ERC20Token public implementation;
    MinimalProxyFactory public factory;

    function setUp() public {
        implementation = new ERC20Token();
        factory = new MinimalProxyFactory();
    }

    function testDeployClone() public {
        // Deploy a clone
        address clone = factory.deployClone(
            address(implementation),
            "Test Token",
            "TTK",
            18,
            1000 ether,
            address(this)
        );

        // Verify the clone
        ERC20Token token = ERC20Token(clone);
        assertEq(token.name(), "Test Token");
        assertEq(token.symbol(), "TTK");
        assertEq(token.decimals(), 18);
        assertEq(token.totalSupply(), 1000 ether);
        assertEq(token.balanceOf(address(this)), 1000 ether);

        // Transfer from one clone to another
        address clone2 = factory.deployClone(
            address(implementation),
            "Another Token",
            "ATK",
            18,
            2000 ether,
            address(this)
        );
        ERC20Token token2 = ERC20Token(clone2);
        token.transfer(address(token2), 500 ether);

        // Verify balances after transfer
        assertEq(token.balanceOf(address(this)), 500 ether);
        assertEq(token.balanceOf(address(token2)), 500 ether);
        assertEq(token2.balanceOf(address(token2)), 0);
        assertEq(token2.balanceOf(address(this)), 2000 ether);
    }
}
