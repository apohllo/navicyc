var SymbolPanel = function() {
    SymbolPanel.superclass.constructor.call(this, {
      minSize: 175,
    });
};

Ext.extend(SymbolPanel, Ext.grid.GridPanel, {
    initComponent: function() {
        var that = this;
        Ext.apply(this, {
            store: new Ext.data.ArrayStore({
                fields: [
                    'name',
                    'source',
                    'id'
                ]
            }),
            columns: [
                {
                    id: 'name',
                    header: 'Symbol',
                    dataIndex: 'name'
                }
            ],
            autoExpandColumn: 'name',
            enableHdMenu: false,
            tbar: [],
            listeners: {
                cellclick: function(grid, rowIndex) {
                    var record = grid.getStore().getAt(rowIndex);
                    var name = record.get('name');
                    var source = record.get('source');
                    var id = record.get('id');
                    that.fireEvent('show_element', name, source, id);
                }
            }
        });
        SymbolPanel.superclass.initComponent.call(this);
    },
    addToStore: function(name, source, id) {
        if (this.store.findExact('name', name) === -1) {
            this.store.insert(0, new Ext.data.Record({
                name:name,
                source:source,
                id:id
            }));
        }
    },
    focusSearchField: function() {
        this.searchCombo.focus();
    }
});

var SearchForm = Ext.extend(Ext.form.FormPanel, {
    title: 'Search',
    labelWidth: 50,
    labelSeparator: ' ',
    hideLabels: false,
    labelAlign: 'right',
    initComponent: function() {
        var that = this;
        this.searchCombo = new Ext.form.ComboBox({
            store: new Ext.data.JsonStore({
                root: 'data',
                fields: ['name'],
                url: baseUrl() + '/search/complete/',
                listeners:
                { beforeload:
                  function(store, options){
                    store.url = baseUrl() + '/' +
                      that.searchGroup.getValue().inputValue + '/complete';
                    store.baseParams.source = that.searchGroup.getValue().inputValue;
                  }
                }

            }),
            displayField: 'name',
            autoWidth: true,
            emptyText: 'Search...',
            enableKeyEvents: true,
            hideTrigger: true,
            hideLabel: true,
            forceSelection: true,
            mode: 'remote',
            queryDelay: 750,
            minChars: 2,
            selectOnFocus: true,
            listeners: {
                select: function(combo, record) {
                    that.fireEvent('show_element', record.json.name, record.json.source, record.json.id);
                },
                keypress: function(combo, e) {
                    if (e.getKey() === Ext.EventObject.ENTER && !combo.findRecord('name', combo.getValue())) {
                        that.fireEvent('show_element', combo.getValue(), 'denotation');
                    }
                }
            }
        });
        this.searchGroup = new Ext.form.RadioGroup({
                fieldLabel: "Source",
                xtype: "radiogroup",
                name: "searchgroup",
                columns: 1,
                items: [
                  {
                    boxLabel: "CYC",
                    name: "source",
                    inputValue: "symbol",
                    checked: true
                  }, {
                    boxLabel: "CYC API",
                    name: "source",
                    inputValue: "api",
                  }, {
                    boxLabel: "CKAN",
                    name: "source",
                    inputValue: "ckan",
                  }, {
                    boxLabel: "SPARQL",
                    name: "source",
                    inputValue: "sparql",
                  }
                ]
              });
        Ext.apply(this, {
            items: [
              this.searchCombo,
              this.searchGroup
          ],
        });
        SearchForm.superclass.initComponent.call(this);
    }
});

var SearchPanel = function() {
    SearchPanel.superclass.constructor.call(this, {
        region: 'west',
        split: true,
        header: false,
        width: 195,
        minSize: 175,
        maxSize: 500,
        collapsible: true,
        margins: '0 0 5 5',
        collapseMode: 'mini'
    });
};

Ext.extend(SearchPanel, Ext.Panel, {
    initComponent: function() {
        this.searchForm = new SearchForm();
        this.symbolPanel = new SymbolPanel();
        Ext.apply(this, {
          items: [this.searchForm, this.symbolPanel],
        });
        SearchPanel.superclass.initComponent.call(this);
    },
});
