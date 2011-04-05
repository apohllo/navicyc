var CkanPanel = Ext.extend(Ext.Panel, {
    layout: {
        type: 'border'
    },
    initComponent: function() {
        this.tree = new CkanTree({
                    region: 'west',
                    width: 400,
                    split: true,
                    margins: '0 5 5 0',
                    autoScroll: true
                });
        this.contents = new Ext.Panel({
                    id: 'ckan_contents',
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


