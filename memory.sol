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



contract MemoryBootcamp4 {

    // =====================================================
    // EXERCISE 1
    // =====================================================

    function ex1()
        public
        pure
    {
       assembly {
        mstore(0x80 , 123)
        revert(0x80 , 32)
       }
    }

    // =====================================================
    // EXERCISE 2
    // =====================================================

    function ex2()
        public
        pure
    {
        assembly {

            mstore(0x80 , 23)
            revert (0x90 , 32)
        }
    }

    // =====================================================
    // EXERCISE 3
    // =====================================================

    function ex3(
        uint256 x
    )
        public
        pure
        returns (uint256)
    {
        assembly {

            if lt(x, 10) {

                mstore(
                    0x80,
                    123456
                )

                revert(0x80, 32)
            }

            mstore(0x80, x)

            return(0x80, 32)
        }
    }

    // =====================================================
    // EXERCISE 4
    // =====================================================

    function ex4()
        public
        pure
    {
        assembly {

            /*
                Build fake revert string
                manually.

                Not full ABI encoding yet.

                Just raw bytes.
            */

           mstore(0x80 , 0xDEADBEEF)
           revert(0x80 , 32)
        }
    }

    // =====================================================
    // EXERCISE 5
    // =====================================================

    function ex5()
        public
        pure
    {
        assembly {

            /*
                malformed revert

                only return
                middle slice
            */

            mstore(
                0x80,
                0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
            )

            revert(0x81, 31)
        }
    }

    // =====================================================
    // EXERCISE 6
    // =====================================================

    function ex6()
        public
        pure
    {
        assembly {

            /*
                Simulate:
                revert CustomError()

                Selector:
                first 4 bytes
            */

            mstore(
                0x80,
                0x12345678
            )

           revert (0x80 , 4)
        }
    }
}


contract MemoryBootcamp5 {

    // =====================================================
    // EXERCISE 1
    // =====================================================

    function ex1()
        public
        pure
        returns(bytes32 h)
    {
       // normally hash starting 32 bytes from memory
       assembly {
        mstore(0x80 , 123)
        h := keccak256(
            0x80,
            32
        )
       }
    }

    // =====================================================
    // EXERCISE 2
    // =====================================================

    function ex2()
        public
        pure
        returns(
            bytes32 hash1,
            bytes32 hash2
        )
    {
        assembly {

          // hash 32 bytes starting from 0x80 
          // hash 31 bytes starting from 0x81
             mstore(0x80 , 12)
             hash1 := keccak256(
                0x80 ,
                32
             )
             hash2 := keccak256(
                0x81,
                31
             )


        }
    }

    // =====================================================
    // EXERCISE 3
    // =====================================================

    function ex3()
        public
        pure
        returns(bytes32 h)
    {
        assembly {

           // hash 64 bytes starting from 0x80
           mstore(0x80 , 12)
           mstore(0xA0 , 22)
           h := keccak256(
            0x80,
            64
           )
        }
    }

    // =====================================================
    // EXERCISE 4
    // =====================================================

    function ex4()
        public
        pure
        returns(
            bytes32 h1,
            bytes32 h2
        )
    {
        assembly {

           //hash1 : 64 bytes starting from 0x80
                //hash2 : 32 bytes starting from 0x80
            let ptr := mload(0x40)
            mstore(ptr ,12)
              mstore(add(ptr,0x20) ,22)
              h1 := keccak256(
                ptr,
                64
              )
              h2 := keccak256 (
                ptr ,
                32
              )
        }
    }

    // =====================================================
    // EXERCISE 5
    // =====================================================

    function ex5(
        uint256 key
    )
        public
        pure
        returns(bytes32 location)
    {
        assembly {

            /*
                Simulate:

                mapping(uint=>uint)

                location =
                keccak256(
                    key,
                    slot
                )
            */

               let slot := 7 
               mstore(0x80 , key)
               mstore(add(0x80 , 0x20) , slot)
               location := keccak256(
                0x80 ,
                64
               )
        }
    }

    // =====================================================
    // EXERCISE 6
    // =====================================================

    function ex6()
        public
        pure
        returns(bytes32 location)
    {
        assembly {

            /*
                dynamic array base

                keccak(slot)
            */ 
           let slot := 4
           mstore(0x80 , slot)
           location := keccak256(
            0x80 ,
            32
           )    
        }
    }

    // =====================================================
    // EXERCISE 7
    // =====================================================

    function ex7()
        public
        pure
        returns(bytes32 h)
    {
        assembly {

            /*
                hash only first byte
            */
           mstore(0x80 , 12)

           h := keccak256(
            0x9f,
            1
           )
           
        }
    }
}



contract MemoryBootcamp6 {

    /*
        event OneNumber(
            uint value
        );
    */

    function ex1() public {

        assembly {

            /*
                no indexed args

                data:
                55
            */
           mstore(0x80 , 55)
           log0(
            0x80,
            32
           )

           
        }
    }

    /*
        event IndexedValue(
            uint indexed x
        );
    */

    function ex2() public {

        assembly {

            /*
                topic:
                77

                no data
            */
           log1(
            0x00,
            0,
            77
           )

           
        }
    }

    /*
        event TwoIndexed(
            uint indexed a,
            uint indexed b
        );
    */

    function ex3() public {

        assembly {
            /*
                topics:
                11
                22

                no data
            */
          log2(
            0x00,
            0,
            11,
            22
          )
          
        }
    }

    /*
        event Mixed(
            uint indexed a,
            uint value
        );
    */

    function ex4() public {

        assembly {

            /*
                value goes
                into memory
            */
           mstore(0x80 , 123)
           log1(
            0x80,
            32,
            31
           )

          
        }
    }

    /*
        Simulate:

        event Transfer(
            address indexed from,
            address indexed to,
            uint amount
        )
    */

    function ex5(
        address from,
        address to,
        uint amount
    )
        public
    {
        bytes32 sig = keccak256(
            "Transfer(address,address,uint256)"
        )
        assembly {

            /*
                data section
            */
           mstore(0x80 , amount)
           log3(
            0x80,
            32,
            sig,
            from,
            to,
           )

           
        }
    }

    /*
        custom data payload
    */

    function ex6()
        public
    {
        assembly {

            mstore(
                0x80,
                111
            )

            mstore(
                0xA0,
                222
            )

            log0(
                0x80,
                64
            )
        }
    }

    /*
        tricky one
    */

    function ex7()
        public
    {
        assembly {

            mstore(
                0x80,
                0xAA
            )

            /*
                partial memory log
            */

            log0(
                0x90,
                16
            )
        }
    }
}