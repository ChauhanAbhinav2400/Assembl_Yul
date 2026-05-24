# Yul Storage Master Practice (Storage Only)

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
    =========================================================
                YUL STORAGE MASTER PRACTICE
    =========================================================

    PURPOSE:

    Practice EVERYTHING related to STORAGE before moving
    to MEMORY.

    Topics:

    1. Simple storage slots
    2. Packed variables
    3. Packed variable read/write
    4. Fixed arrays
    5. Dynamic arrays
    6. Small packed arrays
    7. Mappings
    8. Nested mappings
    9. Mapping => Dynamic Array

    IMPORTANT:

    We ARE allowed to use mstore here ONLY because
    keccak256 requires memory input.

    But we are NOT studying memory deeply yet.

    So just remember:

    - mstore is temporarily helping us compute hashes
    - focus is still STORAGE SLOT COMPUTATION

*/

contract YulStorageMasterPractice {

    // =====================================================
    // BASIC STORAGE
    // =====================================================

    uint256 public x = 11;
    uint256 public y = 22;
    uint256 public z = 33;

    /*
        x -> slot 0
        y -> slot 1
        z -> slot 2
    */

    function readSlot(
        uint256 slot
    )
        public
        view
        returns (uint256 value)
    {
       assembly {
        value := sload(slot)
       }
    }

    function writeSlot(
        uint256 slot,
        uint256 value
    )
        public
    {
       assembly {
        sstore(slot , value)
       }
    }

    // =====================================================
    // PACKED VARIABLES
    // =====================================================

    uint128 public a = 5;
    uint64 public b = 10;
    uint16 public c = 15;
    uint8 public d = 20;

    /*
        All packed into ONE slot.
    */

    function getPackedSlot()
        public
        pure
        returns (uint256 slot)
    {
       assembly {
        slot := a.slot
       }
    }

    function getOffsets()
        public
        pure
        returns (
            uint256 aOffset,
            uint256 bOffset,
            uint256 cOffset,
            uint256 dOffset
        )
    {
       assembly{
        aoffset := a.offset
        boffset := b.offset
        coffset := c.offset
        doffset := d.offset
       }
    }

    // =====================================================
    // READ C MANUALLY
    // =====================================================

    function readC()
        public
        view
        returns (uint256 result)
    {
       assembly {
        value := sload(c.slot)
        value := shr(mul(c.offset , 8), value)
        result := and(value , 0xFFFF)
       }
    }

    // =====================================================
    // WRITE C MANUALLY
    // =====================================================

    function writeC(
        uint16 newC
    )
        public
    {
       assembly {
        let slotValue := sload(c.slot)
        // clear c bits
        let clearMask := not(shl(mul(c.offset , 8 ) , 0xFFFF))
        slotValue := and(slotValue , clearMask)

        // set new c value
        let newShiftedC := shl(mul(c.offset , 8) , newC)
        slotValue := or(slotValue , newShiftedC)
        sstore(c.slot , slotValue)
       }   
    }

    // =====================================================
    // FIXED ARRAY
    // =====================================================

    uint256[3] public fixedArray =
        [100, 200, 300];

    /*
        fixedArray[0]
            -> slot

        fixedArray[1]
            -> slot + 1

        fixedArray[2]
            -> slot + 2
    */

    function readFixedArray(
        uint256 index
    )
        public
        view
        returns (uint256 value)
    {
        assembly {

            value := sload(
                add(
                    fixedArray.slot,
                    index
                )
            )
        }
    }

    function writeFixedArray(
        uint256 index,
        uint256 newValue
    )
        public
    {
        assembly {

            sstore(
                add(
                    fixedArray.slot,
                    index
                ),
                newValue
            )
        }
    }

    // =====================================================
    // DYNAMIC ARRAY
    // =====================================================

    uint256[] public dynamicArray;

    constructor() {

        dynamicArray.push(1000);
        dynamicArray.push(2000);
        dynamicArray.push(3000);
    }

    /*
        dynamicArray.slot
            stores LENGTH

        actual data starts at:

        keccak256(slot)
    */

    function dynamicArrayLength()
        public
        view
        returns (uint256 length)
    {
        assembly{
            length := sload(dynamicArray.slot)
        }
    }

    // =====================================================
    // READ DYNAMIC ARRAY MANUALLY
    // =====================================================

    function readDynamicArray(
        uint256 index
    )
        public
        view
        returns (uint256 value)
    {
       assembly{
        let dataStart := keccak256(
            dynamicArray.slot,
            32
        )
        sload(
            add(dataStart , index)
        )
       }
    }

    // =====================================================
    // WRITE DYNAMIC ARRAY MANUALLY
    // =====================================================

    function writeDynamicArray(
        uint256 index,
        uint256 newValue
    )
        public
    {
        assembly{
            let dataStart := keccak256(
                dynamicArray.slot,
                32
            )
            sstore(
                add(dataStart , index),
                newValue
            )
        }
    }

    // =====================================================
    // SMALL PACKED ARRAY
    // =====================================================

    uint8[] public smallArray;

    function fillSmallArray() public {

        smallArray.push(1);
        smallArray.push(2);
        smallArray.push(3);
        smallArray.push(4);
    }

    function smallArrayLength()
        public
        view
        returns (uint256 length)
    {
       assembly {
        sload(
            smallArray.slot
        )
       }
    }

    function readSmallArraySlot()
        public
        view
        returns (bytes32 value)
    {
        
    }

    // =====================================================
    // MAPPING
    // =====================================================

    mapping(uint256 => uint256)
        public myMapping;

    function setMapping(
        uint256 key,
        uint256 value
    )
        public
    {
        myMapping[key] = value;
    }

    /*
        location =
        keccak256(key, slot)
    */

    function readMapping(
        uint256 key
    )
        public
        view
        returns (uint256 value)
    {
       assembly{
        let hash  : = keccak256(
            myMapping.slot,
            key
        )
        value := sload(hash)

       }
    }

    function writeMapping(
        uint256 key,
        uint256 newValue
    )
        public    
    {
       assembly {
         let hash  : = keccak256(
            myMapping.slot,
            key
        )
        sstore(hash, newValue)
       }
    }

    // =====================================================
    // NESTED MAPPING
    // =====================================================

    mapping(uint256 =>
        mapping(uint256 => uint256)
    )
        public nested;

    function setNested(
        uint256 k1,
        uint256 k2,
        uint256 value
    )
        public
    {
        nested[k1][k2] = value;
    }

    function readNested(
        uint256 k1,
        uint256 k2
    )
        public
        view
        returns (uint256 value)
    {
       assembly {
        let hash1 := keccak256(
            nested.slot,
            k1
        )
        let hash2 := keccak256(
            hash1,
            k2
        )
        value := sload(hash2)
       }
    }

    function writeNested(
        uint256 k1,
        uint256 k2,
        uint256 newValue
    )
        public
    {
       assembly {
        let hash1 := keccak256(
            nested.slot,
            k1
        )
        let hash2 := keccak256(
            hash1,
            k2
        )
        sstore(hash2, newValue)
       }
    }

    // =====================================================
    // MAPPING => DYNAMIC ARRAY
    // =====================================================

    mapping(address => uint256[])
        public addressToList;

    function addToList(
        uint256 value
    )
        public
    {
        addressToList[msg.sender]
            .push(value);
    }

    /*
        lengthLocation =
        keccak256(user, slot)

        dataStart =
        keccak256(lengthLocation)
    */

    function readAddressListLength(
        address user
    )
        public
        view
        returns (uint256 length)
    {
       assembly {
        length := sload(
            keccak256(
                user, addressToList.slot
            )
        )}
    }

    function readAddressListValue(
        address user,
        uint256 index
    )
        public
        view
        returns (uint256 value)
    {
       assembly {
        let lengthLocation := keccak256(
            user , addressToList.slot
        )
        let dataStart := keccak256(
            lengthLocation,
             32
         )
        
        value := sload(
            add(dataStart , index)
        )
       }
    }

    function writeAddressListValue(
        address user,
        uint256 index,
        uint256 newValue
    )
        public
    {
       assembly {
       let lengthLocation := keccak256(
        user , addressToList.slot
       )
       let dataStart := keccak256(
        lengthLocation,
         32
       )
        
        sstore(
            add(dataStart , index),
            newValue
        )


       }
    }
}



