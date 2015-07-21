
Ext.define('AM.view.operation.recoveryresultcompounddetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.recoveryresultcompounddetailform',

  title : 'Add / Edit Recovery Result Compound Usage Detail',
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
					name : 'batch_instance_name',
					mapping : "name"
				}, 
				{
					name : 'batch_instance_amount',
					mapping : "amount"
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
				name : 'recovery_order_detail_id',
				fieldLabel: 'recovery_order_detail_id'
			},
 
			
			
			{
				fieldLabel: 'Batch',
				xtype: 'combo',
				queryMode: 'remote',
				forceSelection: true, 
				displayField : 'batch_instance_name',
				valueField : 'batch_instance_id',
				pageSize : 5,
				minChars : 1, 
				allowBlank : false, 
				triggerAction: 'all',
				store : remoteJsonStoreBatchInstance, 
				listConfig : {
					getInnerTpl: function(){
						return  	'<div data-qtip="{batch_instance_name}">' +  
												'<div class="combo-name">'  + 
															" ({batch_instance_name}) <br />" 	 		+  
															" Jumlah: ({batch_instance_amount}) <br />" 	 		+ 
												 "</div>" +  
						 					'</div>';
					}
				},
				name : 'batch_instance_id' 
			},
				
			{
    	        xtype: 'textfield',
    	        name : 'finish_amount',
    	        fieldLabel: 'Jumlah Finish (m)'
    	     },
    	     {
    	        xtype: 'textfield',
    	        name : 'reject_amount',
    	        fieldLabel: 'Jumlah Reject (m)'
    	     },
    	     {
    	        xtype: 'textfield',
    	        name : 'defect_amount',
    	        fieldLabel: 'Jumlah Defect (m)'
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

	setExtraParamInBatchInstanceComboBox: function( recovery_order_detail_id ){
		var comboBox = this.down('form').getForm().findField('batch_instance_id'); 
		var store = comboBox.store;
		
		store.getProxy().extraParams.recovery_order_detail_id =  recovery_order_detail_id;
	},
	
	
	setComboBoxExtraParams: function( record ) { 
		
		console.log( record ) ;
		var me =this;
		me.setExtraParamInBatchInstanceComboBox( record.get("id") ); 
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
	 
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		
		me.setSelectedBatchInstance( record.get("batch_instance_id")  ) ;  
	},
	
	
	
	setParentData: function( record) {
		// this.down('form').getForm().findField('template_code').setValue(record.get('code')); 
		this.down('form').getForm().findField('recovery_order_detail_id').setValue(record.get('id'));
	}
 
});




