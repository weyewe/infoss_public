Ext.define('AM.view.master.customer.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.customerform',

  title : 'Add / Edit Customer',
  layout: 'fit',
	width	: 960, 
  autoShow: true,  // does it need to be called?
	modal : true, 
	height : 500,
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
	companyInfo : function(){
				var entityInfo = {
					xtype : 'fieldset',
					title : "Info Badan Usaha",
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
							fieldLabel : 'Name Badan Usaha',
							name : 'name'
						},
						{
							xtype: 'textfield',
							fieldLabel : 'Contact No',
							name : 'contact_no' 
						}, 
						{
							xtype: 'textarea',
							fieldLabel : 'Alamat',
							name : 'address' 
						}, 
						{
							xtype: 'textarea',
							fieldLabel : 'Alamat pengiriman',
							name : 'delivery_address' 
						}, 
						{
							xtype: 'textarea',
							fieldLabel : 'Deskripsi',
							name : 'description' 
						}, 
						{
							xtype: 'numberfield',
							fieldLabel : 'Payment Term',
							name : 'default_payment_term' 
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
		
		var remoteJsonStoreContactGroup = Ext.create(Ext.data.JsonStore, {
			storeId : 'member_search',
			fields	: [
			 		{
						name : 'contact_group_name',
						mapping : "name"
					} ,
					{
						name : 'contact_group_description',
						mapping : "description"
					} ,
			 
					{
						name : 'contact_group_id',
						mapping : 'id'
					}  
			],
			
		 
			proxy  	: {
				type : 'ajax',
				url : 'api/search_contact_groups',
				reader : {
					type : 'json',
					root : 'records', 
					totalProperty  : 'total'
				}
			},
			autoLoad : false 
		});
		
		var taxInfo = {
					xtype : 'fieldset',
					title : "Tax Info",
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
							xtype: 'textfield',
							fieldLabel : 'NPWP',
							name : 'npwp' 
						}, 
						{
							xtype: 'checkboxfield',
							fieldLabel : 'Wajib Pajak?',
							name : 'is_taxable' 
						}, 
						{
							xtype: 'textfield',
							fieldLabel : 'Tax Code',
							name : 'tax_code' 
						}, 
						{
							xtype: 'textfield',
							fieldLabel : 'Nama Faktur Pajak',
							name : 'nama_faktur_pajak' 
						}, 
						
						
					]
				};
				
				
		var contactPersonInfo = {
					xtype : 'fieldset',
					title : "Contact Person",
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
							xtype: 'textfield',
							fieldLabel : 'Name PIC',
							name : 'pic'
						},
						{
							xtype: 'textfield',
							fieldLabel : 'No kontak PIC',
							name : 'pic_contact_no' 
						}, 
						{
							xtype: 'textfield',
							fieldLabel : 'Email',
							name : 'email' 
						},  
	
					]
				};
				
				var contactInfo = {
					xtype : 'fieldset',
					title : "Contact Info",
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
							fieldLabel: 'Contact Group',
							xtype: 'combo',
							queryMode: 'remote',
							forceSelection: true, 
							displayField : 'contact_group_name',
							valueField : 'contact_group_id',
							pageSize : 5,
							minChars : 1, 
							allowBlank : false, 
							triggerAction: 'all',
							store : remoteJsonStoreContactGroup , 
							listConfig : {
								getInnerTpl: function(){
									return  	'<div data-qtip="{contact_group_name}">' + 
															'<div class="combo-name">{contact_group_name}</div>' + 
															'<div class="combo-name">Deskripsi: {contact_group_description}</div>' + 
									 					'</div>';
								}
							},
							name : 'contact_group_id' 
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
						taxInfo,
						contactPersonInfo,
						contactInfo 
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

	setSelectedContactGroup: function( contact_group_id ){
		var comboBox = this.down('form').getForm().findField('contact_group_id'); 
		var me = this; 
		var store = comboBox.store; 
		// console.log( 'setSelectedMember');
		// console.log( store ) ;
		store.load({
			params: {
				selected_id : contact_group_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( contact_group_id );
			}
		});
	},
	
	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		me.setSelectedContactGroup( record.get("contact_group_id")  ) ;
	}
});

