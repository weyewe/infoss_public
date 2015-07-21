Ext.define('AM.view.operation.recoveryworkprocess.FinishForm', {
  extend: 'Ext.window.Window',
  alias : 'widget.finishrecoveryworkprocessform',

  title : 'Finish RecoveryWorkProcess',
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
					xtype: 'datefield',
					fieldLabel: 'Tanggal Finish',
					name: 'finished_date' ,
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
