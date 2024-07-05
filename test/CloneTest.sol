// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/ERC20Token.sol";
import "../src/MinimalProxy.sol";
import "../src/MinimalProxyFactory.sol";

contract MinimalProxyFactoryTest is Test {
    ERC20Token public implementation;
    MinimalProxyFactory public factory;

    function setUp() public {
        implementation = new ERC20Token();
        factory = new MinimalProxyFactory(address(implementation));
    }

    function testGetClones() public {
        address cloneAddress1 = factory.createClone();
        address cloneAddress2 = factory.createClone();
        
        address[] memory clones = factory.getClones();
        
        assertEq(clones.length, 2);
        assertEq(clones[0], cloneAddress1);
        assertEq(clones[1], cloneAddress2);
    }
}

