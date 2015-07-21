
Ext.define('AM.view.operation.blanketresultdetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.blanketresultdetailform',

  title : 'Add / Edit Blanket Batch Allocation',
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
			url : 'api/records',
			reader : {
				type : 'json',
				root : 'batch_instances', 
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
				name : 'blanket_order_detail_id',
				fieldLabel: 'blanket_order_detail_id'
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
  
	setExtraParamInBatchInstanceComboBox: function( blanket_order_detail_id ){
		var comboBox = this.down('form').getForm().findField('batch_instance_id'); 
		var store = comboBox.store;
		
		store.getProxy().extraParams.blanket_order_detail_id =  blanket_order_detail_id;
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
		this.down('form').getForm().findField('blanket_order_detail_id').setValue(record.get('id')); 
		// this.down('form').getForm().findField('template_id').setValue(record.get('id'));
	}
 
});




