var MainPanel = function() {
    this.api_panel = new ApiPanel({
            id: 'api-panel',
            title: 'NaviCyc API',
            autoScroll: true
        });
    this.ckan_panel = new CkanPanel({
            id: 'ckan-panel',
            title: 'CKAN',
            autoScroll: true
        });
    MainPanel.superclass.constructor.call(this, {
        region: 'center',
        margins: '0 5 5 0',
        resizeTabs: true,
        minTabWidth: 135,
        tabWidth: 135,
        plugins: new Ext.ux.TabCloseMenu(),
        enableTabScroll: true,
        activeTab: 0,
        tabprefix: 'tab-',
        items: [this.api_panel, this.ckan_panel]
    });
};

Ext.extend(MainPanel, Ext.TabPanel, {
    initEvents: function() {
        MainPanel.superclass.initEvents.call(this);
        this.body.on('click', this.onClick, this);
    },

    onClick: function(e, target) {
        if (target.localName == 'a') {
          if(target.className == 'symbol'){
            this.showSymbolTab(target.innerHTML, 'symbol', target.innerHTML);
          }
        }
        e.stopEvent();
    },
    showSymbolTab: function(symbol, type, id) {
        if(type == 'symbol'){
          if (this.isSymbolLoaded(symbol)) {
              this.setActiveSymbol(symbol);
          } else {
              this.addSymbolTab(symbol, type, id);
          }
        } else if(type == 'api'){
          this.setActiveTab(this.api_panel);
          this.api_panel.tree.loadContents("function_id",id);
        } else if(type == 'ckan'){
          this.setActiveTab(this.ckan_panel);
          this.ckan_panel.tree.loadContents("package_id",symbol,id);
        }
    },
    isSymbolLoaded: function(symbol) {
        var tabId = this.tabprefix + symbol;
        var tab = this.getComponent(tabId);
        if (tab) {
            return true;
        }
        else {
            return false;
        }
    },
    setActiveSymbol: function(symbol) {
        var tabId = this.tabprefix + symbol;
        var tab = this.getComponent(tabId);
        this.setActiveTab(tab);
    },
    addSymbolTab: function(name, type, id) {
        if (!(type === 'symbol' || type === 'api' || type === 'ckan'
              || type === 'dbpedia')) {
          return;
        }
        var newPanel = this.add(new DocPanel({
            id: this.tabprefix + name,
            title: name,
            url: baseUrl() + "/search/show/",
            name: name,
            type: type,
            id: id
        }));
        this.setActiveTab(newPanel);
        this.fireEvent('element_loaded', name, type, id);
    }
});
