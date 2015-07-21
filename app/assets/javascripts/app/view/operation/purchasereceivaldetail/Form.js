
Ext.define('AM.view.operation.purchasereceivaldetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.purchasereceivaldetailform',

  title : 'Add / Edit Purchase Receival Detail',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	

		
		var remoteJsonStorePurchaseOrderDetail = Ext.create(Ext.data.JsonStore, {
			storeId : 'purchase_order_detail_search',
			fields	: [
					{
						name : 'purchase_order_detail_id',
						mapping : "id"
					}, 
					{
						name : 'purchase_order_detail_code',
						mapping : "code"
					}, 
					{
						name : 'purchase_order_detail_pending_receival_amount',
						mapping : "pending_receival_amount"
					}, 
					{
						name : 'purchase_order_detail_item_sku',
						mapping : "item_sku"
					}, 
					{
						name : 'purchase_order_detail_item_name',
						mapping : 'item_name'
					},
					{
						name : 'purchase_order_detail_item_id',
						mapping : "item_id"
					}, 
		 
			],
			proxy  	: {
				type : 'ajax',
				url : 'api/search_purchase_order_details',
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
	        name : 'purchase_receival_id',
	        fieldLabel: 'purchase_receival_id'
	      },
	      {
            xtype: 'displayfield',
            name : 'purchase_receival_code',
            fieldLabel: 'Kode PurchaseReceival'
        },
			
			{
				fieldLabel: 'Item',
				xtype: 'combo',
				queryMode: 'remote',
				forceSelection: true, 
				displayField : 'purchase_order_detail_item_name',
				valueField : 'purchase_order_detail_id',
				pageSize : 5,
				minChars : 1, 
				allowBlank : false, 
				triggerAction: 'all',
				store : remoteJsonStorePurchaseOrderDetail , 
				listConfig : {
					getInnerTpl: function(){
						return  	'<div data-qtip="{purchase_order_detail_item_name}">' +  
												'<div class="combo-name">'  +
															" {purchase_order_detail_code} " 		+ "<br />" 	 + 
															" ({purchase_order_detail_item_name}) " 		+ "<br />" 	 + 
															'{purchase_order_detail_item_sku}' 			+ "<br />" 	 +
															'{purchase_order_detail_pending_receival_amount}' 	+
												 "</div>" +  
						 					'</div>';
					}
				},
				name : 'purchase_order_detail_id' 
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
  
	setSelectedPurchaseOrderDetail: function( purchase_order_detail_id ){
		// console.log("inside set selected original account id ");
		var comboBox = this.down('form').getForm().findField('purchase_order_detail_id'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : purchase_order_detail_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( purchase_order_detail_id );
			}
		});
	},
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		
		me.setSelectedPurchaseOrderDetail( record.get("purchase_order_detail_id")  ) ;  
	},
	
	
	setParentData: function( record) {
		this.down('form').getForm().findField('purchase_receival_code').setValue(record.get('code')); 
		this.down('form').getForm().findField('purchase_receival_id').setValue(record.get('id'));
	}
 
});




