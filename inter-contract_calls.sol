// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CalldataBootcamp1 {
    function ex1() external pure returns (uint256 size) {
        // load size of calldata
        assembly {
            size := calldatasize()
        }
    }

    function ex2() external pure returns (bytes32 value) {
        // load selector
        assembly {
            value := calldataload(0)
        }
    }

    function ex3(uint256 x) external pure returns (bytes32 value) {
        // load x
        assembly {
            value := calldataload(4)
        }
    }

    function ex4(
        uint256 x,
        uint256 y
    ) external pure returns (bytes32 a, bytes32 b) {
        assembly {
            a := calldataload(4)
            b := calldataload(36)
        }
    }

    function ex5() external pure returns (bytes32 value) {
        assembly {
            value := calldataload(999)
        }
    }
}

//=============================================================================================

contract CalldataBootcamp2 {
    function ex1() external pure returns (bytes32 value) {
        assembly {
            calldatacopy(0x80, 0, calldatasize())
            value := mload(0x80)
        }
    }

    function ex2() external pure returns (bytes32 value) {
        assembly {
            calldatacopy(0x80, 0, 4)

            value := mload(0x80)
        }
    }

    function ex3(uint256 x) external pure returns (bytes32 value) {
        assembly {
            calldatacopy(0x80, 4, 32)

            value := mload(0x80)
        }
    }

    function ex4(
        uint256 a,
        uint256 b
    ) external pure returns (bytes32 first, bytes32 second) {
        assembly {
            calldatacopy(0x80, 4, 64)

            first := mload(0x80)

            second := mload(add(0x80, 32))
        }
    }

    function ex5(uint256 x) external pure returns (bytes32 value) {
        assembly {
            calldatacopy(0x80, 20, 8)

            value := mload(0x80)
        }
    }

    function ex6() external pure returns (bytes32 value) {
        assembly {
            calldatacopy(0x80, 999, 32)

            value := mload(0x80)
        }
    }

    function getselectorofex1() public pure returns (bytes4 selector) {
        return bytes4(keccak256("ex1()"));
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SelectorBootcamp {
    function ex1() external pure returns (bytes4 selector) {
        //return selector with right shift
        assembly {
            selector := shr(224, calldataload(0))
        }
    }

    function ex2() external pure returns (uint256 result) {
        assembly {
            let selector := shr(224, calldataload(0))

            /*
            Replace this
            with your own
            selector
        */

            if eq(selector, 0x12345678) {
                result := 111
            }
        }
    }

    function ex3() external pure {
        assembly {
            // selector match with switch statement
            let selector := calldataload(0)
            switch selector
            case 0x12345678 {
                mstore(0, 2)
                return(0, 32)
            }
            case 0xabcdef12 {
                mstore(0, 3)
                return(0, 32)
            }
            default {
                mstore(0, 4)
                return(0, 32)
            }
        }
    }

    function ex4() external pure returns (uint256 x) {
        assembly {
            x := calldataload(4)
        }
    }

    function ex5() external pure returns (uint256 x) {
        assembly {
            // if calldata size is less than 36 revert otherwise return x - selctor
            let size := calldatasize()
            if lt(size, 36) {
                revert(0, 0)
            }
            x := calldataload(4)
        }
    }

    function ex6(uint256 arg) external pure returns (uint256) {
        assembly {
            // use helper function and if arg = 8 return 88 otherwose return 99 and store in memory and return it
            let result := helper(arg)
            mstore(0x80, result)
            return(0x80, 32)
            function helper(x) -> r {
                if eq(x, 8) {
                    r := 88
                    leave
                }
                r := 99
            }
        }
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Target {
    function getTwo() external pure returns (uint256) {
        return 2;
    }

    function get99(uint256 x) external pure returns (uint256) {
        if (x == 8) {
            return 88;
        }

        return 99;
    }

    function add(uint256 a, uint256 b) external pure returns (uint256) {
        return a + b;
    }
}

contract Caller {
    function ex1() external pure returns (bytes32 value) {
        bytes4 selector = bytes4(keccak256("getTwo()"));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, shl(224, selector))
            value := mload(ptr)
        }
    }

    function ex2(address target) external view returns (uint256) {
        bytes4 selector = bytes4(keccak256("getTwo()"));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, selector) // getTwo()

            let success := staticcall(gas(), target, ptr, 4, ptr, 32)

            if iszero(success) {
                revert(0, 0)
            }

            return(ptr, 32)
        }
    }

    function ex3(address target) external view returns (uint256) {
        bytes4 selector = bytes4(keccak256("get99(uint256)"));

        assembly {
            let ptr := mload(0x40)
            mstore(ptr, selector)
            mstore(add(ptr, 4), 8)

            let success := staticcall(gas(), target, ptr, 36, ptr, 32)

            if iszero(success) {
                revert(0, 0)
            }

            return(ptr, 32)
        }
    }
}
