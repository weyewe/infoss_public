
Ext.define('AM.view.operation.salesorder.FilterForm', {
  extend: 'Ext.window.Window',
  alias : 'widget.filtersalesorderform',

  title : 'Filter SalesOrder',
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
    					xtype: 'checkboxfield',
    					name : 'is_confirmed',
    					fieldLabel: 'Sudah Konfirmasi?' 
				},
                {
    					xtype: 'datefield',
    					name : 'start_confirmation',
    					fieldLabel: 'Mulai Konfirmasi',
    					format: 'Y-m-d',
				},
				
                {
    					xtype: 'datefield',
    					name : 'end_confirmation',
    					fieldLabel: 'Akhir Konfirmasi',
    					format: 'Y-m-d',
				},
 
    		    {
    					xtype: 'datefield',
    					name : 'start_sales_date',
    					fieldLabel: 'Mulai Penjualan',
    					format: 'Y-m-d',
				},
 
    		    {
    					xtype: 'datefield',
    					name : 'end_sales_date',
    					fieldLabel: 'Akhir Penjualan',
    					format: 'Y-m-d',
				},
 
    	        
    	      {
	    				fieldLabel: 'Contact',
	    				xtype: 'combo',
	    				queryMode: 'remote',
	    				forceSelection: false, 
	    				displayField : 'contact_name',
	    				valueField : 'contact_id',
	    				pageSize : 5,
	    				minChars : 1, 
	    				allowBlank : true, 
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
	    				forceSelection: false, 
	    				displayField : 'employee_name',
	    				valueField : 'employee_id',
	    				pageSize : 5,
	    				minChars : 1, 
	    				allowBlank : true, 
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
	    				forceSelection: false, 
	    				displayField : 'exchange_name',
	    				valueField : 'exchange_id',
	    				pageSize : 5,
	    				minChars : 1, 
	    				allowBlank : true, 
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
      text: 'Reset',
      action: 'reset'
    },{
      text: 'Cancel',
      scope: this,
      handler: this.close
    },
    ];

    this.callParent(arguments);
  },
   
	setPreviousValue: function(extraParamsObject){
	   // console.log("inside setting the previous value");
	    var me = this; 
	    var view = this; 
 
 		var form_new  = view.down('form');
  
 		var items = form_new.items ; 
 		me.setLoading(true);
     		
       for(i = 0; i <  items.length; i += 1){ 
             var item_i = items.getAt(i);
             
             
             var field  = view.down('form').getForm().findField( item_i.name ); 
             
             if( item_i.name in extraParamsObject ){
                 
             }else{
                  
                 continue; 
             }
             
             
             var field_value = extraParamsObject[item_i.name]  
             var field_name = item_i.name
             
          
             
             if( item_i.xtype !== "combo"){ 
             	field.setValue( field_value) ;
             	
             	
             }else{
   
   
   
        		var comboBox = field;  
        		var me = this; 
        		var store = comboBox.store;   
                // console.log("gonna remote load "+ field_name);
                
                me.loadComboBox( comboBox, field_value, field_name );
  
             } 
        }
        me.setLoading(false);
        
	},
	
	loadComboBox: function(comboBox, field_value, field_name ){
        		var store = comboBox.store;  
                // console.log("gonna remote load "+ field_name);
 

        		store.load({
        			params: {
        				selected_id :  field_value
        			},
        			callback : function(records, options, success){
        				// console.log("success remote load "+ field_name);
        				comboBox.setValue( field_value );
        			}
        		});
	    
	}
 
});




