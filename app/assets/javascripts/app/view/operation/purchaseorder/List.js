Ext.define('AM.view.operation.purchaseorder.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.purchaseorderlist',

  	store: 'PurchaseOrders',  
 

	initComponent: function() {
		this.columns = [
			// { header: 'Kode',  dataIndex: 'code', flex: 1},
			// { header: 'Nomor Surat', dataIndex: 'nomor_surat', flex: 2 },
			// { header: 'Tanggal Pembelian', dataIndex: 'purchase_date', flex: 2 },
		 //	{ header: 'Contact',  dataIndex: 'contact_name', flex: 2},
			// { header: 'Currency',  dataIndex: 'exchange_name', flex: 2},
			
			{ header: 'Kode',  dataIndex: 'code', flex: 1},

			{
				xtype : 'templatecolumn',
				text : "Description",
				flex : 3,
				tpl : 	'Sales Date: <br />  <b>{purchase_date}</b>'  + '<br />' + '<br />' +
							'No Surat: <b>{nomor_surat}</b>' + '<br />' + '<br />' +
							'Quantity Editable: <b>{allow_edit_detail}</b>' 
			},
			
			{	header: 'Supplier', dataIndex: 'contact_name', flex: 2 },
			{	header: 'Currency', dataIndex: 'exchange_name', flex: 2 }, 
		  
			{
				xtype : 'templatecolumn',
				text : "Konfirmasi",
				flex : 3,
				tpl : 	'Status Konfirmasi:  <b>{is_confirmed}</b>'  + '<br />' + '<br />' +
							'Tanggal Konfirmasi: <br /> <b>{confirmed_at}</b>' 
			},
			
			
		];

		this.addObjectButton = new Ext.Button({
			text: 'Add',
			action: 'addObject'
		});

		this.editObjectButton = new Ext.Button({
			text: 'Edit',
			action: 'editObject',
			disabled: true
		});

		this.deleteObjectButton = new Ext.Button({
			text: 'Delete',
			action: 'deleteObject',
			disabled: true
		});
		
		this.confirmObjectButton = new Ext.Button({
			text: 'Confirm',
			action: 'confirmObject',
			disabled: true
		});
	
		this.unconfirmObjectButton = new Ext.Button({
			text: 'Unconfirm',
			action: 'unconfirmObject',
			disabled: true,
			hidden : true
		});
		
		this.downloadButton = new Ext.Button({
			text: 'Print',
			action: 'downloadObject',
			disabled: true
		});
		
		this.searchField = new Ext.form.field.Text({
			name: 'searchField',
			hideLabel: true,
			width: 200,
			emptyText : "Search",
			checkChangeBuffer: 300
		});
		
		 
			this.tbar = [this.addObjectButton, this.editObjectButton, this.deleteObjectButton , 
				'-',
					this.confirmObjectButton, this.unconfirmObjectButton,
					this.downloadButton, 
					'->',
					this.searchField ];
	 


		
		this.bbar = Ext.create("Ext.PagingToolbar", {
			store	: this.store, 
			displayInfo: true,
			displayMsg: 'Displaying topics {0} - {1} of {2}',
			emptyMsg: "No topics to display" 
		});

		this.callParent(arguments);
	},
 
	loadMask	: true,
	
	getSelectedObject: function() {
		return this.getSelectionModel().getSelection()[0];
	},

	enableRecordButtons: function() {
		this.editObjectButton.enable();
		this.deleteObjectButton.enable(); 
		this.downloadButton.enable();
		
		selectedObject = this.getSelectedObject();
		
		if( selectedObject && selectedObject.get("is_confirmed") == true ){
			this.confirmObjectButton.hide();
			this.unconfirmObjectButton.show();
			this.unconfirmObjectButton.enable();
		}else{
			this.confirmObjectButton.enable();
			this.confirmObjectButton.show();
			this.unconfirmObjectButton.hide();
		}
	},

	disableRecordButtons: function() {
		this.editObjectButton.disable();
		this.deleteObjectButton.disable();
		this.confirmObjectButton.disable(); 
		this.downloadButton.disable();
	}
});
