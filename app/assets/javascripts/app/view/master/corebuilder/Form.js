Ext.define('AM.view.master.corebuilder.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.corebuilderform',

  title : 'Add / Edit CoreBuilder',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	
		var localJsonStoreTypeCase = Ext.create(Ext.data.Store, {
			type : 'array',
			storeId : 'core_builder_type_case',
			fields	: [ 
				{ name : "core_builder_type_case"}, 
				{ name : "core_builder_type_case_text"}  
			], 
			data : [
				{ core_builder_type_case : "Hollow", core_builder_type_case_text : "Hollow"},
				{ core_builder_type_case : "Shaft", core_builder_type_case_text : "Shaft"},
				{ core_builder_type_case : "None", core_builder_type_case_text : "None"}
			] 
		});
		
		var remoteJsonStoreUom = Ext.create(Ext.data.JsonStore, {
			storeId : 'uom_search',
			fields	: [
	 				{
						name : 'uom_name',
						mapping : "name"
					},
					{
						name : 'uom_id',
						mapping : 'id'
					}
			],
			proxy  	: {
				type : 'ajax',
				url : 'api/search_uoms',
				reader : {
					type : 'json',
					root : 'records', 
					totalProperty  : 'total'
				}
			},
			autoLoad : false 
		});
		
		var remoteJsonStoreMachine = Ext.create(Ext.data.JsonStore, {
			storeId : 'machine_search',
			fields	: [
	 				{
						name : 'machine_name',
						mapping : "name"
					},
					{
						name : 'machine_code',
						mapping : "code"
					},
					{
						name : 'machine_id',
						mapping : 'id'
					}
			],
			proxy  	: {
				type : 'ajax',
				url : 'api/search_machines',
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
	        xtype: 'textfield',
	        name : 'base_sku',
	        fieldLabel: 'Base Sku'
	      },
	      {
					xtype: 'displayfield',
					name : 'sku_used_core',
					fieldLabel: 'Used Sku'
				},
				{
					xtype: 'displayfield',
					name : 'sku_new_core',
					fieldLabel: 'New Sku'
				},
				{
	        xtype: 'textfield',
	        name : 'name',
	        fieldLabel: 'Name'
	      },
	      {
					xtype: 'textarea',
					name : 'description',
					fieldLabel: 'Description'
				},
				{
					xtype: 'displayfield',
					name : 'used_core_item_amount',
					fieldLabel: 'Used Quantity'
				},
				{
					xtype: 'displayfield',
					name : 'new_core_item_amount',
					fieldLabel: 'New Quantity'
				},
				{
					fieldLabel: 'UoM',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'uom_name',
					valueField : 'uom_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStoreUom , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{uom_name}">' + 
													'<div class="combo-name">{uom_name}</div>' +
							 					'</div>';
						}
					},
					name : 'uom_id' 
				},
				{
					fieldLabel: 'Machine',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'machine_name',
					valueField : 'machine_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStoreMachine , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{machine_name}">' + 
													'<div class="combo-name">{machine_code}</div>' +
													'<div class="combo-name">{machine_name}</div>' +
							 					'</div>';
						}
					},
					name : 'machine_id' 
				},
						{
							fieldLabel: 'Type',
							xtype: 'combo',
							queryMode: 'remote',
							forceSelection: true, 
							displayField : 'core_builder_type_case_text',
							valueField : 'core_builder_type_case',
							pageSize : 5,
							minChars : 1, 
							allowBlank : false, 
							triggerAction: 'all',
							store : localJsonStoreTypeCase , 
							listConfig : {
								getInnerTpl: function(){
									return  	'<div data-qtip="{core_builder_type_case_text}">' +  
															'<div class="combo-name">{core_builder_type_case_text}</div>' +  
									 					'</div>';
								}
							},
							name : 'core_builder_type_case' 
				},
				{
					xtype: 'numberfield',
					name : 'cd',
					fieldLabel: 'CD'
				},
				{
					xtype: 'numberfield',
					name : 'tl',
					fieldLabel: 'TL'
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
	
	setSelectedUom: function( uom_id ){ 
		var comboBox = this.down('form').getForm().findField('uom_id'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : uom_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( uom_id );
			}
		});
	},
	
	setSelectedMachine: function( machine_id ){ 
		var comboBox = this.down('form').getForm().findField('machine_id'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : machine_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( machine_id );
			}
		});
	},
	
	setSelectedCoreType: function( core_builder_type_case ){ 
		var comboBox = this.down('form').getForm().findField('core_builder_type_case'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : core_builder_type_case 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( core_builder_type_case );
			}
		});
	},
	
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		me.setSelectedMachine( record.get("machine_id")  ) ;
		me.setSelectedUom( record.get("uom_id")  ) ;
		me.setSelectedCoreType( record.get("core_builder_type_case")  ) ;
		
	}
})