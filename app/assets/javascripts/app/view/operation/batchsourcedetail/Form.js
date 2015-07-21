
Ext.define('AM.view.operation.batchsourcedetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.batchsourcedetailform',

  title : 'Add / Edit Batch Allocation',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	
  
	
	var remoteJsonStoreBatchInstance = Ext.create(Ext.data.JsonStore, {
		storeId : 'batch_instance_search',
		fields	: [
		 		{
					name : 'batch_instance_manufactured_at',
					mapping : "manufactured_at"
				}, 
				{
					name : 'batch_instance_name',
					mapping : 'name'
				},
				{
					name : 'batch_instance_amount',
					mapping : "amount"
				}, 
				{
					name : 'batch_instance_item_sku',
					mapping : "item_sku"
				},
				{
					name : 'batch_instance_id',
					mapping : "id"
				}, 
				
	 
		],
		proxy  	: {
			type : 'ajax',
			url : 'api/search_batch_instances',
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
	        xtype: 'hidden',
	        name : 'batch_source_id',
	        fieldLabel: 'sales_order_id'
	      },
	      
			{
				fieldLabel: 'Item',
				xtype: 'combo',
				queryMode: 'remote',
				forceSelection: true, 
				displayField : 'batch_instance_name',
				valueField : 'batch_instance_id',
				pageSize : 5,
				minChars : 1, 
				allowBlank : false, 
				triggerAction: 'all',
				store : remoteJsonStoreBatchInstance , 
				listConfig : {
					getInnerTpl: function(){
						return  	'<div data-qtip="{batch_instance_name}">' +  
												'<div class="combo-name">'  + 
															"Nama Batch: <b>{batch_instance_name}</b> " 		 + "<br />" + 
															"Item: <b>{batch_instance_item_sku}</b> " 		 + "<br />" + 
															"Manufactured: <b>{batch_instance_manufactured_at}</b> " 		 + "<br />" + 
															"Jumlah: <b>{batch_instance_amount}</b> " 		 + "<br />" + 
												 "</div>" +  
						 					'</div>';
					}
				},
				name : 'batch_instance_id' 
			},
				
			{
    	        xtype: 'textfield',
    	        name : 'amount',
    	        fieldLabel: 'Quantity'
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

	setSelectedBatchInstance: function( batch_instance_id ){
		// console.log("inside set selected original account id ");
		var comboBox = this.down('form').getForm().findField('batch_instance_id'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : batch_instance_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( batch_instance_id );
			}
		});
	},
	 
	 
	setExtraParamInBatchInstanceIdComboBox: function(item_id){  
		var comboBox = this.down('form').getForm().findField('batch_instance_id'); 
		var store = comboBox.store;
		
		store.getProxy().extraParams.item_id =  item_id;
	},
	
	
	setComboBoxExtraParams: function( record ) {  
		var me =this;
		me.setExtraParamInBatchInstanceIdComboBox( record.get("item_id") ); 
	},
	
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		
		me.setSelectedBatchInstance( record.get("batch_instance_id")  ) ;  
	},
	
	
	setParentData: function( record) {
		// this.down('form').getForm().findField('template_code').setValue(record.get('code')); 
		this.down('form').getForm().findField('batch_source_id').setValue(record.get('id'));
	}
 
});




