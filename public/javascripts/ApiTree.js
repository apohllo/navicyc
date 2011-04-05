var ApiTree = Ext.extend(Ext.tree.TreePanel, {
    containerScroll: true,
    rootVisible: false,
    animate: false,
    constructor: function(config){
        url = baseUrl() + '/api/node';
        this.loader = new Ext.tree.TreeLoader({dataUrl:url});
        this.loader.on("beforeload", function(treeLoader,node) {
            this.baseParams.type = node.attributes.type;
            this.baseParams.text = node.attributes.text;
        });
        ApiTree.superclass.constructor.call(this,config);
    },
    listeners: {
        click: function(node) {
                 this.loadContents(node.attributes.type,node.attributes.text);
        }
    },
    root: {
        nodeType: 'async',
        text: 'API',
        type: 'root',
        expanded: true
    },
    loadContents: function(type,text){
            Ext.getCmp("api_contents").body.load({
                url: baseUrl() + '/api/show',
                params: {
                    type: type,
                    text: text
                }
            });
    }
});
