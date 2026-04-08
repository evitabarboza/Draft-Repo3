sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"ecommerce/cartui/test/integration/pages/CartList",
	"ecommerce/cartui/test/integration/pages/CartObjectPage",
	"ecommerce/cartui/test/integration/pages/CartItemsObjectPage"
], function (JourneyRunner, CartList, CartObjectPage, CartItemsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('ecommerce/cartui') + '/test/flp.html#app-preview',
        pages: {
			onTheCartList: CartList,
			onTheCartObjectPage: CartObjectPage,
			onTheCartItemsObjectPage: CartItemsObjectPage
        },
        async: true
    });

    return runner;
});

