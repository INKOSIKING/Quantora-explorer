// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Store {
    struct Product { uint id; string name; uint price; uint stock; }
    struct Order { uint id; address buyer; uint[] productIds; uint total; bool paid; }
    mapping(uint => Product) public products;
    mapping(uint => Order) public orders;
    uint public nextProduct = 1;
    uint public nextOrder = 1;

    function addProduct(string calldata name, uint price, uint stock) external {
        products[nextProduct++] = Product(nextProduct, name, price, stock);
    }
    function buy(uint[] calldata productIds) external payable {
        uint total = 0;
        for (uint i=0; i<productIds.length; i++) {
            Product storage p = products[productIds[i]];
            require(p.stock > 0, "Out of stock");
            total += p.price;
            p.stock -= 1;
        }
        require(msg.value >= total, "Not enough ETH/QTX sent");
        orders[nextOrder++] = Order(nextOrder, msg.sender, productIds, total, true);
    }
}