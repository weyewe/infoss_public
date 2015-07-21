
Ext.define('AM.view.operation.salesinvoicedetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.salesinvoicedetailform',

  title : 'Add / Edit Sales Invoice Detail',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	
	
	var remoteJsonStoreDeliveryOrderDetail = Ext.create(Ext.data.JsonStore, {
		storeId : 'delivery_order_detail_search',
		fields	: [
				{
					name : 'delivery_order_detail_id',
					mapping : "id"
				}, 
				{
					name : 'delivery_order_detail_code',
					mapping : "code"
				}, 
				{
					name : 'delivery_order_detail_amount',
					mapping : "amount"
				},
				{
					name : 'delivery_order_detail_sales_order_detail_price',
					mapping : "sales_order_detail_price"
				}, 
		 		{
					name : 'delivery_order_detail_sales_order_detail_item_sku',
					mapping : "sales_order_detail_item_sku"
				}, 
				{
					name : 'delivery_order_detail_sales_order_detail_item_name',
					mapping : 'sales_order_detail_item_name'
				},
				{
					name : 'delivery_order_detail_sales_order_detail_item_id',
					mapping : "sales_order_detail_item_id"
				}, 
	 
		],
		proxy  	: {
			type : 'ajax',
			url : 'api/search_delivery_order_details',
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
	        name : 'sales_invoice_id',
	        fieldLabel: 'sales_invoice_id'
	      },
	      {
            xtype: 'displayfield',
            name : 'sales_invoice_code',
            fieldLabel: 'Kode SalesInvoice'
        },

			{
				fieldLabel: 'Item',
				xtype: 'combo',
				queryMode: 'remote',
				forceSelection: true, 
				displayField : 'delivery_order_detail_sales_order_detail_item_name',
				valueField : 'delivery_order_detail_id',
				pageSize : 5,
				minChars : 1, 
				allowBlank : false, 
				triggerAction: 'all',
				store : remoteJsonStoreDeliveryOrderDetail , 
				listConfig : {
					getInnerTpl: function(){
						return  '<div data-qtip="{delivery_order_detail_sales_order_detail_item_name}">' +  
												'<div class="combo-name">'  +
															" {delivery_order_detail_code} " 		+ "<br />" 	 + 
															" ({delivery_order_detail_sales_order_detail_item_name}) " 		+ "<br />" 	 + 
															'{delivery_order_detail_sales_order_detail_item_sku}' 			+ "<br />" 	 +
															'{delivery_order_detail_amount}' 	+ "<br />"	+
															'{delivery_order_detail_sales_order_detail_price}' 	+
												 "</div>" +  
						 					'</div>';
					}
				},
				name : 'delivery_order_detail_id' 
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

	setSelectedDeliveryOrderDetail: function( delivery_order_detail_id ){
		// console.log("inside set selected original account id ");
		var comboBox = this.down('form').getForm().findField('delivery_order_detail_id'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : delivery_order_detail_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( delivery_order_detail_id );
			}
		});
	},
	
	
	
	setExtraParamInDeliveryOrderDetailIdComboBox: function(delivery_order_id){  
		var comboBox = this.down('form').getForm().findField('delivery_order_detail_id'); 
		var store = comboBox.store;
		
		store.getProxy().extraParams.delivery_order_id =  delivery_order_id;
	},
	
	
	setComboBoxExtraParams: function( record ) {  
		var me =this;
		me.setExtraParamInDeliveryOrderDetailIdComboBox( record.get("delivery_order_id") ); 
	},
	
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		
		me.setSelectedDeliveryOrderDetail( record.get("delivery_order_detail_id")  ) ;  
	},
	
	
	setParentData: function( record) {
		this.down('form').getForm().findField('sales_invoice_code').setValue(record.get('code')); 
		this.down('form').getForm().findField('sales_invoice_id').setValue(record.get('id'));
	}
 
});




