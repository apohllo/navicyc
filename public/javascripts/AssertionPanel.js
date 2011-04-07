var AssertionPanel = Ext.extend(Ext.Panel, {
    closable: true,
    autoScroll: true,
    layout: {
        type: 'border'
    },

    constructor: function(config){
      this.url = config['url'];
      this.name = config['name'];
      this.source = config['source'];
      this.id = config['id'];
      AssertionPanel.superclass.constructor.call(this,config);
    },

    initComponent: function () {
        Ext.apply(this, {
            items: [new AssertionTree({
                id: this.id + '_assertions',
                region: 'west',
                width: 300,
                split: true,
                margins: '0 5 5 0',
                name: this.name,
                source: this.source,
                item_id: this.id,
                root : {
                  nodeType: 'async',
                  text: 'assertions',
                  expanded: true,
                }
            }), {
                id: this.id + '_contents',
                region: 'center',
                split: true,
                margins: '0 5 5 0',
                autoScroll: true,
                autoLoad: {
                    url: this.url,
                    params: {
                        name: this.name,
                        source: this.source,
                        id: this.id
                    }
                }
            } ]
        });
        AssertionPanel.superclass.initComponent.call(this);
    },
    expandTree : function(){
        this.items.get(0).getRootNode().expand();
    }
});
