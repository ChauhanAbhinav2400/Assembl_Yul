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