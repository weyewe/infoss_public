Ext.define('AM.view.master.itemtype.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.itemtypeform',

  title : 'Add / Edit Type',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	 	var me = this; 
		var remoteJsonStoreAccount = Ext.create(Ext.data.JsonStore, {
			storeId : 'account_search',
			fields	: [
			 		{
						name : 'account_name',
						mapping : "name"
					} ,
					{
						name : 'account_code',
						mapping : "code"
					} ,
			 
					{
						name : 'account_id',
						mapping : 'id'
					}  ,
					{
						name : 'display',
						convert: function(v, rec){
							var code = rec.get('account_code') ;
							var name = rec.get("account_name");
							
							return name + " ("+  code +    ")"; 
						} 
					}
			],
			
		 
			proxy  	: {
				type : 'ajax',
				url : 'api/search_ledger_accounts',
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
	        fieldLabel: 'Nama'
	      },
				{
					xtype: 'textfield',
					name : 'description',
					fieldLabel: 'Deskripsi'
				},
				{
							fieldLabel: 'CoA terhubung',
							xtype: 'combo',
							queryMode: 'remote',
							forceSelection: true, 
							displayField : 'display',
							valueField : 'account_id',
							pageSize : 5,
							minChars : 1, 
							allowBlank : false, 
							triggerAction: 'all',
							store : remoteJsonStoreAccount , 
							listConfig : {
								getInnerTpl: function(){
									return  	'<div data-qtip="{account_name}">' + 
															'<div class="combo-name">{account_name}</div>' + 
															'<div class="combo-name">Code: {account_code}</div>' + 
									 					'</div>';
								}
							},
							name : 'account_id' 
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

	setSelectedAccount: function( account_id ){
		var comboBox = this.down('form').getForm().findField('account_id'); 
		var me = this; 
		var store = comboBox.store; 
		// console.log( 'setSelectedMember');
		// console.log( store ) ;
		store.load({
			params: {
				selected_id : account_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( account_id );
			}
		});
	},
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		me.setSelectedAccount( record.get("account_id")  ) ;
	}
});

