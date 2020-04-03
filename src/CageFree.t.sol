pragma solidity 0.5.15;

import "ds-test/test.sol";
import "ds-math/math.sol";
//import "lib/dss-interfaces/src/Interfaces.sol";
import "lib/dss-interfaces/src/ERC/GemAbstract.sol";

import "./CageFree.sol";

contract Hevm { function warp(uint) public; }

contract TubLike {
    function gem() public view returns (address);
    function per() public view returns (uint256);
    function off() public view returns (bool);
}

contract TapLike {
    function vent() public;
    function off() public view returns (bool);
}

contract TopLike {
    function cage() public;
}

contract GovLike {
    function balanceOf(address) public view returns (uint256);
    function approve(address, uint256) public;
    function mint(address, uint256) public;
}

contract ChiefLike {
    function hat() public view returns (address);
    function lock(uint256) public;
    function vote(address[] memory) public;
    function lift(address) public;
}

contract StopLike {
    function stopped() public view returns (bool);
}

contract CageFreeTest is DSTest, DSMath {

    CageFree cageFree;
    Hevm hevm;

    TubLike tub = TubLike(0x448a5065aeBB8E423F0896E6c5D525C040f59af3);
    TapLike tap = TapLike(0xBda109309f9FafA6Dd6A9CB9f1Df4085B27Ee8eF);
    TopLike top = TopLike(0x9b0ccf7C8994E19F39b2B4CF708e0A7DF65fA8a3);
    ChiefLike chief = ChiefLike(0x9eF05f7F6deB616fd37aC3c959a2dDD25A54E4F5);
    GovLike gov = GovLike(0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2);

    // CHEAT_CODE = 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D
    bytes20 constant CHEAT_CODE =
        bytes20(uint160(uint256(keccak256('hevm cheat code'))));


    function setUp() public {
        hevm = Hevm(address(CHEAT_CODE));
        // Using the MkrAuthority test address, mint enough MKR to overcome the
        // current hat.
        //gov.mint(address(this), 300000 ether);

        address mainnetTap = address(0xBda109309f9FafA6Dd6A9CB9f1Df4085B27Ee8eF);
        address mainnetWeth = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
        cageFree = new CageFree(mainnetTap, mainnetWeth);
    }

    function vote() private {
        gov.approve(address(chief), uint256(-1));
        chief.lock(gov.balanceOf(address(this)));

        address[] memory yays = new address[](1);
        yays[0] = address(this);

        chief.vote(yays);
        chief.lift(address(this));
        assertEq(chief.hat(), address(this));

        top.cage();
        hevm.warp(now + 10 days);
    }

    function testCageFree() public {
        assertTrue(!tub.off());
        vote();
        assertTrue(tub.off());

        // Luckily the test address has a little over 1 Sai that we can use.
        // Run some tests to ensure Sai is correct.
        assertEq(cageFree.sai(), address(0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359));
        assertTrue(GemAbstract(cageFree.sai()).balanceOf(address(this)) > 10**16);
        assertTrue(GemAbstract(cageFree.sai()).totalSupply() > 1);

        assertTrue(!StopLike(cageFree.sai()).stopped());
        assertTrue(tap.off());

        GemAbstract(cageFree.sai()).approve(address(cageFree), uint256(-1));
        assertEq(GemAbstract(cageFree.sai()).allowance(address(this), address(cageFree)), uint(-1));
        assertTrue(GemAbstract(cageFree.weth()).balanceOf(address(tub)) > 10**16);
        uint256 prebalance = address(this).balance;
        assertTrue(prebalance > 1);

        uint256 freed = cageFree.freeCash(10**16);

        assertTrue(freed > 0);
        assertTrue(prebalance < address(this).balance);


    }

    function() external payable {}

    function canCall(address, address, bytes4) public pure returns (bool) {
        return true;
    }
}
