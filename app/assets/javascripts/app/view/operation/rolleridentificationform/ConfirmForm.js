Ext.define('AM.view.operation.rolleridentificationform.ConfirmForm', {
  extend: 'Ext.window.Window',
  alias : 'widget.confirmrolleridentificationformform',

  title : 'Confirm RollerIdentificationForm',
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
					xtype: 'datefield',
					fieldLabel: 'Tanggal Konfirmasi',
					name: 'confirmed_at' ,
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
		this.down('form').getForm().findField('code').setValue(record.get('code')); 
	}
});
