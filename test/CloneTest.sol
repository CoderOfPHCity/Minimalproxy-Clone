// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/ERC20Token.sol";
import "../src/MinimalProxyFactory.sol";

contract MinimalProxyFactoryTest is Test {
    ERC20Token public implementation;
    MinimalProxyFactory public factory;

    //  attacker = makeAddr("Attacker");
    address attacker = makeAddr("alice");
    address attacker1 = makeAddr("attacker");

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
        vm.startPrank(attacker);
        address cloneAddress = factory.createClone();
        ERC20Token token = ERC20Token(cloneAddress);

        token.initialize("Test Token", "TTK", 18, 1000 ether, attacker);

        token.transfer(attacker1, 1 ether);

        assertEq(token.balanceOf(attacker1), 1 ether);
    }
}
