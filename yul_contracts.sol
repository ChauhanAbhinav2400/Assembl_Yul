PURE YUL CONTRACTS + ERC20 ARCHITECTURE + CONTRACT CREATION REVISION NOTES
1. Big Mental Model
Ethereum Contract:
Constructor Code


Runtime Code
Constructor:
runs once
Runtime:
lives forever
Deployment Flow:
constructor
↓
returns runtime bytecode
↓
Ethereum stores runtime bytecode
↓
future calls execute runtime

2. Pure Yul Contract Structure
Pattern:
object "Contract" {
code {
 constructor logic

}
object "runtime" {
 code {

     runtime logic

  }

}
}
Think:
outer object
↓
deployment
runtime object
↓
actual contract

3. Constructor Job
Constructor responsibility:
initialize storage
prepare runtime code
return runtime bytecode
Pattern:
datacopy(
ptr,
dataoffset("runtime"),
datasize("runtime")
)
return(
ptr,
datasize("runtime")
)
Important:
constructor return
!=
normal return
It returns:
runtime bytecode

4. Runtime Code
Runtime executes after deployment.
Example:
mstore(
0,
2
)
return(
0,
32
)
This contract:
always returns:
2
No selector logic.
No ABI.
Nothing automatic.

5. Yul Has NO Built-In Solidity Features
Yul does NOT automatically provide:
selectors
dispatchers
ABI decoding
storage variables
mappings
arrays
events
return encoding
You build everything.

6. Function Dispatcher
Solidity secretly generates dispatcher.
Yul version:
selector := shr(
224,
calldataload(0)
)
switch selector
case SELECTOR {
...
}
default {
revert(0,0)
}
Dispatcher Flow:
selector
↓
switch
↓
correct function

7. Nonpayable Check
Equivalent:
require(
msg.value == 0
)
Pattern:
if callvalue() {
revert(
 0,

  0

)
}
callvalue()
=
msg.value

8. Helper Functions Pattern
Yul contracts become manageable by using helpers.
Examples:
ownerPosition()
totalSupplyPosition()
returnUint()
require()
Mental Model:
helpers simulate Solidity features

9. Simulating Storage Variables
No storage variables exist.
Pattern:
function ownerPosition()
-> p {
p := 0
}
Then:
sload(
ownerPosition()
)
This simulates:
owner

10. Single Return Pattern
Instead of:
many returns
Create:
function returnUint(x){
mstore(
 0,

  x

)
return(
 0,

  32

)
}
Benefits:
simpler code
reusable
centralized returns

11. Bytecode Data Storage
Can store constants directly in bytecode.
Pattern:
data "message"
hex"..."
Read:
datacopy(
ptr,
dataoffset("message"),
datasize("message")
)
return(
ptr,
datasize("message")
)
Good for:
large constants
metadata
strings
SVGs
Immutable.

12. dataoffset()
Purpose:
find location inside bytecode
Returns:
start position
Think:
pointer to bytecode region

13. datasize()
Purpose:
size of data region
Useful for:
runtime copy
constant blobs
deployment

14. datacopy()
Copies:
bytecode region
↓
memory
Pattern:
datacopy(
dest,
source,
size
)
Think:
calldatacopy()
but for bytecode

15. Why Not Full Yul Usually?
Problems:
verification hard
fewer tools
easier bugs
harder auditing
Better approach:
Solidity shell


assembly critical paths

16. ERC20 Architecture
High Level:
dispatcher
↓
decode calldata
↓
business logic
↓
storage updates
↓
events

17. ERC20 Storage Layout Example
slot 0:
owner
slot 1:
total supply
balances:
address + offset
allowances:
hashed slots
Important:
storage design
=
manual

18. totalSupply()
Flow:
slot position
↓
sload()
↓
returnUint()
Equivalent:
return totalSupply;

19. balanceOf()
Flow:
address
↓
compute slot
↓
sload()
↓
return balance
Mapping Simulation:
slot := add(
address,
0x1000
)
Simple teaching approach.
Real Solidity:
keccak256()

20. Mint Flow
owner check
↓
increase supply
↓
increase balance
↓
emit Transfer
Pseudo Flow:
mint()
↓
mintTokens()
↓
addBalance()
↓
emit()

21. Safe Add Overflow Pattern
result := add(
a,
b
)
Overflow:
if lt(
result,
a
){
revert()
}
Rule:
sum should not become smaller

22. Transfer Flow
transfer()
↓
inject caller()
↓
executeTransfer()
executeTransfer():
deduct sender
↓
add receiver
↓
emit event

23. Deduct Balance Pattern
balance := sload(slot)
Check:
amount <= balance
Store:
sstore(
slot,
sub(
 balance,

  amount

)
)
Prevents:
underflow

24. Approvals / Allowances
approve():
compute allowance slot
↓
store allowance
transferFrom():
load allowance
↓
validate
↓
reduce allowance
↓
execute transfer

25. Double Mapping Simulation
Memory:
ownerSlot
spender
Hash:
keccak256(
ptr,
64
)
Used as storage location.

26. Event Emission
Transfer:
topic0:
signature hash
topic1:
from
topic2:
to
data:
amount
Use:
log3()

27. Important Opcodes To Remember
callvalue()
caller()
sload()
sstore()
log0-log4()
datacopy()
datasize()
dataoffset()
revert()
return()
stop()

28. Auditor Checklist
Always ask:
selector validated?
storage collisions?
overflow / underflow?
zero address?
allowance logic safe?
delegatecall risk?
event emitted correctly?
constructor returning runtime?

29. Final Mental Models
Constructor:
factory
Runtime:
actual machine
Dispatcher:
router
Storage positions:
manual variables
Bytecode data:
read-only storage
ERC20:
storage updates + events


