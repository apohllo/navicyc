var ApiPanel = Ext.extend(Ext.Panel, {
    layout: {
        type: 'border'
    },
    initComponent: function() {
        Ext.apply(this, {
            items: [new ApiTree({
                    region: 'west',
                    width: 400,
                    split: true,
                    margins: '0 5 5 0',
                    autoScroll: true
                }), new Ext.Panel({
                    id: 'api_contents',
                    region: 'center',
                    split: true,
                    margins: '0 5 5 0',
                    autoScroll: true,
                })
            ]
        });
        ApiPanel.superclass.initComponent.call(this);
    },
});

