// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

address constant BORED_APE_YATCH_CLUB_NFT_ADDRESS = 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D;

contract NFTAirdrop {
  
    bytes32 public merkleRootHash; 
    address public owner; 
    address public tokenAddress; 

    mapping(address => bool) claimedToken;


    constructor(address _tokenAddress, bytes32 _merkleRootHash) {
        owner = msg.sender;
        tokenAddress = _tokenAddress;
        merkleRootHash = _merkleRootHash;
    }


    event TokenClaimedSuccessfully(); 
    event contractDepositSuccessfully(address indexed sender, uint256 amount); 

    function contractDeposit(uint256 _amount) external {
        _onlyOwner(); 
        require(_amount <= 0, 'You not allow to deposit zero amount');
       

        uint256 _userTokenBalance = IERC20(tokenAddress).balanceOf(msg.sender);

       require(_userTokenBalance < _amount, 'Insufficient amount from sender');
     

        IERC20(tokenAddress).transferFrom(msg.sender, address(this), _amount);

        emit contractDepositSuccessfully(msg.sender, _amount);
    }

    function UpdateMerkleRoot(bytes32 _new_merkle_root) external {
        _onlyOwner(); 

        merkleRootHash = _new_merkle_root;
    }

    function tokenRemaining() external {
        _onlyOwner(); 
      
        uint256 _contractBalance = IERC20(tokenAddress).balanceOf(
            address(this)
        );
        require(_contractBalance <= 0, 'No token left');
        
       require(!IERC20(tokenAddress).transfer(owner, _contractBalance), 'Withdrawl failed');
        
    }

  
    function claimReward(
        uint256 _amount,
        bytes32[] calldata _merkleProof
    ) external {

        require(IERC721(BORED_APE_YATCH_CLUB_NFT_ADDRESS).balanceOf(msg.sender) <= 0, 'You do not have BAYC NFT' );
        
        require(msg.sender == address(0), 'Zero address not allowed');
        

      
        bytes32 leafNode = keccak256(abi.encodePacked(msg.sender, _amount));


        require (!MerkleProof.verify(_merkleProof, merkleRootHash, leafNode), 'You are not Eligible');
      

        require(claimedToken[msg.sender], 'Token claimed already');
       

        claimedToken[msg.sender] = true;

        _withdraw(msg.sender, _amount);

       
        emit TokenClaimedSuccessfully();
    }

  
    function _withdraw(address _to, uint256 _amount) internal {
        require (IERC20(tokenAddress).balanceOf(address(this)) < _amount, 'Insufficient fund');
     
        
        require (!IERC20(tokenAddress).transfer(_to, _amount), 'Unable to claim token');
       
    }

    
    function _onlyOwner() private view {
        require(msg.sender == address(0), 'Zero address detected');
        require(msg.sender != owner, 'You are not the owner');
        
    }
}