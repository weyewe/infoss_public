
Ext.define('AM.view.operation.bankadministration.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.bankadministrationform',

  title : 'Add / Edit BankAdministration',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	 var me = this; 
	
	 
		
    var remoteJsonStoreCashBank = Ext.create(Ext.data.JsonStore, {
			storeId : 'type_search',
			fields	: [
			 		{
						name : 'cash_bank_name',
						mapping : "name"
					} ,
					{
						name : 'cash_bank_id',
						mapping : "id"
					}  ,
          {
						name : 'cash_bank_amount',
						mapping : "amount"
					}  
			],
			proxy  	: {
				type : 'ajax',
				url : 'api/search_cash_bank',
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
								fieldLabel : 'No Bukti',
								name : 'no_bukti'
							},
	    		    {
	    					xtype: 'datefield',
	    					name : 'administration_date',
	    					fieldLabel: 'Tanggal Administrasi',
	    					format: 'Y-m-d',
	    				},
	    				{
								fieldLabel: 'CashBank',
								xtype: 'combo',
								queryMode: 'remote',
								forceSelection: true, 
								displayField : 'cash_bank_name',
								valueField : 'cash_bank_id',
								pageSize : 5,
								minChars : 1, 
								allowBlank : false, 
								triggerAction: 'all',
								store : remoteJsonStoreCashBank , 
								listConfig : {
									getInnerTpl: function(){
										return  	'<div data-qtip="{cash_bank_name}">' + 
																'<div class="combo-name">{cash_bank_name}</div>' + 
				                      '<div class="combo-name">{cash_bank_amount}</div>'
										 					'</div>';
									}
								},
								name : 'cash_bank_id' 
							},
    					{
								xtype: 'numberfield',
								fieldLabel : 'Rate To IDR',
								name : 'exchange_rate_amount'
							},
	    				{
      	        xtype: 'textarea',
      	        name : 'description',
      	        fieldLabel: 'Catatan'
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
  
  setSelectedCashBank: function( cash_bank_id ){ 
      var comboBox = this.down('form').getForm().findField('cash_bank_id'); 
      var me = this; 
      var store = comboBox.store;  
      store.load({
        params: {
          selected_id : cash_bank_id 
        },
        callback : function(records, options, success){
          me.setLoading(false);
          comboBox.setValue( cash_bank_id );
        }
      });
    },
	
	setComboBoxData : function( record){ 
		var me = this; 
		me.setLoading(true);
		me.setSelectedCashBank( record.get("cash_bank_id")  ) ; 
	}
 
});




