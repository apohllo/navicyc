var ApiTree = Ext.extend(Ext.tree.TreePanel, {
    containerScroll: true,
    rootVisible: false,
    animate: false,
    constructor: function(config){
        url = document.location.href + '/api/node';
        this.loader = new Ext.tree.TreeLoader({dataUrl:url});
        this.loader.on("beforeload", function(treeLoader,node) {
            this.baseParams.type = node.attributes.type;
            this.baseParams.text = node.attributes.text;
        });
        ApiTree.superclass.constructor.call(this,config);
    },
    listeners: {
        click: function(node) {
            Ext.getCmp("api_contents").body.load({
                url: document.location.href + '/api/show',
                params: {
                    type: node.attributes.type,
                    text: node.attributes.text
                }
            });
        }
    },
    root: {
        nodeType: 'async',
        text: 'API',
        type: 'root',
        expanded: true
    }
});
