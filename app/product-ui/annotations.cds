using EcommerceService as service from '../../srv/service';
annotate service.Products with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : ID,
                Label : 'Product ID',
            },
            {
                $Type : 'UI.DataField',
                Label : 'Product Name',
                Value : name,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Description',
                Value : description,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Price',
                Value : price,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Stock',
                Value : stock,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Category',
                Value : category,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Image URL',
                Value : imageUrl,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Rating',
                Value : rating,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Status',
                Value : status_code,
                Criticality : status.criticality,
                CriticalityRepresentation : #WithIcon,
            },
            {
                $Type : 'UI.DataField',
                Value : createdAt,
            },
            {
                $Type : 'UI.DataField',
                Value : createdBy,
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
            Label : 'Name',
            Value : name,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Description',
            Value : description,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Price (₹)',
            Value : price,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Category',
            Value : category,
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Target : '@UI.Chart#stock',
            Label : 'Stock',
        },
    ],
    UI.DataPoint #stock : {
        Value : stock,
        MinimumValue : 0,
        MaximumValue : 100,
    },
    UI.Chart #stock : {
        ChartType : #Bullet,
        Measures : [
            stock,
        ],
        MeasureAttributes : [
            {
                DataPoint : '@UI.DataPoint#stock',
                Role : #Axis1,
                Measure : stock,
            },
        ],
    },
    UI.HeaderInfo : {
        TypeName : 'Product',
        TypeNamePlural : 'Products',
        Title : {
            $Type : 'UI.DataField',
            Value : name,
        },
        Description : {
            $Type : 'UI.DataField',
            Value : price,
        },
        TypeImageUrl : 'sap-icon://product',
    },
    UI.SelectionFields : [
        price,
        rating,
    ],
);

annotate service.Products with {
    status @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'ProductStatus',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : status_code,
                ValueListProperty : 'code',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'criticality',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'displayText',
            },
        ],
    }
};

annotate service.Products with {
    status_code @(
        Common.FieldControl : #ReadOnly,
        Common.Text : status.displayText,
        Common.Text.@UI.TextArrangement : #TextFirst,
    )
};

annotate service.Products with {
    price @Common.Label : 'Price'
};

annotate service.Products with {
    rating @(
        Common.Label : 'Ratings',
        )
};

