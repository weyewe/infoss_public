Ext.define('AM.view.master.blanket.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.blanketform',

  title : 'Add / Edit Blanket',
  layout: 'fit',
	width	: 960,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
	companyInfo : function(){
		
	var localJsonStoreBlanketType = Ext.create(Ext.data.Store, {
			type : 'array',
			storeId : 'is_bar_required',
			fields	: [ 
				{ name : "is_bar_required"}, 
				{ name : "is_bar_required_text"}  
			], 
			data : [
				{ is_bar_required : 0, is_bar_required_text : "Non Bar"},
				{ is_bar_required : 1, is_bar_required_text : "With Bar"},
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
		
		var remoteJsonStoreAdhesive = Ext.create(Ext.data.JsonStore, {
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
						name : 'item_adhesive_id',
						mapping : 'id'
					}
			],
			proxy  	: {
				type : 'ajax',
				url : 'api/search_item_adhesive_blankets',
				reader : {
					type : 'json',
					root : 'records', 
					totalProperty  : 'total'
				}
			},
			autoLoad : false 
		});
		
	
		
		var remoteJsonStoreContact = Ext.create(Ext.data.JsonStore, {
		storeId : 'contact_search',
		fields	: [
		 		{
					name : 'contact_name',
					mapping : "name"
				} ,
				{
					name : 'contact_description',
					mapping : "description"
				} ,
		 
				{
					name : 'contact_id',
					mapping : 'id'
				}  
		],
		
	 
		proxy  	: {
			type : 'ajax',
			url : 'api/search_customers',
			reader : {
				type : 'json',
				root : 'records', 
				totalProperty  : 'total'
			}
		},
		autoLoad : false 
		});
	
	var remoteJsonStoreRollBlanket = Ext.create(Ext.data.JsonStore, {
			storeId : 'item_roll_blanket_search',
			fields	: [
	 				{
						name : 'item_roll_blanket_name',
						mapping : "name"
					},
					{
						name : 'item_aroll_blanket_sku',
						mapping : "sku"
					},
					{
						name : 'item_roll_blanket_id',
						mapping : 'id'
					}
			],
			proxy  	: {
				type : 'ajax',
				url : 'api/search_item_roll_blankets',
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
	        xtype: 'textfield',
	        name : 'sku',
	        fieldLabel: ' Sku'
	      },{
					xtype: 'textfield',
					name : 'name',
					fieldLabel: 'Name'
				},
				{
					xtype: 'textfield',
					name : 'description',
					fieldLabel: 'Description'
				},
				{
					xtype: 'displayfield',
					name : 'amount',
					fieldLabel: 'QTY'
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
					fieldLabel: 'Customer',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'contact_name',
					valueField : 'contact_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStoreContact , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{contact_name}">' + 
													'<div class="combo-name">{contact_name}</div>' +
							 					'</div>';
						}
					},
					name : 'contact_id' 
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
													'<div class="combo-name">{machine_name}</div>' +
							 					'</div>';
						}
					},
					name : 'machine_id' 
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
					allowBlank : true, 
					triggerAction: 'all',
					store : remoteJsonStoreAdhesive , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{item_adhesive_name}">' + 
													'<div class="combo-name">{item_adhesive_name}</div>' +
							 					'</div>';
						}
					},
					name : 'adhesive_id' 
				},
				{
					fieldLabel: 'Adhesive 2',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'item_adhesive_name',
					valueField : 'item_adhesive_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : true, 
					triggerAction: 'all',
					store : remoteJsonStoreAdhesive , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{item_adhesive_name}">' + 
													'<div class="combo-name">{item_adhesive_name}</div>' +
							 					'</div>';
						}
					},
					name : 'adhesive2_id' 
				},
				{
					fieldLabel: 'RollBlanket',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'item_roll_blanket_name',
					valueField : 'item_roll_blanket_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStoreRollBlanket , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{item_roll_blanket_name}">' + 
													'<div class="combo-name">{item_roll_blanket_name}</div>' +
							 					'</div>';
						}
					},
					name : 'roll_blanket_item_id' 
				},
					{
					fieldLabel: 'BlanketType',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'is_bar_required_text',
					valueField : 'is_bar_required',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : localJsonStoreBlanketType , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{is_bar_required_text}">' + 
													'<div class="combo-name">{is_bar_required_text}</div>' +
							 					'</div>';
						}
					},
					name : 'is_bar_required' 
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
		var localJsonStoreApplicationCase = Ext.create(Ext.data.Store, {
			type : 'array',
			storeId : 'application_case',
			fields	: [ 
				{ name : "application_case"}, 
				{ name : "application_case_text"}  
			], 
			data : [
				{ application_case : 1, application_case_text : "Sheetfed"},
				{ application_case : 2, application_case_text : "Web"},
				{ application_case : 3, application_case_text : "Both"},
			] 
		});
		
		var localJsonStoreCroppingType= Ext.create(Ext.data.Store, {
			type : 'array',
			storeId : 'cropping_type',
			fields	: [ 
				{ name : "cropping_type"}, 
				{ name : "cropping_type_text"}  
			], 
			data : [
				{ cropping_type : 1, cropping_type_text : "Normal"},
				{ cropping_type : 2, cropping_type_text : "Special"},
			] 
		});
		
			
		
		
		var remoteJsonStoreBar = Ext.create(Ext.data.JsonStore, {
			storeId : 'item_bar_search',
			fields	: [
	 				{
						name : 'item_bar_name',
						mapping : "name"
					},
					{
						name : 'item_bar_sku',
						mapping : "sku"
					},
					{
						name : 'item_bar_id',
						mapping : 'id'
					}
			],
			proxy  	: {
				type : 'ajax',
				url : 'api/search_item_bars',
				reader : {
					type : 'json',
					root : 'records', 
					totalProperty  : 'total'
				}
			},
			autoLoad : false 
		});
		
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
					fieldLabel: 'Bar 1',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'item_bar_name',
					valueField : 'item_bar_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStoreBar , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{item_bar_name}">' + 
													'<div class="combo-name">{item_bar_name}</div>' +
							 					'</div>';
						}
					},
					name : 'left_bar_item_id' 
				},
				{
					fieldLabel: 'Bar 2',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'item_bar_name',
					valueField : 'item_bar_id',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : remoteJsonStoreBar , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{item_bar_name}">' + 
													'<div class="combo-name">{item_bar_name}</div>' +
							 					'</div>';
						}
					},
					name : 'right_bar_item_id' 
				},
				{
					xtype: 'numberfield',
					name : 'ac',
					fieldLabel: 'AC'
				},
				{
					xtype: 'numberfield',
					name : 'ar',
					fieldLabel: 'AR'
				},
				{
					xtype: 'numberfield',
					name : 'thickness',
					fieldLabel: 'Thick'
				},
				{
					fieldLabel: 'Application',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'application_case_text',
					valueField : 'application_case',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : localJsonStoreApplicationCase , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{application_case_text}">' + 
													'<div class="combo-name">{application_case_text}</div>' +
							 					'</div>';
						}
					},
					name : 'application_case' 
				},
				{
					fieldLabel: 'Cropping',
					xtype: 'combo',
					queryMode: 'remote',
					forceSelection: true, 
					displayField : 'cropping_type_text',
					valueField : 'cropping_type',
					pageSize : 5,
					minChars : 1, 
					allowBlank : false, 
					triggerAction: 'all',
					store : localJsonStoreCroppingType , 
					listConfig : {
						getInnerTpl: function(){
							return  	'<div data-qtip="{cropping_type_text}">' + 
													'<div class="combo-name">{cropping_type_text}</div>' +
							 					'</div>';
						}
					},
					name : 'cropping_type' 
				},
				{
					xtype: 'numberfield',
					name : 'left_over_ac',
					fieldLabel: 'Cropped AC'
				},
				{
					xtype: 'numberfield',
					name : 'left_over_ar',
					fieldLabel: 'Cropped AT'
				},
				{
					xtype: 'numberfield',
					name : 'special',
					fieldLabel: 'Cropped Special'
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
	
		var me = this
		
    this.items = [{
      xtype: 'form',
			msgTarget	: 'side',
			border: false,
      bodyPadding: 10,
			fieldDefaults: {
          labelWidth: 165,
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
	
	setSelectedCroppingType: function( cropping_type ){ 
		var comboBox = this.down('form').getForm().findField('cropping_type'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : cropping_type 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( cropping_type );
			}
		});
	},
	
	setSelectedApplicationCase: function( application_case ){ 
		var comboBox = this.down('form').getForm().findField('application_case'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : application_case 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( application_case );
			}
		});
	},
	
	setSelectedBlanketType: function( is_bar_required ){ 
		var comboBox = this.down('form').getForm().findField('is_bar_required'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : is_bar_required 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( is_bar_required );
			}
		});
	},
	
	setSelectedContact: function( contact_id ){ 
		var comboBox = this.down('form').getForm().findField('contact_id'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : contact_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( contact_id );
			}
		});
	},
	
	
	setSelectedRightBar: function( right_bar_item_id ){ 
		var comboBox = this.down('form').getForm().findField('right_bar_item_id'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : right_bar_item_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( right_bar_item_id );
			}
		});
	},
	
	setSelectedLeftBar: function( left_bar_item_id ){ 
		var comboBox = this.down('form').getForm().findField('left_bar_item_id'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : left_bar_item_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( left_bar_item_id );
			}
		});
	},
	
	setSelectedRollBlanket: function( roll_blanket_item_id ){ 
		var comboBox = this.down('form').getForm().findField('roll_blanket_item_id'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : roll_blanket_item_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( roll_blanket_item_id );
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
	
	setSelectedAdhesive2: function( adhesive2_id ){ 
		var comboBox = this.down('form').getForm().findField('adhesive2_id'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : adhesive2_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( adhesive2_id );
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
		me.setSelectedContact( record.get("contact_id")  ) ;
		me.setSelectedUom( record.get("uom_id")  ) ;
		me.setSelectedAdhesive( record.get("adhesive_id")  ) ;
		me.setSelectedAdhesive2( record.get("adhesive2_id")  ) ;
		me.setSelectedRollBlanket( record.get("roll_blanket_item_id")  ) ;
		me.setSelectedLeftBar( record.get("left_bar_item_id")  ) ;
		me.setSelectedRightBar( record.get("right_bar_item_id")  ) ;
		me.setSelectedCroppingType( record.get("cropping_type")  ) ;
		me.setSelectedBlanketType( record.get("is_bar_required")  ) ;
		me.setSelectedApplicationCase( record.get("application_case")  ) ;
	}
});

