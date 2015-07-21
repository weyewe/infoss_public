Ext.define('AM.view.master.subtype.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.subtypeform',

  title : 'Add / Edit Sub Type',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
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
	        name : 'name',
	        fieldLabel: 'Namat'
	      },
				{
							fieldLabel: 'Item Type ',
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
															'<div class="combo-name">{item_type_name}</div>'  
									 					'</div>';
								}
							},
							name : 'item_type_id' 
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
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		me.setSelectedItemType( record.get("item_type_id")  ) ;
	}
});

