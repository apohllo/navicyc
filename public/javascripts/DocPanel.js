var DocPanel = Ext.extend(Ext.Panel, {
    closable: true,
    autoScroll: true,
    layout: {
        type: 'border'
    },

    constructor: function(config){
      this.url = config['url'];
      this.symbol = config['symbol'];
      DocPanel.superclass.constructor.call(this,config);
    },

    initComponent: function () {
        Ext.apply(this, {
            items: [new AssertionTree({
                id: this.id + '_assertions',
                region: 'west',
                width: 200,
                split: true,
                margins: '0 5 5 0',
                symbol: this.symbol,
                root : {
                  nodeType: 'async',
                  text: 'assertions',
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
                        name: this.symbol
                    }
                }
            } ]
        });
        DocPanel.superclass.initComponent.call(this);
    },
    expandTree : function(){
        this.items.get(0).getRootNode().expand();
    }
});
