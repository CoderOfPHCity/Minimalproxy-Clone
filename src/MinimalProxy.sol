// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MinimalProxy {
    address public masterContract;

    constructor(address _masterContract) {
        masterContract = _masterContract;
    }

    fallback() external {
        address target = masterContract;
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), target, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }
}
