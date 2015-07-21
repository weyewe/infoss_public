
Ext.define('AM.view.operation.virtualorderclearance.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.virtualorderclearanceform',

  title : 'Add / Edit VirtualOrderClearance',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	var me = this; 
	var remoteJsonStoreVirtualDeliveryOrder = Ext.create(Ext.data.JsonStore, {
		storeId : 'virtual_delivery_order_search',
		fields	: [
		 		{
					name : 'virtual_delivery_order_code',
					mapping : "code"
				} ,
				{
					name : 'virtual_delivery_order_contact_name',
					mapping : "contact_name"
				} ,
		 		{
					name : 'virtual_delivery_order_nomor_surat',
					mapping : "nomor_surat"
				} ,
				{
					name : 'virtual_delivery_order_order_type',
					mapping : "order_type"
				} ,
				{
					name : 'virtual_delivery_order_delivery_date',
					mapping : "delivery_date"
				} ,
				{
					name : 'virtual_delivery_order_id',
					mapping : 'id'
				}  
		],
		
	 
		proxy  	: {
			type : 'ajax',
			url : 'api/search_virtual_delivery_orders',
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
		    				fieldLabel: 'Delivery VirtualOrder',
		    				xtype: 'combo',
		    				queryMode: 'remote',
		    				forceSelection: true, 
		    				displayField : 'virtual_delivery_order_nomor_surat',
		    				valueField : 'virtual_delivery_order_id',
		    				pageSize : 5,
		    				minChars : 1, 
		    				allowBlank : false, 
		    				triggerAction: 'all',
		    				store : remoteJsonStoreVirtualDeliveryOrder , 
		    				listConfig : {
		    					getInnerTpl: function(){
		    						return  	'<div data-qtip="{virtual_delivery_order_nomor_surat}">' + 
		    												'<div class="combo-name">Code : {virtual_delivery_order_code}</div>' + 
		    												'<div class="combo-name">Nomor Surat : {virtual_delivery_order_nomor_surat}</div>' + 
		    												'<div class="combo-name">Contact : {virtual_delivery_order_contact_name}</div>' + 
		    						 					'</div>';
		    					}
		  					},
		  					name : 'virtual_delivery_order_id' 
		  	      },
		  	      {
	    					xtype: 'datefield',
	    					name : 'clearance_date',
	    					fieldLabel: 'Tanggal Clearance',
	    					format: 'Y-m-d',
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
  
    setSelectedVirtualDeliveryOrder: function( virtual_delivery_order_id ){
		var comboBox = this.down('form').getForm().findField('virtual_delivery_order_id'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : virtual_delivery_order_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( virtual_delivery_order_id );
			}
		});
	},
	
	setComboBoxData : function( record){ 

		var me = this; 
		me.setLoading(true);
		me.setSelectedVirtualDeliveryOrder( record.get("virtual_delivery_order_id")  ) ;
	}
 
});




