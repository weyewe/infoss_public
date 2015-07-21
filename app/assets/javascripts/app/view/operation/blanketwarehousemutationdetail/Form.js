
Ext.define('AM.view.operation.blanketwarehousemutationdetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.blanketwarehousemutationdetailform',

  title : 'Add / Edit Warehouse Mutation Detail',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	
	
    var remoteJsonStoreBlanketOrderDetail = Ext.create(Ext.data.JsonStore, {
		storeId : 'blanket_order_details_search',
		fields	: [
		 		{
					name : 'blanket_order_detail_blanket_sku',
					mapping : "blanket_id"
				}, 
				{
					name : 'blanket_order_detail_blanket_name',
					mapping : 'blanket_name'
				},
				{
					name : 'blanket_order_detail_id',
					mapping : "id"
				}, 
	 
		],
		proxy  	: {
			type : 'ajax',
			url : 'api/search_blanket_order_details',
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
	        name : 'blanket_warehouse_mutation_id',
	        fieldLabel: 'blanket_warehouse_mutation_id'
	      },
	      {
            xtype: 'displayfield',
            name : 'blanket_warehouse_mutation_code',
            fieldLabel: 'Kode BlanketWarehouseMutation'
        },
				{
	    				fieldLabel: 'Blanket Order Detail',
	    				xtype: 'combo',
	    				queryMode: 'remote',
	    				forceSelection: true, 
	    				displayField : 'blanket_order_detail_blanket_name',
	    				valueField : 'blanket_order_detail_id',
	    				pageSize : 5,
	    				minChars : 1, 
	    				allowBlank : false, 
	    				triggerAction: 'all',
	    				store : remoteJsonStoreBlanketOrderDetail , 
	    				listConfig : {
	    					getInnerTpl: function(){
	    						return  	'<div data-qtip="{blanket_order_detail_blanket_name}">' + 
	    												'<div class="combo-name">{blanket_order_detail_blanket_sku}</div>' + 
	    												'<div class="combo-name">Name: {blanket_order_detail_blanket_name}</div>' + 
	    						 					'</div>';
	    					}
	    				},
	    				name : 'blanket_order_detail_id' 
    				},
			{
    	        xtype: 'numberfield',
    	        name : 'quantity',
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

	setSelectedBlanketOrderDetail: function( blanket_order_detail_id ){
		// console.log("inside set selected original account id ");
		var comboBox = this.down('form').getForm().findField('blanket_order_detail_id'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : blanket_order_detail_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( blanket_order_detail_id );
			}
		});
	},
	
	
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		
		me.setSelectedBlanketOrderDetail( record.get("blanket_order_detail_id")  ) ; 
	},
	
	
	setParentData: function( record) {
		this.down('form').getForm().findField('blanket_warehouse_mutation_code').setValue(record.get('code')); 
		this.down('form').getForm().findField('blanket_warehouse_mutation_id').setValue(record.get('id'));
	}
 
});




