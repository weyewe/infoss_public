
Ext.define('AM.view.operation.paymentrequestdetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.paymentrequestdetailform',

  title : 'Add / Edit Payment Request Detail',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	
	
    var remoteJsonStoreAccount = Ext.create(Ext.data.JsonStore, {
			storeId : 'account_search',
			fields	: [
			 		{
						name : 'account_code',
						mapping : "code"
					}, 
					{
						name : 'account_name',
						mapping : 'name'
					},
					{
						name : 'account_id',
						mapping : "id"
					}, 
		 
			],
			proxy  	: {
				type : 'ajax',
				url : 'api/search_ledger_accounts',
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
	        xtype: 'hidden',
	        name : 'payment_request_id',
	        fieldLabel: 'payment_request_id'
	      },
	      {
            xtype: 'displayfield',
            name : 'payment_request_code',
            fieldLabel: 'Kode PaymentRequest'
        },
				{
					fieldLabel: 'Account',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'account_name',
					valueField : 'account_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStoreAccount , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{account_name}">' + 
  												'<div class="combo-name">Code : {account_code}</div>' + 
  												'<div class="combo-name">Name: {account_name}</div>' + 
  						 					'</div>';
						}
					},
					name : 'account_id' 
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

	setSelectedAccount: function( account_id ){
		// console.log("inside set selected original account id ");
		var comboBox = this.down('form').getForm().findField('account_id'); 
		var me = this; 
		var store = comboBox.store;  
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
		me.setSelectedAccount( record.get("account_id")  ) ; 
	},
	
	
	setParentData: function( record) {
		this.down('form').getForm().findField('payment_request_code').setValue(record.get('code')); 
		this.down('form').getForm().findField('payment_request_id').setValue(record.get('id'));
	}
 
});




