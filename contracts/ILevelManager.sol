// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface ILevelManager {
    function getSumByLevel(uint8 _level) external returns(uint256);
    function getPercentageByDepth(uint8 _depth) external returns(uint8);
}
