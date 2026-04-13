namespace ecommerce.db;

using {
    cuid,
    managed
} from '@sap/cds/common';

// ─────────────────────────────────────────
// USERS
// ─────────────────────────────────────────
@odata.draft.enabled
entity Users : cuid, managed {
    name     : String(100) not null;
    email    : String(255) not null;
    password : String(255);
    role     : String(10) default 'CUSTOMER'; // ADMIN | CUSTOMER
}

// ─────────────────────────────────────────
// PRODUCTS
// ─────────────────────────────────────────
@odata.draft.enabled
entity Products : cuid, managed {
    name        : String(200) not null;
    description : String(1000);
    price       : Decimal(10, 2) not null;
    stock       : Integer default 0;
    category    : String(100);
    imageUrl    : String(500);
    rating      : Decimal(3, 2) default 0.0;
    status_code : String(1) default 'A';
    status      : Association to ProductStatus
                      on status.code = status_code;
}

entity ProductStatus {
    key code        : String(1) enum {
            Available = 'A';
            Low_Stock = 'L';
            Out_of_Stock = 'U';
        };
        criticality : Integer;
        displayText : String;
}

// ─────────────────────────────────────────
// CART
// ─────────────────────────────────────────
@odata.draft.enabled
entity Cart : cuid, managed {
    user       : Association to Users;
    totalPrice : Decimal(10, 2) default 0.0;
    items      : Composition of many CartItems
                     on items.cart = $self;
}

entity CartItems : cuid {
    cart      : Association to Cart;
    product   : Association to Products;
    quantity  : Integer not null;
    price     : Decimal(10, 2); // snapshot of product price at time of adding
    lineTotal : Decimal(10, 2);
}

// ─────────────────────────────────────────
// ORDERS
// ─────────────────────────────────────────
//@odata.draft.enabled
entity Orders : cuid, managed {
    user          : Association to Users;
    totalAmount   : Decimal(10, 2);
    orderDate     : Timestamp;
    paymentStatus : String(20) default 'PENDING'; // PENDING | SUCCESS | FAILED
    orderStatus   : String(20) default 'PLACED'; // PLACED | SHIPPED | DELIVERED | CANCELLED
    items         : Composition of many OrderItems
                        on items.order = $self;
    payment : Composition of many Payments on payment.order = $self;
}

entity OrderItems : cuid {
    order    : Association to Orders;
    product  : Association to Products;
    quantity : Integer;
    price    : Decimal(10, 2);
    lineTotal : Decimal(10, 2);
}

// ─────────────────────────────────────────
// PAYMENTS (Simulation)
// ─────────────────────────────────────────
entity Payments : cuid, managed {
    order         : Association to Orders;
    amount        : Decimal(10, 2);
    paymentMode   : String(20); // CARD | UPI | COD
    status        : String(20); // SUCCESS | FAILED
    transactionId : String(100);
}
