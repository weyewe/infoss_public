
Ext.define('AM.view.operation.stockadjustmentdetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.stockadjustmentdetailform',

  title : 'Add / Edit Stock Adjustment Detail',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	
	
	
	    var localJsonStoreStatus = Ext.create(Ext.data.Store, {
			type : 'array',
			storeId : 'adjustment_status_search',
			fields	: [ 
				{ name : "status"}, 
				{ name : "status_text"}  
			], 
			data : [
				{ status : 1, status_text : "Penambahan"},
				{ status : 2, status_text : "Pengurangan"}
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
	        name : 'stock_adjustment_id',
	        fieldLabel: 'stock_adjustment_id'
	      },
	      {
            xtype: 'displayfield',
            name : 'stock_adjustment_code',
            fieldLabel: 'Kode StockAdjustment'
        },
			{
				fieldLabel: 'Status Penyesuaian',
				xtype: 'combo',
				queryMode: 'remote',
				forceSelection: true, 
				displayField : 'status_text',
				valueField : 'status',
				pageSize : 5,
				minChars : 1, 
				allowBlank : false, 
				triggerAction: 'all',
				store : localJsonStoreStatus , 
				listConfig : {
					getInnerTpl: function(){
						return  	'<div data-qtip="{status_text}">' +  
												'<div class="combo-name">{status_text}</div>' +  
						 					'</div>';
					}
				},
				name : 'status' 
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
    	        fieldLabel: 'Value per item'
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
	 
	
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		
		me.setSelectedItem( record.get("item_id")  ) ;  
	},
	
	
	setParentData: function( record) {
		this.down('form').getForm().findField('stock_adjustment_code').setValue(record.get('code')); 
		this.down('form').getForm().findField('stock_adjustment_id').setValue(record.get('id'));
	}
 
});




