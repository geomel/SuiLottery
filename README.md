# SuiLottery

A Lottery game implementation in Sui Move.

## Overall Scope:

- Move contract features demonstration.

- Complete dapp example for the SUI chain.

- A first try to implement randomness via Drand that lately announced their randomness output can be used inside Move contracts. 

- Similarities/Differences from a same contract implementation in Solidity.

## Features

- There is a manager, an account that deploys and controls the contract.

- The lottery game starts by accepting TXs (players buying tickets).

- The manager only can finalise the lottery by running a random function that will withdraw all tokens from the lottery and deposit them to a random player.

- To be able to finalise the lottery there should be at least 3 players.



