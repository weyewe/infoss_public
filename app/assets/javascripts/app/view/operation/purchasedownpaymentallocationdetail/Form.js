
Ext.define('AM.view.operation.purchasedownpaymentallocationdetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.purchasedownpaymentallocationdetailform',

  title : 'Add / Edit PurchaseDownPaymentAllocation Detail',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	
	
    var remoteJsonStorePayable = Ext.create(Ext.data.JsonStore, {
		storeId : 'payable_search',
		fields	: [
		 		{
					name : 'payable_source_code',
					mapping : "source_code"
				}, 
				{
					name : 'payable_source_class',
					mapping : "source_class"
				}, 
				{
					name : 'payable_due_date',
					mapping : 'due_date'
				},
				{
					name : 'payable_amount',
					mapping : "amount"
				}, 
				{
					name : 'payable_remaining_amount',
					mapping : "remaining_amount"
				}, 
				{
					name : 'payable_contact_name',
					mapping : "contact_name"
				}, 
				{
					name : 'payable_remaining_amount',
					mapping : "remaining_amount"
				}, 
				{
					name : 'payable_exchange_name',
					mapping : "exchange_name"
				}, 
				{
					name : 'payable_exchange_rate_amount',
					mapping : "exchange_rate_amount"
				}, 
				{
					name : 'payable_id',
					mapping : "id"
				}, 
	 
		],
		proxy  	: {
			type : 'ajax',
			url : 'api/search_payables',
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
	        name : 'purchase_down_payment_allocation_id',
	        fieldLabel: 'purchase_down_payment_allocation_id'
	      },
	      {
					fieldLabel: 'Payable',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'payable_source_code',
					valueField : 'payable_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStorePayable , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{payable_source_code}">' +  
													'<div class="combo-name">Code : {payable_source_code}</div>' +  
													'<div class="combo-name">Contact : {payable_contact_name}</div>' +   
													'<div class="combo-name">Amount : {payable_amount}</div>' +   
													'<div class="combo-name">Remaining Amount : {payable_remaining_amount}</div>' +   
							 					'</div>';
						}
					},
					name : 'payable_id' 
				},
				{
	        xtype: 'numberfield',
	        name : 'rate',
	        fieldLabel: 'Rate'
	      },
	      {
	        xtype: 'numberfield',
	        name : 'amount_paid',
	        fieldLabel: 'Amount Paid'
	      },
	      {
	        xtype: 'displayfield',
	        name : 'amount',
	        fieldLabel: 'Amount'
	      },
	      	{
	        xtype: 'textarea',
	        name : 'description',
	        fieldLabel: 'Description'
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

	setSelectedPayable: function( payable_id ){
		// console.log("inside set selected original account id ");
		var comboBox = this.down('form').getForm().findField('payable_id'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : payable_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( payable_id );
			}
		});
	},
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		
		me.setSelectedPayable( record.get("payable_id")  ) ; 
	},
	
	
	setParentData: function( record) {
		this.down('form').getForm().findField('purchase_down_payment_allocation_id').setValue(record.get('id'));
	}
 
});




