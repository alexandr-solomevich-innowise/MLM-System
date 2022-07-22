// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Functionality {
    address payable systemAccount;// = 0x43169f86f1A575a8Fa7ceA12E1883E22A848f0F8;

    mapping(address => User) public users;
    mapping(address => mapping(address => bool)) directPartners;
    //mapping(address => uint) userLevel;

    struct User {
        //address[] directPartners;
        uint8 level;
        bool active;
        uint partnersCount;
        //mapping(address => bool) dP;
    }

    modifier onlyNewUser(address _id) {
        require(!users[msg.sender].active, "You've already entered the system.");
        _;
    }

    function enterSystem() onlyNewUser(msg.sender) external {
        users[msg.sender].active = true;
    }

    function enterSystem(address _partnerId) onlyNewUser(msg.sender) external {
        require(users[_partnerId].active, "The user with such referral reference does not exist.");
        users[msg.sender].active = true;
        //users[_partnerId].directPartners.push(msg.sender);
        directPartners[_partnerId][msg.sender] = true;
        users[_partnerId].partnersCount++;
    }

    function viewLevel() external view returns(uint8) {
        return users[msg.sender].level;
    }

    function viewDirectPartnersNumber() external view returns(uint) {
        return users[msg.sender].partnersCount;
    }

    function viewDirectPartnerLevel(address _partner) external view returns (uint8) {
        require(directPartners[msg.sender][_partner], "There is no such partner in your list.");
        return users[_partner].level;
    }

    function invest() public payable {
        (bool success,) = systemAccount.call{value: msg.value}("");
        require(success, "Failed to send money");
    }
}
