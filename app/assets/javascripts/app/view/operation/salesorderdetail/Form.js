
Ext.define('AM.view.operation.salesorderdetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.salesorderdetailform',

 
  title : 'Add / Edit SalesOrderDetail',

  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	
	
    var localJsonStoreStatus = Ext.create(Ext.data.Store, {
		type : 'array',
		storeId : 'sales_status_search',
		fields	: [ 
			{ name : "is_service"}, 
			{ name : "is_service_text"}  
		], 
		data : [
			{ is_service : false, is_service_text : "Trading"},
			{ is_service : true, is_service_text : "Service"}
		] 
	});
	
	
	var remoteJsonStoreItem = Ext.create(Ext.data.JsonStore, {
		storeId : 'item_search',
		fields	: [
		 		{
					name : 'item_sku',
					mapping : "sku"
				}, 
				{
					name : 'item_name',
					mapping : 'name'
				},
				{
					name : 'item_id',
					mapping : "id"
				}, 
	 
		],
		proxy  	: {
			type : 'ajax',
			url : 'api/search_items',
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
	        name : 'sales_order_id',
	        fieldLabel: 'sales_order_id'
	      },
	      {
            xtype: 'displayfield',
            name : 'sales_order_code',
            fieldLabel: 'Kode SalesOrder'
        },
			{
				fieldLabel: 'Status',
				xtype: 'combo',
				queryMode: 'remote',
				forceSelection: true, 
				displayField : 'is_service_text',
				valueField : 'is_service',
				pageSize : 5,
				minChars : 1, 
				allowBlank : false, 
				triggerAction: 'all',
				store : localJsonStoreStatus , 
				listConfig : {
					getInnerTpl: function(){
						return  	'<div data-qtip="{is_service_text}">' +  
												'<div class="combo-name">{is_service_text}</div>' +  
						 					'</div>';
					}
				},
				name : 'is_service' 
			},
			{
				fieldLabel: 'Item',
				xtype: 'combo',
				queryMode: 'remote',
				forceSelection: true, 
				displayField : 'item_name',
				valueField : 'item_id',
				pageSize : 5,
				minChars : 1, 
				allowBlank : false, 
				triggerAction: 'all',
				store : remoteJsonStoreItem , 
				listConfig : {
					getInnerTpl: function(){
						return  	'<div data-qtip="{item_name}">' +  
												'<div class="combo-name">'  + 
															" ({item_name}) " 		+ "<br />" 	 + 
															'{item_sku}' 			+  
												 "</div>" +  
						 					'</div>';
					}
				},
				name : 'item_id' 
			},
				
			{
    	        xtype: 'textfield',
    	        name : 'amount',
    	        fieldLabel: 'Quantity'
    	     },
   
    	     {
    	        xtype: 'textfield',
    	        name : 'price',
    	        fieldLabel: 'Selling Price'
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
	
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		
		me.setSelectedItem( record.get("item_id")  ) ; 
		me.setSelectedStatus( record.get("is_service")  ) ; 
	},
	
	
	setParentData: function( record) {
		this.down('form').getForm().findField('sales_order_code').setValue(record.get('code')); 
		this.down('form').getForm().findField('sales_order_id').setValue(record.get('id'));
	}
 
});




