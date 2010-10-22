Ext.BLANK_IMAGE_URL = 'stylesheets/images/default/s.gif';

Ext.onReady(function() {
    Ext.QuickTips.init();

    var symbolPanel = new SymbolPanel();
    var mainPanel = new MainPanel();
    var myData = [];

    symbolPanel.store.loadData(myData);
    symbolPanel.on('show_element', function(symbol, type) {
        mainPanel.showSymbolTab(symbol, type);
    });
    mainPanel.on('element_loaded', function(symbol, type) {
        symbolPanel.addToStore(symbol, type);
    });
    //mainPanel.items.get(0).expandTree();

    var viewport = new Ext.Viewport({
        layout: 'border',
        items: [
            {
                height: 30,
                region: 'north',
                xtype: 'box',
                el: 'header',
                border: false,
                margins: '0 0 5 0'
            },
            symbolPanel,
            mainPanel
        ]
    });

    viewport.doLayout();
    symbolPanel.focusSearchField();
});
