Ext.define('AM.view.operation.blendingworkorder.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.blendingworkorderform',

  title : 'Add / Edit BlendingWorkOrder',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
		var remoteJsonStoreWarehouse = Ext.create(Ext.data.JsonStore, {
			storeId : 'warehouse_search',
			fields	: [
			 		{
						name : 'warehouse_name',
						mapping : "name"
					} ,
					{
						name : 'warehouse_description',
						mapping : "description"
					} ,
			 
					{
						name : 'warehouse_id',
						mapping : 'id'
					}  
			],
			
		 
			proxy  	: {
				type : 'ajax',
				url : 'api/search_warehouses',
				reader : {
					type : 'json',
					root : 'records', 
					totalProperty  : 'total'
				}
			},
			autoLoad : false 
		});
	
		var remoteJsonBlendingRecipe = Ext.create(Ext.data.JsonStore, {
			storeId : 'blending_recipe_search',
			fields	: [
	 				{
						name : 'blending_recipe_name',
						mapping : "name"
					},
					{
						name : 'blending_recipe_description',
						mapping : "description"
					},
					{
						name : 'blending_recipe_target_item_sku',
						mapping : "target_item_sku"
					},
					{
						name : 'blending_recipe_target_item_name',
						mapping : "target_item_name"
					},
					{
						name : 'blending_recipe_target_item_uom_name',
						mapping : "target_item_uom_name"
					},
					{
						name : 'blending_recipe_id',
						mapping : 'id'
					}
			],
			proxy  	: {
				type : 'ajax',
				url : 'api/search_blending_recipes',
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
	      },{
	        xtype: 'textfield',
	        name : 'code',
	        fieldLabel: ' Code'
	      },
				{
					xtype: 'textarea',
					name : 'description',
					fieldLabel: 'Deskiprsi'
				},
				{
  				fieldLabel: 'Blending Recipe',
  				xtype: 'combo',
  				queryMode: 'remote',
  				forceSelection: true, 
  				displayField : 'blending_recipe_name',
  				valueField : 'blending_recipe_id',
  				pageSize : 5,
  				minChars : 1, 
  				allowBlank : false, 
  				triggerAction: 'all',
  				store : remoteJsonBlendingRecipe , 
  				listConfig : {
  					getInnerTpl: function(){
  						return  	'<div data-qtip="{blending_recipe_name}">' + 
  												'<div class="combo-name">{blending_recipe_name}</div>' + 
  												'<div class="combo-name">Deskripsi: {blending_recipe_description}</div>' + 
  												'<div class="combo-name">Target Sku: {blending_recipe_target_item_sku}</div>' + 
  												'<div class="combo-name">Target Name: {blending_recipe_target_item_sku}</div>' + 
  												'<div class="combo-name">UoM: {blending_recipe_target_item_uom_name}</div>' + 
  						 					'</div>';
  					}
  				},
  				name : 'blending_recipe_id' 
    		},
				{
  				fieldLabel: 'Warehouse',
  				xtype: 'combo',
  				queryMode: 'remote',
  				forceSelection: true, 
  				displayField : 'warehouse_name',
  				valueField : 'warehouse_id',
  				pageSize : 5,
  				minChars : 1, 
  				allowBlank : false, 
  				triggerAction: 'all',
  				store : remoteJsonStoreWarehouse , 
  				listConfig : {
  					getInnerTpl: function(){
  						return  	'<div data-qtip="{warehouse_name}">' + 
  												'<div class="combo-name">{warehouse_name}</div>' + 
  												'<div class="combo-name">Deskripsi: {warehouse_description}</div>' + 
  						 					'</div>';
  					}
  				},
  				name : 'warehouse_id' 
    		},
				{
  					xtype: 'datefield',
  					name : 'blending_date',
  					fieldLabel: 'Tanggal Blending',
  					format: 'Y-m-d',
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


	
	setSelectedBlendingRecipe: function( blending_recipe_id ){
		var comboBox = this.down('form').getForm().findField('blending_recipe_id'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : blending_recipe_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( blending_recipe_id );
			}
		});
	},
	
  setSelectedWarehouse: function( warehouse_id ){
		var comboBox = this.down('form').getForm().findField('warehouse_id'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : warehouse_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( warehouse_id );
			}
		});
	},
	
	setComboBoxData : function( record){ 

		var me = this; 
		me.setLoading(true);
		
		me.setSelectedWarehouse( record.get("warehouse_id")  ) ;
		me.setSelectedBlendingRecipe( record.get("blending_recipe_id")  ) ;
 
	}
	
});

