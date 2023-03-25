// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol'; 

import './ChainId.sol';


  //to do in   
//in assembly
//deposit 
//withdarw

  // contract deployed at address = 0xae7a1728513aC60A297B074461233C6d7A70252a 
  // deployed with first contract of testing blue 
 
contract MetaTransaction is ERC721{

// function transfer() public  {

// payable(0x6030B4F6164aF2257226BC70a97f9B9C664AaEf7).transfer(100000000000000000);


// }

uint public chainId= 5 ;
mapping(address => bool) public isAuthorized;
event transactionExecuted(address indexed usedToPlay, address indexed _to , bool indexed isDone) ;


// function setChainId(uint _chainId) public {
// chainId = chainId ;
// }


address public usedToPlay = 0x0417aFb6dC09c5Efed6a294ceAc2515f6BA481A9 ;

function hardcodingAddress() public {
 // authorize is set to be the function that transfers the funds 
  isAuthorized[0x0417aFb6dC09c5Efed6a294ceAc2515f6BA481A9] = true ;

}


function addAuthorization(address _permitAddress) public {
    isAuthorized[_permitAddress]= true;
}

// set hardcode for testing - 0x6030B4F6164aF2257226BC70a97f9B9C664AaEf7 // blue test second 
// constructor(){

//   addAuthorization(0x6030B4F6164aF2257226BC70a97f9B9C664AaEf7);

// }

// function getWhetherTrueOrFalse(address _permitAddress) public view returns(bool){
//   require( isAuthorized[_permitAddress], "not authorized");
//   return true;
// }
//in assembly

    bytes32 private immutable nameHash;

    bytes32 private immutable versionHash;

 constructor(
        string memory name_,
        string memory symbol_,
        string memory version_
    ) ERC721(name_, symbol_) {
        nameHash = keccak256(bytes(name_));
        versionHash = keccak256(bytes(version_));
    }


function DOMAIN_SEPARATOR() public view  returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    // keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)')
                    0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f,
                    nameHash,
                    versionHash,
                    ChainId.get(),
                    address(this)
                )
            );
    }
 


 //usedToPlay is the payer
function execute(address usedToPlay, address _to , bytes calldata  _data , uint8 sigv, bytes32 sigr , bytes32 sigs) public {
  // Check that the caller is authorized to execute transactions on behalf of the user
  require(isAuthorized[usedToPlay],"Unauthorized relayer");
  // to verify the signature
  bytes32 hash = keccak256(abi.encodePacked(chainId, _data));
  address signer = ecrecover(hash, sigv, sigr, sigs);
  require(signer == usedToPlay, "Invalid signature");

  // to execute the user's transaction
// (bool didSucceed, ) = usedToPlay.delegatecall(_data); 

  (bool success, ) = usedToPlay.delegatecall("transfer()");





require(success , "Call Failed");
emit transactionExecuted(usedToPlay, _to, true ); 

}


fallback() external payable{} 
receive() external payable{} 





}

//Your contract is deployed at the address :  0x25e50f144Df72d7Da97EA7Aa626c2ABbce1a4941
