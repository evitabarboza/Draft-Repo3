sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"ecommerce/usersui/test/integration/pages/UsersList",
	"ecommerce/usersui/test/integration/pages/UsersObjectPage"
], function (JourneyRunner, UsersList, UsersObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('ecommerce/usersui') + '/test/flp.html#app-preview',
        pages: {
			onTheUsersList: UsersList,
			onTheUsersObjectPage: UsersObjectPage
        },
        async: true
    });

    return runner;
});

