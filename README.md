# Common Vulnerabilities in Smart Contracts

This repository shows three critical vulnerabilities commonly found in smart contracts, along with their mitigations. These examples are implemented using Solidity and include annotated explanations to educate developers and auditors on how these attacks occur and how to avoid them.

## 🛠 Vulnerabilities Covered

1. **Reentrancy Attack**
2. **Front Running Attack**
3. **Same Address Exploit (DAO-style Delegatecall Attack)**

---

## 1. Reentrancy Attack

### 📂 File:
- `ReentrancyAttack.sol`
- `solutionReentrancyAttack.sol`

### 🧠 Description:
A classic vulnerability where an attacker repeatedly calls the `withdraw` function before the original call finishes, draining all Ether.

### 🧪 Attack Scenario:
The vulnerable `withdrawEth()` function sends Ether before updating the user’s balance, allowing the attacker's fallback function to recursively re-enter the contract.

### ✅ Solution:
The issue is mitigated by using [OpenZeppelin's](https://docs.openzeppelin.com/contracts/) `ReentrancyGuard` and applying the `nonReentrant` modifier to prevent nested calls.

```solidity
function withdrawEth() external nonReentrant {
    ...
}
```
## 2. Front Running Attack

### 📂 File:
- `frontrunning_Vulnerable.sol`
- `FrontRunning_Fixed.sol`

### 🧠 Description:
A front running vulnerability occurs when a user's transaction is observed in the mempool and outpaced by a malicious actor using a higher gas fee.

### 🧪 Attack Scenario:
A user solves a challenge and submits a solution on-chain. An attacker observes the transaction in the mempool, copies the solution, and submits it with higher gas, stealing the reward.

### ✅ Solution:
A commit-reveal pattern is implemented, where:

- Users commit a hashed version of their solution.
- Later, they reveal the solution and claim the reward if it matches.

This approach prevents front running by hiding the actual solution until the reveal phase.

---

## 3. Same Address / Delegatecall Exploit (DAO Hack Pattern)

### 📂 File:
- `Dao_hack.sol`

### 🧠 Description:
This vulnerability abuses the use of `delegatecall` to execute malicious code in the context of the calling contract.

### 🧪 Attack Scenario:
An attacker precomputes the address of a contract and deploys a malicious `Attack` contract to that same address. The DAO uses `delegatecall` to execute a `Proposal`, but the function `executeProposal()` now performs unexpected malicious logic, including potential state manipulation.

### ✅ Solution:
Avoid using `delegatecall` to unknown or externally deployed contracts. Always validate the integrity and origin of addresses before executing delegatecalls, or better yet, avoid using `delegatecall` unless necessary.

---

## 🧠 Purpose

This repository serves as an educational tool for understanding common Ethereum smart contract vulnerabilities. Each contract is structured to be readable and concise, making it ideal for:

- Security auditors  
- Blockchain developers  
- Solidity learners

