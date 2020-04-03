pragma solidity 0.5.15;

// https://github.com/makerdao/sai/blob/master/src/tap.sol
contract SaiTapInterface {
    function sai() public view returns (address);
    function cash(uint256) public;
}

contract TokenInterface {
    function approve(address, uint256) public;
    function allowance(address, address) public view returns (uint256);
    function transfer(address, uint256) public returns (bool);
    function transferFrom(address, address, uint256) public returns (bool);
    function deposit() public payable;
    function withdraw(uint256) public;
    function balanceOf(address) public view returns (uint256);
}

// User must approve() this contract on Sai prior to calling.
contract CageFree {

    address public tap;
    address public sai;
    address public weth;

    event FreeCash(address sender, uint256 amount);

    constructor(address _tap, address _weth) public {
        tap  = _tap;
        sai  = SaiTapInterface(tap).sai();
        weth = _weth;
        TokenInterface(sai).approve(tap, uint256(-1));
        TokenInterface(weth).approve(weth, uint256(-1));
    }

    function freeCash(uint256 wad) public payable returns (uint256) {
        TokenInterface(sai).transferFrom(msg.sender, address(this), wad);
        SaiTapInterface(tap).cash(wad);
        uint256 cashoutBalance = TokenInterface(weth).balanceOf(address(this));
        TokenInterface(weth).withdraw(cashoutBalance);
        msg.sender.transfer(cashoutBalance);
        emit FreeCash(msg.sender, cashoutBalance);
        return cashoutBalance;
    }

    function() external payable {}
}
