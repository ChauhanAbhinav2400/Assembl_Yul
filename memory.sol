// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract MemoryBootcamp1  {

    function ex1 () public pure returns (uint256 result ) {

   assembly {
    mstore(0x00 , 10) 
    result := mload(0x00)
   }
    }

    function ex2 () public pure returns(uint256 result) {
        assembly {
            mstore8(0x00 ,0xA0)
            result := mload(0x00)
        }
    }

    function ex3 () public pure returns(uint256 result ) {

        assembly {
            mstore(0x00 , 1)
            mstore(0x01 , 2)
            result := mload(0x00)
        }
    }

    function ex4() public pure returns (bytes32 first , bytes32 second) {

        assembly {
            mstore(0x00 , 11)
            mstore(0x20,22)
            first := mload(0x00)
            second := mload(0x20)
        }
    }

    function ex5() public pure returns(bytes32 result) {

     assembly {
        mstore(0x80 , 23)
        result := msize()
     }

    }
}