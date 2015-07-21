
Ext.define('AM.view.operation.salesinvoice.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.salesinvoiceform',

  title : 'Add / Edit SalesInvoice',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
			var me = this; 
	
	var remoteJsonStoreDeliveryOrder = Ext.create(Ext.data.JsonStore, {
		storeId : 'delivery_order_search',
		fields	: [
		 		{
					name : 'delivery_order_code',
					mapping : "code"
				} ,
				{
					name : 'delivery_order_nomor_surat',
					mapping : "nomor_surat"
				} ,
		 
				{
					name : 'delivery_order_id',
					mapping : 'id'
				}  
		],
		
	 
		proxy  	: {
			type : 'ajax',
			url : 'api/search_delivery_orders',
			reader : {
				type : 'json',
				root : 'records', 
				totalProperty  : 'total'
			}
		},
		autoLoad : false 
	});
		
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
    		        name : 'nomor_surat',
    		        fieldLabel: 'NomorSurat'
    		    	},
    		    {
    					xtype: 'datefield',
    					name : 'invoice_date',
    					fieldLabel: 'Tanggal Invoice',
    					format: 'Y-m-d',
    				},
    				{
    					xtype: 'datefield',
    					name : 'due_date',
    					fieldLabel: 'Due Date',
    					format: 'Y-m-d',
    				},
    					{
        	        xtype: 'textarea',
        	        name : 'description',
        	        fieldLabel: 'Deskripsi'
    	        },
    	        
    	        {
    				fieldLabel: 'DeliveryOrder',
    				xtype: 'combo',
    				queryMode: 'remote',
    				forceSelection: true, 
    				displayField : 'delivery_order_code',
    				valueField : 'delivery_order_id',
    				pageSize : 5,
    				minChars : 1, 
    				allowBlank : false, 
    				triggerAction: 'all',
    				store : remoteJsonStoreDeliveryOrder , 
    				listConfig : {
    					getInnerTpl: function(){
    						return  	'<div data-qtip="{delivery_order_code}">' + 
    												'<div class="combo-name">{delivery_order_code}</div>' + 
    												'<div class="combo-name">NomorSurat: {delivery_order_nomor_surat}</div>' + 
    						 					'</div>';
    					}
    				},
    				name : 'delivery_order_id' 
    			},
    			{
    		        xtype: 'displayfield',
    		        name : 'tax_value',
    		        fieldLabel: 'Tax(%)'
    		 	},
    		 	{
    		        xtype: 'displayfield',
    		        name : 'amount_receivable',
    		        fieldLabel: 'Amount'
    		 	},
    		 	{
    		        xtype: 'displayfield',
    		        name : 'delivery_order_sales_order_exchange_name',
    		        fieldLabel: 'Currency'
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
  
  
  
  setSelectedDeliveryOrder: function( delivery_order_id ){
		var comboBox = this.down('form').getForm().findField('delivery_order_id'); 
		var me = this; 
		var store = comboBox.store; 
		// console.log( 'setSelectedMember');
		// console.log( store ) ;
		store.load({
			params: {
				selected_id : delivery_order_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( delivery_order_id );
			}
		});
	},
	
	setComboBoxData : function( record){ 

		
		var me = this; 
		me.setLoading(true);
		
		me.setSelectedDeliveryOrder( record.get("delivery_order_id")  ) ;
 
	}
 
});




