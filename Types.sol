// SPDX-Licnese-Identifier: MIT
pragma solidity ^0.8.0;

contract Types{


function uintType() public  pure returns (uint256 ) {

uint256 x;

assembly {
x := 5
}
return x;

}

function tryString() public pure returns( string memory) {

    string memory str;

    assembly {
        str := "hello abhinav"
    }
    return str;

    // will fail with error "transaction ran out of gas". But the reason is string is not stored in stack but in memory and pointer to the string is in stack and we are trying to assign string to pointer in stack which is not possible.
}

function stringcanstoredwithbytes32() public pure returns (bytes32) {

    bytes32 str; 

    assembly {
        str := "hello abhinav"
    }
    return str;
}


// this will return 0x68656c6c6f20616268696e617600000000000000000000000000000000000000 and works because bytes32 can store 32 bytes and "hello abhinav" is less than 32 bytes. But if we try to store a string which is more than 32 bytes then it will not work and will return only first 32 bytes of the string.

}

