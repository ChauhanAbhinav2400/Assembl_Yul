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
            mstore(0x40 , add(beforePtr , 0x20)) 
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
        assembly {
            ptr := mload(0x40)
            mstore(ptr,12)
            mstore(add(ptr,0x20),22)
            // update pointer 
            mstore(0x40 ,add(ptr,0x40))
            first := mload(ptr)
            second := mload(add(ptr,0x20))
        }
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
        
        assembly {

            ptr := mload(0x40)
            mstore(ptr,2)
            mstore(add(ptr,0x20),11)
            mstore(add(ptr,0x40),22)
            mstore(0x40 , add(ptr,0x60))
            length := mload(ptr)
            first := mload(add(ptr,0x20))
            second := mload(add(ptr ,0x40))
        }
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
      assembly{
        beforePtr := mload(0x40)
        mstore(0x200, 777)
        afterPtr := mload(0x40)
        size := msize()
      }
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
        assembly{
            ptr := mload(0x40)
           mstore(ptr , 20)
           mstore(add(ptr,0x20),29)
           mstore(0x40 , add(ptr,0x40))
           x := mload(ptr)
           y := mload(add(ptr,0x20))
        }
    }
}



contract MemoryBootcamp3 {

    // =====================================================
    // EXERCISE 1
    // =====================================================

    function ex1()
        public
        pure
        returns (uint256)
    {
      assembly{
        let ptr := mload(0x40)
        mstore(ptr , 123)
        return(ptr,0x20)
      } 
    }

    // =====================================================
    // EXERCISE 2
    // =====================================================

    function ex2()
        public
        pure
        returns (
            uint256,
            uint256
        )
    {
         assembly {
            let ptr := mload(0x40)
            mstore(ptr , 12) 
            mstore(add(ptr , 0x20) , 22)
            return(ptr , 0x40)
         }
    }

    // =====================================================
    // EXERCISE 3
    // =====================================================

    function ex3()
        public
        pure
        returns (bytes32)
    {
       assembly {
        mstore(0x80 , 123)
        return(0x90 , 0x20)
       }
    }

    // =====================================================
    // EXERCISE 4
    // =====================================================

    function ex4()
        public
        pure
        returns (
            uint256,
            uint256,
            uint256
        )
    {
       assembly {
        mstore(0x80 , 123)
        mstore(0xA0 , 321)
        mstore(0xC0 , 74)
        return (0x80 , 96)
       }
    }

    // =====================================================
    // EXERCISE 5
    // =====================================================

    function ex5()
        public
        pure
        returns (uint256)
    {
       assembly {
        mstore(0x80 , 123)
        return(0x81 , 32)
       }
    }


    // =====================================================
    // EXERCISE 6
    // =====================================================

    function ex6()
        public
        pure
        returns (bytes memory)
    {
      assembly {
      let ptr := mload(0x40)
      mstore(ptr , 32)
      mstore(add(ptr,0x20),3)
      mstore8(add(ptr,64), 34)
      mstore8(add(ptr,65),45)
      mstore8( add(ptr ,66),56)
      mstore(0x40,add(ptr,0x60))
      return(ptr,0x60)
     }
    }
}