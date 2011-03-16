var MainPanel = function() {
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

        items: [new ApiPanel({
            id: 'api-panel',
            title: 'NaviCyc API',
            autoScroll: true
        })]
    });
};

Ext.extend(MainPanel, Ext.TabPanel, {
    initEvents: function() {
        MainPanel.superclass.initEvents.call(this);
        this.body.on('click', this.onClick, this);
    },

    onClick: function(e, target) {
        if (target.localName == 'a') {
            this.showSymbolTab(target.innerHTML, 'symbol');
        }
        e.stopEvent();
    },
    showSymbolTab: function(symbol, type) {
        if (this.isSymbolLoaded(symbol)) {
            this.setActiveSymbol(symbol);
        } else {
            this.addSymbolTab(symbol, type);
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
    addSymbolTab: function(symbol, type) {
        var url;
        if (type === 'symbol') {
            url = "/symbol/show";
        } else {
            url = "/symbol/show_denotation/";
        }
        url = document.location.href + url;
        var newPanel = this.add(new DocPanel({
            id: this.tabprefix + symbol,
            title: symbol,
            url: url,
            symbol: symbol
        }));
        this.setActiveTab(newPanel);
        this.fireEvent('element_loaded', symbol, type);
    }
});
