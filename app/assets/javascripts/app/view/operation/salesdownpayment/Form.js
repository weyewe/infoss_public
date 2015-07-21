Ext.define('AM.view.operation.salesdownpayment.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.salesdownpaymentform',

  title : 'Add / Edit SalesDownPayment',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	
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
					xtype: 'datefield',
					name : 'down_payment_date',
					fieldLabel: 'Down Payment Date',
					format: 'Y-m-d',
				},
				{
					xtype: 'datefield',
					name : 'due_date',
					fieldLabel: 'Due Date',
					format: 'Y-m-d',
				},
				{
							fieldLabel: 'Currency ',
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
															'<div class="combo-name">{exchange_name}</div>'  
									 					'</div>';
								}
							},
							name : 'exchange_id' 
				},
				{
	        xtype: 'numberfield',
	        name : 'total_amount',
	        fieldLabel: 'Total Amount'
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
	
	setSelectedExchange: function( exchange_id ){
		var comboBox = this.down('form').getForm().findField('exchange_id'); 
		var me = this; 
		var store = comboBox.store; 
		// console.log( 'setSelectedMember');
		// console.log( store ) ;
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
		me.setSelectedCustomer( record.get("contact_id")  ) ;
		me.setSelectedExchange( record.get("exchange_id")  ) ;
	}
});

