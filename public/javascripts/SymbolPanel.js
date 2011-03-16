var SymbolPanel = function() {
    SymbolPanel.superclass.constructor.call(this, {
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

Ext.extend(SymbolPanel, Ext.grid.GridPanel, {
    initComponent: function() {
        this.searchCombo = new Ext.form.ComboBox({
            store: new Ext.data.JsonStore({
                root: 'data',
                fields:['name'],
                url: document.location.href + '/symbol/complete'
            }),
            displayField: 'name',
            autoWidth: true,
            emptyText: 'Search...',
            enableKeyEvents: true,
            hideTrigger: true,
            forceSelection: true,
            mode: 'remote',
            queryDelay: 750,
            minChars: 1,
            selectOnFocus: true,
            listeners: {
                select: function(combo, record) {
                    that.fireEvent('show_element', record.data.name, 'symbol');
                },
                keypress: function(combo, e) {
                    if (e.getKey() === Ext.EventObject.ENTER && !combo.findRecord('name', combo.getValue())) {
                        that.fireEvent('show_element', combo.getValue(), 'denotation');
                    }
                }
            }
        });
        var that = this;
        Ext.apply(this, {
            store: new Ext.data.ArrayStore({
                fields: [
                    'name',
                    'type'
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
            tbar: [this.searchCombo],
            listeners: {
                cellclick: function(grid, rowIndex) {
                    var record = grid.getStore().getAt(rowIndex);
                    var name = record.get('name');
                    var type = record.get('type');
                    that.fireEvent('show_element', name, type);
                }
            }
        });
        SymbolPanel.superclass.initComponent.call(this);
    },
    addToStore: function(symbol, type) {
        if (this.store.findExact('name', symbol) === -1) {
            this.store.insert(0, new Ext.data.Record({
                name:symbol,
                type:type
            }));
        }
    },
    focusSearchField: function() {
        this.searchCombo.focus();
    }
});
