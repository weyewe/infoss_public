Ext.define('AM.view.operation.rolleridentificationformdetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.rolleridentificationformdetailform',

  title : 'Add / Edit RollerIdentificationForm Detail',
  layout: 'fit',
	width	: 960, 
  height : 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
	
	
 companyInfo : function(){
 	
 		var localJsonStoreMaterialCase = Ext.create(Ext.data.Store, {
			type : 'array',
			storeId : 'rif_material_case',
			fields	: [ 
				{ name : "rif_material_case"}, 
				{ name : "rif_material_case_text"}  
			], 
			data : [
				{ rif_material_case : 1, rif_material_case_text : "New"},
				{ rif_material_case : 2, rif_material_case_text : "Used"},
			] 
		});
		
		var localJsonStoreRepairRequestCase = Ext.create(Ext.data.Store, {
			type : 'array',
			storeId : 'rif_repair_request_case',
			fields	: [ 
				{ name : "rif_repair_request_case"}, 
				{ name : "rif_repair_request_case_text"}  
			], 
			data : [
				{ rif_repair_request_case : 1, rif_repair_request_case_text : "Bearing Set"},
				{ rif_repair_request_case : 2, rif_repair_request_case_text : "Centre Drill"},
				{ rif_repair_request_case : 3, rif_repair_request_case_text : "None"},
				{ rif_repair_request_case : 4, rif_repair_request_case_text : "Bearing Set and Centre Drill"},
				{ rif_repair_request_case : 5, rif_repair_request_case_text : "Repair Corosive"},
				{ rif_repair_request_case : 6, rif_repair_request_case_text : "Bearing Set and Repair Corosive"},
				{ rif_repair_request_case : 7, rif_repair_request_case_text : "Centre Drill and Repair Corosive"},
				{ rif_repair_request_case : 8, rif_repair_request_case_text : "All"},
			] 
		});
		
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
	      },
	      {
	        xtype: 'hidden',
	        name : 'roller_identification_form_id',
	        fieldLabel: 'roller_identification_form_id'
	      },
	      {
						xtype: 'textfield',
						name : 'detail_id',
						fieldLabel: 'RIF id'
					},
	     	{
	        xtype: 'textfield',
	        name : 'roller_no',
	        fieldLabel: 'Roller No.'
	      }
	      ,{
					fieldLabel: 'Material Case',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'rif_material_case_text',
					valueField : 'rif_material_case',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : localJsonStoreMaterialCase , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{rif_material_case_text}">' + 
													'<div class="combo-name">{rif_material_case_text}</div>' +
							 					'</div>';
						}
					},
					name : 'material_case' 
				}
				,{
					fieldLabel: 'Repair Request Case',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'rif_repair_request_case_text',
					valueField : 'rif_repair_request_case',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : localJsonStoreRepairRequestCase , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{rif_repair_request_case_text}">' + 
													'<div class="combo-name">{rif_repair_request_case_text}</div>' +
							 					'</div>';
						}
					},
					name : 'repair_request_case' 
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

	      ,{
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
					name : 'rd',
					fieldLabel: 'RD'
					},
					{
						xtype: 'numberfield',
						name : 'cd',
						fieldLabel: 'CD'
					},
					{
						xtype: 'numberfield',
						name : 'rl',
						fieldLabel: 'RL'
					},
					{
						xtype: 'numberfield',
						name : 'wl',
						fieldLabel: 'WL'
					},
					{
						xtype: 'numberfield',
						name : 'gl',
						fieldLabel: 'GL'
					},
						{
						xtype: 'numberfield',
						name : 'groove_length',
						fieldLabel: 'Groove Length'
					},
					{
						xtype: 'numberfield',
						name : 'groove_amount',
						fieldLabel: 'QTY of Grooves'
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
	
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		me.setSelectedMachine( record.get("machine_id")  ) ;
		me.setSelectedRollerType( record.get("roller_type_id")  ) ;
		me.setSelectedCoreBuilder( record.get("core_builder_id")  ) ;
	},
	
	
	setParentData: function( record) {
		// this.down('form').getForm().findField('roller_identification_form_code').setValue(record.get('code')); 
		this.down('form').getForm().findField('roller_identification_form_id').setValue(record.get('id'));
	}
 
});




