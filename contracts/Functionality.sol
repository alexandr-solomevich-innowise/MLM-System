// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Functionality {
    address systemAccount = 0x43169f86f1A575a8Fa7ceA12E1883E22A848f0F8;

    mapping(address => User) public users;
    mapping(address => mapping(address => bool)) directPartners;
    //mapping(address => uint) userLevel;
    mapping(uint => uint) public levelTable;

    constructor() {
        levelTable[1] = 5 * 10 ** 6;
        levelTable[2] = 10 * 10 ** 6;
        levelTable[3] = 20 * 10 ** 6;
        levelTable[4] = 50 * 10 ** 6;
        levelTable[5] = 100 * 10 ** 6;
        levelTable[6] = 200 * 10 ** 6;
        levelTable[7] = 500 * 10 ** 6;
        levelTable[8] = 1000 * 10 ** 6;
        levelTable[9] = 2000 * 10 ** 6;
        levelTable[10] = 5000 * 10 ** 6;
    }

    struct User {
        //address[] directPartners;
        uint8 level;
        bool active;
        uint partnersCount;
        uint investmentAmount;
        address referral; //owner==address(0);
        //mapping(address => bool) dP;
    }

    modifier onlyNewUser(address _id) {
        require(!users[msg.sender].active, "You've already entered the system.");
        _;
    }

    function enterSystem() onlyNewUser(msg.sender) public {
        users[msg.sender].active = true;
    }

    function enterSystem(address _partnerId) onlyNewUser(msg.sender) public {
        require(users[_partnerId].active, "The user with such referral reference does not exist.");
        users[msg.sender].active = true;
        users[msg.sender].referral = _partnerId;
        //users[_partnerId].directPartners.push(msg.sender);
        directPartners[_partnerId][msg.sender] = true;
        users[_partnerId].partnersCount++;
    }

    function viewLevel() public view returns(uint8) {
        return users[msg.sender].level;
    }

    function viewDirectPartnersNumber() public view returns(uint) {
        return users[msg.sender].partnersCount;
    }

    function viewDirectPartnerLevel(address _partner) public view returns (uint8) {
        require(directPartners[msg.sender][_partner], "There is no such partner in your list.");
        return users[_partner].level;
    }

    function invest() public payable {
        (bool success,) = systemAccount.call{value: msg.value}("");
        require(success, "Failed to send money");
        updateLevel(msg.value, msg.sender);
        //зачислить на контракт 5%
    }

    function updateLevel(uint _value, address _user) private {
        uint currentLevel = users[_user].level;
        uint investment = users[_user].investmentAmount;

        investment += _value;

        uint nextLevel = currentLevel + 1;
        if (levelTable[nextLevel] <= investment)
            users[_user].level++;
    }

    function withdraw() public {

    }

}
