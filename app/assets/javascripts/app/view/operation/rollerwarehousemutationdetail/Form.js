
Ext.define('AM.view.operation.rollerwarehousemutationdetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.rollerwarehousemutationdetailform',

  title : 'Add / Edit Roller Warehouse Mutation Detail',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	
	
   var remoteJsonStoreRecoveryOrderDetail = Ext.create(Ext.data.JsonStore, {
		storeId : 'recovery_order_details_search',
		fields	: [
		 		{
					name : 'recovery_order_detail_recovery_sku',
					mapping : "roller_builder_sku"
				}, 
				{
					name : 'recovery_order_detail_recovery_name',
					mapping : 'roller_builder_name'
				},
				{
					name : 'recovery_order_detail_id',
					mapping : "id"
				}, 
	 
		],
		proxy  	: {
			type : 'ajax',
			url : 'api/search_recovery_order_details',
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
	        name : 'roller_warehouse_mutation_id',
	        fieldLabel: 'roller_warehouse_mutation_id'
	      },
	      {
            xtype: 'displayfield',
            name : 'roller_warehouse_mutation_code',
            fieldLabel: 'Kode RollerWarehouseMutation'
        },
				{
	    				fieldLabel: 'Recovery Order Detail',
	    				xtype: 'combo',
	    				queryMode: 'remote',
	    				forceSelection: true, 
	    				displayField : 'recovery_order_detail_recovery_name',
	    				valueField : 'recovery_order_detail_id',
	    				pageSize : 5,
	    				minChars : 1, 
	    				allowBlank : false, 
	    				triggerAction: 'all',
	    				store : remoteJsonStoreRecoveryOrderDetail , 
	    				listConfig : {
	    					getInnerTpl: function(){
	    						return  	'<div data-qtip="{recovery_order_detail_recovery_name}">' + 
	    												'<div class="combo-name">{recovery_order_detail_recovery_sku}</div>' + 
	    												'<div class="combo-name">Name: {recovery_order_detail_recovery_name}</div>' + 
	    						 					'</div>';
	    					}
	    				},
	    				name : 'recovery_order_detail_id' 
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

	setSelectedRecoveryOrderDetail: function( recovery_order_detail_id ){
		// console.log("inside set selected original account id ");
		var comboBox = this.down('form').getForm().findField('recovery_order_detail_id'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : recovery_order_detail_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( recovery_order_detail_id );
			}
		});
	},
	
	
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		
		me.setSelectedRecoveryOrderDetail( record.get("recovery_order_detail_id")  ) ; 
	},
	
	
	setParentData: function( record) {
		this.down('form').getForm().findField('roller_warehouse_mutation_code').setValue(record.get('code')); 
		this.down('form').getForm().findField('roller_warehouse_mutation_id').setValue(record.get('id'));
	}
 
});




