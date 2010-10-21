var AssertionTree = Ext.extend(Ext.tree.TreePanel, {
    animate:true,
    autoScroll:true,
    rootVisible:false,
    constructor: function(config){
        this.symbol = config['symbol'];
        url = 'symbol/assertions/'+config['symbol'];
        this.loader = new Ext.tree.TreeLoader({dataUrl:url})
        this.loader.on("beforeload", function(treeLoader,node) {
            this.baseParams.type = node.attributes.type;
            this.baseParams.index = node.attributes.index;
            this.baseParams.relation = node.attributes.relation;
        });
        AssertionTree.superclass.constructor.call(this,config);
    },
    enableDD:true,
    containerScroll: true,
    border: false,
    dropConfig: {appendOnly:true},
    root : {
        nodeType: 'async',
        text: 'assertions',
        expanded: true,
    },
    listeners :{
        click: function(node) {
            Ext.get("tab-"+this.symbol+"_contents").getUpdater().update({
                url: 'symbol/assertions',
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
