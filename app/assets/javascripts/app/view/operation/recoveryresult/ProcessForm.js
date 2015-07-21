Ext.define('AM.view.operation.recoveryresult.ProcessForm', {
  extend: 'Ext.window.Window',
  alias : 'widget.processrecoveryresultform',

  title : 'Process RecoveryResult',
  layout: 'fit',
	width	: 400,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
  	var me = this; 
  	
 	var remoteJsonStoreItemCompound = Ext.create(Ext.data.JsonStore, {
			storeId : 'item_compound_search',
			fields	: [
	 				{
						name : 'item_compound_name',
						mapping : "name"
					},
					{
						name : 'item_compound_sku',
						mapping : "sku"
					},
					{
						name : 'item_compound_amount',
						mapping : "amount"
					},
					{
						name : 'item_compound_uom',
						mapping : "uom_name"
					},
					{
						name : 'item_compound_id',
						mapping : 'id'
					}
			],
			proxy  	: {
				type : 'ajax',
				url : 'api/search_item_compounds',
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
					xtype: 'checkbox',
					fieldLabel : 'Disassembled',
					name : 'is_disassembled'
				},
				{
					xtype: 'checkbox',
					fieldLabel : 'StrippedAndGlued',
					name : 'is_stripped_and_glued'
				},
				{
					xtype: 'checkbox',
					fieldLabel : 'Wrapped',
					name : 'is_wrapped'
				},
				{
					xtype: 'checkbox',
					fieldLabel : 'Vulcanized',
					name : 'is_vulcanized'
				},
				{
					xtype: 'checkbox',
					fieldLabel : 'FacedOff',
					name : 'is_faced_off'
				},
				{
					xtype: 'checkbox',
					fieldLabel : 'ConventionalGrinded',
					name : 'is_conventional_grinded'
				},
				{
					xtype: 'checkbox',
					fieldLabel : 'CNCGrinded',
					name : 'is_cnc_grinded'
				},
				{
					xtype: 'checkbox',
					fieldLabel : 'PolishedAndQC',
					name : 'is_polished_and_gc'
				},
				{
					xtype: 'checkbox',
					fieldLabel : 'Packaged',
					name : 'is_packaged'
				},
				{
					xtype: 'numberfield',
					fieldLabel : 'Compound Usage',
					name : 'compound_usage'
				},
				{
					fieldLabel: 'Compound UnderLayer',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'item_compound_name',
					valueField : 'item_compound_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStoreItemCompound , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{item_compound_name}">' + 
													'<div class="combo-name">{item_compound_sku}</div>' +
													'<div class="combo-name">{item_compound_name}</div>' +
													'<div class="combo-name">{item_compound_amount}</div>' +
													'<div class="combo-name">{item_compound_uom}</div>' +
							 					'</div>';
						}
					},
					name : 'compound_under_layer_id' 
				},
				{
					xtype: 'numberfield',
					fieldLabel : 'Compound Under Layer Usage',
					name : 'compound_under_layer_usage'
				},
			]
    }];


    this.buttons = [{
      text: 'Process',
      action: 'process'
    }, {
      text: 'Cancel',
      scope: this,
      handler: this.close
    }];

    this.callParent(arguments);
  },
  
  
	setSelectedCompound: function( compound_under_layer_id ){ 
		var comboBox = this.down('form').getForm().findField('compound_under_layer_id'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : compound_under_layer_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( compound_under_layer_id );
			}
		});
	},
	
	setComboBoxData : function( record){ 

		var me = this; 
		me.setLoading(true);
		
		me.setSelectedCompound( record.get("compound_under_layer_id")  ) ;
 
	},

	setPreviousValue: function(record){
	   // console.log("inside setting the previous value");
	    var me = this; 
	    var view = this; 
 
 		var form_new  = view.down('form');
  
 		var items = form_new.items ; 
 		me.setLoading(true);
     		
       for(i = 0; i <  items.length; i += 1){ 
             var item_i = items.getAt(i);
             
             
             var field  = view.down('form').getForm().findField( item_i.name ); 
             
             //if( item_i.name in record ){
                 
             //}else{
                  
             //    continue; 
             //}
             
             
             var field_value = record.get(item_i.name)
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
	    
	},
	
	
	setParentData: function( record ) {
		// this.down('form').getForm().findField('code').setValue(record.get('code')); 
		// this.down('form').getForm().findField('transaction_datetime').setValue(record.get('transaction_datetime')); 
		// this.down('form').getForm().findField('description').setValue(record.get('description')); 
	}
});
