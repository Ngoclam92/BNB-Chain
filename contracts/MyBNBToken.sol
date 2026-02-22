// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MyBNBToken {
    string public name = "My BNB";
    string public symbol = "MBNB";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(uint256 supply) {
        owner = msg.sender;
        totalSupply = supply * 10 ** decimals;
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(balanceOf[msg.sender] >= value, "Balance low");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(balanceOf[from] >= value, "Balance low");
        require(allowance[from][msg.sender] >= value, "Not allowed");

        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;

        emit Transfer(from, to, value);
        return true;
    }

    function mint(uint256 amount) public onlyOwner {
        uint256 value = amount * 10 ** decimals;
        totalSupply += value;
        balanceOf[msg.sender] += value;
        emit Transfer(address(0), msg.sender, value);
    }

    function burn(uint256 amount) public {
        uint256 value = amount * 10 ** decimals;
        require(balanceOf[msg.sender] >= value, "Balance low");

        balanceOf[msg.sender] -= value;
        totalSupply -= value;
        emit Transfer(msg.sender, address(0), value);
    }
}
