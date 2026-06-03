// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CalldataBootcamp1 {

    function ex1()
        external
        pure
        returns(uint256 size)
    {
       // load size of calldata
       assembly {
        size := calldatasize()
       }
    }

    function ex2()
    external
    pure
    returns(bytes32 value)
{
   // load selector 
   assembly {
    value := calldataload(0)
   }
}
 
 function ex3(
    uint256 x
)
    external
    pure
    returns(bytes32 value)
{
    // load x 
    assembly {
        value := calldataload(4)
    }
}


function ex4(
    uint256 x,
    uint256 y
)
    external
    pure
    returns(
        bytes32 a,
        bytes32 b
    )
{
    assembly {
        a := calldataload(4)
        b := calldataload(36)

    }
}


function ex5()
    external
    pure
    returns(bytes32 value)
{
   assembly {
    value := calldataload(999)
   }
}

}



//=============================================================================================



contract CalldataBootcamp2 {  


function ex1()
    external
    pure
    returns(bytes32 value)
{
    assembly {
   calldatacopy(
    0x80 ,
    0,
    calldatasize()
   )
   value := mload(0x80)
    }
   
}


function ex2()
    external
    pure
    returns(bytes32 value)
{
    assembly {

        calldatacopy(
            0x80,
            0,
            4
        )

        value := mload(0x80)

    }
}


function ex3(
    uint256 x
)
    external
    pure
    returns(bytes32 value)
{
    assembly {

        calldatacopy(
            0x80,
            4,
            32
        )

        value := mload(0x80)

    }
}



function ex4(
    uint256 a,
    uint256 b
)
    external
    pure
    returns(
        bytes32 first,
        bytes32 second
    )
{
    assembly {

        calldatacopy(
            0x80,
            4,
            64
        )

        first := mload(0x80)

        second := mload(
            add(
                0x80,
                32
            )
        )
    }
}



function ex5(
    uint256 x
)
    external
    pure
    returns(bytes32 value)
{
    assembly {

        calldatacopy(
            0x80,
            20,
            8
        )

        value := mload(0x80)

    }
}



function ex6()
    external
    pure
    returns(bytes32 value)
{
    assembly {

        calldatacopy(
            0x80,
            999,
            32
        )

        value := mload(0x80)

    }
}

function getselectorofex1 () pure public returns(bytes4 selector) {
    return bytes4(keccak256("ex1()"));
}


} 