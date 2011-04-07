var ApiTree = Ext.extend(Ext.tree.TreePanel, {
    containerScroll: true,
    rootVisible: false,
    animate: false,
    constructor: function(config){
        url = baseUrl() + '/api/tree';
        this.loader = new Ext.tree.TreeLoader({dataUrl:url});
        this.loader.on("beforeload", function(treeLoader,node) {
            this.baseParams.level = node.attributes.level;
            this.baseParams.text = node.attributes.text;
        });
        ApiTree.superclass.constructor.call(this,config);
    },
    listeners: {
        click: function(node) {
                 this.loadContents(node.attributes.level,node.attributes.text);
        }
    },
    root: {
        nodeType: 'async',
        text: 'API',
        level: 'root',
        expanded: true
    },
    loadContents: function(level,text){
            Ext.getCmp("api_contents").body.load({
                url: baseUrl() + '/api/show',
                params: {
                    level: level,
                    text: text
                }
            });
    }
});
