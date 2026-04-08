sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"ecommerce/productui/test/integration/pages/ProductsList",
	"ecommerce/productui/test/integration/pages/ProductsObjectPage"
], function (JourneyRunner, ProductsList, ProductsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('ecommerce/productui') + '/test/flp.html#app-preview',
        pages: {
			onTheProductsList: ProductsList,
			onTheProductsObjectPage: ProductsObjectPage
        },
        async: true
    });

    return runner;
});

