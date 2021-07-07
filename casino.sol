pragma solidity ^0.8.0;
contract Casino {
    address payable public owner;
 uint minPriceBEt;
 uint noOfBets;
 uint maxBets;
 uint totalBets;
 uint noOFWinners;
 uint public winningNumber;
  address [] winners;
 

    constructor (uint _minPriceBEt, uint _maxBets) {
        owner=payable(msg.sender);
        minPriceBEt=_minPriceBEt;
        maxBets=_maxBets;
    }
    
    address []  players;
     struct User_Bet {
     uint amtBet;
     uint numBet;
     bool IsBetted;
 }
  mapping(address=>User_Bet) public UserBet;
  event amtTransferred(address _receiver, uint  _value);
  
    function kill() public {
        if (msg.sender==owner)
        selfdestruct(owner);
}
function Bet(  uint _numBet) payable public {
    require(msg.sender!=owner, "owner cannot bet" );
    require(noOfBets<maxBets , "Max number of bets reached");
    require ( !UserBet[msg.sender].IsBetted, "/ already betted");
    require(msg.value >=minPriceBEt, "Bet amount less than minimum");
    require(_numBet >=1 && _numBet <10, "Number selected is not between 1 to 10");
    players.push(msg.sender);
        User_Bet memory new_Bet =User_Bet( msg.value, _numBet, true);
        UserBet[msg.sender] = new_Bet;
      totalBets+=msg.value;  
    
    noOfBets++;
    if (noOfBets>=maxBets) generateWinner();
    
}
function generateWinner() public 
{
    winningNumber=((block.timestamp) %10);
    
   
}
  function  distributePrizes() payable public {
     
      noOFWinners=0;
        for(uint i=0; i<players.length; i++) {
            address playeraddress=players[i];
            if(UserBet[playeraddress].numBet ==winningNumber){
                        winners.push(playeraddress);
                        noOFWinners++;
        } 
        delete players[i];
        }
         uint amtWon=totalBets/noOFWinners;
        for(uint j=0; j<=winners.length-1; j++) {
         if( winners[j]!=address(0)){                     
           payable(winners[j]).transfer(amtWon);
           emit amtTransferred(winners[j], amtWon);

        } 
    }
   
  }
}
