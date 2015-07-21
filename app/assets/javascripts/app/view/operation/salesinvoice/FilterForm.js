
Ext.define('AM.view.operation.salesinvoice.FilterForm', {
  extend: 'Ext.window.Window',
  alias : 'widget.filtersalesinvoiceform',

  title : 'Filter SalesInvoice',
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
    					name : 'start_invoice_date',
    					fieldLabel: 'Mulai Invoice Date',
    					format: 'Y-m-d',
				},
				
                {
    					xtype: 'datefield',
    					name : 'end_invoice_date',
    					fieldLabel: 'Akhir Invoice Date',
    					format: 'Y-m-d',
				},
				
				
		  
    	        
    	        {
    				fieldLabel: 'DeliveryOrder',
    				xtype: 'combo',
    				queryMode: 'remote',
    				forceSelection: true, 
    				displayField : 'delivery_order_code',
    				valueField : 'delivery_order_id',
    				pageSize : 5,
    				minChars : 1, 
    				allowBlank : false, 
    				triggerAction: 'all',
    				store : remoteJsonStoreDeliveryOrder , 
    				listConfig : {
    					getInnerTpl: function(){
    						return  	'<div data-qtip="{delivery_order_code}">' + 
    												'<div class="combo-name">{delivery_order_code}</div>' + 
    												'<div class="combo-name">NomorSurat: {delivery_order_nomor_surat}</div>' + 
    						 					'</div>';
    					}
    				},
    				name : 'delivery_order_id' 
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




