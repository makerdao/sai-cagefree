pragma solidity ^0.5.15;

import "ds-test/test.sol";

import "./SaiCagefree.sol";

contract SaiCagefreeTest is DSTest {
    SaiCagefree cagefree;

    function setUp() public {
        cagefree = new SaiCagefree();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
