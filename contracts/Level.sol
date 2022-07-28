// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./ILevelManager.sol";

contract Level is ILevelManager{
    mapping(uint8 => uint256) public levelTable;
    mapping(uint8 => uint8) public percentageTable;

    constructor() {
        levelTable[1] = 5 * 10 ** 15;
        levelTable[2] = 10 * 10 ** 15;
        levelTable[3] = 20 * 10 ** 15;
        levelTable[4] = 50 * 10 ** 15;
        levelTable[5] = 100 * 10 ** 15;
        levelTable[6] = 200 * 10 ** 15;
        levelTable[7] = 500 * 10 ** 15;
        levelTable[8] = 1000 * 10 ** 15;
        levelTable[9] = 2000 * 10 ** 15;
        levelTable[10] = 5000 * 10 ** 15;

        percentageTable[1] = 10;
        percentageTable[2] = 7;
        percentageTable[3] = 5;
        percentageTable[4] = 2;
        percentageTable[5] = 1;
        percentageTable[6] = 1;
        percentageTable[7] = 1;
        percentageTable[8] = 1;
        percentageTable[9] = 1;
        percentageTable[10] = 1;
    }

    function getSumByLevel(uint8 _level) external view returns(uint256) {
        return levelTable[_level];
    }

    function getPercentageByDepth(uint8 _depth) external view returns(uint8) {
        return percentageTable[_depth];
    }
}