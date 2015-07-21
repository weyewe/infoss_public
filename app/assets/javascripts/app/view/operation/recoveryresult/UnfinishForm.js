Ext.define('AM.view.operation.recoveryresult.UnfinishForm', {
  extend: 'Ext.window.Window',
  alias : 'widget.unfinishrecoveryresultform',

  title : 'Cancel Finish',
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
      text: 'Cancel Finish',
      action: 'unfinish'
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
