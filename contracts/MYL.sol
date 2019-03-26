pragma solidity ^0.5.0;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";

contract MYL is ERC20, ERC20Detailed {

    /* Address of the MARKETING account, allowed to mint coins */
    address public accMarketing = 0x7853A60bbc563F079F17e59Ab223146A42060858;
    /* Address of the OPERATIONAL account, allowed to mint coins */
    address public accOperational = 0x4da7279AFbb18750D5DC707095aE3325Aa03d56c;
    /* Address of the TRANSFER account, allowed to mint coins */
    address public accTransfer = 0x35065a71ff561f1275D0E8C971fa42A1F0054F49;

    uint public timestamp_last_marketing_mint = block.timestamp;
    uint public timestamp_last_operational_mint = block.timestamp;

    constructor()
        ERC20()
        ERC20Detailed("MYRILLION", "MYL", 4)
        public {
            /* Initial token allocation */
            
            // Marketing: 300 000 000 MYL
            _mint(accMarketing, 3000000000000);
            // Operational: 500 000 000 MYL
            _mint(accOperational, 5000000000000);
            // Team & Advisor: 500 000 000 MYL
            _mint(0xaf1D0E25908FB3616b1938e57cAC86A95857beBf, 5000000000000);

            // ICO's accounts
            _mint(0x3c6D321b5FA40038C0fC90a3a1Ef35BEFCAAdF4B, 1400000000);
            _mint(0x38eFcA7EbFedD1043573E46bFf86706DbAda330D, 14000000000);
            _mint(0x3F43cCf9Ae4594436BC498655075b8f83B98A8C2, 15000000000);
            _mint(0xD9Df8D29Df90F1852c8f8eE704ECA568fEd33545, 15000000000);
            _mint(0x88EFed88f4040A2F034F08bE8ac988f9D4DB93De, 14000000000);
            _mint(0xf51aF4d3445f9600476F7e79d2e0B351860C8575, 129063185);
            _mint(0x8dC482998a684F8aC9B64ec4e1FA469684169daE, 1600000000);
            _mint(0xcF1ab02060C4D497f2966a3a928a9AfBc35aa907, 16000000000);
        }

    /* PUBLIC ENTRY POINTS */

    /* mint a certain amount of tokens */
    function mint(uint256 value) public returns (bool) {
        // Validate msg.sender
        require(
            (msg.sender == accMarketing && marketingCanMint(value)) 
            ||
            (msg.sender == accOperational && operationalCanMint(value))
            ||
            msg.sender == accTransfer
        );

        // Update timestamp of last mint, if applicable
        if (msg.sender == accMarketing) {
            timestamp_last_marketing_mint = block.timestamp;
        } else if (msg.sender == accOperational) {
            timestamp_last_operational_mint = block.timestamp;
        }

        // Issue tokens to msg.sender
        _mint(msg.sender, value);

        return true;
    }

    /* Allow the current MARKETING account to change its address */
    function changeMarketingAccount(address _newAccount) public returns (bool) {
        require(msg.sender == accMarketing, "Invalid msg.sender");
        accMarketing = _newAccount;
        return true;
    }

    /* Allow the current OPERATIONAL account to change its address */
    function changeOperationalAccount(address _newAccount) public returns (bool) {
        require(msg.sender == accOperational, "Invalid msg.sender");
        accOperational = _newAccount;
        return true;
    }

    /* Allow the current TRANSFER account to change its address */
    function changeTransferAccount(address _newAccount) public returns (bool) {
        require(msg.sender == accTransfer, "Invalid msg.sender");
        accTransfer = _newAccount;
        return true;
    }

    /* PRIVATE FUNCTIONS */

    function marketingCanMint(uint value) internal view returns (bool) {
        // Marketing can mint if balance (after mint) is <= 0.75% of totalSupply (after mint)
        uint threshold = totalSupply().add(value).mul(75).div(10000);
        if (balanceOf(accMarketing).add(value) > threshold) return false;
        // Marketing can mint if last mint was issued more than 6 months ago
        if (block.timestamp < timestamp_last_marketing_mint + 24 weeks) return false;
        return true;
    }

    function operationalCanMint(uint value) internal view returns (bool) {
        // Operational can mint if balance (after mint) is <= 1.25% of totalSupply (after mint)
        uint threshold = totalSupply().add(value).mul(125).div(10000);
        if (balanceOf(accOperational).add(value) > threshold) return false;
        // Operational can mint if last mint was issued more than 6 months ago
        if (block.timestamp < timestamp_last_operational_mint + 24 weeks) return false;
        return true;
    }
}