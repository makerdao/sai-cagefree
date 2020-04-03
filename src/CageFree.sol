pragma solidity 0.5.15;

// https://github.com/makerdao/sai/blob/master/src/tap.sol
contract SaiTapInterface {
    function sai() public view returns (address);
    function cash(uint256) public;
}

contract TokenInterface {
    function approve(address, uint256) public;
    function transfer(address, uint256) public returns (bool);
    function transferFrom(address, address, uint256) public returns (bool);
    function deposit() public payable;
    function withdraw(uint256) public;
}

// User must approve() this contract on Sai prior to calling.
contract CageFree {

    address public tap;
    address public sai;
    address public weth;

    constructor(address _tap, address _weth) public {
        tap  = _tap;
        sai  = SaiTapInterface(tap).sai();
        weth = _weth;
        TokenInterface(sai).approve(tap, uint256(-1));
    }

    function freeCash(uint256 wad) public {
        TokenInterface(sai).transferFrom(msg.sender, address(this), wad);
        SaiTapInterface(tap).cash(wad);
        TokenInterface(weth).withdraw(wad);
        msg.sender.transfer(wad);
    }
}
