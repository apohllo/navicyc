var DocPanel = Ext.extend(Ext.Panel, {
    closable: true,
    autoScroll: true,
    layout: {
        type: 'border'
    },

    constructor: function(config){
      this.url = config['url'];
      this.name = config['name'];
      this.type = config['type'];
      this.id = config['id'];
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
                name: this.name,
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
                        name: this.name,
                        type: this.type,
                        id: this.id
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
