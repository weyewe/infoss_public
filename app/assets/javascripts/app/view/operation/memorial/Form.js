Ext.define('AM.view.operation.memorial.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.memorialform',

  title : 'Add / Edit Memorial',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	var me = this; 
		
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
    		        xtype: 'displayfield',
    		        name : 'code',
    		        fieldLabel: 'Kode'
    		  	  },
		  		  	{
								xtype: 'textfield',
								fieldLabel : 'No Bukti',
								name : 'no_bukti'
							},
	    				{
        	        xtype: 'textarea',
        	        name : 'description',
        	        fieldLabel: 'Deskripsi'
  	  	      },
  	  	      {
        	        xtype: 'numberfield',
        	        name : 'amount',
        	        fieldLabel: 'Amount'
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
		
		// // me.setSelectedCustomer( record.get("contact_id")  ) ;
		// me.setSelectedEmployee( record.get("employee_id")  ) ;
		// me.setSelectedExchange( record.get("exchange_id")  ) ;
		// me.setSelectedCustomer( record.get("contact_id")  ) ;
 
	}
 
});




