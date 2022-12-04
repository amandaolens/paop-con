// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/access/Ownable.sol";

// PUSH Comm Contract Interface
interface IPUSHCommInterface {
    function sendNotification(address _channel, address _recipient, bytes calldata _identity) external;
}

contract Poap is Ownable {

    constructor(){}

    struct QuestData{
        string questId;
        string questUrl;
        string nftMetadata;
    }

    struct MemberVotes{
        uint256 score;
        address member;
        string[] choices;
    }

    mapping(address => QuestData[]) private _questList;
    mapping(string => string) private _questIdIpfsMap;
    mapping(string => MemberVotes[]) private _questMemberScore;

    event AddQuestEmit(string questUrl,string questId,string nftMetadata );
    function addQuest(string memory questUrl,string memory questId,string memory nftMetadata) external {
        _questList[msg.sender].push(QuestData(questId,questUrl,nftMetadata));
        IPUSHCommInterface(0xb3971BCef2D791bc4027BbfedFb47319A4AAaaAa)
        .sendNotification(0x7D04A724BCd6c0DBAf976BE9e9b89758c300E45A,address(this),bytes(
        string(
            abi.encodePacked(
                "0",
                "+", 
                "3",
                "+", 
                "Title",
                "+", 
                "Body" 
            )
        )));
        _questIdIpfsMap[questId] = questUrl;
        emit AddQuestEmit(questUrl, questId, nftMetadata);
    }

    function getQuests() external view returns(QuestData[] memory) {
        return _questList[msg.sender];
    }

    function getTotalAttempt(string memory questId) external view returns(uint256) {
        return _questMemberScore[questId].length;
    }

    function setQuestTotalAttempt(uint256 score,address member,string[] memory choices,string memory questId) external {
        _questMemberScore[questId].push(MemberVotes(score,member,choices));
    }

    function getQuestResult(string memory questId) external view returns(MemberVotes[] memory) {
        return _questMemberScore[questId];
    }
}
