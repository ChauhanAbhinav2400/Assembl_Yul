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
            sstore(slot, value)
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
            slot := c.slot
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
        assembly {
            aOffset := a.offset
            bOffset := b.offset
            cOffset := c.offset
            dOffset := d.offset
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

            // load whole slot
            let value := sload(c.slot)

            // move c to right side
            let shifted := shr(
                mul(c.offset, 8),
                value
            )

            // keep only uint16
            result := and(
                shifted,
                0xFFFF
            )
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

            // load full slot
            let value := sload(c.slot)

            // create mask to clear old c
            let mask := not(
                shl(
                    mul(c.offset, 8),
                    0xFFFF
                )
            )

            // clear old c
            value := and(value, mask)

            // move new value into correct place
            let shiftedNew := shl(
                mul(c.offset, 8),
                newC
            )

            // merge
            value := or(
                value,
                shiftedNew
            )

            // save back
            sstore(c.slot, value)
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
        assembly {

            length := sload(
                dynamicArray.slot
            )
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
        assembly {

            // get free memory pointer
            let ptr := mload(0x40)

            // store slot in memory
            mstore(ptr, dynamicArray.slot)

            // hash(slot)
            let base := keccak256(ptr, 32)

            // base + index
            let location := add(base, index)

            // load value
            value := sload(location)
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
        assembly {

            let ptr := mload(0x40)

            // store slot in memory
            mstore(ptr, dynamicArray.slot)

            // hash(slot)
            let base := keccak256(ptr, 32)

            // compute location
            let location := add(base, index)

            // write value
            sstore(location, newValue)
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
            length := sload(
                smallArray.slot
            )
        }
    }

    function readSmallArraySlot()
        public
        view
        returns (bytes32 value)
    {
        assembly {

            let ptr := mload(0x40)

            mstore(ptr, smallArray.slot)

            let base := keccak256(ptr, 32)

            value := sload(base)
        }
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
        assembly {

            let ptr := mload(0x40)

            // store key
            mstore(ptr, key)

            // store slot
            mstore(
                add(ptr, 32),
                myMapping.slot
            )

            // hash(key, slot)
            let location := keccak256(
                ptr,
                64
            )

            value := sload(location)
        }
    }

    function writeMapping(
        uint256 key,
        uint256 newValue
    )
        public
    {
        assembly {

            let ptr := mload(0x40)

            mstore(ptr, key)

            mstore(
                add(ptr, 32),
                myMapping.slot
            )

            let location := keccak256(
                ptr,
                64
            )

            sstore(location, newValue)
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

            let ptr := mload(0x40)

            // first hash
            mstore(ptr, k1)

            mstore(
                add(ptr, 32),
                nested.slot
            )

            let firstHash := keccak256(
                ptr,
                64
            )

            // second hash
            mstore(ptr, k2)

            mstore(
                add(ptr, 32),
                firstHash
            )

            let finalLocation := keccak256(
                ptr,
                64
            )

            value := sload(finalLocation)
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

            let ptr := mload(0x40)

            // first hash
            mstore(ptr, k1)

            mstore(
                add(ptr, 32),
                nested.slot
            )

            let firstHash := keccak256(
                ptr,
                64
            )

            // second hash
            mstore(ptr, k2)

            mstore(
                add(ptr, 32),
                firstHash
            )

            let finalLocation := keccak256(
                ptr,
                64
            )

            sstore(finalLocation, newValue)
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

            let ptr := mload(0x40)

            mstore(ptr, user)

            mstore(
                add(ptr, 32),
                addressToList.slot
            )

            let location := keccak256(
                ptr,
                64
            )

            length := sload(location)
        }
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

            let ptr := mload(0x40)

            // hash(user, slot)
            mstore(ptr, user)

            mstore(
                add(ptr, 32),
                addressToList.slot
            )

            let lengthLocation := keccak256(
                ptr,
                64
            )

            // hash(lengthLocation)
            mstore(ptr, lengthLocation)

            let dataStart := keccak256(
                ptr,
                32
            )

            // final location
            let location := add(
                dataStart,
                index
            )

            value := sload(location)
        }
    }

    // function writeAddressListValue(
    //     address user,
    //     uint256 index,
    //     uint256 newValue
    // )
    //     public
    // {
    //     assembly {

    //         let ptr := mload(0x40)

    //         // hash(user, slot)
    //         mstore(ptr, user)

            mstore(
                add(ptr, 32),
                addressToList.slot
            )

            let lengthLocation := keccak256(
                ptr,
                64
            )

            // hash again
            mstore(ptr, lengthLocation)

            let dataStart := keccak256(
                ptr,
                32
            )

            let location := add(
                dataStart,
                index
            )

            sstore(location, newValue)
        }
    }
}



