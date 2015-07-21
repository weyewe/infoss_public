
Ext.define('AM.view.operation.closingdetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.closingdetailform',

  title : 'Add / Edit Closing Detail',
  layout: 'fit',
	width	: 500,
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
	        xtype: 'hidden',
	        name : 'id',
	        fieldLabel: 'id'
	      },
				{
	        xtype: 'hidden',
	        name : 'closing_id',
	        fieldLabel: 'closing_id'
	      },
	      {
            xtype: 'displayfield',
            name : 'id',
            fieldLabel: 'Id'
        },
        {
            xtype: 'displayfield',
            name : 'exchange_name',
            fieldLabel: 'Currency'
        },
        {
            xtype: 'numberfield',
            name : 'rate',
            fieldLabel: 'Rate'
        },
			]
    }];

    this.buttons = [{
      text: 'Save',
      action: 'save'
    }, {
      text: 'Cancel',
      scope: this,
      handler: this.close
    }];

    this.callParent(arguments);
  },

	
	
	setComboBoxData : function( record){
		// var me = this; 
		// me.setLoading(true);
	},
	
	
	setParentData: function( record) {
		this.down('form').getForm().findField('closing_id').setValue(record.get('id'));
	}
 
});




