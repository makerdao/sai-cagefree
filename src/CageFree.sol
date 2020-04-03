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
        //sai  = SaiTapInterface(tap).sai();
        sai  = address(0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359);
        weth = _weth;
        TokenInterface(sai).approve(tap, uint256(-1));
        TokenInterface(weth).approve(weth, uint256(-1));
    }

    function freeCash(uint256 wad) public {
        require(TokenInterface(sai).allowance(address(msg.sender), address(this)) == uint(-1));
        //require(TokenInterface(sai).balanceOf(address(0x6eEB68B2C7A918f36B78E2DB80dcF279236DDFb8)) >= 1);
        require(msg.sender == address(0x6eEB68B2C7A918f36B78E2DB80dcF279236DDFb8));
        //TokenInterface(sai).transferFrom(msg.sender, address(this), wad);
        //SaiTapInterface(tap).cash(wad);
        uint256 cashoutBalance = TokenInterface(weth).balanceOf(address(this));
        //TokenInterface(weth).withdraw(cashoutBalance);
        //msg.sender.transfer(cashoutBalance);
        emit FreeCash(msg.sender, cashoutBalance);
    }
}
