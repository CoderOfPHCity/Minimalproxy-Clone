// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./MinimalProxy.sol";

contract MinimalProxyFactory {
    address public masterContract;
    address[] public clones;

    event CloneCreated(address indexed clone);

    constructor(address _masterContract) {
        masterContract = _masterContract;
    }

    function createClone() external returns (address) {
        clones.push(address(masterContract));
        return address(masterContract);
    }

    function getClones() external view returns (address[] memory) {
        return clones;
    }
}
