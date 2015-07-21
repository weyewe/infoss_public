	
Ext.define('AM.view.master.blendingrecipe.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.blendingrecipeform',

  title : 'Add / Edit BlendingRecipe',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
			var me = this; 
	
	var remoteJsonStoreItem = Ext.create(Ext.data.JsonStore, {
		storeId : 'item_search',
		fields	: [
		 		{
					name : 'item_name',
					mapping : "name"
				} ,
				{
					name : 'item_sku',
					mapping : "sku"
				} ,
		 		{
					name : 'item_amount',
					mapping : "amount"
				} ,
				{
					name : 'item_id',
					mapping : 'id'
				}  
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
    		        xtype: 'displayfield',
    		        name : 'code',
    		        fieldLabel: 'Kode'
    		  	  },
    		  	{
					xtype: 'textfield',
					fieldLabel : 'Name',
					name : 'name'
				},
				{
					xtype: 'textarea',
					fieldLabel : 'Description',
					name : 'description'
				},
    	    	{
	    				fieldLabel: 'Target Item',
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
	    												'<div class="combo-name">{item_sku}</div>' + 
	    												'<div class="combo-name">Name: {item_name}</div>' + 
	    												'<div class="combo-name">QTY: {item_amount}</div>' + 
	    						 					'</div>';
	    					}
    					},
    					name : 'target_item_id' 
    	      },
	      	{
				xtype: 'numberfield',
				fieldLabel : 'Target QTY',
				name : 'target_amount'
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
  
  setSelectedTargetItem: function( target_item_id ){
		var comboBox = this.down('form').getForm().findField('target_item_id'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : target_item_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( target_item_id );
			}
		});
	},
	
	setComboBoxData : function( record){ 

		var me = this; 
		me.setLoading(true);
		
		me.setSelectedTargetItem( record.get("target_item_id")  ) ;
 
	}
 
});




