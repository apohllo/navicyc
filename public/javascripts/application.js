function baseUrl(){
  var str = document.location.href;
  if(str.charAt(str.length-1) == "/"){
    str = str.slice(0,str.length-1);
  }
  return str;
}

Ext.BLANK_IMAGE_URL = baseUrl() + '/stylesheets/images/default/s.gif';

Ext.onReady(function() {
    Ext.QuickTips.init();

    var searchPanel = new SearchPanel();
    var mainPanel = new MainPanel();
    var myData = [];

    searchPanel.symbolPanel.store.loadData(myData);
    searchPanel.searchForm.on('show_element', function(symbol, source, id) {
        mainPanel.showSymbolTab(symbol, source, id);
    });
    mainPanel.on('element_loaded', function(symbol, source, id) {
        searchPanel.symbolPanel.addToStore(symbol, source, id);
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
            searchPanel,
            mainPanel
        ]
    });

    viewport.doLayout();
    //symbolPanel.focusSearchField();
});
