Ext.define('AM.view.master.exchangerate.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.exchangerateform',

  title : 'Add / Edit Exchange Rate',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() { 
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
	        name : 'exchange_id',
	        fieldLabel: 'currency id'
	      },
	      {
	        xtype: 'displayfield',
	        name : 'exchange_name',
	        fieldLabel: 'Currency'
	      },
				 
	      {
      			xtype: 'datefield',
      			name : 'ex_rate_date',
      			fieldLabel: 'Tanggal Aktif',
      			format: 'Y-m-d',
      	},
      	{
      			xtype: 'textfield',
      			name : 'rate',
      			fieldLabel: 'Nilai Exchange' 
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
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		me.setSelectedExchange( record.get("exchange_id")  ) ;
	},
	
	setParentData: function( record ){ 
		this.down('form').getForm().findField('exchange_id').setValue(record.get('id')); 
		this.down('form').getForm().findField('exchange_name').setValue(record.get('name'));  
	},
});

