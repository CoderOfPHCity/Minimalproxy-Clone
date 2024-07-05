// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/ERC20Token.sol";
import "../src/MinimalProxy.sol";
import "../src/MinimalProxyFactory.sol";

contract MinimalProxyFactoryTest is Test {
    ERC20Token public implementation;
    MinimalProxyFactory public factory;

    //  attacker = makeAddr("Attacker");
    address attacker = makeAddr("alice");

    function setUp() public {
        implementation = new ERC20Token();
        factory = new MinimalProxyFactory(address(implementation));
    }

    function testGetClones() public {
        address cloneAddress1 = factory.createClone();
        //vm.prank(attacker);
        address cloneAddress2 = factory.createClone();

        address[] memory clones = factory.getClones();

        assertEq(clones.length, 2);
        assertEq(clones[0], cloneAddress1);
        assertEq(clones[1], cloneAddress2);
    }

    function testDeployClone() public {
        address cloneAddress = factory.createClone();
        ERC20Token token = ERC20Token(cloneAddress);

        token.initialize("Test Token", "TTK", 18, 1000 ether, address(this));

        // vm.pauseGasMetering();
        vm.stopPrank();
        vm.prank(attacker);

        address cloneAddress2 = factory.createClone();
        ERC20Token token2 = ERC20Token(cloneAddress2);

        token2.initialize("Another Token", "ATK", 18, 2000 ether, address(attacker));

        token2.transfer(cloneAddress2, 500 ether);

        assertEq(token.balanceOf(address(this)), 500 ether);
        assertEq(token.balanceOf(cloneAddress2), 500 ether);
    }
}
