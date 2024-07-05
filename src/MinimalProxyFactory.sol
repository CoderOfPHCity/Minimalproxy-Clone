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
        MinimalProxy clone = new MinimalProxy(masterContract);
        clones.push(address(clone));
        emit CloneCreated(address(clone));
        return address(clone);
    }

    function getClones() external view returns (address[] memory) {
        return clones;
    }
}
