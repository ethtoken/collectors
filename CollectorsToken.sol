pragma solidity ^0.4.11;

contract ERC20Token {
    function transfer(address _to, uint _value) returns (bool success);
    function transferFrom(address _from, address _to, uint _value) returns (bool success);
    function approve(address _spender, uint _value) returns (bool success);

    function totalSupply() constant returns (uint supply);
    function balanceOf(address _owner) constant returns (uint balance);
    function allowance(address _owner, address _spender) constant returns (uint remaining);

    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}

contract CollectorsToken is ERC20Token {

    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    function CollectorsToken(string tokenName, string tokenSymbol, uint8 decimalUnits, uint256 initialSupply) {
        name = tokenName;
        symbol = tokenSymbol;
        decimals = decimalUnits;
        totalSupply = initialSupply;

        // Give the creator all initial supply
        balanceOf[msg.sender] = initialSupply;
    }

    function transfer(address _to, uint256 _value)
        validAddress(_to)
        enoughBalance(msg.sender, _value)
        recipientWouldNotOverflow(_to, _value)
        returns (bool success)
    {
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        Transfer(msg.sender, _to, _value);
        
        return true;
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value)
        validAddress(_to)
        enoughBalance(_from, _value)
        enoughAllowance(_from, msg.sender, _value)
        recipientWouldNotOverflow(_to, _value)
        returns (bool success)
    {
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);

        return true;
    }
    
    modifier validAddress(address anAddress) {
        require(anAddress != 0x0);
        _;
    }

    modifier enoughBalance(address anAddress, uint256 amount) {
        require(balanceOf[anAddress] >= amount);
        _;
    }
    
    modifier enoughAllowance(address from, address spender, uint256 amount) {
        require(amount <= allowance[from][spender]);
        _;
    }
    
    modifier recipientWouldNotOverflow(address recipient, uint256 amount) {
        require((balanceOf[recipient] + amount) >= balanceOf[recipient]);
        _;
    }
}
