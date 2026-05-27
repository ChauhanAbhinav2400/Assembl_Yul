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


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MemoryBootcamp2 {

    // =====================================================
    // EXERCISE 1
    // =====================================================

    function ex1()
        public
        pure
        returns (
            uint256 beforePtr,
            uint256 afterPtr
        )
    {
        assembly {
            beforePtr := mload(0x40) 
            mstore(beforePtr , 123) 
            afterPtr := mload(0x40)
        }
       
        }
   

    // =====================================================
    // EXERCISE 2
    // =====================================================

    function ex2()
        public
        pure
        returns (
            uint256 ptr,
            uint256 first,
            uint256 second
        )
    {
        
    }

    // =====================================================
    // EXERCISE 3
    // =====================================================

    function ex3()
        public
        pure
        returns (
            uint256 ptr,
            uint256 length,
            uint256 first,
            uint256 second
        )
    {
        
    }

    // =====================================================
    // EXERCISE 4
    // =====================================================

    function ex4()
        public
        pure
        returns (
            uint256 beforePtr,
            uint256 afterPtr,
            uint256 size
        )
    {
      
    }

    // =====================================================
    // EXERCISE 5
    // =====================================================

    function ex5()
        public
        pure
        returns (
            uint256 ptr,
            uint256 x,
            uint256 y
        )
    {
        
    }
}