var ApiPanel = Ext.extend(Ext.Panel, {
    layout: {
        type: 'border'
    },
    initComponent: function() {
        this.tree = new ApiTree({
                    region: 'west',
                    width: 300,
                    split: true,
                    margins: '0 5 5 0',
                    autoScroll: true
                });
        this.contents = new Ext.Panel({
                    id: 'api_contents',
                    region: 'center',
                    split: true,
                    margins: '0 5 5 0',
                    autoScroll: true,
                });
        Ext.apply(this, {
            items: [this.tree, this.contents]
        });
        ApiPanel.superclass.initComponent.call(this);
    },
});

