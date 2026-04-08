sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"ecommerce/orderui/test/integration/pages/OrdersList",
	"ecommerce/orderui/test/integration/pages/OrdersObjectPage"
], function (JourneyRunner, OrdersList, OrdersObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('ecommerce/orderui') + '/test/flp.html#app-preview',
        pages: {
			onTheOrdersList: OrdersList,
			onTheOrdersObjectPage: OrdersObjectPage
        },
        async: true
    });

    return runner;
});

