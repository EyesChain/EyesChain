pragma solidity 0.4.25;

/**
 * @title Eyestoken contract
 */
 
contract Eyestoken is DetailedERC20, ERC20Token,Ownable{
	using SafeMath for uint256;

	event Approval(address indexed owner, address indexed spender, uint256 value);
	
	mapping(address => uint) public locker;
	
	string public constant symbol = "EYE";
	string public constant name = "Eyestoken";
	uint8 public constant decimals = 18;
	
	uint256 public constant TOTAL_SUPPLY = 2*(10**7)*(10**uint256(decimals));

	constructor() DetailedERC20(name, symbol, decimals) public {
		_totalSupply = TOTAL_SUPPLY;
		balances[owner] = _totalSupply;
		emit Transfer(address(0x0), msg.sender, _totalSupply);
	}

	
	function transfer(address _to, uint256 _value)  public returns (bool){
		return super.transfer(_to, _value);
	}

	function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
		balances[_from] = balances[_from].sub(_value);
		balances[_to] = balances[_to].add(_value);
		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

		emit Transfer(_from, _to, _value);

		return true;
		
	}

	function() public payable {
		revert();
	}
}



contract ERC20Basic {
	function totalSupply() public view returns (uint256);
	function balanceOf(address who) public view returns (uint256);
	function transfer(address to, uint256 value) public returns (bool);
	event Transfer(address indexed from, address indexed to, uint256 value);
}


contract ERC20 is ERC20Basic {
	function allowance(address owner, address spender) public view returns (uint256);
	function transferFrom(address from, address to, uint256 value) public returns (bool);
	function approve(address spender, uint256 value) public returns (bool);
	event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract DetailedERC20 is ERC20 {
	string public name;
	string public symbol;
	uint8 public decimals;
	
	constructor(string _name, string _symbol, uint8 _decimals) public {
		name = _name;
		symbol = _symbol;
		decimals = _decimals;
	}
}

contract BasicToken is ERC20Basic {
	using SafeMath for uint256;
	mapping(address => uint256) balances;
	mapping (address => uint256) freezeOf;
	uint256 _totalSupply;
	
	function totalSupply() public view returns (uint256) {
		return _totalSupply;
	}
	
	function transfer(address _to, uint256 _value) public returns (bool) {
		require(_to != address(0));
		require(_value > 0);
		require(_value <= balances[msg.sender]);
		
		balances[msg.sender] = balances[msg.sender].sub(_value);
		balances[_to] = balances[_to].add(_value);
		emit Transfer(msg.sender, _to, _value);
		
		return true;
	}
	
	function balanceOf(address _owner) public view returns (uint256 balance) {
		return balances[_owner];
	}
}

contract ERC20Token is BasicToken, ERC20 {
	using SafeMath for uint256;
	mapping (address => mapping (address => uint256)) allowed;
	mapping (address => uint256) freezeOf;
	
	function approve(address _spender, uint256 _value) public returns (bool) {
		require(_value == 0 || allowed[msg.sender][_spender] == 0);
		allowed[msg.sender][_spender] = _value;
		emit Approval(msg.sender, _spender, _value);
		
		return true;
	}
	
	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
		return allowed[_owner][_spender];
	}

	function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
		
		return true;
	}
	
	function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
		uint256 oldValue = allowed[msg.sender][_spender];
		if (_subtractedValue >= oldValue) {
			allowed[msg.sender][_spender] = 0;
		} else {
			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
		}
		
		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
		
		return true;
		
	}
	
}

contract Ownable {

	address public owner;
	address public admin;
	
	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
	
	constructor() public {
		owner = msg.sender;
	}


	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	modifier onlyOwnerOrAdmin() {
		require(msg.sender != address(0) && (msg.sender == owner || msg.sender == admin));
		_;
	}
	
	function transferOwnership(address newOwner) onlyOwner public {
		require(newOwner != address(0));
		require(newOwner != owner);
		require(newOwner != admin);

		emit OwnershipTransferred(owner, newOwner);
		owner = newOwner;
		
	}

	function setAdmin(address newAdmin) onlyOwner public {
		require(admin != newAdmin);
		require(owner != newAdmin);
		
		admin = newAdmin;
	}
  
}

library SafeMath {
	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
		if (a == 0 || b == 0) {
			return 0;
		}
		
		uint256 c = a * b;
		assert(c / a == b);
		return c;
	}

	function div(uint256 a, uint256 b) internal pure returns (uint256) {
		uint256 c = a / b;
		return c;
	}
	
	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
		assert(b <= a);
		return a - b;
	}

	function add(uint256 a, uint256 b) internal pure returns (uint256) {
		uint256 c = a + b;
		assert(c >= a);
		return c;
	}
}
