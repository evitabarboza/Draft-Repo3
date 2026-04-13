using ecommerce.db as db from '../db/schema';

service EcommerceService @(path: '/api') {

    // ── Users ──────────────────────────────
    @restrict: [
        {
            grant: '*',
            to   : 'ADMIN'
        },
        {
            grant: 'READ',
            to   : 'CUSTOMER'
        }
    ]
    entity Users         as
        projection on db.Users
        excluding {
            password
        };

    action registerUser(name: String, email: String, password: String, role: String) returns Users;
    action loginUser(email: String, password: String)                                returns Users;

    // ── Products ───────────────────────────
    @odata.draft.enabled
    @restrict: [
        {
            grant: '*',
            to   : 'ADMIN'
        },
        {
            grant: 'READ',
            to   : 'CUSTOMER'
        }
    ]
    entity Products      as projection on db.Products;

    entity ProductStatus as projection on db.ProductStatus;

    // ── Cart ───────────────────────────────
    @restrict: [{
        grant: '*',
        to   : [
            'ADMIN',
            'CUSTOMER'
        ]
    }]
    entity Cart          as projection on db.Cart
        actions {
            action checkoutCart() returns Orders;
        };

    entity CartItems     as projection on db.CartItems;

    action addToCart(userId: UUID, productId: UUID, quantity: Integer)               returns CartItems;
    // removeFromCart(cartItemId: UUID)                              returns { message: String };
    action removeFromCart(cartItemId: UUID)                                          returns CartItems;
    action updateCartItem(cartItemId: UUID, quantity: Integer)                       returns CartItems;

    // ── Orders ─────────────────────────────
    @restrict: [
        {
            grant: '*',
            to   : 'ADMIN'
        },
        {
            grant: 'READ',
            to   : 'CUSTOMER'
        }
    ]
    entity Orders        as projection on db.Orders;

    entity OrderItems    as projection on db.OrderItems;

    action updateOrderStatus(orderId: UUID, status: String)                          returns Orders;

    // ── Payments ───────────────────────────
    entity Payments      as projection on db.Payments;

    action simulatePayment(orderId: UUID, paymentMode: String)                       returns Payments;

}
