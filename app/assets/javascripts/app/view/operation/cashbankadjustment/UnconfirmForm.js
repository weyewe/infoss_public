Ext.define('AM.view.operation.cashbankadjustment.UnconfirmForm', {
  extend: 'Ext.window.Window',
  alias : 'widget.unconfirmcashbankadjustmentform',

  title : 'Unconfirm CashBankAdjustment',
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
					fieldLabel: 'Kode',
					name: 'code' 
				},
			 
				{
					xtype: 'displayfield',
					fieldLabel: 'Tanggal Konfirmasi',
					name: 'confirmed_at' 
				}
			]
    }];

    this.buttons = [{
      text: 'Unconfirm',
      action: 'confirm'
    }, {
      text: 'Cancel',
      scope: this,
      handler: this.close
    }];

    this.callParent(arguments);
  },

	setParentData: function( record ) {
		// console.log("Inside set Parent Data");
// d.get('total_members_count') );
		this.down('form').getForm().findField('code').setValue(record.get('code')); 
		this.down('form').getForm().findField('confirmed_at').setValue(record.get('confirmed_at')); 
	}
});
