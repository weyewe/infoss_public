
Ext.define('AM.view.operation.blanketorderdetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.blanketorderdetailform',

  title : 'Add / Edit BlanketOrderDetail',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	
	var remoteJsonStoreBlanket = Ext.create(Ext.data.JsonStore, {
		storeId : 'blanket_search',
		fields	: [
		 		{
					name : 'blanket_sku',
					mapping : "sku"
				}, 
				{
					name : 'blanket_name',
					mapping : 'name'
				},
				{
					name : 'blanket_roll_blanket_name',
					mapping : 'roll_blanket_item_name'
				},
				{
					name : 'blanket_left_bar_item_name',
					mapping : 'left_bar_item_name'
				},
				{
					name : 'blanket_right_bar_item_name',
					mapping : 'right_bar_item_name'
				},
				{
					name : 'blanket_id',
					mapping : "id"
				}, 
	 
		],
		proxy  	: {
			type : 'ajax',
			url : 'api/search_blankets',
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
	        name : 'blanket_order_id',
	        fieldLabel: 'blanket_order_id'
	      },
		   {
				fieldLabel: 'Blanket',
				xtype: 'combo',
				queryMode: 'remote',
				forceSelection: true, 
				displayField : 'blanket_name',
				valueField : 'blanket_id',
				pageSize : 5,
				minChars : 1, 
				allowBlank : false, 
				triggerAction: 'all',
				store : remoteJsonStoreBlanket , 
				listConfig : {
					getInnerTpl: function(){
						return  	'<div data-qtip="{blanket_name}">' +  
												'<div class="combo-name">Sku : {blanket_sku}</div>' +  
												'<div class="combo-name">Name : {blanket_name}</div>' +  
												'<div class="combo-name">Roll Blanket :{blanket_roll_blanket_name}</div>' +  
												'<div class="combo-name">Bar 1 : {blanket_left_bar_item_name}</div>' +  
												'<div class="combo-name">Bar 2 : {blanket_right_bar_item_name}</div>' +  
						 					'</div>';
					}
				},
				name : 'blanket_id' 
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

	setSelectedBlanket: function( blanket_id ){
		// console.log("inside set selected original account id ");
		var comboBox = this.down('form').getForm().findField('blanket_id'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : blanket_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( blanket_id );
			}
		});
	},
	
	setSelectedStatus: function( is_service ){
		// console.log("inside set selected original account id ");
		var comboBox = this.down('form').getForm().findField('is_service'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : is_service 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( is_service );
			}
		});
	},
	
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		
		me.setSelectedBlanket( record.get("blanket_id")  ) ; 
		// me.setSelectedStatus( record.get("is_service")  ) ; 
	},
	
	
	setParentData: function( record) {
		this.down('form').getForm().findField('blanket_order_id').setValue(record.get('id'));
	}
 
});




