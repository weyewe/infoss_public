
Ext.define('AM.view.operation.purchaseinvoicedetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.purchaseinvoicedetailform',

  title : 'Add / Edit Purchase Invoice Detail',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	
		
		var remoteJsonStorePurchaseReceivalDetail = Ext.create(Ext.data.JsonStore, {
			storeId : 'purchase_receival_detail_search',
			fields	: [
					{
						name : 'purchase_receival_detail_id',
						mapping : "id"
					}, 
					{
						name : 'purchase_receival_detail_code',
						mapping : "code"
					}, 
					{
						name : 'purchase_receival_detail_amount',
						mapping : "amount"
					},
					{
						name : 'purchase_receival_detail_purchase_order_detail_price',
						mapping : "purchase_order_detail_price"
					}, 
			 		{
						name : 'purchase_receival_detail_purchase_order_detail_item_sku',
						mapping : "purchase_order_detail_item_sku"
					}, 
					{
						name : 'purchase_receival_detail_purchase_order_detail_item_name',
						mapping : 'purchase_order_detail_item_name'
					},
					{
						name : 'purchase_receival_detail_purchase_order_detail_item_id',
						mapping : "purchase_order_detail_item_id"
					}, 
		 
			],
			proxy  	: {
				type : 'ajax',
				url : 'api/search_purchase_receival_details',
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
	        name : 'purchase_invoice_id',
	        fieldLabel: 'purchase_invoice_id'
	      },
	      {
            xtype: 'displayfield',
            name : 'purchase_invoice_code',
            fieldLabel: 'Kode PurchaseInvoice'
        },

			{
				fieldLabel: 'Item',
				xtype: 'combo',
				queryMode: 'remote',
				forceSelection: true, 
				displayField : 'purchase_receival_detail_purchase_order_detail_item_name',
				valueField : 'purchase_receival_detail_id',
				pageSize : 5,
				minChars : 1, 
				allowBlank : false, 
				triggerAction: 'all',
				store : remoteJsonStorePurchaseReceivalDetail , 
				listConfig : {
					getInnerTpl: function(){
						return  '<div data-qtip="{purchase_receival_detail_purchase_order_detail_item_name}">' +  
												'<div class="combo-name">'  +
															" {purchase_receival_detail_code} " 		+ "<br />" 	 + 
															" ({purchase_receival_detail_purchase_order_detail_item_name}) " 		+ "<br />" 	 + 
															'{purchase_receival_detail_purchase_order_detail_item_sku}' 			+ "<br />" 	 +
															'{purchase_receival_detail_amount}' 	+ "<br />"	+
															'{purchase_receival_detail_purchase_order_detail_price}' 	+
												 "</div>" +  
						 					'</div>';
					}
				},
				name : 'purchase_receival_detail_id' 
			},
				
			{
    	        xtype: 'textfield',
    	        name : 'amount',
    	        fieldLabel: 'Quantity'
    	     },
    	     {
    	        xtype: 'displayfield',
    	        name : 'price',
    	        fieldLabel: 'Price x Qty'
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
  
  
	setSelectedPurchaseReceivalDetail: function( purchase_receival_detail_id ){
		// console.log("inside set selected original account id ");
		var comboBox = this.down('form').getForm().findField('purchase_receival_detail_id'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : purchase_receival_detail_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( purchase_receival_detail_id );
			}
		});
	},
	
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		
		me.setSelectedPurchaseReceivalDetail( record.get("purchase_receival_detail_id")  ) ;  
	},
	
	
	setParentData: function( record) {
		this.down('form').getForm().findField('purchase_invoice_code').setValue(record.get('code')); 
		this.down('form').getForm().findField('purchase_invoice_id').setValue(record.get('id'));
	}
 
});




