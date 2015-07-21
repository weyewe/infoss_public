
Ext.define('AM.view.operation.purchasedownpaymentallocation.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.purchasedownpaymentallocationform',

  title : 'Add / Edit PurchaseDownPaymentAllocation',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
			var me = this; 
	
	var remoteJsonStoreContact = Ext.create(Ext.data.JsonStore, {
		storeId : 'contact_search',
		fields	: [
		 		{
					name : 'contact_name',
					mapping : "name"
				} ,
				{
					name : 'contact_description',
					mapping : "description"
				} ,
		 
				{
					name : 'contact_id',
					mapping : 'id'
				}  
		],
		
	 
		proxy  	: {
			type : 'ajax',
			url : 'api/search_suppliers',
			reader : {
				type : 'json',
				root : 'records', 
				totalProperty  : 'total'
			}
		},
		autoLoad : false 
	});
	
	
	var remoteJsonStorePurchaseDownPayment = Ext.create(Ext.data.JsonStore, {
		storeId : 'purchase_down_payment_search',
		fields	: [
		 		{
					name : 'purchase_down_payment_code',
					mapping : "code"
				} ,
				{
					name : 'purchase_down_payment_receivable_source_code',
					mapping : "receivable_source_code"
				} ,
		 		{
					name : 'purchase_down_payment_receivable_total_amount',
					mapping : "receivable_total_amount"
				} ,
				{
					name : 'purchase_down_payment_receivable_remaining_amount',
					mapping : "receivable_remaining_amount"
				} ,
				{
					name : 'purchase_down_payment_receivable_id',
					mapping : "receivable_id"
				} ,
				{
					name : 'purchase_down_payment_id',
					mapping : 'id'
				}  
		],
		
	 
		proxy  	: {
			type : 'ajax',
			url : 'api/search_purchase_down_payments',
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
    					xtype: 'datefield',
    					name : 'allocation_date',
    					fieldLabel: 'Tanggal Alokasi',
    					format: 'Y-m-d',
    				},
    	      {
	    				fieldLabel: 'Contact',
	    				xtype: 'combo',
	    				queryMode: 'remote',
	    				forceSelection: true, 
	    				displayField : 'contact_name',
	    				valueField : 'contact_id',
	    				pageSize : 5,
	    				minChars : 1, 
	    				allowBlank : false, 
	    				triggerAction: 'all',
	    				store : remoteJsonStoreContact , 
	    				listConfig : {
	    					getInnerTpl: function(){
	    						return  	'<div data-qtip="{contact_name}">' + 
	    												'<div class="combo-name">{contact_name}</div>' + 
	    												'<div class="combo-name">Deskripsi: {contact_description}</div>' + 
	    						 					'</div>';
	    					}
    					},
    					name : 'contact_id' 
    	      },
    				{
	    				fieldLabel: 'Receivable',
	    				xtype: 'combo',
	    				queryMode: 'remote',
	    				forceSelection: true, 
	    				displayField : 'purchase_down_payment_code',
	    				valueField : 'purchase_down_payment_receivable_id',
	    				pageSize : 5,
	    				minChars : 1, 
	    				allowBlank : false, 
	    				triggerAction: 'all',
	    				store : remoteJsonStorePurchaseDownPayment , 
	    				listConfig : {
	    					getInnerTpl: function(){
	    						return  	'<div data-qtip="{purchase_down_payment_code}">' + 
	    												'<div class="combo-name">{purchase_down_payment_code}</div>' + 
	    												'<div class="combo-name">Source: {purchase_down_payment_receivable_source_code}</div>' + 
	    												'<div class="combo-name">Total: {purchase_down_payment_receivable_total_amount}</div>' + 
	    												'<div class="combo-name">Remaining: {purchase_down_payment_receivable_remaining_amount}</div>' + 
	    						 					'</div>';
	    					}
    					},
    					name : 'receivable_id' 
    				},
    				 {
    		        xtype: 'numberfield',
    		        name : 'rate_to_idr',
    		        fieldLabel: 'Rate to IDR'
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
  
    setSelectedCustomer: function( contact_id ){
		var comboBox = this.down('form').getForm().findField('contact_id'); 
		var me = this; 
		var store = comboBox.store; 
		// console.log( 'setSelectedMember');
		// console.log( store ) ;
		store.load({
			params: {
				selected_id : contact_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( contact_id );
			}
		});
	},
	
	setSelectedReceivable: function( receivable_id ){
		var comboBox = this.down('form').getForm().findField('receivable_id'); 
		var me = this; 
		var store = comboBox.store; 
		// console.log( 'setSelectedMember');
		// console.log( store ) ;
		store.load({
			params: {
				selected_id : receivable_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( receivable_id );
			}
		});
	},
	
	setSelectedExchange: function( exchange_id ){
		var comboBox = this.down('form').getForm().findField('exchange_id'); 
		var me = this; 
		var store = comboBox.store; 
		// console.log( 'setSelectedMember');
		// console.log( store ) ;
		store.load({
			params: {
				selected_id : exchange_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( exchange_id );
			}
		});
	},
	
	setComboBoxData : function( record){ 

		var me = this; 
		me.setLoading(true);
		
		me.setSelectedReceivable( record.get("receivable_id")  ) ;
		me.setSelectedExchange( record.get("exchange_id")  ) ;
		me.setSelectedCustomer( record.get("contact_id")  ) ;
 
	}
 
});




