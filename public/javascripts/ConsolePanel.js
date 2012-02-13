var ConsoleOutput = Ext.extend(Ext.Panel, {
    autoScroll: true,
    region: 'center',
    border: false,
    style:'border-width:0 1px 0 0',

    log : function(value, level){
        if(level == undefined){
          level = '';
        }
        if (value == undefined){
          value = '';
        }
        var markup = ['<div class="console_row ' + level + '">',
          value.replace(/\n/g, '<br/>').replace(/\s/g, '&#160;'),'</div>'].join('');
        this.append(markup);
    },

    append : function(value){
          var body_dom = this.body.dom;
          this.body.insertHtml('beforeend', value);
          body_dom.scrollTop = body_dom.scrollHeight;
    },

    clear : function(){
          this.body.update('');
          this.body.dom.scrollTop = 0;
    },
    initComponent: function() {
          ConsoleOutput.superclass.initComponent.call(this);
    }
});

var ConsolePanel = Ext.extend(Ext.Panel, {
    layout: {
        type: 'border'
    },
    initComponent: function() {
        this.output = new ConsoleOutput({
                    id: 'subl_output',
                    region: 'center',
                    split: true,
                    autoScroll: true,
                    cls: 'monospace',
                });
        this.console = new Ext.Panel({
                    id: 'subl_console',
                    region: 'south',
                    margins: '0 0 0 0',
                    autoScroll: true,
                    height: 22,
                    layout: {
                      type: 'border',
                    },
                    items: [new Ext.form.TextField({
                      region: 'center',
                      margins: '0 0 0 0',
                      enableKeyEvents: true,
                      cls: 'monospace',
                      listeners: {
                        keypress: function(field, e) {
                          if(e.getKey() === Ext.EventObject.ENTER){
                            var value = this.getValue();
                            Ext.getCmp("subl_output").log(value,'query');
                            this.setValue('');
                            Ext.Ajax.request({
                              url: baseUrl() + '/console/show',
                              params: {
                                id: value
                              },
                              success: function(response, opts) {
                                Ext.getCmp("subl_output").append(response.responseText);
                              },
                              failure: function(response, opts) {
                                Ext.getCmp("subl_output").log(response.responseText,'error');
                              }
                            });
                          }
                          if(e.getKey() === Ext.EventObject.UP){
                            this.setValue('ala');
                          }
                        }
                      }
                    })]
                });
        Ext.apply(this, {
            items: [this.output, this.console]
        });
        ConsolePanel.superclass.initComponent.call(this);
    },
});

