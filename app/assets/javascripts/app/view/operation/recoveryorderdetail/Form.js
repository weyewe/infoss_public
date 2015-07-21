
Ext.define('AM.view.operation.recoveryorderdetail.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.recoveryorderdetailform',

  title : 'Add / Edit Recovey Order Detail',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	
	
    var localJsonStoreCoreTypeCase = Ext.create(Ext.data.Store, {
		type : 'array',
		storeId : 'core_type_case',
		fields	: [ 
			{ name : "core_type_case"}, 
			{ name : "core_type_case_text"}  
		], 
		data : [
			{ core_type_case : "R", core_type_case_text : "R"},
			{ core_type_case : "Z", core_type_case_text : "Z"}
		] 
	});
	
	
	var remoteJsonStoreRIFdetail= Ext.create(Ext.data.JsonStore, {
		storeId : 'rif_detail_search',
		fields	: [
		 		{
					name : 'rifd_roller_no',
					mapping : "roller_no"
				}, 
				{
					name : 'rifd_material_case',
					mapping : 'material_case_text'
				},
				{
					name : 'rifd_core_builder_sku',
					mapping : 'core_builder_sku'
				},
				{
					name : 'rifd_core_builder_name',
					mapping : 'core_builder_name'
				},
				{
					name : 'rifd_roller_type_name',
					mapping : 'roller_type_name'
				},
				{
					name : 'rifd_machine_name',
					mapping : 'machine_name'
				},
				{
					name : 'rifd_repair_request_case',
					mapping : 'repair_request_case_text'
				},
				{
					name : 'rifd_rd',
					mapping : 'rd'
				},
				{
					name : 'rifd_cd',
					mapping : 'cd'
				},
				{
					name : 'rifd_rl',
					mapping : 'rl'
				},
				{
					name : 'rifd_wl',
					mapping : 'wl'
				},
				{
					name : 'rifd_tl',
					mapping : 'tl'
				},
				{
					name : 'roller_identification_form_detail_id',
					mapping : "id"
				}, 
	 
		],
		proxy  	: {
			type : 'ajax',
			url : 'api/search_roller_identification_form_details',
			reader : {
				type : 'json',
				root : 'records', 
				totalProperty  : 'total'
			}
		},
		autoLoad : false 
	});
		
	var remoteJsonStoreRollerBuilder= Ext.create(Ext.data.JsonStore, {
		storeId : 'roller_builder_search',
		fields	: [
		 		{
					name : 'roller_builder_sku',
					mapping : "base_sku"
				}, 
				{
					name : 'roller_builder_name',
					mapping : 'name'
				},
				{
					name : 'roller_builder_roller_type_name',
					mapping : 'roller_type_name'
				},
				{
					name : 'roller_builder_rd',
					mapping : 'rd'
				},
				{
					name : 'roller_builder_cd',
					mapping : 'cd'
				},
				{
					name : 'roller_builder_rl',
					mapping : 'rl'
				},
				{
					name : 'roller_builder_wl',
					mapping : 'wl'
				},
				{
					name : 'roller_builder_tl',
					mapping : 'tl'
				},
				{
					name : 'roller_builder_used_sku',
					mapping : 'sku_roller_used_core'
				},
				{
					name : 'roller_builder_new_sku',
					mapping : 'sku_roller_new_core'
				},
				{
					name : 'roller_builder_machine_name',
					mapping : 'machine_name'
				},
				{
					name : 'roller_builder_compound_name',
					mapping : 'compound_name'
				},
				{
					name : 'roller_builder_adhesived_name',
					mapping : 'adhesive_name'
				},
				{
					name : 'roller_builder_core_builder_sku',
					mapping : 'core_builder_sku'
				},
				{
					name : 'roller_builder_core_builder_name',
					mapping : 'core_builder_name'
				},
				{
					name : 'roller_builder_id',
					mapping : "id"
				}, 
	 
		],
		proxy  	: {
			type : 'ajax',
			url : 'api/search_roller_builders',
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
	        name : 'recovery_order_id',
	        fieldLabel: 'recovery_order_id'
	      },
				{
					fieldLabel: 'RIF detail',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'rifd_core_builder_name',
					valueField : 'roller_identification_form_detail_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStoreRIFdetail , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{rifd_core_builder_name}">' +  
													'<div class="combo-name">Roller No : {rifd_roller_no}</div>' +  
													'<div class="combo-name">Material : {rifd_material_case}</div>' +  
													'<div class="combo-name">Core Sku : {rifd_core_builder_sku}</div>' +  
													'<div class="combo-name">Core Name : {rifd_core_builder_name}</div>' +  
													'<div class="combo-name">Roller Type : {rifd_roller_type_name}</div>' +  
							 					'</div>';
						}
					},
					name : 'roller_identification_form_detail_id' 
				},
				{
					fieldLabel: 'Roller Builder',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'roller_builder_name',
					valueField : 'roller_builder_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStoreRollerBuilder , 
					listConfig : {
						getInnerTpl: function(){
								return  	'<div data-qtip="{roller_builder_name}">' +  
													'<div class="combo-name">Base Sku : {roller_builder_sku}</div>' +  
													'<div class="combo-name">Name : {roller_builder_name}</div>' +  
													'<div class="combo-name">Roller Type : {roller_builder_roller_type_name}</div>' +  
													'<div class="combo-name">Machine : {roller_builder_machine_name}</div>' +  
													'<div class="combo-name">Compound : {roller_builder_compound_name}</div>' +  
													'<div class="combo-name">Adhesive : {roller_builder_adhesived_name}</div>' +  
													'<div class="combo-name">Core : {roller_builder_core_builder_name}</div>' +  
							 					'</div>';
						}
					},
					name : 'roller_builder_id' 
				},
				{
					fieldLabel: 'CoreTypeCase',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'core_type_case_text',
					valueField : 'core_type_case',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : localJsonStoreCoreTypeCase , 
					listConfig : {
						getInnerTpl: function(){
								return  	'<div data-qtip="{core_type_case_text}">' +  
													'<div class="combo-name">{core_type_case_text}</div>' +  
							 					'</div>';
						}
					},
					name : 'core_type_case' 
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

	setSelectedRollerBuilder: function( roller_builder_id ){
		// console.log("inside set selected original account id ");
		var comboBox = this.down('form').getForm().findField('roller_builder_id'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : roller_builder_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( roller_builder_id );
			}
		});
	},
	
	setSelectedRIFDetail: function( roller_identification_form_detail_id ){
		// console.log("inside set selected original account id ");
		var comboBox = this.down('form').getForm().findField('roller_identification_form_detail_id'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : roller_identification_form_detail_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( roller_identification_form_detail_id );
			}
		});
	},
	
	setSelectedCoreTypeCase: function( core_type_case ){
		// console.log("inside set selected original account id ");
		var comboBox = this.down('form').getForm().findField('core_type_case'); 
		var me = this; 
		var store = comboBox.store;  
		store.load({
			params: {
				selected_id : core_type_case 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( core_type_case );
			}
		});
	},
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		
		me.setSelectedRollerBuilder( record.get("roller_builder_id")  ) ; 
		me.setSelectedRIFDetail( record.get("roller_identification_form_detail_id")  ) ; 
		me.setSelectedCoreTypeCase( record.get("core_type_case")  ) ; 
	},
	
	
	setParentData: function( record) {
		this.down('form').getForm().findField('recovery_order_id').setValue(record.get('id'));
	}
 
});




