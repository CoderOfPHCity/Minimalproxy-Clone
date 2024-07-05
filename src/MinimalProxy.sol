// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.19;

// import "./ERC20Token.sol";
// import "@openzeppelin/contracts/proxy/Clones.sol";

// contract MinimalProxyFactory {
//     address[] public proxies;

//     event CloneCreated(address indexed clone);

//     function deployClone(
//         address implementation,
//         string memory name,
//         string memory symbol,
//         uint8 decimals,
//         uint256 initialSupply,
//         address owner
//     ) external returns (address) {
//         address clone = Clones.clone(implementation);

//         ERC20Token(clone).initialize(name, symbol, decimals, initialSupply, owner);
//         proxies.push(clone);
//         emit CloneCreated(clone);
//         return clone;
//     }
// }



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
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }
}

