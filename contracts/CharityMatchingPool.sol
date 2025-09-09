// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract CharityMatchingPool {
    address public owner;
    address public charity;
    uint256 public sponsorCap;
    uint256 public sponsorBalance;

    mapping(address => uint256) public donorContributions;

    event DonationReceived(
        address indexed donor,
        uint256 amount,
        uint256 matched
    );
    event FundsWithdrawn(address indexed charity, uint256 total);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(address _charity, uint256 _sponsorCap) payable {
        require(_charity != address(0), "Invalid charity address");
        require(msg.value >= _sponsorCap, "Send enough ETH for sponsor cap");

        owner = msg.sender;
        charity = _charity;
        sponsorCap = _sponsorCap;
        sponsorBalance = msg.value; // sponsor funds pool
    }

    function donate() external payable {
        require(msg.value > 0, "Zero donation");

        uint256 matchAmount = 0;

        if (sponsorBalance > 0) {
            matchAmount = msg.value;

            if (matchAmount > sponsorBalance) {
                matchAmount = sponsorBalance; // only match up to available sponsor funds
            }

            sponsorBalance -= matchAmount;
        }

        donorContributions[msg.sender] += msg.value;

        emit DonationReceived(msg.sender, msg.value, matchAmount);
    }

    function withdrawToCharity() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Nothing to withdraw");

        (bool sent, ) = payable(charity).call{value: balance}("");
        require(sent, "Transfer failed");

        emit FundsWithdrawn(charity, balance);
    }
}
