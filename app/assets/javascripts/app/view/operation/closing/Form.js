
Ext.define('AM.view.operation.closing.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.closingform',

  title : 'Add / Edit Closing',
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
  		        name : 'Id',
  		        fieldLabel: 'Id'
  		  	  },
    		  	{
							xtype: 'textfield',
							fieldLabel : 'Period',
							name : 'period'
						},
						{
							xtype: 'textfield',
							fieldLabel : 'Year',
							name : 'year_period'
						},
    		    {
    					xtype: 'datefield',
    					name : 'beginning_period',
    					fieldLabel: 'Beginning',
    					format: 'Y-m-d',
    				},
    	      {
    					xtype: 'datefield',
    					name : 'end_date_period',
    					fieldLabel: 'Ending',
    					format: 'Y-m-d',
    				},  
    	      {
    		        xtype: 'checkboxfield',
    		        name : 'is_year_closing',
    		        fieldLabel: 'Is Year?'
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
 
	}
 
});




