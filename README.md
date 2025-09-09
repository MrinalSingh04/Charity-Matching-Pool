# Charity Matching Pool

## 📌 What is this? 

The **Charity Matching Pool** is a simple Ethereum smart contract where:

- A **sponsor** funds a matching pool (e.g., 5 ETH). 
- **Donors** contribute ETH.
- The contract automatically **matches donations 1:1** from the sponsor’s pool, until the sponsor’s cap is reached.
- The **contract owner** can withdraw all funds (donations + sponsor matches) to the designated **charity address**.

This creates transparency and fairness in donation matching campaigns.

---

## 🎯 Why build this?

- **Transparency** – Donors and sponsors can see all contributions on-chain.
- **Trustless Matching** – Matching happens automatically by smart contract rules, not manually.
- **Flexibility** – Any address can be a charity, sponsor, or donor.
- **Beginner-friendly** – Demonstrates Solidity basics: constructor args, payable functions, mappings, events, and withdrawals.

---

## ⚙️ How it Works

1. **Deployment (Sponsor sets pool):**

   - The sponsor deploys the contract, specifying:
     - `_charity`: Ethereum address of the charity.
     - `_sponsorCap`: Maximum amount the sponsor will match (in wei).
   - The sponsor must also send ETH (`msg.value`) equal to or greater than `_sponsorCap`.

   Example:

   - `_charity = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
   - `_sponsorCap = 1000000000000000000` (1 ETH in wei)
   - `msg.value = 1 ETH`

2. **Donation (Public):**

   - Anyone can call `donate()` with ETH.
   - The contract matches the donation from sponsor funds (up to the sponsor balance).
   - If sponsor funds are exhausted, donations are still accepted but not matched.

3. **Withdraw (Owner-only):**
   - Only the owner (deployer) can call `withdrawToCharity()`.
   - This transfers all ETH (donations + matched) to the charity.

---

## 📜 Events

- `DonationReceived(address donor, uint256 amount, uint256 matched)`  
  → Emitted whenever someone donates.

- `FundsWithdrawn(address charity, uint256 total)`  
  → Emitted when the owner sends all funds to the charity.

---

## 🛠️ Example Workflow

1. **Deploy contract**

   - Charity: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
   - Sponsor cap: `1 ETH (1000000000000000000 wei)`
   - Send `1 ETH` as deployment value.

2. **Donor donates**

   - Donor calls `donate()` with `0.2 ETH`.
   - Contract matches `0.2 ETH` from sponsor pool.
   - Event logged: `DonationReceived(donor, 0.2 ETH, 0.2 ETH)`.

3. **Charity receives funds**
   - Owner calls `withdrawToCharity()`.
   - Entire balance transferred to charity address.
   - Event logged: `FundsWithdrawn(charity, total)`.

---

## ✅ Benefits

- Builds **trust** for donors (they see matching rules are enforced by code).
- Ensures sponsor funds are **only used for matching**.
- Makes donation campaigns **transparent and auditable** on-chain.

---
