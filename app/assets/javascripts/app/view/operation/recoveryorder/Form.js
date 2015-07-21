
Ext.define('AM.view.operation.recoveryorder.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.recoveryorderform',

  title : 'Add / Edit RecoveryOrder',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	var me = this; 
	var remoteJsonStoreRIF = Ext.create(Ext.data.JsonStore, {
		storeId : 'rif_search',
		fields	: [
		 		{
					name : 'rif_search',
					mapping : "name"
				} ,
				{
					name : 'rif_code',
					mapping : "code"
				} ,
		 
		 		{
					name : 'rif_code',
					mapping : "code"
				},
					{
					name : 'rif_nomor_disasembly',
					mapping : "nomor_disasembly"
				},
				{
					name : 'rif_contact_name',
					mapping : "contact_name"
				},
				{
					name : 'rif_is_in_house',
					mapping : "is_in_house"
				},
				{
					name : 'rif_amount',
					mapping : "amount"
				},
				{
					name : 'rif_incoming_roll',
					mapping : "incoming_roll"
				},
					{
					name : 'rif_identified_date',
					mapping : "identified_date"
				},
				{
					name : 'roller_identification_form_id',
					mapping : 'id'
				}  
		],
		
	 
		proxy  	: {
			type : 'ajax',
			url : 'api/search_roller_identification_forms',
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
    		        xtype: 'textfield',
    		        name : 'code',
    		        fieldLabel: 'Kode'
    		  	  },
    		  	  {
		    				fieldLabel: 'RIF',
		    				xtype: 'combo',
		    				queryMode: 'remote',
		    				forceSelection: true, 
		    				displayField : 'rif_code',
		    				valueField : 'roller_identification_form_id',
		    				pageSize : 5,
		    				minChars : 1, 
		    				allowBlank : false, 
		    				triggerAction: 'all',
		    				store : remoteJsonStoreRIF , 
		    				listConfig : {
		    					getInnerTpl: function(){
		    						return  	'<div data-qtip="{rif_code}">' + 
		    												'<div class="combo-name">Code : {rif_code}</div>' + 
		    												'<div class="combo-name">No.Diss : {rif_nomor_disasembly}</div>' + 
		    												'<div class="combo-name">InHouse : {rif_is_in_house}</div>' + 
		    												'<div class="combo-name">Contact : {rif_contact_name}</div>' + 
		    												'<div class="combo-name">QTY : {rif_amount}</div>' + 
		    												'<div class="combo-name">Identified Date : {rif_identified_date}</div>' + 
		    												'<div class="combo-name">Incoming Roll Date : {rif_incoming_roll}</div>' + 
		    						 					'</div>';
		    					}
		    				},
		    				name : 'roller_identification_form_id' 
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
	    					xtype: 'numberfield',
	    					name : 'amount_received',
	    					fieldLabel: 'Quantity',
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
  
  setSelectedRIF: function( roller_identification_form_id ){
		var comboBox = this.down('form').getForm().findField('roller_identification_form_id'); 
		var me = this; 
		var store = comboBox.store; 
		// console.log( 'setSelectedMember');
		// console.log( store ) ;
		store.load({
			params: {
				selected_id : roller_identification_form_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( roller_identification_form_id );
			}
		});
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
	
	setComboBoxData : function( record){ 

		var me = this; 
		me.setLoading(true);
		
		me.setSelectedWarehouse( record.get("warehouse_id")  ) ;
		me.setSelectedRIF( record.get("roller_identification_form_id")  ) ;
 
	}
 
});




