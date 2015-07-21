Ext.define('AM.view.operation.blanketresult.UnfinishForm', {
  extend: 'Ext.window.Window',
  alias : 'widget.unfinishblanketresultform',

  title : 'Unfinish BlanketResult',
  layout: 'fit',
	width	: 400,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
    this.items = [{
      xtype: 'form',
			msgTarget	: 'side',
			border: false,
      bodyPadding: 10,
			fieldDefaults: {
          labelWidth: 165,
					anchor: '100%'
      },
      items: [

		 
			 
				{
					xtype: 'displayfield',
					fieldLabel: 'Tanggal Finish',
					name: 'finished_at' 
				}
			]
    }];

    this.buttons = [{
      text: 'Unfinish',
      action: 'finish'
    }, {
      text: 'Cancel',
      scope: this,
      handler: this.close
    }];

    this.callParent(arguments);
  },

	setParentData: function( record ) {
 
		this.down('form').getForm().findField('finished_at').setValue(record.get('finished_at')); 
	}
});
