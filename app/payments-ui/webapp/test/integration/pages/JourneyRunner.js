sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"ecommerce/paymentsui/test/integration/pages/PaymentsList",
	"ecommerce/paymentsui/test/integration/pages/PaymentsObjectPage"
], function (JourneyRunner, PaymentsList, PaymentsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('ecommerce/paymentsui') + '/test/flp.html#app-preview',
        pages: {
			onThePaymentsList: PaymentsList,
			onThePaymentsObjectPage: PaymentsObjectPage
        },
        async: true
    });

    return runner;
});

