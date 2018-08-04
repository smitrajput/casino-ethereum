pragma solidity ^0.4.20;


contract Casino {
    address public owner;
    uint public minimumBet;
    uint public numberOfBets;
    uint public totalBet;
    uint public maxAmountOfBets = 100;
    address[] public players;

    struct Player {
        uint amountBet;
        uint numberSelected;
    }

    mapping(address => Player) public playerInfo;

    function() public payable {}

    constructor(uint _minimumBet) public {
        owner = msg.sender;
        if (_minimumBet != 0) minimumBet = _minimumBet;
    }

    function kill() public {
        if (msg.sender == owner) selfdestruct(owner);
    }

    function checkPlayerExists(address player) public constant returns(bool) {
        for (uint i = 0; i <= players.length; i++) {
            if (players[i] == player) return true;
        }
        return false;
    }

    function bet(uint numberSelected) public payable {
        require(!checkPlayerExists(msg.sender));
        require(numberSelected >= 1 && numberSelected <= 10);
        require(msg.value >= minimumBet);

        playerInfo[msg.sender].amountBet = msg.value;
        playerInfo[msg.sender].numberSelected = numberSelected;
        numberOfBets++;
        players.push(msg.sender);
        totalBet += msg.value;

        if (numberOfBets >= maxAmountOfBets) generateNumberWinner();
    }

    function generateNumberWinner() public {
        uint numberGenerated = block.number % 10 + 1;
        distributePrizes(numberGenerated);
    }

    function resetData() public {
       players.length = 0; // Delete all the players array
       totalBet = 0;
       numberOfBets = 0;
    }

    function distributePrizes(uint numberWinner) public {
        address[100] memory winners;
        uint count = 0;
        for (uint i = 0; i <= players.length; i++){
            if (playerInfo[players[i]].numberSelected == numberWinner) {
                winners[count] = players[i];
                count++;
            }
            delete playerInfo[players[i]];
        }
        players.length = 0;
        uint winnerEtherAmount = totalBet/winners.length;
        for (uint j=0; j < count; j++){
            if (winners[j] != address(0))
                winners[j].transfer(winnerEtherAmount);
        }
    }
}
