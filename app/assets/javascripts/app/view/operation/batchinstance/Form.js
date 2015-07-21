Ext.define('AM.view.operation.batchinstance.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.batchinstanceform',

  title : 'Add / Edit BatchInstance',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	
	var remoteJsonStoreItem = Ext.create(Ext.data.JsonStore, {
		storeId : 'item_search',
		fields	: [
		 		{
					name : 'item_sku',
					mapping : "sku"
				}, 
				{
					name : 'item_name',
					mapping : 'name'
				},
				{
					name : 'item_id',
					mapping : "id"
				}, 
	 
		],
		proxy  	: {
			type : 'ajax',
			url : 'api/search_items',
			reader : {
				type : 'json',
				root : 'records', 
				totalProperty  : 'total'
			}
		},
		autoLoad : false 
	});
	remoteJsonStoreItem.getProxy().extraParams.is_batch =  true;
		
	
		
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
			fieldLabel: 'Item',
			xtype: 'combo',
			queryMode: 'remote',
			forceSelection: true, 
			displayField : 'item_name',
			valueField : 'item_id',
			pageSize : 5,
			minChars : 1, 
			allowBlank : false, 
			triggerAction: 'all',
			store : remoteJsonStoreItem , 
			listConfig : {
				getInnerTpl: function(){
					return  	'<div data-qtip="{item_name}">' +  
											'<div class="combo-name">'  + 
														" ({item_name}) " 		+ "<br />" 	 + 
														'{item_sku}' 			+  
											 "</div>" +  
					 					'</div>';
				}
			},
			name : 'item_id' 
		},
	      {
	        xtype: 'textfield',
	        name : 'name',
	        fieldLabel: ' Name'
	      },
	      {
			xtype: 'textfield',
			name : 'description',
			fieldLabel: 'Deskripsi'
		  },
		  {
			xtype: 'datefield',
			name : 'manufactured_at',
			fieldLabel: 'Tanggal Manufacture',
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



	setComboBoxData : function( record){
		console.log("inside setComboBoxData")
		var item_id = record.get("item_id");
		var comboBox = this.down('form').getForm().findField('item_id'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : item_id ,
				is_batch : true 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( item_id );
			}
		});
	},
	
 
});

