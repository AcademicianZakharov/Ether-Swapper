pragma solidity ^0.5.0;

import "./Token.sol";

contract EthSwap {
   string public name = "EthSwap Instant Exchange";
   Token public token;
   uint public rate = 100;

   event TokenPurchased(
      address account,
      address token,
      uint amount,
      uint rate
   );

   event TokensSold(
      address account,
      address token,
      uint amount,
      uint rate
   );

   constructor(Token _token) public {
      token = _token;
   }
   function buyTokens() public payable {
       // calculate # of tokens to buy
      uint tokenAmount = msg.value * rate;

      require(token.balanceOf(address(this)) >= tokenAmount);

      //transfer tokens to user
      token.transfer(msg.sender, tokenAmount);

      //emit an event
      emit TokenPurchased(msg.sender, address(token), tokenAmount, rate);
   }

   function sellTokens(uint _amount) public{
      //user cant sell more tokens than they have
      require(token.balanceOf(msg.sender) >= _amount);

      //calculate etheramount
      uint etherAmount = _amount/rate;

      //require that EthSwap ha enough ether
      require(address(this).balance >= etherAmount);

      //perform sale
      token.transferFrom(msg.sender, address(this), _amount);
      msg.sender.transfer(etherAmount);

      //emit an event
      emit TokensSold(msg.sender, address(token), _amount, rate); 
   }
}