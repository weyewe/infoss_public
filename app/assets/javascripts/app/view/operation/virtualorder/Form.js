Ext.define('AM.view.operation.virtualorder.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.virtualorderform',

  title : 'Add / Edit VirtualOrder',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
		var me = this; 
		
		var localJsonStoreOrderType = Ext.create(Ext.data.Store, {
			type : 'array',
			storeId : 'order_type_case',
			fields	: [ 
				{ name : "order_type"}, 
				{ name : "order_type_text"}  
			], 
			data : [
				{ order_type : 0, order_type_text : "Trial Order"},
				{ order_type : 1, order_type_text : "Sample Order"},
				{ order_type : 2, order_type_text : "Consignment"},
			] 
		});
		
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
	
	var remoteJsonStoreEmployee = Ext.create(Ext.data.JsonStore, {
		storeId : 'employee_search',
		fields	: [
		 		{
					name : 'employee_name',
					mapping : "name"
				} ,
				{
					name : 'employee_description',
					mapping : "description"
				} ,
		 
				{
					name : 'employee_id',
					mapping : 'id'
				}  
		],
		
	 
		proxy  	: {
			type : 'ajax',
			url : 'api/search_employees',
			reader : {
				type : 'json',
				root : 'records', 
				totalProperty  : 'total'
			}
		},
		autoLoad : false 
	});
	
	var remoteJsonStoreExchange = Ext.create(Ext.data.JsonStore, {
		storeId : 'exchange_search',
		fields	: [
		 		{
					name : 'exchange_name',
					mapping : "name"
				} ,
				{
					name : 'exchange_description',
					mapping : "description"
				} ,
		 
				{
					name : 'exchange_id',
					mapping : 'id'
				}  
		],
		
	 
		proxy  	: {
			type : 'ajax',
			url : 'api/search_exchanges',
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
	    					name : 'order_date',
	    					fieldLabel: 'Tanggal Order',
	    					format: 'Y-m-d',
	    				},
	    				{
      	        xtype: 'textarea',
      	        name : 'description',
      	        fieldLabel: 'Deskripsi'
	    	      },
    	        {
		    				fieldLabel: 'Order Type',
		    				xtype: 'combo',
		    				queryMode: 'remote',
		    				forceSelection: true, 
		    				displayField : 'order_type_text',
		    				valueField : 'order_type',
		    				pageSize : 5,
		    				minChars : 1, 
		    				allowBlank : false, 
		    				triggerAction: 'all',
		    				store : localJsonStoreOrderType , 
		    				listConfig : {
		    					getInnerTpl: function(){
		    						return  	'<div data-qtip="{order_type_text}">' + 
		    												'<div class="combo-name">{order_type_text}</div>' + 
		    						 					'</div>';
		    					}
	    					},
	    					name : 'order_type' 
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
		    				fieldLabel: 'Marketing',
		    				xtype: 'combo',
		    				queryMode: 'remote',
		    				forceSelection: true, 
		    				displayField : 'employee_name',
		    				valueField : 'employee_id',
		    				pageSize : 5,
		    				minChars : 1, 
		    				allowBlank : false, 
		    				triggerAction: 'all',
		    				store : remoteJsonStoreEmployee , 
		    				listConfig : {
		    					getInnerTpl: function(){
		    						return  	'<div data-qtip="{employee_name}">' + 
		    												'<div class="combo-name">{employee_name}</div>' + 
		    												'<div class="combo-name">Deskripsi: {employee_description}</div>' + 
		    						 					'</div>';
		    					}
	    					},
	    					name : 'employee_id' 
	    				},
	    				{
		    				fieldLabel: 'Currency',
		    				xtype: 'combo',
		    				queryMode: 'remote',
		    				forceSelection: true, 
		    				displayField : 'exchange_name',
		    				valueField : 'exchange_id',
		    				pageSize : 5,
		    				minChars : 1, 
		    				allowBlank : false, 
		    				triggerAction: 'all',
		    				store : remoteJsonStoreExchange , 
		    				listConfig : {
		    					getInnerTpl: function(){
		    						return  	'<div data-qtip="{exchange_name}">' + 
		    												'<div class="combo-name">{exchange_name}</div>' + 
		    												'<div class="combo-name">Deskripsi: {exchange_description}</div>' + 
		    						 					'</div>';
		    					}
	    					},
	    					name : 'exchange_id' 
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
	
	setSelectedOrderType: function( order_type ){
		var comboBox = this.down('form').getForm().findField('order_type'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : order_type 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( order_type );
			}
		});
	},
	
	
	setSelectedEmployee: function( employee_id ){
		var comboBox = this.down('form').getForm().findField('employee_id'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : employee_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( employee_id );
			}
		});
	},
	
	setSelectedExchange: function( exchange_id ){
		var comboBox = this.down('form').getForm().findField('exchange_id'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : exchange_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( exchange_id );
			}
		});
	},
	
	setComboBoxData : function( record){ 

		var me = this; 
		me.setLoading(true);
		me.setSelectedOrderType( record.get("order_type")  ) ;
		me.setSelectedEmployee( record.get("employee_id")  ) ;
		me.setSelectedExchange( record.get("exchange_id")  ) ;
		me.setSelectedCustomer( record.get("contact_id")  ) ;
 
	}
 
});




