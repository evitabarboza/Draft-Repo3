using EcommerceService as service from '../../srv/service';

// ─────────────────────────────────────────
// ORDERS — List Report + Object Page
// ─────────────────────────────────────────
annotate service.Orders with @(

    UI.SelectionFields: [
        orderDate
    ],

    UI.LineItem: [
        { $Type: 'UI.DataField', Value: ID,            Label: 'Order ID'       },
        { $Type: 'UI.DataField', Value: user.name,     Label: 'Customer'       },
        { $Type: 'UI.DataField', Value: orderDate,     Label: 'Order Date'     },
        { $Type: 'UI.DataField', Value: totalAmount,   Label: 'Total (₹)'      },
        { $Type: 'UI.DataField', Value: orderStatus,   Label: 'Order Status'   },
        { $Type: 'UI.DataField', Value: paymentStatus, Label: 'Payment'        },
    ],

    UI.HeaderInfo: {
        TypeName:       'Order',
        TypeNamePlural: 'Orders',
        Title:       { $Type: 'UI.DataField', Value: user.name          },
        Description: { $Type: 'UI.DataField', Value: orderStatus },
        TypeImageUrl: 'sap-icon://sales-order',
    },

    UI.Facets: [
        {
            $Type:  'UI.ReferenceFacet',
            Label:  'Order Summary',
            ID:     'OrderSummary',
            Target: '@UI.FieldGroup#Summary'
        },
        {
            $Type:  'UI.ReferenceFacet',
            Label:  'Order Items',
            ID:     'OrderItemsFacet',
            Target: 'items/@UI.LineItem'    // ← navigates via composition to OrderItems
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Payment Details',
            ID : 'PaymentDetails',
            Target : '@UI.FieldGroup#PaymentDetails',
        },
    ],

    UI.FieldGroup #Summary: {
        Label: 'Order Summary',
        Data: [
            { $Type: 'UI.DataField', Value: ID,            Label: 'Order ID'       },
            {
                $Type : 'UI.DataField',
                Value : user.ID,
                Label : 'Customer ID',
            },
            { $Type: 'UI.DataField', Value: user.name,     Label: 'Customer Name'  },
            { $Type: 'UI.DataField', Value: user.email,    Label: 'Email'          },
            { $Type: 'UI.DataField', Value: totalAmount,   Label: 'Total (₹)'      },
            { $Type: 'UI.DataField', Value: orderDate,     Label: 'Order Date'     },
            { $Type: 'UI.DataField', Value: orderStatus,   Label: 'Order Status'   },
            { $Type: 'UI.DataField', Value: paymentStatus, Label: 'Payment Status' },
        ]
    },
    UI.FieldGroup #PaymentDetails : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : ID,
            },
            {
                $Type : 'UI.DataField',
                Value : user_ID,
                Label : 'User ID',
            },
            {
                $Type : 'UI.DataField',
                Value : user.email,
                Label : 'Email',
            },
            {
                $Type : 'UI.DataField',
                Value : orderDate,
            },
            {
                $Type : 'UI.DataField',
                Value : totalAmount,
            },
            {
                $Type : 'UI.DataField',
                Value : paymentStatus,
            },
            {
                $Type : 'UI.DataField',
                Value : payment.ID,
                Label : 'ID',
            },
            {
                $Type : 'UI.DataField',
                Value : payment.transactionId,
                Label : 'transactionId',
            },
        ],
    },
);

// ─────────────────────────────────────────
// ORDER ITEMS — MUST be a separate top-level
// annotate block for 'items/@UI.LineItem'
// to resolve correctly
// ─────────────────────────────────────────
annotate service.OrderItems with @(

    UI.LineItem: [
        {
            $Type : 'UI.DataField',
            Value : product.ID,
            Label : 'Product ID',
        },
        {
            $Type : 'UI.DataField',
            Value : product.name,
            Label : 'Product Name',
        },
        {
            $Type : 'UI.DataField',
            Value : product.price,
        },
        {
            $Type : 'UI.DataField',
            Value : order.items.quantity,
            Label : 'Quantity',
        },
        {
            $Type : 'UI.DataField',
            Value : lineTotal,
            Label : 'Total Price',
        }
    ],

    UI.HeaderInfo: {
        TypeName:       'Order Item',
        TypeNamePlural: 'Order Items',
        Title:       { $Type: 'UI.DataField', Value: product.name },
        Description: { $Type: 'UI.DataField', Value: product_ID   },
        TypeImageUrl: 'sap-icon://product',
    },

    UI.Facets: [
        {
            $Type:  'UI.ReferenceFacet',
            Label:  'Item Details',
            ID:     'ItemDetails',
            Target: '@UI.FieldGroup#ItemDetails',
        }
    ],

    UI.FieldGroup #ItemDetails: {
        $Type: 'UI.FieldGroupType',
        Data: [
            { $Type: 'UI.DataField', Value: product_ID,          Label: 'Product ID'          },
            { $Type: 'UI.DataField', Value: product.name,        Label: 'Product Name'        },
            { $Type: 'UI.DataField', Value: product.description, Label: 'Product Description' },
            { $Type: 'UI.DataField', Value: product.category,    Label: 'Category'            },
            { $Type: 'UI.DataField', Value: quantity,            Label: 'Quantity'            },
            { $Type: 'UI.DataField', Value: price,               Label: 'Unit Price (₹)'      },
        ]
    }
);

// ─────────────────────────────────────────
// FIELD TITLES & VALUE HELPS
// ─────────────────────────────────────────
annotate service.Orders with {
    ID            @title: 'Order ID';
    totalAmount   @title: 'Total Amount (₹)';
    orderDate     @title: 'Order Date';
    orderStatus   @(
        title: 'Order Status',
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Orders',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : orderStatus,
                    ValueListProperty : 'orderStatus',
                },
            ],
        },
        Common.ValueListWithFixedValues : true,
    );
    paymentStatus @(
        title: 'Payment Status',
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Payments',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : paymentStatus,
                    ValueListProperty : 'status',
                },
            ],
        },
        Common.ValueListWithFixedValues : true,
    );
    user          ;
};

annotate service.OrderItems with {
    product @(
        Common.Text:            product.name,
        Common.TextArrangement: #TextOnly
    );
};
annotate service.Orders with {
    user @(
        Common.Text : user.name,
        Common.Text.@UI.TextArrangement : #TextFirst,
    )
};

