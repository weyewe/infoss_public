Ext.define('AM.view.master.rollerbuilder.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.rollerbuilderform',

  title : 'Add / Edit RollerBuilder',
  layout: 'fit',
  width	: 960, 
  height : 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
	companyInfo : function(){
		var remoteJsonStoreMachine = Ext.create(Ext.data.JsonStore, {
			storeId : 'machine_search',
			fields	: [
	 				{
						name : 'machine_name',
						mapping : "name"
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
		
		var remoteJsonStoreRollerType = Ext.create(Ext.data.JsonStore, {
			storeId : 'roller_type_search',
			fields	: [
	 				{
						name : 'roller_type_name',
						mapping : "name"
					},
					{
						name : 'roller_type_id',
						mapping : 'id'
					}
			],
			proxy  	: {
				type : 'ajax',
				url : 'api/search_roller_types',
				reader : {
					type : 'json',
					root : 'records', 
					totalProperty  : 'total'
				}
			},
			autoLoad : false 
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
		
		var remoteJsonStoreItemAdhesive = Ext.create(Ext.data.JsonStore, {
			storeId : 'item_adhesive_search',
			fields	: [
	 				{
						name : 'item_adhesive_name',
						mapping : "name"
					},
					{
						name : 'item_adhesive_sku',
						mapping : "sku"
					},
					{
						name : 'item_adhesive_amount',
						mapping : "amount"
					},
					{
						name : 'item_adhesive_uom',
						mapping : "uom_name"
					},
					{
						name : 'item_adhesive_id',
						mapping : 'id'
					}
			],
			proxy  	: {
				type : 'ajax',
				url : 'api/search_item_adhesive_rollers',
				reader : {
					type : 'json',
					root : 'records', 
					totalProperty  : 'total'
				}
			},
			autoLoad : false 
		});
		
		
		var remoteJsonStoreCoreBuilder = Ext.create(Ext.data.JsonStore, {
			storeId : 'core_builder_search',
			fields	: [
	 				{
						name : 'core_builder_name',
						mapping : "name"
					},
					{
						name : 'core_builder_base_sku',
						mapping : "base_sku"
					},
					{
						name : 'core_builder_description',
						mapping : "description"
					},
					{
						name : 'core_builder_machine_name',
						mapping : "machine_name"
					},
					{
						name : 'core_builder_core_builder_type_case',
						mapping : "core_builder_type_case"
					},
					{
						name : 'core_builder_sku_used_core',
						mapping : "sku_used_core"
					},
					{
						name : 'core_builder_sku_new_core',
						mapping : "sku_new_core"
					},
					{
						name : 'core_builder_used_core_item_amount',
						mapping : "used_core_item_amount"
					},
					{
						name : 'core_builder_uom_name',
						mapping : "uom_name"
					},
					{
						name : 'core_builder_new_core_item_amount',
						mapping : "new_core_item_amount"
					},
					{
						name : 'core_builder_cd',
						mapping : "cd"
					},
					{
						name : 'core_builder_tl',
						mapping : "tl"
					},
					{
						name : 'core_builder_id',
						mapping : 'id'
					}
			],
			proxy  	: {
				type : 'ajax',
				url : 'api/search_core_builders',
				reader : {
					type : 'json',
					root : 'records', 
					totalProperty  : 'total'
				}
			},
			autoLoad : false 
		});
		
		
		var entityInfo = {
			xtype : 'fieldset',
			title : "",
			flex : 1 , 
			border : true, 
			labelWidth: 60,
			defaultType : 'field',
			width : '90%',
			defaults : {
				anchor : '-10'
			},
			items : [
				{
	        xtype: 'hidden',
	        name : 'id',
	        fieldLabel: 'id'
	      },{
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
													'<div class="combo-name">{machine_name}</div>' +
							 					'</div>';
						}
					},
					name : 'machine_id' 
				},{
					fieldLabel: 'RollerType',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'roller_type_name',
					valueField : 'roller_type_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStoreRollerType , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{roller_type_name}">' + 
													'<div class="combo-name">{roller_type_name}</div>' +
							 					'</div>';
						}
					},
					name : 'roller_type_id' 
				},
				{
					fieldLabel: 'Compound',
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
					name : 'compound_id' 
				},
				{
					fieldLabel: 'Adhesive',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'item_adhesive_name',
					valueField : 'item_adhesive_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStoreItemAdhesive , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{item_adhesive_name}">' + 
													'<div class="combo-name">{item_adhesive_sku}</div>' +
													'<div class="combo-name">{item_adhesive_name}</div>' +
													'<div class="combo-name">{item_adhesive_amount}</div>' +
													'<div class="combo-name">{item_adhesive_uom}</div>' +
							 					'</div>';
						}
					},
					name : 'adhesive_id' 
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
					fieldLabel: 'Core Builder',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'core_builder_name',
					valueField : 'core_builder_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStoreCoreBuilder , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{core_builder_name}">' + 
													'<div class="combo-name">{core_builder_base_sku}</div>' +
													'<div class="combo-name">{core_builder_name}</div>' +
													'<div class="combo-name">{core_builder_description}</div>' +
													'<div class="combo-name">{core_builder_machine_name}</div>' +
													'<div class="combo-name">{core_builder_type_case}</div>' +
													
							 					'</div>';
						}
					},
					name : 'core_builder_id' 
				},
				{
					xtype: 'textfield',
					name : 'base_sku',
					fieldLabel: 'BaseSku'
				},
				{
					xtype: 'displayfield',
					name : 'sku_roller_used_core',
					fieldLabel: 'Sku Used'
				},
				{
					xtype: 'displayfield',
					name : 'sku_roller_new_core',
					fieldLabel: 'Sku New'
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
			]
		};
		
			var container = {
					xtype : 'container',
					layoutConfig: {
						align :'stretch'
					},
					flex: 1, 
					width : 500,
					layout : 'vbox',
					items : [
						entityInfo
					]
				};
				
				return container; 
				
	},
	
	picInfo: function(){
		
		var me = this; 
		
		var salesInfo = {
					xtype : 'fieldset',
					title : "",
					flex : 1 , 
					border : true,
					width : '90%', 
					labelWidth: 60,
					defaultType : 'field',
					defaults : {
						anchor : '-10'
					},
					items : [ 
						{
							xtype: 'numberfield',
							fieldLabel : 'RD',
							name : 'rd' 
						}, 
						{
							xtype: 'numberfield',
							fieldLabel : 'CD',
							name : 'cd' 
						}, 
						{
							xtype: 'numberfield',
							fieldLabel : 'RL',
							name : 'rl' 
						},
						{
							xtype: 'numberfield',
							fieldLabel : 'WL',
							name : 'wl' 
						},
						{
							xtype: 'numberfield',
							fieldLabel : 'TL',
							name : 'tl' 
						}, 
						{
							xtype: 'displayfield',
							fieldLabel : 'QTY Used',
							name : 'roller_used_core_item_amount' 
						},
						{
							xtype: 'displayfield',
							fieldLabel : 'QTY New',
							name : 'roller_new_core_item_amount' 
						},
						{
							xtype: 'checkboxfield',
							fieldLabel : 'Crowning?',
							name : 'is_crowning' 
						}, 
						{
							xtype: 'numberfield',
							fieldLabel : 'Crowning Size',
							name : 'crowning_size' 
						}, 
						{
							xtype: 'checkboxfield',
							fieldLabel : 'Grooving?',
							name : 'is_grooving' 
						},
						{
							xtype: 'numberfield',
							fieldLabel : 'Grooving Width',
							name : 'grooving_width' 
						}, 
						{
							xtype: 'numberfield',
							fieldLabel : 'Grooving Depth',
							name : 'grooving_depth' 
						}, 
						{
							xtype: 'numberfield',
							fieldLabel : 'Grooving Position',
							name : 'grooving_position' 
						}, 
						{
							xtype: 'checkboxfield',
							fieldLabel : 'Chamfer?',
							name : 'is_chamfer' 
						},
					]
				};
				
				
				var container = {
					xtype : 'container',
					layoutConfig: {
						align :'stretch'
					},
					flex: 1, 
					width : 500,
					layout : 'vbox',
					items : [
						salesInfo
					]
				};
				
				return container; 
	},
	
	
  initComponent: function() {
  	var me = this; 
    this.items = [{
	      xtype: 'form',
				msgTarget	: 'side',
				border: false,
	      bodyPadding: 10,
				fieldDefaults: {
	          labelWidth: 100,
						anchor: '100%'
	      },
				height : 350,
				overflowY : 'auto', 
				layout : 'hbox', 
				// height : 400,
				items : [
					me.companyInfo(), 
					me.picInfo()
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

	setSelectedCoreBuilder: function( core_builder_id ){ 
		var comboBox = this.down('form').getForm().findField('core_builder_id'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : core_builder_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( core_builder_id );
			}
		});
	},
	
	setSelectedAdhesive: function( adhesive_id ){ 
		var comboBox = this.down('form').getForm().findField('adhesive_id'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : adhesive_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( adhesive_id );
			}
		});
	},

	setSelectedCompound: function( compound_id ){ 
		var comboBox = this.down('form').getForm().findField('compound_id'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : compound_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( compound_id );
			}
		});
	},
	
	setSelectedRollerType: function( roller_type_id ){ 
		var comboBox = this.down('form').getForm().findField('roller_type_id'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : roller_type_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( roller_type_id );
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
	


	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		me.setSelectedMachine( record.get("machine_id")  ) ;
		me.setSelectedRollerType( record.get("roller_type_id")  ) ;
		me.setSelectedCompound( record.get("compound_id")  ) ;
		me.setSelectedAdhesive( record.get("adhesive_id")  ) ;
		me.setSelectedUom( record.get("uom_id")  ) ;
		me.setSelectedCoreBuilder( record.get("core_builder_id")  ) ;
	}
});

