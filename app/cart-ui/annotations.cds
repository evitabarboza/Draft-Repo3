// using EcommerceService as service from '../../srv/service';
// // annotate service.Cart with @(
// //     UI.FieldGroup #GeneratedGroup : {
// //         $Type : 'UI.FieldGroupType',
// //         Data : [
// //             {
// //                 $Type : 'UI.DataField',
// //                 Value : ID,
// //                 Label : 'ID',
// //             },
// //             {
// //                 $Type : 'UI.DataField',
// //                 Value : user_ID,
// //                 Label : 'user_ID',
// //             },
// //             {
// //                 $Type : 'UI.DataField',
// //                 Value : totalPrice,
// //                 Label : 'totalPrice',
// //             },
// //             {
// //                 $Type : 'UI.DataField',
// //                 Value : user.email,
// //                 Label : 'email',
// //             },
// //             {
// //                 $Type : 'UI.DataField',
// //                 Value : user.name,
// //                 Label : 'name',
// //             },
// //             {
// //                 $Type : 'UI.DataField',
// //                 Value : user.role,
// //                 Label : 'role',
// //             },
// //         ],
// //     },
// //     UI.Facets : [
// //         {
// //             $Type : 'UI.ReferenceFacet',
// //             ID : 'GeneratedFacet1',
// //             Label : 'General Information',
// //             Target : '@UI.FieldGroup#GeneratedGroup',
// //         },
// //     ],
// //     UI.LineItem : [
// //         {
// //             $Type : 'UI.DataField',
// //             Value : ID,
// //             Label : 'Cart ID',
// //         },
// //         {
// //             $Type : 'UI.DataField',
// //             Value : user.ID,
// //             Label : 'User ID',
// //         },
// //         {
// //             $Type : 'UI.DataField',
// //             Value : user.name,
// //             Label : 'Name',
// //         },
// //     ],
// //     UI.HeaderInfo : {
// //         TypeName : 'Cart',
// //         TypeNamePlural : 'Carts',
// //         Title : {
// //             $Type : 'UI.DataField',
// //             Value : user.name,
// //         },
// //         Description : {
// //             $Type : 'UI.DataField',
// //             Value : user.role,
// //         },
// //         TypeImageUrl : 'sap-icon://cart',
// //     },
// // );

// // annotate service.Cart with {
// //     user @Common.ValueList : {
// //         $Type : 'Common.ValueListType',
// //         CollectionPath : 'Users',
// //         Parameters : [
// //             {
// //                 $Type : 'Common.ValueListParameterInOut',
// //                 LocalDataProperty : user_ID,
// //                 ValueListProperty : 'ID',
// //             },
// //             {
// //                 $Type : 'Common.ValueListParameterDisplayOnly',
// //                 ValueListProperty : 'name',
// //             },
// //             {
// //                 $Type : 'Common.ValueListParameterDisplayOnly',
// //                 ValueListProperty : 'email',
// //             },
// //             {
// //                 $Type : 'Common.ValueListParameterDisplayOnly',
// //                 ValueListProperty : 'role',
// //             },
// //         ],
// //     }
// // };

// // annotate service.Users with {
// //     ID @(
// //         Common.ValueList : {
// //             $Type : 'Common.ValueListType',
// //             CollectionPath : 'Users',
// //             Parameters : [
// //                 {
// //                     $Type : 'Common.ValueListParameterInOut',
// //                     LocalDataProperty : ID,
// //                     ValueListProperty : 'ID',
// //                 },
// //             ],
// //         },
// //         Common.ValueListWithFixedValues : true,
// //         Common.Text : name,
// // )};


// // ─────────────────────────────────────────
// // CART — List Report + Object Page
// // ─────────────────────────────────────────

// annotate service.Cart with @(

//     UI.SelectionFields: [
//         user_ID
//     ],

//     UI.LineItem: [
//         { $Type: 'UI.DataField', Value: ID,          Label: 'Cart ID'     },
//         {
//             $Type : 'UI.DataField',
//             Value : user_ID,
//             Label : 'Customer ID',
//         },
//         { $Type: 'UI.DataField', Value: user.name,   Label: 'Customer'    },
//         { $Type: 'UI.DataField', Value: user.email,  Label: 'Email'       },
//         { $Type: 'UI.DataField', Value: totalPrice,  Label: 'Total (₹)'   },
//     ],

//     UI.HeaderInfo: {
//         TypeName:       'Cart',
//         TypeNamePlural: 'Carts',
//         Title:          { Value: user.name         },
//         Description:    { Value: user.role  },
//         TypeImageUrl : 'sap-icon://cart',
//     },

//     UI.Facets: [
//         {
//             $Type:  'UI.ReferenceFacet',
//             Label:  'Cart Info',
//             Target: '@UI.FieldGroup#CartInfo'
//         },
//         {
//             $Type:  'UI.ReferenceFacet',
//             Label:  'Cart Items',
//             Target: 'items/@UI.LineItem'
//         }
//     ],

//     UI.FieldGroup #CartInfo: {
//         Label: 'Cart Info',
//         Data: [
//             { $Type: 'UI.DataField', Value: ID,         Label: 'Cart ID'   },
//             {
//                 $Type : 'UI.DataField',
//                 Value : user_ID,
//                 Label : 'Customer ID',
//             },
//             { $Type: 'UI.DataField', Value: user.name,  Label: 'Customer Name'  },
//             { $Type: 'UI.DataField', Value: user.email, Label: 'Email'     },
//             { $Type: 'UI.DataField', Value: totalPrice, Label: 'Total (₹)' },
//         ]
//     }
// );

// // Cart Items — sub-table on Object Page
// annotate service.CartItems with @(
//     UI.LineItem: [
//         { $Type: 'UI.DataField', Value: product.name,     Label: 'Product'   },
//         { $Type: 'UI.DataField', Value: product.category, Label: 'Category'  },
//         { $Type: 'UI.DataField', Value: quantity,         Label: 'Qty'       },
//         { $Type: 'UI.DataField', Value: price,            Label: 'Price (₹)' }
//     ],
//     UI.Facets : [
//         {
//             $Type : 'UI.ReferenceFacet',
//             Label : 'General Information',
//             ID : 'GeneralInformation',
//             Target : '@UI.FieldGroup#GeneralInformation',
//         },
//     ],
//     UI.FieldGroup #GeneralInformation : {
//         $Type : 'UI.FieldGroupType',
//         Data : [
//             {
//                 $Type : 'UI.DataField',
//                 Value : product_ID,
//                 Label : 'Product ID',
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Value : product.name,
//                 Label : 'Product Name',
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Value : product.description,
//                 Label : 'Product Description',
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Value : product.price,
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Value : product.rating,
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Value : product.stock,
//                 Label : 'Stock',
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Value : product.status_code,
//                 Label : 'Status',
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Value : product.modifiedBy,
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Value : product.modifiedAt,
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Value : product.createdBy,
//             },
//         ],
//     },
//     UI.HeaderInfo : {
//         TypeName : 'Cart Item',
//         TypeNamePlural : 'Cart Items',
//         Title : {
//             $Type : 'UI.DataField',
//             Value : product.name,
//         },
//         Description : {
//             $Type : 'UI.DataField',
//             Value : product_ID
//         },
//         TypeImageUrl : 'sap-icon://cart-5',
//     },
// );

// annotate service.Cart with {
//     ID         @title: 'Cart ID';
//     totalPrice @title: 'Total Price (₹)';
// }
// annotate service.Cart with {
//     user @(
//         Common.ValueList : {
//             $Type : 'Common.ValueListType',
//             CollectionPath : 'Users',
//             Parameters : [
//                 {
//                     $Type : 'Common.ValueListParameterInOut',
//                     LocalDataProperty : user_ID,
//                     ValueListProperty : 'ID',
//                 },
//             ],
//         },
//         Common.ValueListWithFixedValues : true,
// )};

// annotate service.Users with {
//     ID @Common.Text : name
// };

// annotate service.Products with {
//     ID @(
//         Common.ValueList : {
//             $Type : 'Common.ValueListType',
//             CollectionPath : 'Products',
//             Parameters : [
//                 {
//                     $Type : 'Common.ValueListParameterInOut',
//                     LocalDataProperty : product_ID,   // 🔥 THIS ENTITY FIELD
//                     ValueListProperty : 'ID',         // 🔥 FROM PRODUCTS
//                 },
//                 {
//                     $Type : 'Common.ValueListParameterDisplayOnly',
//                     ValueListProperty : 'name',
//                 }
//             ],
//         },
//         Common.ValueListWithFixedValues : true,
//         Common.Text : name,
//         Common.FieldControl : #Mandatory,
// )};


using EcommerceService as service from '../../srv/service';
// annotate service.Cart with @(
//     UI.FieldGroup #GeneratedGroup : {
//         $Type : 'UI.FieldGroupType',
//         Data : [
//             {
//                 $Type : 'UI.DataField',
//                 Value : ID,
//                 Label : 'ID',
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Value : user_ID,
//                 Label : 'user_ID',
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Value : totalPrice,
//                 Label : 'totalPrice',
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Value : user.email,
//                 Label : 'email',
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Value : user.name,
//                 Label : 'name',
//             },
//             {
//                 $Type : 'UI.DataField',
//                 Value : user.role,
//                 Label : 'role',
//             },
//         ],
//     },
//     UI.Facets : [
//         {
//             $Type : 'UI.ReferenceFacet',
//             ID : 'GeneratedFacet1',
//             Label : 'General Information',
//             Target : '@UI.FieldGroup#GeneratedGroup',
//         },
//     ],
//     UI.LineItem : [
//         {
//             $Type : 'UI.DataField',
//             Value : ID,
//             Label : 'Cart ID',
//         },
//         {
//             $Type : 'UI.DataField',
//             Value : user.ID,
//             Label : 'User ID',
//         },
//         {
//             $Type : 'UI.DataField',
//             Value : user.name,
//             Label : 'Name',
//         },
//     ],
//     UI.HeaderInfo : {
//         TypeName : 'Cart',
//         TypeNamePlural : 'Carts',
//         Title : {
//             $Type : 'UI.DataField',
//             Value : user.name,
//         },
//         Description : {
//             $Type : 'UI.DataField',
//             Value : user.role,
//         },
//         TypeImageUrl : 'sap-icon://cart',
//     },
// );

// annotate service.Cart with {
//     user @Common.ValueList : {
//         $Type : 'Common.ValueListType',
//         CollectionPath : 'Users',
//         Parameters : [
//             {
//                 $Type : 'Common.ValueListParameterInOut',
//                 LocalDataProperty : user_ID,
//                 ValueListProperty : 'ID',
//             },
//             {
//                 $Type : 'Common.ValueListParameterDisplayOnly',
//                 ValueListProperty : 'name',
//             },
//             {
//                 $Type : 'Common.ValueListParameterDisplayOnly',
//                 ValueListProperty : 'email',
//             },
//             {
//                 $Type : 'Common.ValueListParameterDisplayOnly',
//                 ValueListProperty : 'role',
//             },
//         ],
//     }
// };

// annotate service.Users with {
//     ID @(
//         Common.ValueList : {
//             $Type : 'Common.ValueListType',
//             CollectionPath : 'Users',
//             Parameters : [
//                 {
//                     $Type : 'Common.ValueListParameterInOut',
//                     LocalDataProperty : ID,
//                     ValueListProperty : 'ID',
//                 },
//             ],
//         },
//         Common.ValueListWithFixedValues : true,
//         Common.Text : name,
// )};


// ─────────────────────────────────────────
// CART — List Report + Object Page
// ─────────────────────────────────────────

annotate service.Cart with @(

    UI.SelectionFields     : [user_ID],

    UI.LineItem            : [
        {
            $Type: 'UI.DataField',
            Value: ID,
            Label: 'Cart ID'
        },
        {
            $Type: 'UI.DataField',
            Value: user_ID,
            Label: 'Customer ID',
        },
        {
            $Type: 'UI.DataField',
            Value: user.name,
            Label: 'Customer'
        },
        {
            $Type: 'UI.DataField',
            Value: user.email,
            Label: 'Email'
        },
        {
            $Type: 'UI.DataField',
            Value: totalPrice,
            Label: 'Total (₹)'
        },
        // {
        //     $Type : 'UI.DataFieldForAction',
        //     Action: 'checkoutCart',
        //     Label : 'Order Now'
        // },
        // {
        //     $Type         : 'UI.DataFieldForIntentBasedNavigation',
        //     SemanticObject: 'Orders',
        //     Action        : 'display',
        //     Label         : 'View Orders'
        // },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'EcommerceService.checkoutCart',
            Label : 'Order Now',
        },
        {
            $Type : 'UI.DataFieldForActionGroup',
            Actions : [
                {
                    $Type : 'UI.DataFieldForAction',
                    Action : 'EcommerceService.EntityContainer/addToCart',
                    Label : 'Add to Cart',
                },
                {
                    $Type : 'UI.DataFieldForAction',
                    Action : 'EcommerceService.EntityContainer/updateCartItem',
                    Label : 'Update Cart Item',
                },
                {
                    $Type : 'UI.DataFieldForAction',
                    Action : 'EcommerceService.EntityContainer/removeFromCart',
                    Label : 'Remove From Cart',
                },
            ],
            ID : 'ActionMenu',
            Label : 'Modify Cart',
        },
    ],

    // UI.Identification      : [
    //     {
    //         $Type : 'UI.DataFieldForAction',
    //         Action: 'checkoutCart',
    //         Label : 'Order Now'
    //     },
    //     {
    //         $Type         : 'UI.DataFieldForIntentBasedNavigation',
    //         SemanticObject: 'Orders',
    //         Action        : 'display',
    //         Label         : 'View Orders'
    //     }
    // ],

    Common.SideEffects     : {
        $Type           : 'Common.SideEffectsType',
        SourceEntities  : [items],
        TargetEntities  : ['_it'],
        TargetProperties: ['totalPrice'],
        Effects         : [{
            $Type           : 'Common.EffectType',
            SourceProperties: [
                'quantity',
                'price'
            ],
            TargetProperties: ['totalPrice']
        }],
        Actions         : [{
            Action          : 'checkoutCart',
            TargetEntities  : ['_it'],
            TargetProperties: ['*']
        }]
    },

    UI.HeaderInfo          : {
        TypeName      : 'Cart',
        TypeNamePlural: 'Carts',
        Title         : {Value: user.name},
        Description   : {Value: user.role},
        TypeImageUrl  : 'sap-icon://cart',
    },

    UI.Facets              : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Cart Info',
            Target: '@UI.FieldGroup#CartInfo'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Cart Items',
            Target: 'items/@UI.LineItem'
        }
    ],

    UI.FieldGroup #CartInfo: {
        Label: 'Cart Info',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: ID,
                Label: 'Cart ID'
            },
            {
                $Type: 'UI.DataField',
                Value: user_ID,
                Label: 'Customer ID',
            },
            {
                $Type: 'UI.DataField',
                Value: user.name,
                Label: 'Customer Name'
            },
            {
                $Type: 'UI.DataField',
                Value: user.email,
                Label: 'Email'
            },
            {
                $Type: 'UI.DataField',
                Value: totalPrice,
                Label: 'Overall Price (₹)',
            },
        ]
    }
);

// Cart Items — sub-table on Object Page
annotate service.CartItems with @(
    UI.LineItem                      : [
        {
            $Type: 'UI.DataField',
            Value: product.name,
            Label: 'Product'
        },
        {
            $Type: 'UI.DataField',
            Value: product.category,
            Label: 'Category'
        },
        {
            $Type: 'UI.DataField',
            Value: cart.items.quantity,
            Label: 'Quantity',
        },
        {
            $Type: 'UI.DataField',
            Value: product.price,
            Label: 'Price',
        },
        {
            $Type: 'UI.DataField',
            Value: lineTotal,
            Label: 'Total Price',
        },
    ],
    UI.Facets                        : [{
        $Type : 'UI.ReferenceFacet',
        Label : 'General Information',
        ID    : 'GeneralInformation',
        Target: '@UI.FieldGroup#GeneralInformation',
    }, ],
    UI.FieldGroup #GeneralInformation: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: product_ID,
                Label: 'Product ID',
            },
            {
                $Type: 'UI.DataField',
                Value: product.name,
                Label: 'Product Name',
            },
            {
                $Type: 'UI.DataField',
                Value: product.description,
                Label: 'Product Description',
            },
            {
                $Type: 'UI.DataField',
                Value: product.price,
            },
            {
                $Type: 'UI.DataField',
                Value: product.rating,
            },
            {
                $Type: 'UI.DataField',
                Value: product.stock,
                Label: 'Stock',
            },
            {
                $Type: 'UI.DataField',
                Value: product.status_code,
                Label: 'Status',
            },
            {
                $Type: 'UI.DataField',
                Value: cart.items.quantity,
                Label: 'Quantity',
            },
            {
                $Type: 'UI.DataField',
                Value: product.modifiedBy,
            },
            {
                $Type: 'UI.DataField',
                Value: product.modifiedAt,
            },
            {
                $Type: 'UI.DataField',
                Value: product.createdBy,
            },
            {
                $Type: 'UI.DataField',
                Value: lineTotal,
                Label: 'Total Price ',
            },
        ],
    },
    UI.HeaderInfo                    : {
        TypeName      : 'Cart Item',
        TypeNamePlural: 'Cart Items',
        Title         : {
            $Type: 'UI.DataField',
            Value: product.name,
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: product_ID
        },
        TypeImageUrl  : 'sap-icon://cart-5',
    },
);

annotate service.Cart with {
    ID         @title: 'Cart ID';
    totalPrice @title: 'Total Price (₹)';
}

annotate service.Cart with {
    user @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Users',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: user_ID,
                ValueListProperty: 'ID',
            }, ],
        },
        Common.ValueListWithFixedValues: true,
    )
};

annotate service.Users with {
    ID @Common.Text: name
};

annotate service.Products with {
    ID @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Products',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: product_ID, // 🔥 THIS ENTITY FIELD
                    ValueListProperty: 'ID',
                    // 🔥 FROM PRODUCTS
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                }
            ],
        },
        Common.ValueListWithFixedValues: true,
        Common.Text                    : name,
        Common.FieldControl            : #Mandatory,
    )
};

annotate service.CartItems with {
    product @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Products',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: product_ID,
                ValueListProperty: 'ID',
            }, ],
        },
        Common.ValueListWithFixedValues: true,
    )
};
