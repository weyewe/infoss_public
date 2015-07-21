
Ext.define('AM.view.operation.paymentrequest.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.paymentrequestform',

  title : 'Add / Edit PaymentRequest',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
			var me = this; 
	
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
	
	var remoteJsonStoreAccountPayable = Ext.create(Ext.data.JsonStore, {
		storeId : 'account_payable_search',
		fields	: [
		 		{
					name : 'account_payable_name',
					mapping : "name"
				} ,
				{
					name : 'account_payable_code',
					mapping : "code"
				} ,
		 
				{
					name : 'account_payable_id',
					mapping : 'id'
				}  
		],
		
	 
		proxy  	: {
			type : 'ajax',
			url : 'api/search_ledger_account_payables',
			reader : {
				type : 'json',
				root : 'records', 
				totalProperty  : 'total'
			}
		},
		autoLoad : false 
	});
	
	var remoteJsonStoreExchange = Ext.create(Ext.data.JsonStore, {
		storeId : 'exchange_search',
		fields	: [
		 		{
					name : 'exchange_name',
					mapping : "name"
				} ,
				{
					name : 'exchange_description',
					mapping : "description"
				} ,
		 
				{
					name : 'exchange_id',
					mapping : 'id'
				}  
		],
		
	 
		proxy  	: {
			type : 'ajax',
			url : 'api/search_exchanges',
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
					fieldLabel : 'No Bukti',
					name : 'no_bukti'
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
  				store : remoteJsonStoreVendor, 
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
	        xtype: 'textarea',
	        name : 'description',
	        fieldLabel: 'Description'
	      },
	      {
					xtype: 'datefield',
					name : 'request_date',
					fieldLabel: 'Requested Date',
					format: 'Y-m-d',
				},
				{
					xtype: 'datefield',
					name : 'due_date',
					fieldLabel: 'Due Date',
					format: 'Y-m-d',
				},
				{
  				fieldLabel: 'Account Payable',
  				xtype: 'combo',
  				queryMode: 'remote',
  				forceSelection: true, 
  				displayField : 'account_payable_name',
  				valueField : 'account_payable_id',
  				pageSize : 5,
  				minChars : 1, 
  				allowBlank : false, 
  				triggerAction: 'all',
  				store : remoteJsonStoreAccountPayable , 
  				listConfig : {
  					getInnerTpl: function(){
  						return  	'<div data-qtip="{account_payable_name}">' + 
  												'<div class="combo-name">Code : {account_payable_code}</div>' + 
  												'<div class="combo-name">Name: {account_payable_name}</div>' + 
  						 					'</div>';
  					}
					},
					name : 'account_id' 
				},
				{
	        xtype: 'displayfield',
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
  
    setSelectedVendor: function( contact_id ){
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
	
	setSelectedAccountPayable: function( account_id ){
		var comboBox = this.down('form').getForm().findField('account_id'); 
		var me = this; 
		var store = comboBox.store; 
		// console.log( 'setSelectedMember');
		// console.log( store ) ;
		store.load({
			params: {
				selected_id : account_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( account_id );
			}
		});
	},
	
	setComboBoxData : function( record){ 

		var me = this; 
		me.setLoading(true);
		me.setSelectedAccountPayable( record.get("account_id")  ) ;
		me.setSelectedVendor( record.get("contact_id")  ) ;
 
	}
 
});




