
Ext.define('AM.view.operation.virtualdeliveryorderdetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.virtualdeliveryorderdetailform',

  title : 'Add / Edit DeliveryVirtualOrder Detail',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	
	
    var remoteJsonStoreVirtualOrderDetail = Ext.create(Ext.data.JsonStore, {
			storeId : 'virtual_order_detail_search',
			fields	: [
					{
						name : 'virtual_order_detail_id',
						mapping : "id"
					}, 
					{
						name : 'virtual_order_detail_code',
						mapping : "code"
					}, 
					{
						name : 'virtual_order_detail_pending_delivery_amount',
						mapping : "pending_delivery_amount"
					}, 
					{
						name : 'virtual_order_detail_item_sku',
						mapping : "item_sku"
					}, 
					{
						name : 'virtual_order_detail_item_name',
						mapping : 'item_name'
					},
					{
						name : 'virtual_order_detail_item_id',
						mapping : "item_id"
					}, 
		 
			],
			proxy  	: {
				type : 'ajax',
				url : 'api/search_virtual_order_details',
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
	        name : 'virtual_delivery_order_id',
	        fieldLabel: 'virtual_delivery_order_id'
	      },
	      {
            xtype: 'displayfield',
            name : 'virtual_delivery_order_code',
            fieldLabel: 'Kode DeliveryOrder'
        },
			
			{
				fieldLabel: 'Item',
				xtype: 'combo',
				queryMode: 'remote',
				forceSelection: true, 
				displayField : 'virtual_order_detail_item_name',
				valueField : 'virtual_order_detail_id',
				pageSize : 5,
				minChars : 1, 
				allowBlank : false, 
				triggerAction: 'all',
				store : remoteJsonStoreVirtualOrderDetail , 
				listConfig : {
					getInnerTpl: function(){
						return  	'<div data-qtip="{virtual_order_detail_item_name}">' +  
												'<div class="combo-name">'  +
															" {virtual_order_detail_code} " 		+ "<br />" 	 + 
															" ({virtual_order_detail_item_name}) " 		+ "<br />" 	 + 
															'{virtual_order_detail_item_sku}' 			+ "<br />" 	 +
															'{virtual_order_detail_pending_delivery_amount}' 	+
												 "</div>" +  
						 					'</div>';
					}
				},
				name : 'virtual_order_detail_id' 
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

	setSelectedItem: function( virtual_order_detail_id ){
		var comboBox = this.down('form').getForm().findField('virtual_order_detail_id'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : virtual_order_detail_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( virtual_order_detail_id );
			}
		});
	},
	
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		
		me.setSelectedItem( record.get("virtual_order_detail_id")  ) ; 
	},
	
	
	setParentData: function( record) {
		this.down('form').getForm().findField('virtual_delivery_order_code').setValue(record.get('code')); 
		this.down('form').getForm().findField('virtual_delivery_order_id').setValue(record.get('id'));
	}
 
});




