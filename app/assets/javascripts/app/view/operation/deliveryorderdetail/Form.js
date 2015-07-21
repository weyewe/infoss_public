
Ext.define('AM.view.operation.deliveryorderdetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.deliveryorderdetailform',

  title : 'Add / Edit DeliveryOrderDetail',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	
		
		var remoteJsonStoreSalesOrderDetail = Ext.create(Ext.data.JsonStore, {
			storeId : 'sales_order_detail_search',
			fields	: [
					{
						name : 'sales_order_detail_id',
						mapping : "id"
					}, 
					{
						name : 'sales_order_detail_code',
						mapping : "code"
					}, 
					{
						name : 'sales_order_detail_pending_delivery_amount',
						mapping : "pending_delivery_amount"
					}, 
					{
						name : 'sales_order_detail_item_sku',
						mapping : "item_sku"
					}, 
					{
						name : 'sales_order_detail_item_name',
						mapping : 'item_name'
					},
					{
						name : 'sales_order_detail_item_id',
						mapping : "item_id"
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
	        name : 'delivery_order_id',
	        fieldLabel: 'delivery_order_id'
	      },
	      {
            xtype: 'displayfield',
            name : 'delivery_order_code',
            fieldLabel: 'Kode DeliveryOrder'
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
						return  	'<div data-qtip="{sales_order_detail_item_name}">' +  
												'<div class="combo-name">'  +
															" {sales_order_detail_code} " 		+ "<br />" 	 + 
															" ({sales_order_detail_item_name}) " 		+ "<br />" 	 + 
															'{sales_order_detail_item_sku}' 			+ "<br />" 	 +
															'{sales_order_detail_pending_delivery_amount}' 	+
												 "</div>" +  
						 					'</div>';
					}
				},
				name : 'sales_order_detail_id' 
			},
			
				
			{
    	        xtype: 'textfield',
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
	
	
	
	setExtraParamInSalesOrderComboBox: function(sales_order_id){
		var comboBox = this.down('form').getForm().findField('sales_order_detail_id'); 
		var store = comboBox.store;
		
		store.getProxy().extraParams.sales_order_id =  sales_order_id;
	},
	
	
	setComboBoxExtraParams: function( record ) { 
		
		console.log( record ) ;
		var me =this;
		me.setExtraParamInSalesOrderComboBox( record.get("sales_order_id") ); 
	},
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		me.setSelectedSalesOrderDetail( record.get("sales_order_detail_id")  ) ;  
	},
	
	
	setParentData: function( record) {
		this.down('form').getForm().findField('delivery_order_code').setValue(record.get('code')); 
		this.down('form').getForm().findField('delivery_order_id').setValue(record.get('id'));
	}
 
});




