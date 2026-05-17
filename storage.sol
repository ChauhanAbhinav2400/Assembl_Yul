// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
    =========================================================
                    YUL STORAGE PRACTICE
    =========================================================

    Practice Topics Covered:

    1. Simple storage slots
    2. Packed variables
    3. Reading packed values
    4. Writing packed values
    5. Fixed arrays
    6. Dynamic arrays
    7. Small packed arrays
    8. Mappings
    9. Nested mappings
    10. Mapping => Dynamic Array

    Goal:
    Understand how Solidity computes and manipulates storage
    underneath using:
        - sload
        - sstore
        - shifting
        - masking
        - keccak256

    IMPORTANT:
    Try reading storage manually first BEFORE using getters.
*/

contract YulStoragePractice {

    // =====================================================
    // BASIC STORAGE
    // =====================================================

    uint256 public x = 111;
    uint256 public y = 222;
    uint256 public z = 333;

    /*
        Expected slots:
        x -> slot 0
        y -> slot 1
        z -> slot 2
    */

    function readSlot(uint256 slot)
        public
        view
        returns (uint256 value)
    {
        assembly {
            value := sload(slot)
        }
    }

    function writeSlot(uint256 slot, uint256 value) public {
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
    uint8 public d = 12;

    /*
        These all fit in ONE slot.

        Practice:
        - find slot
        - find offsets
        - manually read c
        - manually write c
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

    function getPackedOffsets()
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
            result := and(shifted, 0xFFFF)
        }
    }

    // =====================================================
    // WRITE C MANUALLY
    // =====================================================

    function writeC(uint16 newC) public {

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

            // move new value into position
            let shiftedNew := shl(
                mul(c.offset, 8),
                newC
            )

            // merge
            value := or(value, shiftedNew)

            // save back
            sstore(c.slot, value)
        }
    }

    // =====================================================
    // FIXED ARRAY
    // =====================================================

    uint256[3] public fixedArray = [100, 200, 300];

    /*
        fixedArray[0] -> slot
        fixedArray[1] -> slot + 1
        fixedArray[2] -> slot + 2
    */

    function readFixedArray(uint256 index)
        public
        view
        returns (uint256 value)
    {
        assembly {

            value := sload(
                add(fixedArray.slot, index)
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
        slot stores LENGTH

        actual data:
        keccak256(slot)
    */

    function dynamicArrayLength()
        public
        view
        returns (uint256 length)
    {
        assembly {
            length := sload(dynamicArray.slot)
        }
    }

    function readDynamicArray(uint256 index)
        public
        view
        returns (uint256 value)
    {
        assembly {

            // free memory pointer
            let ptr := mload(0x40)

            // store slot in memory
            mstore(ptr, dynamicArray.slot)

            // hash slot
            let start := keccak256(ptr, 32)

            // read element
            value := sload(
                add(start, index)
            )
        }
    }

    // =====================================================
    // SMALL PACKED ARRAY
    // =====================================================

    uint8[] public smallArray;

    /*
        multiple uint8 packed in one slot
    */

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
            length := sload(smallArray.slot)
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

            let location := keccak256(ptr, 32)

            value := sload(location)
        }
    }

    // =====================================================
    // MAPPING
    // =====================================================

    mapping(uint256 => uint256) public myMapping;

    /*
        storage:
        keccak256(key, slot)
    */

    function setMapping(
        uint256 key,
        uint256 value
    ) public {

        myMapping[key] = value;
    }

    function readMapping(uint256 key)
        public
        view
        returns (uint256 value)
    {
        assembly {

            let ptr := mload(0x40)

            // store key
            mstore(ptr, key)

            // store slot after key
            mstore(add(ptr, 32), myMapping.slot)

            // hash(key, slot)
            let location := keccak256(ptr, 64)

            value := sload(location)
        }
    }

    // =====================================================
    // NESTED MAPPING
    // =====================================================

    mapping(uint256 => mapping(uint256 => uint256))
        public nested;

    function setNested(
        uint256 k1,
        uint256 k2,
        uint256 value
    ) public {

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
            mstore(add(ptr, 32), nested.slot)

            let firstHash := keccak256(ptr, 64)

            // second hash
            mstore(ptr, k2)
            mstore(add(ptr, 32), firstHash)

            let finalLocation := keccak256(ptr, 64)

            value := sload(finalLocation)
        }
    }

    // =====================================================
    // MAPPING => DYNAMIC ARRAY
    // =====================================================

    mapping(address => uint256[]) public addressToList;

    function addToList(uint256 value) public {

        addressToList[msg.sender].push(value);
    }

    /*
        Step 1:
        keccak256(user, slot)
            => stores length

        Step 2:
        keccak256(lengthSlot)
            => start of array data
    */

    function readAddressListLength(address user)
        public
        view
        returns (uint256 length)
    {
        assembly {

            let ptr := mload(0x40)

            mstore(ptr, user)
            mstore(add(ptr, 32), addressToList.slot)

            let location := keccak256(ptr, 64)

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
            mstore(add(ptr, 32), addressToList.slot)

            let location := keccak256(ptr, 64)

            // hash again for array data
            mstore(ptr, location)

            let start := keccak256(ptr, 32)

            value := sload(
                add(start, index)
            )
        }
    }
}