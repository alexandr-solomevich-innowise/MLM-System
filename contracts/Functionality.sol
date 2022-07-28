// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./ILevelManager.sol";

contract Functionality {
    address levelContract;
    ILevelManager levelManager = ILevelManager(levelContract);

    mapping(address => User) public users;
    mapping(address => mapping(address => bool)) directPartners;
    //mapping(address => uint) userLevel;

    struct User {
        //address[] directPartners;
        uint8 level;
        bool active;
        uint256 partnersCount;
        uint256 investmentAmount;
        address referral; //owner==address(0);
        //mapping(address => bool) dP;
    }

    modifier onlyNewUser(address _id) {
        require(!users[msg.sender].active, "You've already entered the system.");
        _;
    }

    function enterSystem() onlyNewUser(msg.sender) public {
        users[msg.sender].active = true;
        users[msg.sender].referral = address(0);
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

    function viewDirectPartnersNumber() public view returns(uint256) {
        return users[msg.sender].partnersCount;
    }

    function viewDirectPartnerLevel(address _partner) public view returns (uint8) {
        require(directPartners[msg.sender][_partner], "There is no such partner in your list.");
        return users[_partner].level;
    }

    function invest() public payable {
        users[msg.sender].investmentAmount += msg.value * 95 / 100;
        updateLevel(msg.value, msg.sender);
    }

    function updateLevel(uint256 _value, address _user) private {
        uint8 currentLevel = users[_user].level;
        uint256 investment = users[_user].investmentAmount;

        investment += _value;

        uint8 nextLevel = currentLevel + 1;
        if (levelManager.getSumByLevel(nextLevel) <= investment)
            users[_user].level++;
    }

    function withdraw(uint256 _sum) public {
        require(users[msg.sender].investmentAmount >= _sum, "There is not enough money on your account");
        users[msg.sender].investmentAmount -= _sum;
        payable(msg.sender).transfer(_sum);
        commissionForPartners(msg.sender, _sum);
    }

    function commissionForPartners(address _user, uint256 _sum) private {
        uint8 depth = 1;
        address partner = users[_user].referral;
        while (partner != address(0)) {
            if (users[partner].level >= depth) {
                users[partner].investmentAmount += _sum * levelManager.getPercentageByDepth(depth) / 10;
            }
            partner = users[partner].referral;
            depth++;
        }
    }
}