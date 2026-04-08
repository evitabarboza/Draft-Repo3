// const cds = require('@sap/cds');
// const crypto = require('crypto');

// module.exports = cds.service.impl(async function (srv) {

//     const { Users, Products, Cart, CartItems, Orders, OrderItems, Payments } = srv.entities;

//     // ─────────────────────────────────────────────────
//     // HELPERS
//     // ─────────────────────────────────────────────────
//     const getStatusCode = (stock) => {
//         if (stock === 0) return 'U';  // Out of Stock
//         if (stock <= 10) return 'L';  // Low Stock
//         return 'A';                    // Available
//     };

//     const recalcCartTotal = async (cartId) => {
//         const items = await SELECT.from(CartItems).where({ cart_ID: cartId });
//         const total = items.reduce((sum, i) => sum + (i.price * i.quantity), 0);
//         await UPDATE(Cart).set({ totalPrice: total }).where({ ID: cartId });
//         return total;
//     };

//     // ─────────────────────────────────────────────────
//     // PRODUCTS — auto status on stock change
//     // ─────────────────────────────────────────────────
//     srv.before(['CREATE', 'UPDATE'], Products, (req) => {
//         if (req.data.stock !== undefined) {
//             req.data.status_code = getStatusCode(req.data.stock);
//         }
//     });

//     // ─────────────────────────────────────────────────
//     // AUTH — Register
//     // ─────────────────────────────────────────────────
//     srv.on('registerUser', async (req) => {
//         const { name, email, password, role } = req.data;

//         if (!name || !email || !password)
//             return req.error(400, 'Name, email and password are required');

//         const existing = await SELECT.one.from(Users).where({ email });
//         if (existing) return req.error(409, 'Email already registered');

//         // Simple hash (use bcrypt in production)
//         const hashedPassword = crypto.createHash('sha256').update(password).digest('hex');

//         const user = await INSERT.into(Users).entries({
//             name,
//             email,
//             password: hashedPassword,
//             role: role || 'CUSTOMER'
//         });

//         return await SELECT.one.from(Users).where({ email });
//     });

//     // ─────────────────────────────────────────────────
//     // AUTH — Login
//     // ─────────────────────────────────────────────────
//     srv.on('loginUser', async (req) => {
//         const { email, password } = req.data;

//         const hashedPassword = crypto.createHash('sha256').update(password).digest('hex');
//         const user = await SELECT.one.from(Users).where({ email, password: hashedPassword });

//         if (!user) return req.error(401, 'Invalid email or password');

//         // Simulate a token (use JWT in production)
//         const token = crypto.randomBytes(32).toString('hex');

//         return { token, user };
//     });

//     // ─────────────────────────────────────────────────
//     // CART — Add item
//     // ─────────────────────────────────────────────────
//     srv.on('addToCart', async (req) => {
//         const { userId, productId, quantity } = req.data;

//         if (quantity <= 0) return req.error(400, 'Quantity must be greater than zero');

//         const product = await SELECT.one.from(Products).where({ ID: productId });
//         if (!product) return req.error(404, 'Product not found');
//         if (product.stock < quantity) return req.error(400, 'Insufficient stock');
//         if (product.status_code === 'U') return req.error(400, 'Product is out of stock');

//         // Get or create cart for user
//         let cart = await SELECT.one.from(Cart).where({ user_ID: userId });
//         if (!cart) {
//             const result = await INSERT.into(Cart).entries({ user_ID: userId, totalPrice: 0 });
//             cart = await SELECT.one.from(Cart).where({ user_ID: userId });
//         }

//         // Check if product already in cart
//         const existing = await SELECT.one.from(CartItems)
//             .where({ cart_ID: cart.ID, product_ID: productId });

//         if (existing) {
//             const newQty = existing.quantity + quantity;
//             if (product.stock < newQty) return req.error(400, 'Not enough stock for requested quantity');

//             await UPDATE(CartItems)
//                 .set({ quantity: newQty })
//                 .where({ ID: existing.ID });
//         } else {
//             await INSERT.into(CartItems).entries({
//                 cart_ID: cart.ID,
//                 product_ID: productId,
//                 quantity,
//                 price: product.price
//             });
//         }

//         await recalcCartTotal(cart.ID);
//         return await SELECT.one.from(CartItems).where({ cart_ID: cart.ID, product_ID: productId });
//     });

//     // ─────────────────────────────────────────────────
//     // CART — Remove item
//     // ─────────────────────────────────────────────────
//     srv.on('removeFromCart', async (req) => {
//         const { cartItemId } = req.data;

//         const item = await SELECT.one.from(CartItems).where({ ID: cartItemId });
//         if (!item) return req.error(404, 'Cart item not found');

//         await DELETE.from(CartItems).where({ ID: cartItemId });
//         await recalcCartTotal(item.cart_ID);

//         return { message: 'Item removed from cart' };
//     });

//     // ─────────────────────────────────────────────────
//     // CART — Update quantity
//     // ─────────────────────────────────────────────────
//     srv.on('updateCartItem', async (req) => {
//         const { cartItemId, quantity } = req.data;

//         if (quantity <= 0) return req.error(400, 'Quantity must be greater than zero');

//         const item = await SELECT.one.from(CartItems).where({ ID: cartItemId });
//         if (!item) return req.error(404, 'Cart item not found');

//         const product = await SELECT.one.from(Products).where({ ID: item.product_ID });
//         if (product.stock < quantity) return req.error(400, 'Insufficient stock');

//         await UPDATE(CartItems).set({ quantity }).where({ ID: cartItemId });
//         await recalcCartTotal(item.cart_ID);

//         return await SELECT.one.from(CartItems).where({ ID: cartItemId });
//     });

//     // ─────────────────────────────────────────────────
//     // CART — Read endpoints (GET) 
//     // ─────────────────────────────────────────────────
//     srv.on('getCart', async (req) => {
//         const { userId } = req.data; // use req.data if bound action; use req.params if REST path
//         if (!userId) return req.error(400, 'User ID is required');

//         // Get or create cart
//         let cart = await SELECT.one.from(Cart).where({ user_ID: userId });
//         if (!cart) {
//             // If no cart, return empty
//             return { cart: null, items: [] };
//         }

//         const items = await SELECT.from(CartItems).where({ cart_ID: cart.ID });
//         return { cart, items };
//     });

//     srv.on('getCartItem', async (req) => {
//         const { cartItemId } = req.data;
//         if (!cartItemId) return req.error(400, 'Cart item ID is required');

//         const item = await SELECT.one.from(CartItems).where({ ID: cartItemId });
//         if (!item) return req.error(404, 'Cart item not found');

//         return item;
//     });

//     // ─────────────────────────────────────────────────
//     // CHECKOUT — bound action on Cart
//     // ─────────────────────────────────────────────────
//     srv.on('checkoutCart', 'Cart', async (req) => {
//         const cartId = req.params[0]?.ID;
//         if (!cartId) return req.error(400, 'Cart ID is required');

//         const cart = await SELECT.one.from(Cart).where({ ID: cartId });
//         if (!cart) return req.error(404, 'Cart not found');

//         const items = await SELECT.from(CartItems).where({ cart_ID: cartId });
//         if (!items.length) return req.error(400, 'Cart is empty');

//         const tx = cds.transaction(req);
//         let total = 0;
//         const orderItems = [];

//         for (const item of items) {
//             const product = await tx.run(SELECT.one.from(Products).where({ ID: item.product_ID }));
//             if (!product) return req.error(404, `Product not found: ${item.product_ID}`);
//             if (product.stock < item.quantity) return req.error(400, `Insufficient stock for: ${product.name}`);

//             const newStock = product.stock - item.quantity;
//             total += item.price * item.quantity;

//             orderItems.push({
//                 product_ID: product.ID,
//                 quantity: item.quantity,
//                 price: item.price
//             });

//             // Reduce stock + update status
//             await tx.run(
//                 UPDATE(Products)
//                     .set({ stock: newStock, status_code: getStatusCode(newStock) })
//                     .where({ ID: product.ID })
//             );
//         }

//         // Create Order
//         const orderId = cds.utils.uuid();
//         await tx.run(INSERT.into(Orders).entries({
//             ID: orderId,
//             user_ID: cart.user_ID,
//             totalAmount: total,
//             orderDate: new Date(),
//             paymentStatus: 'PENDING',
//             orderStatus: 'PLACED'
//         }));

//         // Create Order Items
//         for (const oi of orderItems) {
//             await tx.run(INSERT.into(OrderItems).entries({ order_ID: orderId, ...oi }));
//         }

//         // Clear Cart
//         await tx.run(DELETE.from(CartItems).where({ cart_ID: cartId }));
//         await tx.run(UPDATE(Cart).set({ totalPrice: 0 }).where({ ID: cartId }));

//         return await tx.run(SELECT.one.from(Orders).where({ ID: orderId }));
//     });

//     // ─────────────────────────────────────────────────
//     // ORDERS — Update status
//     // ─────────────────────────────────────────────────
//     srv.on('updateOrderStatus', async (req) => {
//         const { orderId, status } = req.data;

//         const order = await SELECT.one.from(Orders).where({ ID: orderId });
//         if (!order) return req.error(404, 'Order not found');

//         const validTransitions = {
//             PLACED: ['SHIPPED', 'CANCELLED'],
//             SHIPPED: ['DELIVERED'],
//             DELIVERED: [],
//             CANCELLED: []
//         };

//         if (!validTransitions[order.orderStatus]?.includes(status)) {
//             return req.error(400, `Invalid status transition: ${order.orderStatus} → ${status}`);
//         }

//         await UPDATE(Orders).set({ orderStatus: status }).where({ ID: orderId });
//         return await SELECT.one.from(Orders).where({ ID: orderId });
//     });

//     // ─────────────────────────────────────────────────
//     // PAYMENTS — Simulate
//     // ─────────────────────────────────────────────────
//     srv.on('simulatePayment', async (req) => {
//         const { orderId, paymentMode } = req.data;

//         const order = await SELECT.one.from(Orders).where({ ID: orderId });
//         if (!order) return req.error(404, 'Order not found');
//         if (order.paymentStatus === 'SUCCESS') return req.error(400, 'Order already paid');

//         // Simulate: 80% success rate
//         const isSuccess = Math.random() < 0.8;
//         const status = isSuccess ? 'SUCCESS' : 'FAILED';
//         const transactionId = crypto.randomBytes(16).toString('hex');

//         await INSERT.into(Payments).entries({
//             order_ID: orderId,
//             amount: order.totalAmount,
//             paymentMode,
//             status,
//             transactionId
//         });

//         await UPDATE(Orders)
//             .set({
//                 paymentStatus: status,
//                 orderStatus: isSuccess ? 'PLACED' : 'CANCELLED'
//             })
//             .where({ ID: orderId });

//         return await SELECT.one.from(Payments).where({ order_ID: orderId, transactionId });
//     });

//     // ─────────────────────────────────────────────────
//     // VALIDATIONS
//     // ─────────────────────────────────────────────────
//     srv.before(['CREATE', 'UPDATE'], CartItems, (req) => {
//         if (req.data.quantity !== undefined && req.data.quantity <= 0) {
//             req.error(400, 'Quantity must be greater than zero');
//         }
//     });
// });





const cds = require('@sap/cds');
const crypto = require('crypto');

module.exports = cds.service.impl(async function (srv) {

    const { Users, Products, Cart, CartItems, Orders, OrderItems, Payments } = srv.entities;

    // ─────────────────────────────────────────────────
    // HELPERS
    // ─────────────────────────────────────────────────
    const getStatusCode = (stock) => {
        if (stock === 0) return 'U';
        if (stock <= 10) return 'L';
        return 'A';
    };

    // Queries DB directly — bypasses service/draft layer
    // const recalcCartTotal = async (cartId) => {
    //     if (!cartId) return;

    //     const db = await cds.connect.to('db');
    //     const { CartItems: DBCartItems, Cart: DBCart } = db.entities('ecommerce.db');

    //     const items = await db.run(
    //         SELECT.from(DBCartItems).where({ cart_ID: cartId })
    //     );

    //     console.log(`📋 recalcCartTotal — items for cart ${cartId}:`, JSON.stringify(items));

    //     const total = items.reduce((sum, i) => {
    //         const price = parseFloat(i.price) || 0;
    //         const qty = parseInt(i.quantity) || 0;
    //         console.log(`  → price: ${price}, qty: ${qty}, sub: ${price * qty}`);
    //         return sum + (price * qty);
    //     }, 0);

    //     const rounded = Math.round(total * 100) / 100;

    //     await db.run(
    //         UPDATE(DBCart).set({ totalPrice: rounded }).where({ ID: cartId })
    //     );

    //     console.log(`✅ Cart ${cartId} total → ₹${rounded}`);
    //     return rounded;

    // };

    // // ─────────────────────────────────────────────────
    // // PRODUCTS — auto status on stock change
    // // ─────────────────────────────────────────────────
    // srv.before(['CREATE', 'UPDATE'], Products, (req) => {
    //     if (req.data.stock !== undefined) {
    //         req.data.status_code = getStatusCode(req.data.stock);
    //     }
    // });



    const recalcCartTotal = async (cartId, req) => {
        if (!cartId) return;

        const items = await SELECT.from(CartItems).where({ cart_ID: cartId });

        let total = 0;
        for (const i of items) {
            const price = parseFloat(i.price) || 0;
            const qty = parseInt(i.quantity) || 0;
            const lineTotal = Math.round(price * qty * 100) / 100;

            total += lineTotal;

            // ✅ update lineTotal via service
            await UPDATE(CartItems)
                .set({ lineTotal })
                .where({ ID: i.ID });
        }

        const rounded = Math.round(total * 100) / 100;

        // ✅ THIS is the key fix (uses draft context)
        await UPDATE(Cart)
            .set({ totalPrice: rounded })
            .where({ ID: cartId });

        console.log(`✅ Cart ${cartId} total → ₹${rounded}`);
        return rounded;
    };




    // ─────────────────────────────────────────────────
    // ✅ THE REAL FIX
    // Fiori saves Cart + CartItems together as a deep UPDATE on Cart
    // Hook into UPDATE on Cart, fill price on each item before save
    // ─────────────────────────────────────────────────
    srv.before('UPDATE', Cart, async (req) => {
        const items = req.data.items;
        if (!Array.isArray(items) || items.length === 0) return;

        console.log('🔥 UPDATE Cart — processing items:', JSON.stringify(items));

        for (const item of items) {
            // Fill price if missing or null
            if (item.product_ID && (item.price === null || item.price === undefined || item.price === 0)) {
                const product = await SELECT.one.from(Products).where({ ID: item.product_ID });
                if (product) {
                    item.price = product.price;
                    console.log(`✅ Filled price ₹${product.price} for product ${item.product_ID}`);
                }
            }
        }
    });

    // ─────────────────────────────────────────────────
    // After UPDATE on Cart — recalc total
    // ─────────────────────────────────────────────────
    srv.after('UPDATE', Cart, async (data, req) => {
        const cartId = data?.ID || req.data?.ID;
        console.log('📦 after UPDATE Cart — recalculating total for:', cartId);
        if (cartId) 
           // await recalcCartTotal(cartId);
        await recalcCartTotal(cartId, req);
    });

    // ─────────────────────────────────────────────────
    // CART ITEMS — before CREATE (Postman / API)
    // ─────────────────────────────────────────────────
    srv.before('CREATE', CartItems, async (req) => {
        if (req.data.quantity !== undefined && req.data.quantity <= 0)
            return req.error(400, 'Quantity must be greater than zero');

        if (req.data.product_ID && !req.data.price) {
            const product = await SELECT.one.from(Products).where({ ID: req.data.product_ID });
            if (product) req.data.price = product.price;
        }
    });

    // ─────────────────────────────────────────────────
    // CART ITEMS — before UPDATE (Postman / API)
    // ─────────────────────────────────────────────────
    srv.before('UPDATE', CartItems, async (req) => {
        if (req.data.quantity !== undefined && req.data.quantity <= 0)
            return req.error(400, 'Quantity must be greater than zero');

        if (req.data.product_ID) {
            const product = await SELECT.one.from(Products).where({ ID: req.data.product_ID });
            if (product) req.data.price = product.price;
        }
    });

    // ─────────────────────────────────────────────────
    // CART ITEMS — after CREATE (Postman / API)
    // ─────────────────────────────────────────────────
    srv.after('CREATE', CartItems, async (data) => {
        if (data?.cart_ID) await recalcCartTotal(data.cart_ID);
    });

    // ─────────────────────────────────────────────────
    // CART ITEMS — after UPDATE (Postman / API)
    // ─────────────────────────────────────────────────
    srv.after('UPDATE', CartItems, async (data, req) => {
        let cartId = data?.cart_ID;
        if (!cartId) {
            const itemId = data?.ID || req.data?.ID;
            if (itemId) {
                const item = await SELECT.one.from(CartItems).where({ ID: itemId });
                cartId = item?.cart_ID;
            }
        }
        if (cartId) await recalcCartTotal(cartId);
    });

    // ─────────────────────────────────────────────────
    // CART ITEMS — on DELETE
    // Capture cart_ID BEFORE delete, recalc AFTER
    // ─────────────────────────────────────────────────
    srv.on('DELETE', CartItems, async (req, next) => {
        const cartItemId = req.params?.[0]?.ID || req.data?.ID;
        let cartId;

        if (cartItemId) {
            const item = await SELECT.one.from(CartItems).where({ ID: cartItemId });
            cartId = item?.cart_ID;
        }

        const result = await next();
        if (cartId) await recalcCartTotal(cartId);
        return result;
    });

    // ─────────────────────────────────────────────────
    // AUTH — Register
    // ─────────────────────────────────────────────────
    srv.on('registerUser', async (req) => {
        const { name, email, password, role } = req.data;

        if (!name || !email || !password)
            return req.error(400, 'Name, email and password are required');

        const existing = await SELECT.one.from(Users).where({ email });
        if (existing) return req.error(409, 'Email already registered');

        const hashedPassword = crypto.createHash('sha256').update(password).digest('hex');

        await INSERT.into(Users).entries({
            name, email,
            password: hashedPassword,
            role: role || 'CUSTOMER'
        });

        return await SELECT.one.from(Users).where({ email });
    });

    // ─────────────────────────────────────────────────
    // AUTH — Login
    // ─────────────────────────────────────────────────
    srv.on('loginUser', async (req) => {
        const { email, password } = req.data;

        const hashedPassword = crypto.createHash('sha256').update(password).digest('hex');
        const user = await SELECT.one.from(Users).where({ email, password: hashedPassword });

        if (!user) return req.error(401, 'Invalid email or password');

        const token = crypto.randomBytes(32).toString('hex');
        return { token, user };
    });

    // ─────────────────────────────────────────────────
    // CART — Add item (Postman / API)
    // ─────────────────────────────────────────────────
    srv.on('addToCart', async (req) => {
        const { userId, productId, quantity } = req.data;

        if (quantity <= 0) return req.error(400, 'Quantity must be greater than zero');

        const product = await SELECT.one.from(Products).where({ ID: productId });
        if (!product) return req.error(404, 'Product not found');
        if (product.stock < quantity) return req.error(400, 'Insufficient stock');
        if (product.status_code === 'U') return req.error(400, 'Product is out of stock');

        let cart = await SELECT.one.from(Cart).where({ user_ID: userId });
        if (!cart) {
            await INSERT.into(Cart).entries({ user_ID: userId, totalPrice: 0 });
            cart = await SELECT.one.from(Cart).where({ user_ID: userId });
        }

        const existing = await SELECT.one.from(CartItems)
            .where({ cart_ID: cart.ID, product_ID: productId });

        if (existing) {
            const newQty = existing.quantity + quantity;
            if (product.stock < newQty) return req.error(400, 'Not enough stock for requested quantity');
            await UPDATE(CartItems).set({ quantity: newQty }).where({ ID: existing.ID });
        } else {
            await INSERT.into(CartItems).entries({
                cart_ID: cart.ID,
                product_ID: productId,
                quantity,
                price: product.price
            });
        }

        await recalcCartTotal(cart.ID);
        return await SELECT.one.from(CartItems).where({ cart_ID: cart.ID, product_ID: productId });
    });


    srv.before('*', async (req) => {
        if (req.entity?.includes('CartItem') || req.entity?.includes('Cart')) {
            console.log(`🔍 EVENT: "${req.event}" | ENTITY: "${req.entity}" | DATA: ${JSON.stringify(req.data)} | PARAMS: ${JSON.stringify(req.params)}`);
        }
    });



    // ─────────────────────────────────────────────────
    // CART — Remove item (Postman / API)
    // ─────────────────────────────────────────────────
    srv.on('removeFromCart', async (req) => {
        const { cartItemId } = req.data;

        const item = await SELECT.one.from(CartItems).where({ ID: cartItemId });
        if (!item) return req.error(404, 'Cart item not found');

        await DELETE.from(CartItems).where({ ID: cartItemId });
        await recalcCartTotal(item.cart_ID);

        return { message: 'Item removed from cart' };
    });

    // ─────────────────────────────────────────────────
    // CART — Update quantity (Postman / API)
    // ─────────────────────────────────────────────────
    srv.on('updateCartItem', async (req) => {
        const { cartItemId, quantity } = req.data;

        if (quantity <= 0) return req.error(400, 'Quantity must be greater than zero');

        const item = await SELECT.one.from(CartItems).where({ ID: cartItemId });
        if (!item) return req.error(404, 'Cart item not found');

        const product = await SELECT.one.from(Products).where({ ID: item.product_ID });
        if (product.stock < quantity) return req.error(400, 'Insufficient stock');

        await UPDATE(CartItems).set({ quantity }).where({ ID: cartItemId });
        await recalcCartTotal(item.cart_ID);

        // ✅ Always recalculate lineTotal
        if (item.price && item.quantity) {
            item.lineTotal = parseFloat(item.price) * parseInt(item.quantity);
        }

        return await SELECT.one.from(CartItems).where({ ID: cartItemId });
    });

    // ─────────────────────────────────────────────────
    // CHECKOUT — bound action on Cart
    // ─────────────────────────────────────────────────
    srv.on('checkoutCart', 'Cart', async (req) => {
        const cartId = req.params[0]?.ID;
        if (!cartId) return req.error(400, 'Cart ID is required');

        const cart = await SELECT.one.from(Cart).where({ ID: cartId });
        if (!cart) return req.error(404, 'Cart not found');

        const items = await SELECT.from(CartItems).where({ cart_ID: cartId });
        if (!items.length) return req.error(400, 'Cart is empty');

        const tx = cds.transaction(req);
        let total = 0;
        const orderItems = [];
        const availableItemIds = [];

        for (const item of items) {
            const product = await tx.run(SELECT.one.from(Products).where({ ID: item.product_ID }));
            if (!product) return req.error(404, `Product not found: ${item.product_ID}`);
            if (product.stock < item.quantity || product.status_code === 'U') {
                continue; // leave unavailable items in cart
            }

            const newStock = product.stock - item.quantity;
            total += item.price * item.quantity;
            availableItemIds.push(item.ID);

            orderItems.push({
                product_ID: product.ID,
                quantity: item.quantity,
                price: item.price,
                lineTotal: item.price * item.quantity
            });

            await tx.run(
                UPDATE(Products)
                    .set({ stock: newStock, status_code: getStatusCode(newStock) })
                    .where({ ID: product.ID })
            );
        }

        if (!orderItems.length) {
            return req.error(400, 'No available items can be ordered. Please update your cart.');
        }

        const orderId = cds.utils.uuid();
        await tx.run(INSERT.into(Orders).entries({
            ID: orderId,
            user_ID: cart.user_ID,
            totalAmount: total,
            orderDate: new Date(),
            paymentStatus: 'PENDING',
            orderStatus: 'PLACED'
        }));

        for (const oi of orderItems) {
            await tx.run(INSERT.into(OrderItems).entries({ order_ID: orderId, ...oi }));
        }

        if (availableItemIds.length) {
            await tx.run(DELETE.from(CartItems).where({ ID: { in: availableItemIds } }));
        }

        const remainingItems = await tx.run(SELECT.from(CartItems).where({ cart_ID: cartId }));
        const remainingTotal = remainingItems.reduce((sum, item) => {
            const price = parseFloat(item.price) || 0;
            const quantity = parseInt(item.quantity) || 0;
            return sum + (price * quantity);
        }, 0);

        if (remainingItems.length === 0) {
            await tx.run(DELETE.from(Cart).where({ ID: cartId }));
        } else {
            await tx.run(UPDATE(Cart).set({ totalPrice: remainingTotal }).where({ ID: cartId }));
        }

        return await tx.run(SELECT.one.from(Orders).where({ ID: orderId }));
    });

    // ─────────────────────────────────────────────────
    // ORDERS — Update status
    // ─────────────────────────────────────────────────
    srv.on('updateOrderStatus', async (req) => {
        const { orderId, status } = req.data;

        const order = await SELECT.one.from(Orders).where({ ID: orderId });
        if (!order) return req.error(404, 'Order not found');

        const validTransitions = {
            PLACED: ['SHIPPED', 'CANCELLED'],
            SHIPPED: ['DELIVERED'],
            DELIVERED: [],
            CANCELLED: []
        };

        if (!validTransitions[order.orderStatus]?.includes(status))
            return req.error(400, `Invalid status transition: ${order.orderStatus} → ${status}`);

        await UPDATE(Orders).set({ orderStatus: status }).where({ ID: orderId });
        return await SELECT.one.from(Orders).where({ ID: orderId });
    });

    // ─────────────────────────────────────────────────
    // PAYMENTS — Simulate
    // ─────────────────────────────────────────────────
    srv.on('simulatePayment', async (req) => {
        const { orderId, paymentMode } = req.data;

        const order = await SELECT.one.from(Orders).where({ ID: orderId });
        if (!order) return req.error(404, 'Order not found');
        if (order.paymentStatus === 'SUCCESS') return req.error(400, 'Order already paid');

        const isSuccess = Math.random() < 0.8;
        const status = isSuccess ? 'SUCCESS' : 'FAILED';
        const transactionId = crypto.randomBytes(16).toString('hex');

        await INSERT.into(Payments).entries({
            order_ID: orderId,
            amount: order.totalAmount,
            paymentMode,
            status,
            transactionId
        });

        await UPDATE(Orders)
            .set({
                paymentStatus: status,
                orderStatus: isSuccess ? 'PLACED' : 'CANCELLED'
            })
            .where({ ID: orderId });

        return await SELECT.one.from(Payments).where({ order_ID: orderId, transactionId });
    });

});