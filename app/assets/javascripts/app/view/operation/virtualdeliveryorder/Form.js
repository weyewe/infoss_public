
Ext.define('AM.view.operation.virtualdeliveryorder.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.virtualdeliveryorderform',

  title : 'Add / Edit VirtualDeliveryOrder',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	var me = this; 
	
	var remoteJsonStoreWarehouse = Ext.create(Ext.data.JsonStore, {
		storeId : 'warehouse_search',
		fields	: [
		 		{
					name : 'warehouse_name',
					mapping : "name"
				} ,
				{
					name : 'warehouse_description',
					mapping : "description"
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
	
	var remoteJsonStoreVirtualOrder = Ext.create(Ext.data.JsonStore, {
		storeId : 'virtual_order_search',
		fields	: [
		 		{
					name : 'virtual_order_code',
					mapping : "code"
				} ,
				{
					name : 'virtual_order_nomor_surat',
					mapping : "nomor_surat"
				} ,
		 
				{
					name : 'virtual_order_id',
					mapping : 'id'
				}  
		],
		
	 
		proxy  	: {
			type : 'ajax',
			url : 'api/search_virtual_orders',
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
    					xtype: 'datefield',
    					name : 'delivery_date',
    					fieldLabel: 'Tanggal Delivery',
    					format: 'Y-m-d',
    			},
    			{
							xtype: 'textfield',
							fieldLabel : 'Nomor Surat',
							name : 'nomor_surat'
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
    												'<div class="combo-name">{warehouse_name}</div>' + 
    												'<div class="combo-name">Deskripsi: {warehouse_description}</div>' + 
    						 					'</div>';
    					}
    				},
    				name : 'warehouse_id' 
    			},
    			
    			{
    				fieldLabel: 'VirtualOrder',
    				xtype: 'combo',
    				queryMode: 'remote',
    				forceSelection: true, 
    				displayField : 'virtual_order_code',
    				valueField : 'virtual_order_id',
    				pageSize : 5,
    				minChars : 1, 
    				allowBlank : false, 
    				triggerAction: 'all',
    				store : remoteJsonStoreVirtualOrder , 
    				listConfig : {
    					getInnerTpl: function(){
    						return  	'<div data-qtip="{virtual_order_code}">' + 
    												'<div class="combo-name">{virtual_order_code}</div>' + 
    												'<div class="combo-name">NomorSurat: {virtual_order_nomor_surat}</div>' + 
    						 					'</div>';
    					}
    				},
    				name : 'virtual_order_id' 
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
  
    setSelectedWarehouse: function( warehouse_id ){
		var comboBox = this.down('form').getForm().findField('warehouse_id'); 
		var me = this; 
		var store = comboBox.store; 
		// console.log( 'setSelectedMember');
		// console.log( store ) ;
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
	
	setSelectedVirtualOrder: function( virtual_order_id ){
		var comboBox = this.down('form').getForm().findField('virtual_order_id'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : virtual_order_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( virtual_order_id );
			}
		});
	},
	
	setComboBoxData : function( record){ 

		var me = this; 
		me.setLoading(true);
		
		me.setSelectedWarehouse( record.get("warehouse_id")  ) ;
		me.setSelectedVirtualOrder( record.get("virtual_order_id")  ) ;
 
	}
 
});




