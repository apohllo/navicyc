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
    this.console_panel = new ConsolePanel({
            id: 'console-panel',
            title: 'SubL console',
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
        items: [this.api_panel, this.ckan_panel, this.console_panel]
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
    showSymbolTab: function(symbol, source, id) {
        if(source == 'symbol'){
          if (this.isResourceLoaded(symbol)) {
              this.setActiveResource(symbol);
          } else {
              this.addResourceTab(symbol, source, id);
          }
        } else if(source == 'api'){
          this.setActiveTab(this.api_panel);
          this.api_panel.tree.loadContents("function_id",id);
        } else if(source == 'ckan'){
          this.setActiveTab(this.ckan_panel);
          this.ckan_panel.tree.loadContents("package_id",symbol,id);
        } else if(source == 'sparql'){
          if (this.isResourceLoaded(id)) {
              this.setActiveResource(id);
          } else {
              this.addResourceTab(symbol, source, id);
          }
        }
    },
    isResourceLoaded: function(id) {
        var tabId = this.tabprefix + id;
        var tab = this.getComponent(tabId);
        if (tab) {
            return true;
        } else {
            return false;
        }
    },
    setActiveResource: function(id) {
        var tabId = this.tabprefix + id;
        var tab = this.getComponent(tabId);
        this.setActiveTab(tab);
    },
    addResourceTab: function(name, source, id) {
        if (!(source === 'symbol' || source === 'sparql')) {
          return;
        }
        var newPanel = this.add(new AssertionPanel({
            id: this.tabprefix + id,
            title: name,
            url: baseUrl() + "/search/show/",
            name: name,
            source: source,
            id: id
        }));
        this.setActiveTab(newPanel);
        this.fireEvent('element_loaded', name, source, id);
    }
});
