var CkanTree = Ext.extend(Ext.tree.TreePanel, {
    containerScroll: true,
    rootVisible: false,
    animate: false,
    constructor: function(config){
        url = baseUrl() + '/ckan/node';
        this.loader = new Ext.tree.TreeLoader({dataUrl:url});
        this.loader.on("beforeload", function(treeLoader,node) {
            this.baseParams.level = node.attributes.level;
            this.baseParams.text = node.attributes.text;
            this.baseParams.id = node.attributes.id;
        });
        CkanTree.superclass.constructor.call(this,config);
    },
    listeners: {
        click: function(node) {
                 this.loadContents(node.attributes.level,
                   node.attributes.text,node.attributes.id);
        }
    },
    root: {
        nodeType: 'async',
        text: 'CKAN',
        level: 'root',
        expanded: true
    },
    loadContents: function(level,text,id){
            Ext.getCmp("ckan_contents").body.load({
                url: baseUrl() + '/ckan/show',
                params: {
                    level: level,
                    text: text,
                    id: id
                }
            });
    }

});

