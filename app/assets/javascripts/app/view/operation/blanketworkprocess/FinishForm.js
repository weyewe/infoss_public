Ext.define('AM.view.operation.blanketworkprocess.FinishForm', {
  extend: 'Ext.window.Window',
  alias : 'widget.finishblanketworkprocessform',

  title : 'Finish BlanketWorkProcess',
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
					xtype: 'numberfield',
					fieldLabel: 'Roll Blanket Usage QTY',
					name: 'roll_blanket_usage' 
				},
				{
					xtype: 'numberfield',
					fieldLabel: 'Roll Blanket Defect QTY',
					name: 'roll_blanket_defect' 
				},
				{
					xtype: 'numberfield',
					fieldLabel: 'Finish QTY',
					name: 'finished_quantity' 
				},
				{
					xtype: 'numberfield',
					fieldLabel: 'Reject QTY',
					name: 'rejected_quantity' 
				},
				{
					xtype: 'datefield',
					fieldLabel: 'Tanggal Konfirmasi',
					name: 'finished_at' ,
					format: 'Y-m-d',
				},  
		 
			]
    }];

    this.buttons = [{
      text: 'Confirm',
      action: 'confirm'
    }, {
      text: 'Cancel',
      scope: this,
      handler: this.close
    }];

    this.callParent(arguments);
  },

	setParentData: function( record ) {
	}
});
