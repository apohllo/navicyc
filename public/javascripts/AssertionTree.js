var AssertionTree = Ext.extend(Ext.tree.TreePanel, {
    animate:true,
    autoScroll:true,
    rootVisible:false,
    enableDD:true,
    containerScroll: true,
    border: false,
    dropConfig: {appendOnly:true},
    root : {
        nodeType: 'async',
        text: 'assertions',
        expanded: true,
    },
    constructor: function(config){
        this.symbol = config['symbol'];
        url = document.location.href + 'symbol/assertion_tree/'+config['symbol'];
        this.loader = new Ext.tree.TreeLoader({dataUrl:url})
        this.loader.on("beforeload", function(treeLoader,node) {
            this.baseParams.type = node.attributes.type;
            this.baseParams.index = node.attributes.index;
            this.baseParams.relation = node.attributes.relation;
        });
        AssertionTree.superclass.constructor.call(this,config);
    },
    listeners :{
        click: function(node) {
            Ext.getCmp("tab-"+this.symbol+"_contents").body.load({
                url: document.location.href + 'symbol/assertions',
                params: {
                    type: node.attributes.type,
                    id: this.symbol,
                    index: node.attributes.index,
                    relation: node.attributes.relation,
                    mt: node.attributes.mt,
                }
            });
        }
    }
});
