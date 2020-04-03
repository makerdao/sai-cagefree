pragma solidity 0.5.15;

import "ds-test/test.sol";
import "ds-math/math.sol";

import "./CageFree.sol";

contract CageFreeTest is DSTest, DSMath {

    CageFree cageFree;

    function setUp() public {
        address mainnetTap = address(0xBda109309f9FafA6Dd6A9CB9f1Df4085B27Ee8eF);
        address mainnetSai = address(0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359);
        address mainnetWeth = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
        cageFree = new CageFree(mainnetTap, mainnetSai, mainnetWeth);
    }

}
