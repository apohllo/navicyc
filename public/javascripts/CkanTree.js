var CkanTree = Ext.extend(Ext.tree.TreePanel, {
    containerScroll: true,
    rootVisible: false,
    animate: false,
    constructor: function(config){
        url = baseUrl() + '/ckan/node';
        this.loader = new Ext.tree.TreeLoader({dataUrl:url});
        this.loader.on("beforeload", function(treeLoader,node) {
            this.baseParams.type = node.attributes.type;
            this.baseParams.text = node.attributes.text;
            this.baseParams.id = node.attributes.id;
        });
        CkanTree.superclass.constructor.call(this,config);
    },
    listeners: {
        click: function(node) {
            Ext.getCmp("ckan_contents").body.load({
                url: baseUrl() + '/ckan/show',
                params: {
                    type: node.attributes.type,
                    text: node.attributes.text,
                    id: node.attributes.id
                }
            });
        }
    },
    root: {
        nodeType: 'async',
        text: 'CKAN',
        type: 'root',
        expanded: true
    }
});

