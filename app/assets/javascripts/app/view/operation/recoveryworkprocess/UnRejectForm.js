Ext.define('AM.view.operation.recoveryworkprocess.UnrejectForm', {
  extend: 'Ext.window.Window',
  alias : 'widget.unrejectrecoveryworkprocessform',

  title : 'Unreject',
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
	}
});
