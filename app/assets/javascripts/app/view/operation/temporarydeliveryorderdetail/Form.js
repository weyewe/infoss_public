
Ext.define('AM.view.operation.temporarydeliveryorderdetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.temporarydeliveryorderdetailform',

  title : 'Add / Edit TemporaryDeliveryOrder Detail',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	
	
	
	
	var remoteJsonStoreSalesOrderDetail= Ext.create(Ext.data.JsonStore, {
		storeId : 'sales_order_detail_search',
		fields	: [
		 		{
					name : 'sales_order_detail_code',
					mapping : "code"
				}, 
				{
					name : 'sales_order_detail_item_sku',
					mapping : 'item_sku'
				},
				{
					name : 'sales_order_detail_item_name',
					mapping : 'item_name'
				},
				{
					name : 'sales_order_detail_pending_delivery_amount',
					mapping : 'pending_delivery_amount'
				},
				{
					name : 'sales_order_detail_price',
					mapping : 'price'
				},
				{
					name : 'sales_order_detail_id',
					mapping : "id"
				}, 
	 
		],
		proxy  	: {
			type : 'ajax',
			url : 'api/search_sales_order_details',
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
	        name : 'temporary_delivery_order_id',
	        fieldLabel: 'temporary_delivery_order_id'
	      },
				{
					fieldLabel: 'Item',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'sales_order_detail_item_name',
					valueField : 'sales_order_detail_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStoreSalesOrderDetail , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{sales_order_detail_code}">' +  
													'<div class="combo-name">Code : {sales_order_detail_code}</div>' +  
													'<div class="combo-name">Sku : {sales_order_detail_item_sku}</div>' +  
													'<div class="combo-name">Name : {sales_order_detail_item_name}</div>' +  
													'<div class="combo-name">Amount : {sales_order_detail_pending_delivery_amount}</div>' +  
													'<div class="combo-name">Price : {sales_order_detail_pricet}</div>' +  
							 					'</div>';
						}
					},
					name : 'sales_order_detail_id' 
				},
				{
  	        xtype: 'numberfield',
  	        name : 'amount',
  	        fieldLabel: 'Quantity'
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

	setSelectedSalesOrderDetail: function( sales_order_detail_id ){
		// console.log("inside set selected original account id ");
		var comboBox = this.down('form').getForm().findField('sales_order_detail_id'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : sales_order_detail_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( sales_order_detail_id );
			}
		});
	},
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		me.setSelectedSalesOrderDetail( record.get("sales_order_detail_id")  ) ; 
	},
	
	setParentData: function( record) {
		this.down('form').getForm().findField('temporary_delivery_order_id').setValue(record.get('id'));
	}
 
});




