
Ext.define('AM.view.operation.paymentvoucher.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.paymentvoucherform',

  title : 'Add / Edit PaymentVoucher',
  layout: 'fit',
	width	: 960,
	// height : 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
	companyInfo : function(){
		var remoteJsonStoreVendor = Ext.create(Ext.data.JsonStore, {
		storeId : 'vendor_search',
		fields	: [
		 		{
					name : 'vendor_name',
					mapping : "name"
				} ,
				{
					name : 'vendor_description',
					mapping : "description"
				} ,
		 
				{
					name : 'vendor_id',
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
	
		var remoteJsonStoreCashBank = Ext.create(Ext.data.JsonStore, {
			storeId : 'cash_bank_search',
			fields	: [
			 		{
						name : 'cash_bank_name',
						mapping : "name"
					} ,
					{
						name : 'cash_bank_description',
						mapping : "description"
					} ,
			 		{
						name : 'cash_bank_exchange_name',
						mapping : "exchange_name"
					} ,
					{
						name : 'cash_bank_code',
						mapping : "code"
					} ,
					{
						name : 'cash_bank_is_bank',
						mapping : "is_bank"
					} ,
					{
						name : 'cash_bank_id',
						mapping : 'id'
					}  
			],
			
		 
			proxy  	: {
				type : 'ajax',
				url : 'api/search_cash_bank',
				reader : {
					type : 'json',
					root : 'records', 
					totalProperty  : 'total'
				}
			},
			autoLoad : false 
		});
		
		var entityInfo = {
			xtype : 'fieldset',
			title : "",
			flex : 1 , 
			border : true, 
			labelWidth: 60,
			defaultType : 'field',
			width : '90%',
			defaults : {
				anchor : '-10'
			},
			items : [
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
	    				fieldLabel: 'Contact',
	    				xtype: 'combo',
	    				queryMode: 'remote',
	    				forceSelection: true, 
	    				displayField : 'vendor_name',
	    				valueField : 'vendor_id',
	    				pageSize : 5,
	    				minChars : 1, 
	    				allowBlank : false, 
	    				triggerAction: 'all',
	    				store : remoteJsonStoreVendor , 
	    				listConfig : {
	    					getInnerTpl: function(){
	    						return  	'<div data-qtip="{vendor_name}">' + 
	    												'<div class="combo-name">{vendor_name}</div>' + 
	    												'<div class="combo-name">Deskripsi: {vendor_description}</div>' + 
	    						 					'</div>';
	    					}
    					},
    					name : 'contact_id' 
    	    	},
    	    	{
	    				fieldLabel: 'CashBank',
	    				xtype: 'combo',
	    				queryMode: 'remote',
	    				forceSelection: true, 
	    				displayField : 'cash_bank_name',
	    				valueField : 'cash_bank_id',
	    				pageSize : 5,
	    				minChars : 1, 
	    				allowBlank : false, 
	    				triggerAction: 'all',
	    				store : remoteJsonStoreCashBank , 
	    				listConfig : {
	    					getInnerTpl: function(){
	    						return  	'<div data-qtip="{cash_bank_name}">' + 
	    												'<div class="combo-name">{cash_bank_name}</div>' + 
	    												'<div class="combo-name">Deskripsi: {cash_bank_description}</div>' + 
	    												'<div class="combo-name">Currency: {cash_bank_exchange_name}</div>' + 
	    						 					'</div>';
	    					}
    					},
    					name : 'cash_bank_id' 
    	    	},
	  		  	{
							xtype: 'textfield',
							fieldLabel : 'No Bukti',
							name : 'no_bukti'
						},
				    {
							xtype: 'datefield',
							name : 'payment_date',
							fieldLabel: 'Tanggal Pembayaran',
							format: 'Y-m-d',
						},
    				{
        	     xtype: 'checkboxfield',
        	     name : 'is_gbch',
        	     fieldLabel: 'GBCH ?'
    	      },
    	      {
								xtype: 'textfield',
								fieldLabel : 'GBCH no',
								name : 'gbch_no'
						}, 
						{
							xtype: 'datefield',
							name : 'due_date',
							fieldLabel: 'Due Date',
							format: 'Y-m-d',
						},
				]
			};
		
			var container = {
					xtype : 'container',
					layoutConfig: {
						align :'stretch'
					},
					flex: 1, 
					width : 500,
					layout : 'vbox',
					items : [
						entityInfo
					]
				};
				
				return container; 
				
	},
	
	picInfo: function(){
		
		var me = this; 
		
		var localJsonStoreStatusPembulatan = Ext.create(Ext.data.Store, {
			type : 'array',
			storeId : 'status_pembulatan',
			fields	: [ 
				{ name : "status_pembulatan"}, 
				{ name : "status_pembulatan_text"}  
			], 
			data : [
				{ status_pembulatan : 1, status_pembulatan_text : "Debit"},
				{ status_pembulatan : 2, status_pembulatan_text : "Credit"},
			] 
		});
		
		var salesInfo = {
					xtype : 'fieldset',
					title : "",
					flex : 1 , 
					border : true,
					width : '90%', 
					labelWidth: 60,
					defaultType : 'field',
					defaults : {
						anchor : '-10'
					},
					items : [ 
						
						{
							xtype: 'numberfield',
							fieldLabel : 'Pembulatan',
							name : 'pembulatan'
						},
						{
	    				fieldLabel: 'Status Pembulatan',
	    				xtype: 'combo',
	    				queryMode: 'remote',
	    				forceSelection: true, 
	    				displayField : 'status_pembulatan_text',
	    				valueField : 'status_pembulatan',
	    				pageSize : 5,
	    				minChars : 1, 
	    				allowBlank : false, 
	    				triggerAction: 'all',
	    				store : localJsonStoreStatusPembulatan , 
	    				listConfig : {
	    					getInnerTpl: function(){
	    						return  	'<div data-qtip="{status_pembulatan_text}">' + 
	    												'<div class="combo-name">{status_pembulatan_text}</div>' + 
	    						 					'</div>';
	    					}
    					},
    					name : 'status_pembulatan' 
    	    	},
    	    	{
							xtype: 'numberfield',
							fieldLabel : 'Rate To IDR',
							name : 'rate_to_idr'
						},
    	    	{
							xtype: 'numberfield',
							fieldLabel : 'Biaya Bank',
							name : 'biaya_bank'
						},
						{
							xtype: 'displayfield',
							fieldLabel : 'Total PPh 21',
							name : 'total_pph_21'
						},
						{
							xtype: 'displayfield',
							fieldLabel : 'Total PPh 23',
							name : 'total_pph_23'
						},
						{				
							xtype: 'displayfield',
							fieldLabel : 'Total Amount',
							name : 'amount'
						},
					]
				};
				
				
				var container = {
					xtype : 'container',
					layoutConfig: {
						align :'stretch'
					},
					flex: 1, 
					width : 500,
					layout : 'vbox',
					items : [
						salesInfo
					]
				};
				
				return container; 
	},
	
	
  initComponent: function() {
	var me = this; 
		
    this.items = [{
      xtype: 'form',
			msgTarget	: 'side',
			border: false,
      bodyPadding: 10,
			fieldDefaults: {
          labelWidth: 100,
					anchor: '100%'
      },
			height : 350,
			overflowY : 'auto', 
			layout : 'hbox', 
      items: [
   				me.companyInfo(), 
					me.picInfo()
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
	
	setSelectedCashBank: function( cash_bank_id ){
		var comboBox = this.down('form').getForm().findField('cash_bank_id'); 
		var me = this; 
		var store = comboBox.store; 
		// console.log( 'setSelectedMember');
		// console.log( store ) ;
		store.load({
			params: {
				selected_id : cash_bank_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( cash_bank_id );
			}
		});
	},
	
	setSelectedStatusPembulatan: function( status_pembulatan ){
		var comboBox = this.down('form').getForm().findField('status_pembulatan'); 
		var me = this; 
		var store = comboBox.store; 
		// console.log( 'setSelectedMember');
		// console.log( store ) ;
		store.load({
			params: {
				selected_id : status_pembulatan 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( status_pembulatan );
			}
		});
	},
	
	setComboBoxData : function( record){ 

		var me = this; 
		me.setLoading(true);
		
		me.setSelectedCustomer( record.get("contact_id")  ) ;
		me.setSelectedCashBank( record.get("cash_bank_id")  ) ;
		me.setSelectedStatusPembulatan( record.get("status_pembulatan")  ) ;
 
	}
 
});




