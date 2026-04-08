using EcommerceService as service from '../../srv/service';
annotate service.Users with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : ID,
                Label : 'ID',
            },
            {
                $Type : 'UI.DataField',
                Label : 'Name',
                Value : name,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Email',
                Value : email,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Role',
                Value : role,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : ID,
            Label : 'ID',
        },
        {
            $Type : 'UI.DataField',
            Label : 'Name',
            Value : name,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Email',
            Value : email,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Role',
            Value : role,
        },
        {
            $Type : 'UI.DataFieldForActionGroup',
            Actions : [
                {
                    $Type : 'UI.DataFieldForAction',
                    Action : 'EcommerceService.EntityContainer/loginUser',
                    Label : 'Login User',
                },
                {
                    $Type : 'UI.DataFieldForAction',
                    Action : 'EcommerceService.EntityContainer/registerUser',
                    Label : 'Register User',
                },
            ],
            ID : 'UserActions',
            Label : 'User Actions',
        },
    ],
    UI.HeaderInfo : {
        TypeName : 'User',
        TypeNamePlural : 'Users',
        Title : {
            $Type : 'UI.DataField',
            Value : name,
        },
        Description : {
            $Type : 'UI.DataField',
            Value : role,
        },
        TypeImageUrl : 'sap-icon://customer',
    },
);

