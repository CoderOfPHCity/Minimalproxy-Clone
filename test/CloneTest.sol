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
        address clone =
            factory.deployClone(address(implementation), "James Token", "JTK", 18, 1000 ether, address(this));

        ERC20Token token = ERC20Token(clone);

        address clone2 =
            factory.deployClone(address(implementation), "Daniel Token", "DTK", 18, 2000 ether, address(this));
        ERC20Token token2 = ERC20Token(clone2);
        token.transfer(address(token2), 500 ether);

        assertEq(token.balanceOf(address(token2)), 500 ether);
        assertEq(token2.balanceOf(address(token2)), 0);
       
    }
}
