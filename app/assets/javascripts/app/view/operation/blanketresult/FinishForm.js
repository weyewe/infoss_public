Ext.define('AM.view.operation.blanketresult.ConfirmForm', {
  extend: 'Ext.window.Window',
  alias : 'widget.finishblanketresultform',

  title : 'Finish BlanketResult',
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
					xtype: 'hiddenfield',
					fieldLabel: 'id',
					name: 'id' 
				},
				{
					xtype: 'numberfield',
					fieldLabel: 'Kuantitas Blanket Finish',
					name: 'finished_quantity' 
				},
				{
					xtype: 'numberfield',
					fieldLabel: 'Kuantitas Blanket Reject',
					name: 'rejected_quantity' 
				},
		 
			 
				{
					xtype: 'textfield',
					fieldLabel: 'Pemakaian Roll Blanket',
					name: 'roll_blanket_usage' 
				},
				{
					xtype: 'textfield',
					fieldLabel: 'Roll Blanket Defect',
					name: 'roll_blanket_defect' 
				},
				{
					xtype: 'datefield',
					fieldLabel: 'Tanggal Finish',
					name: 'finished_at' ,
					format: 'Y-m-d',
				},  
		 
			]
    }];

    this.buttons = [{
      text: 'Finish',
      action: 'finish'
    }, {
      text: 'Cancel',
      scope: this,
      handler: this.close
    }];

    this.callParent(arguments);
  },

	setParentData: function( record ) {
		// this.down('form').getForm().findField('id').setValue(record.get('code')); 
		// this.down('form').getForm().findField('transaction_datetime').setValue(record.get('transaction_datetime')); 
		// this.down('form').getForm().findField('description').setValue(record.get('description')); 
	}
});
