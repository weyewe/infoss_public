Ext.define('AM.view.master.item.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.itemform',

  title : 'Add / Edit Item',
  layout: 'fit', 
	width	: 960, 
	height : 500,
  autoShow: true,  // does it need to be called?
	modal : true,  
	
	companyInfo : function(){
				var entityInfo = {
					xtype : 'fieldset',
					title : "Info Item",
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
							fieldLabel: 'id',
							name: 'id' 
						},
						{
							xtype: 'textfield',
							fieldLabel : 'Name',
							name : 'name'
						},
						{
							xtype: 'textfield',
							fieldLabel : 'SKU',
							name : 'sku' 
						}, 
			 
						{
							xtype: 'textarea',
							fieldLabel : 'Deskripsi',
							name : 'description' 
						}, 
				 
						{
							xtype: 'textfield',
							fieldLabel : 'Minimum Quantity',
							name : 'minimum_amount' 
						}, 
						
						
	
					]
				};
				
				var me = this; 
		
		
				
				var remoteJsonStoreItemType = Ext.create(Ext.data.JsonStore, {
					storeId : 'item_type_search',
					fields	: [
					 		{
								name : 'item_type_name',
								mapping : "name"
							} ,
						 
					 
							{
								name : 'item_type_id',
								mapping : 'id'
							}  
					],
					
				 
					proxy  	: {
						type : 'ajax',
						url : 'api/search_item_types',
						reader : {
							type : 'json',
							root : 'records', 
							totalProperty  : 'total'
						}
					},
					autoLoad : false 
				});
				
				var remoteJsonStoreSubType = Ext.create(Ext.data.JsonStore, {
					storeId : 'sub_type_search',
					fields	: [
					 		{
								name : 'sub_type_name',
								mapping : "name"
							} ,
						 
					 
							{
								name : 'sub_type_id',
								mapping : 'id'
							}  
					],
					
				 
					proxy  	: {
						type : 'ajax',
						url : 'api/search_sub_types',
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
							} ,
						 
					 
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
				
				
				var categoryInfo = {
					xtype : 'fieldset',
					title : "Kategori Item",
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
							fieldLabel: 'Tipe Item',
							xtype: 'combo',
							queryMode: 'remote',
							forceSelection: true, 
							displayField : 'item_type_name',
							valueField : 'item_type_id',
							pageSize : 5,
							minChars : 1, 
							allowBlank : false, 
							triggerAction: 'all',
							store : remoteJsonStoreItemType , 
							listConfig : {
								getInnerTpl: function(){
									return  	'<div data-qtip="{item_type_name}">' + 
															'<div class="combo-name">{item_type_name}</div>' +
									 					'</div>';
								}
							},
							name : 'item_type_id' 
						},
						
						{
							fieldLabel: 'Sub Tipe',
							xtype: 'combo',
							queryMode: 'remote',
							forceSelection: true, 
							displayField : 'sub_type_name',
							valueField : 'sub_type_id',
							pageSize : 5,
							minChars : 1, 
							allowBlank : false, 
							triggerAction: 'all',
							store : remoteJsonStoreSubType , 
							listConfig : {
								getInnerTpl: function(){
									return  	'<div data-qtip="{sub_type_name}">' + 
															'<div class="combo-name">{sub_type_name}</div>' +  
									 					'</div>';
								}
							},
							name : 'sub_type_id' 
						},
						
						{
							fieldLabel: 'Uom',
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
						entityInfo ,
						categoryInfo
					]
				};
				
				return container; 
	},
	
	picInfo: function(){
		
		var me = this; 
		
		var remoteJsonStoreExchange = Ext.create(Ext.data.JsonStore, {
			storeId : 'exchange_search',
			fields	: [
			 		{
						name : 'exchange_name',
						mapping : "name"
					} ,
 
					{
						name : 'exchange_id',
						mapping : 'id'
					}  
			],
			
		 
			proxy  	: {
				type : 'ajax',
				url : 'api/search_exchanges',
				reader : {
					type : 'json',
					root : 'records', 
					totalProperty  : 'total'
				}
			},
			autoLoad : false 
		});
		
		var salesInfo = {
					xtype : 'fieldset',
					title : "Info Penjualan",
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
							xtype: 'checkboxfield',
							fieldLabel : 'Untuk Dijual?',
							name : 'is_tradeable' 
						}, 
						
						{
							fieldLabel: 'Currency',
							xtype: 'combo',
							queryMode: 'remote',
							forceSelection: true, 
							displayField : 'exchange_name',
							valueField : 'exchange_id',
							pageSize : 5,
							minChars : 1, 
							allowBlank : false, 
							triggerAction: 'all',
							store : remoteJsonStoreExchange , 
							listConfig : {
								getInnerTpl: function(){
									return  	'<div data-qtip="{exchange_name}">' + 
															'<div class="combo-name">{exchange_name}</div>' +  
									 					'</div>';
								}
							},
							name : 'exchange_id' 
						},
		 
						{
							xtype: 'textfield',
							fieldLabel : 'Harga Jual',
							name : 'selling_price' 
						}, 
						{
							xtype: 'textfield',
							fieldLabel : 'Price List',
							name : 'price_list' 
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

	setSelectedExchange: function( exchange_id ){
		var comboBox = this.down('form').getForm().findField('exchange_id'); 
		var me = this; 
		var store = comboBox.store; 
		// console.log( 'setSelectedMember');
		// console.log( store ) ;
		store.load({
			params: {
				selected_id : exchange_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( exchange_id );
			}
		});
	},
	
	setSelectedItemType: function( item_type_id ){
		var comboBox = this.down('form').getForm().findField('item_type_id'); 
		var me = this; 
		var store = comboBox.store; 
		// console.log( 'setSelectedMember');
		// console.log( store ) ;
		store.load({
			params: {
				selected_id : item_type_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( item_type_id );
			}
		});
	},
	
	setSelectedSubType: function( sub_type_id ){
		var comboBox = this.down('form').getForm().findField('sub_type_id'); 
		var me = this; 
		var store = comboBox.store; 
		// console.log( 'setSelectedMember');
		// console.log( store ) ;
		store.load({
			params: {
				selected_id : sub_type_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( sub_type_id );
			}
		});
	},
	
	setSelectedUom: function( uom_id ){ 
		var comboBox = this.down('form').getForm().findField('uom_id'); 
		var me = this; 
		var store = comboBox.store; 
		// console.log( 'setSelectedMember');
		// console.log( store ) ;
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
		
		me.setSelectedExchange( record.get("exchange_id")  ) ;
		me.setSelectedItemType( record.get("item_type_id")  ) ;
		me.setSelectedSubType( record.get("sub_type_id")  ) ;
		me.setSelectedUom( record.get("uom_id")  ) ;
	}
});

