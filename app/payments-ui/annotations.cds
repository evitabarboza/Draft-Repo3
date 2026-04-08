using EcommerceService as service from '../../srv/service';
annotate service.Payments with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'amount',
                Value : amount,
            },
            {
                $Type : 'UI.DataField',
                Label : 'paymentMode',
                Value : paymentMode,
            },
            {
                $Type : 'UI.DataField',
                Label : 'status',
                Value : status,
            },
            {
                $Type : 'UI.DataField',
                Label : 'transactionId',
                Value : transactionId,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'General Information',
            ID : 'GeneralInformation',
            Target : '@UI.FieldGroup#GeneralInformation',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataFieldForActionGroup',
            Actions : [
                {
                    $Type : 'UI.DataFieldForAction',
                    Action : 'EcommerceService.EntityContainer/updateOrderStatus',
                    Label : 'Update Order Status',
                },
                {
                    $Type : 'UI.DataFieldForAction',
                    Action : 'EcommerceService.EntityContainer/simulatePayment',
                    Label : 'Simulate Payment',
                },
            ],
            ID : 'ActionMenu',
            Label : 'Process Actions',
        },
        {
            $Type : 'UI.DataField',
            Value : ID,
            Label : 'Payment ID',
        },
        {
            $Type : 'UI.DataField',
            Value : order_ID,
            Label : 'Order ID',
        },
        {
            $Type : 'UI.DataField',
            Value : paymentMode,
            Label : 'Payment Mode',
        },
        {
            $Type : 'UI.DataField',
            Value : status,
            Label : 'Payment Status',
        },
    ],
    UI.FieldGroup #GeneralInformation : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : ID,
                Label : 'Payment ID',
            },
            {
                $Type : 'UI.DataField',
                Value : order.user.ID,
                Label : 'Customer ID',
            },
            {
                $Type : 'UI.DataField',
                Value : order.user.name,
                Label : 'Customer Name',
            },
            {
                $Type : 'UI.DataField',
                Value : order.user.email,
                Label : 'Email',
            },
            {
                $Type : 'UI.DataField',
                Value : order_ID,
                Label : 'Order ID',
            },
            {
                $Type : 'UI.DataField',
                Value : order.orderDate,
            },
            {
                $Type : 'UI.DataField',
                Value : order.orderStatus,
            },
            {
                $Type : 'UI.DataField',
                Value : amount,
                Label : 'Amount',
            },
            {
                $Type : 'UI.DataField',
                Value : paymentMode,
                Label : 'Payment Mode',
            },
            {
                $Type : 'UI.DataField',
                Value : status,
                Label : 'Payment Status',
            },
            {
                $Type : 'UI.DataField',
                Value : transactionId,
                Label : 'Transaction ID',
            },
        ],
    },
    UI.HeaderInfo : {
        TypeName : 'Payment',
        TypeNamePlural : 'Payments',
        Title : {
            $Type : 'UI.DataField',
            Value : order_ID,
        },
        Description : {
            $Type : 'UI.DataField',
            Value : transactionId,
        },
        TypeImageUrl : 'sap-icon://lead',
    },
);

annotate service.Payments with {
    order @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Orders',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : order_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'totalAmount',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'orderDate',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'paymentStatus',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'orderStatus',
            },
        ],
    }
};

