
Ext.define('AM.view.operation.receiptvoucherdetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.receiptvoucherdetailform',

  title : 'Add / Edit ReceiptVoucher Detail',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	
	
    var remoteJsonStorePayable = Ext.create(Ext.data.JsonStore, {
		storeId : 'receivable_search',
		fields	: [
		 		{
					name : 'receivable_source_code',
					mapping : "source_code"
				}, 
				{
					name : 'receivable_source_class',
					mapping : "source_class"
				}, 
				{
					name : 'receivable_due_date',
					mapping : 'due_date'
				},
				{
					name : 'receivable_amount',
					mapping : "amount"
				}, 
				{
					name : 'receivable_remaining_amount',
					mapping : "remaining_amount"
				}, 
				{
					name : 'receivable_contact_name',
					mapping : "contact_name"
				}, 
				{
					name : 'receivable_remaining_amount',
					mapping : "remaining_amount"
				}, 
				{
					name : 'receivable_exchange_name',
					mapping : "exchange_name"
				}, 
				{
					name : 'receivable_exchange_rate_amount',
					mapping : "exchange_rate_amount"
				}, 
				{
					name : 'receivable_id',
					mapping : "id"
				}, 
	 
		],
		proxy  	: {
			type : 'ajax',
			url : 'api/search_receivables',
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
	        name : 'receipt_voucher_id',
	        fieldLabel: 'receipt_voucher_id'
	      },
				{
					fieldLabel: 'Receivable',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'receivable_source_code',
					valueField : 'receivable_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStorePayable , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{receivable_source_code}">' +  
													'<div class="combo-name">Code : {receivable_source_code}</div>' +  
													'<div class="combo-name">Contact : {receivable_contact_name}</div>' +   
													'<div class="combo-name">Amount : {receivable_amount}</div>' +   
													'<div class="combo-name">Remaining Amount : {receivable_remaining_amount}</div>' +   
							 					'</div>';
						}
					},
					name : 'receivable_id' 
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
	        xtype: 'numberfield',
	        name : 'pph_23',
	        fieldLabel: 'PPh 23'
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
	
	setSelectedReceivable: function( receivable_id ){
		// console.log("inside set selected original account id ");
		var comboBox = this.down('form').getForm().findField('receivable_id'); 
		var me = this; 
		var store = comboBox.store;  
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
	
	setSelectedItem: function( item_id ){
		// console.log("inside set selected original account id ");
		var comboBox = this.down('form').getForm().findField('item_id'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : item_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( item_id );
			}
		});
	},
	
	setSelectedStatus: function( is_service ){
		// console.log("inside set selected original account id ");
		var comboBox = this.down('form').getForm().findField('is_service'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : is_service 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( is_service );
			}
		});
	},
	
	
	setExtraParamInReceivableComboBox: function(contact_id){
		console.log("inside setExtraParamInReceivable");
		console.log("The contact_id");
		console.log( contact_id);
		var comboBox = this.down('form').getForm().findField('receivable_id'); 
		var store = comboBox.store;
		
		store.getProxy().extraParams.contact_id =  contact_id;
	},
	
	
	setComboBoxExtraParams: function( record ) {
		console.log("inside setComboBoxExtraParams");
		
		console.log( record ) ;
		var me =this;
		me.setExtraParamInReceivableComboBox( record.get("contact_id") ); 
	},
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		me.setSelectedReceivable( record.get("item_id")  ) ; 
		me.setSelectedItem( record.get("item_id")  ) ; 
		me.setSelectedStatus( record.get("is_service")  ) ; 
	},
	
	
	setParentData: function( record) {
		// this.down('form').getForm().findField('template_code').setValue(record.get('code')); 
		this.down('form').getForm().findField('receipt_voucher_id').setValue(record.get('id'));
	}
 
});




