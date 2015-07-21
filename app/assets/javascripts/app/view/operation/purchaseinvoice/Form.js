
Ext.define('AM.view.operation.purchaseinvoice.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.purchaseinvoiceform',

  title : 'Add / Edit PurchaseInvoice',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
			var me = this; 
	
	
	var remoteJsonStorePurchaseReceival = Ext.create(Ext.data.JsonStore, {
		storeId : 'purchase_receival_search',
		fields	: [
		 		{
					name : 'purchase_receival_code',
					mapping : "code"
				} ,
				{
					name : 'purchase_receival_nomor_surat',
					mapping : "nomor_surat"
				} ,
		 
				{
					name : 'purchase_receival_id',
					mapping : 'id'
				}  
		],
		
	 
		proxy  	: {
			type : 'ajax',
			url : 'api/search_purchase_receivals',
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
    				fieldLabel: 'PurchaseReceival',
    				xtype: 'combo',
    				queryMode: 'remote',
    				forceSelection: true, 
    				displayField : 'purchase_receival_code',
    				valueField : 'purchase_receival_id',
    				pageSize : 5,
    				minChars : 1, 
    				allowBlank : false, 
    				triggerAction: 'all',
    				store : remoteJsonStorePurchaseReceival , 
    				listConfig : {
    					getInnerTpl: function(){
    						return  	'<div data-qtip="{purchase_receival_code}">' + 
    												'<div class="combo-name">{purchase_receival_code}</div>' + 
    												'<div class="combo-name">NomorSurat: {purchase_receival_nomor_surat}</div>' + 
    						 					'</div>';
    					}
    				},
    				name : 'purchase_receival_id' 
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
    		        name : 'purchase_receival_purchase_order_exchange_name',
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
  
  setSelectedPurchaseReceival: function( purchase_receival_id ){
		var comboBox = this.down('form').getForm().findField('purchase_receival_id'); 
		var me = this; 
		var store = comboBox.store; 
		// console.log( 'setSelectedMember');
		// console.log( store ) ;
		store.load({
			params: {
				selected_id : purchase_receival_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( purchase_receival_id );
			}
		});
	},
	
	setComboBoxData : function( record){ 

		var me = this; 
		me.setLoading(true);
		
		me.setSelectedPurchaseReceival( record.get("purchase_receival_id")  ) ;
 
	}
 
});




