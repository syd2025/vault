// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../common/IERC20.sol";

contract Vault {
    IERC20 public immutable token;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function _mint(address _to, uint256 _shares) private {
        totalSupply += _shares;
        balanceOf[_to] += _shares;
    }

    function _burn(address _from, uint256 _shares) private {
        totalSupply -= _shares;
        balanceOf[_from] -= _shares;
    }

    // 存钱
    function deposit(uint256 _amount) external {
        /*
        A: dispoit amount (amount)
        B: balance of token before deposit (token.balanceOf(account))
        T: total supply (totalSupply)
        S: shares to mint, 需要计算的数值
        (T+S)/ T = (A + B) / B
        S = AT / B
        */
        uint256 shares;
        if (totalSupply == 0) {
            shares = _amount;
        } else {
            shares = (_amount * totalSupply) / token.balanceOf(address(this));
        }
        _mint(msg.sender, _amount);
        token.transferFrom(msg.sender, address(this), _amount);
    }

    function withdraw(uint256 _shares) external {
        /**
         * A: withdraw amount 需要计算的值
         *     B: balance of token before withdraw (token.balanceOf(account))
         *     T: total supply (totalSupply)
         *     S: shares to burn (_shares), 
         *     (T-S)/ T = (A - B) / B
         *     A = SB / T
         */
        uint256 amount = (_shares * token.balanceOf(address(this))) / totalSupply;
        _burn(msg.sender, _shares);
        token.transfer(msg.sender, amount); // 当前金库合约向MOA账户转账
    }
}
