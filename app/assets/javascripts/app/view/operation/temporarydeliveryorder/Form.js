
Ext.define('AM.view.operation.temporarydeliveryorder.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.temporarydeliveryorderform',

  title : 'Add / Edit TemporaryDeliveryOrder',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
			var me = this; 
	
	var remoteJsonStoreDeliveryOrder = Ext.create(Ext.data.JsonStore, {
		storeId : 'delivery_order_search',
		fields	: [
		 		{
					name : 'delivery_order_code',
					mapping : "code"
				} ,
				{
					name : 'delivery_order_nomor_surat',
					mapping : "nomor_surat"
				} ,
		 		{
					name : 'delivery_order_contact_name',
					mapping : "contact_name"
				} ,
				{
					name : 'delivery_order_delivery_date',
					mapping : "delivery_date"
				} ,
				{
					name : 'delivery_order_id',
					mapping : 'id'
				}  
		],
		
	 
		proxy  	: {
			type : 'ajax',
			url : 'api/search_delivery_orders',
			reader : {
				type : 'json',
				root : 'records', 
				totalProperty  : 'total'
			}
		},
		autoLoad : false 
	});
	
	var remoteJsonStoreWarehouse = Ext.create(Ext.data.JsonStore, {
		storeId : 'warehouse_search',
		fields	: [
				{
					name : 'warehouse_code',
					mapping : "code"
				} ,
		 		{
					name : 'warehouse_name',
					mapping : "name"
				} ,
				{
					name : 'warehouse_id',
					mapping : 'id'
				}  
		],
		
	 
		proxy  	: {
			type : 'ajax',
			url : 'api/search_warehouses',
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
    		        xtype: 'displayfield',
    		        name : 'code',
    		        fieldLabel: 'Kode'
    		  	  },
	    		  	{
								xtype: 'textfield',
								fieldLabel : 'Nomor Surat',
								name : 'nomor_surat'
							},
	    		    {
	    					xtype: 'datefield',
	    					name : 'delivery_date',
	    					fieldLabel: 'Tanggal Delivery',
	    					format: 'Y-m-d',
	    				},
	    	      {
		    				fieldLabel: 'Delivery Order',
		    				xtype: 'combo',
		    				queryMode: 'remote',
		    				forceSelection: true, 
		    				displayField : 'delivery_order_nomor_surat',
		    				valueField : 'delivery_order_id',
		    				pageSize : 5,
		    				minChars : 1, 
		    				allowBlank : false, 
		    				triggerAction: 'all',
		    				store : remoteJsonStoreDeliveryOrder , 
		    				listConfig : {
		    					getInnerTpl: function(){
		    						return  	'<div data-qtip="{delivery_order_code}">' + 
		    												'<div class="combo-name">{delivery_order_nomor_surat}</div>' + 
		    												'<div class="combo-name">Contact: {delivery_order_contact_name}</div>' + 
		    						 					'</div>';
		    					}
	    					},
	    					name : 'delivery_order_id' 
	    	      },
    					{
		    				fieldLabel: 'Warehouse',
		    				xtype: 'combo',
		    				queryMode: 'remote',
		    				forceSelection: true, 
		    				displayField : 'warehouse_name',
		    				valueField : 'warehouse_id',
		    				pageSize : 5,
		    				minChars : 1, 
		    				allowBlank : false, 
		    				triggerAction: 'all',
		    				store : remoteJsonStoreWarehouse , 
		    				listConfig : {
		    					getInnerTpl: function(){
		    						return  	'<div data-qtip="{warehouse_name}">' + 
		    												'<div class="combo-name">Code: {warehouse_code}</div>' + 
		    												'<div class="combo-name">Name: {warehouse_name}</div>' + 
		    						 					'</div>';
		    					}
	    					},
	    					name : 'warehouse_id' 
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
  
    setSelectedDeliveryOrder: function( delivery_order_id ){
			var comboBox = this.down('form').getForm().findField('delivery_order_id'); 
			var me = this; 
			var store = comboBox.store; 
			store.load({
				params: {
					selected_id : delivery_order_id 
				},
				callback : function(records, options, success){
					me.setLoading(false);
					comboBox.setValue( delivery_order_id );
				}
			});
		},
	
		setSelectedWarehouse: function( warehouse_id ){
			var comboBox = this.down('form').getForm().findField('warehouse_id'); 
			var me = this; 
			var store = comboBox.store; 
			store.load({
				params: {
					selected_id : warehouse_id 
				},
				callback : function(records, options, success){
					me.setLoading(false);
					comboBox.setValue( warehouse_id );
				}
			});
		},
	
	
	setComboBoxData : function( record){ 

		var me = this; 
		me.setLoading(true);
		
		me.setSelectedDeliveryOrder( record.get("delivery_order_id")  ) ;
		me.setSelectedWarehouse( record.get("warehouse_id")  ) ;
	}
 
});




