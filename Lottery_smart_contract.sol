// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract lottery{
    //creating entites
    //manager will be one who will run the lottery service
    address public manager;
    address payable [] public participants;

    // making manager a controllable
    constructor(){
        manager = msg.sender;  //global
    }

    // can be used only once in a contract && it doesnt take any arguments and it should be payaable
    //here we are mentioning that we are transfering min of 1 ether else transaction will abort
    // require state is just like if else but with shorthand 
    receive() external payable{
        require(msg.value==1 ether);
        participants.push(payable(msg.sender));
    }
    //  here we are giving balance control to manager only manager can see the balance
    
    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() public view returns (uint){
        //generating random  number
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp, participants.length )));
    }

    function selectWinner() public {
        require(msg.sender==manager);
        require(participants.length>=3);
        uint r = random();
        address payable winner;
        uint index = r %participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
        //reseting
        participants = new address payable[](0);

    }



}