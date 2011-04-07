var AssertionTree = Ext.extend(Ext.tree.TreePanel, {
    animate:true,
    autoScroll:true,
    rootVisible:false,
    enableDD:true,
    containerScroll: true,
    border: false,
    dropConfig: {appendOnly:true},
    constructor: function(config){
        this.symbol = config['item_id'];
        url = baseUrl() + '/search/tree/'+ config['item_id'];
        this.loader = new Ext.tree.TreeLoader({dataUrl:url})
        this.loader.on("beforeload", function(treeLoader,node) {
            this.baseParams.level = node.attributes.level;
            this.baseParams.index = node.attributes.index;
            this.baseParams.relation = node.attributes.relation;
            this.baseParams.source = config['source'];
        });
        AssertionTree.superclass.constructor.call(this,config);
    },
    listeners :{
        click: function(node) {
            Ext.getCmp(this.symbol+"_contents").body.load({
                url: baseUrl() + '/search/show',
                params: {
                    source: node.attributes.source,
                    id: this.symbol,
                    index: node.attributes.index,
                    relation: node.attributes.relation,
                    mt: node.attributes.mt,
                    level: node.attributes.level
                }
            });
        }
    }
});
