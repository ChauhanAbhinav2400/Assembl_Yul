//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BasicOperation {
    function loop() public pure returns (uint256) {
        uint256 i;
        assembly {
            for {
                i := 1
            } lt(i, 10) {
                i := add(i, 1)
            } {
               
                if iszero(mod(i, 2)) {
                    break
                }
                if mod(i, 2) {
                    continue
                }
            }
        }
        return i;
    }

    function add(uint256 x , uint256 y ) public pure returns (uint256) {
        uint256 result;
        assembly {
            result := add(x,y)
        }
        return result;
    }

   function sub(uint256 x , uint256 y ) public pure returns (uint256) {
        uint256 result;
        assembly {
            result := sub(x,y)
        }
        return result;
    }

    function mul(uint256 x , uint256 y ) public pure returns (uint256) {
        uint256 result;
        assembly {
            result := mul(x,y)
        }
        return result;
    }

    function div(uint256 x , uint256 y ) public pure returns (uint256) {
        uint256 result;
        assembly {
            result := div(x,y)
        }
        return result;
    }

    function and(uint256 x , uint256 y ) public pure returns (uint256) {
        uint256 result;
        assembly {
            result := and(x,y)
        }
        return result;
    }

    function or(uint256 x , uint256 y ) public pure returns (uint256) {
        uint256 result;
        assembly {
            result := or(x,y)
        }
        return result;
    }


    function xor(uint256 x , uint256 y ) public pure returns (uint256) {
        uint256 result;
        assembly {
            result := xor(x,y)
        }
        return result;
    }
    

    function lessthan(uint256 x , uint256 y ) public pure returns (bool) {
        bool result;
        assembly {
            result := lt(x,y)
        }
        return result;
    }

    function greaterthan(uint256 x , uint256 y ) public pure returns (bool) {
        bool result;
        assembly{
            result := gt(x,y)
        }
        return result;
    }


    function modulo(uint256 x , uint256 y ) public pure returns (uint256) {
        uint256 result;
        assembly {
            result := mod(x,y)
        }
        return result;
    }
}
