Ext.define('AM.view.operation.rolleridentificationform.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.rolleridentificationformform',

  title : 'Add / Edit RollerIdentificationForm',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
			var me = this; 
	
	var remoteJsonStoreContact = Ext.create(Ext.data.JsonStore, {
		storeId : 'contact_search',
		fields	: [
		 		{
					name : 'contact_name',
					mapping : "name"
				} ,
				{
					name : 'contact_description',
					mapping : "description"
				} ,
		 
				{
					name : 'contact_id',
					mapping : 'id'
				}  
		],
		
	 
		proxy  	: {
			type : 'ajax',
			url : 'api/search_customers',
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
								xtype: 'textfield',
								fieldLabel : 'No. Diss',
								name : 'nomor_disasembly'
							},
	    				{
        	        xtype: 'textarea',
        	        name : 'description',
        	        fieldLabel: 'Deskripsi'
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
	    					xtype: 'datefield',
	    					name : 'incoming_roll',
	    					fieldLabel: 'Incoming Roll Date',
	    					format: 'Y-m-d',
	    				},
	    			  {
	    					xtype: 'datefield',
	    					name : 'identified_date',
	    					fieldLabel: 'Identified Date',
	    					format: 'Y-m-d',
	    				},
	    				{
	    					xtype: 'checkbox',
	    					name : 'is_in_house',
	    					fieldLabel: 'InHouse?',
	    				},
	    				{
		    				fieldLabel: 'Contact',
		    				xtype: 'combo',
		    				queryMode: 'remote',
		    				forceSelection: true, 
		    				displayField : 'contact_name',
		    				valueField : 'contact_id',
		    				pageSize : 5,
		    				minChars : 1, 
		    				allowBlank : false, 
		    				triggerAction: 'all',
		    				store : remoteJsonStoreContact , 
		    				listConfig : {
		    					getInnerTpl: function(){
		    						return  	'<div data-qtip="{contact_name}">' + 
		    												'<div class="combo-name">{contact_name}</div>' + 
		    												'<div class="combo-name">Deskripsi: {contact_description}</div>' + 
		    						 					'</div>';
		    					}
	    					},
	    					name : 'contact_id' 
	    	      },
	    	      {
	    					xtype: 'numberfield',
	    					name : 'amount',
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
  
    setSelectedCustomer: function( contact_id ){
		var comboBox = this.down('form').getForm().findField('contact_id'); 
		var me = this; 
		var store = comboBox.store; 
		// console.log( 'setSelectedMember');
		// console.log( store ) ;
		store.load({
			params: {
				selected_id : contact_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( contact_id );
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
		me.setSelectedCustomer( record.get("contact_id")  ) ;
 
	}
 
});