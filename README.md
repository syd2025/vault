## 金库合约

**实现了一个简单的金库合约，可以存币和取币，并且可以按照存储代币的比例进行取币。**

金库合约的组成部分:

-   **ERC20**: 本合约集成了ERC20的相关方法,通过IERC20接口调用.
-   **depoist**: 存币方法.
-   **withdraw**: 取币方法.

## Documentation

https://github.com/syd2025/vault

## Need to know

存币计算方式：

A - Amount to deposit

B - Balance of vault before deposit

S - Shares to mint

T - Total shares before mint

- (A + B)/B = (S+T)/T => S = A * T / B

---
取币计算方式：
A - Amount to withdraw

B = Balance of vault before withdraw

S = Shares to burn

T = Total shares before burn

- (B - A)/B = (T - S)/T => A = B * S / T


### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
