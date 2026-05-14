// SPDX-Licnese-Identifier: MIT
pragma solidity ^0.8.0;

contract Types{


function type() public  pure returns (uint256 ) {

uint256 x;

assembly {
x := 5
}
return x;

}



}