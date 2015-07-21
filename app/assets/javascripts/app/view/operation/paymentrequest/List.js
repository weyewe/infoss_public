Ext.define('AM.view.operation.paymentrequest.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.paymentrequestlist',

  	store: 'PaymentRequests',  
 

	initComponent: function() {
		this.columns = [
			// { header: 'ID', dataIndex: 'id'},
			{ header: 'No Bukti', dataIndex: 'nomor_surat', flex: 2 },
			{ header: 'Code',  dataIndex: 'code', flex: 1},
		 	{ header: 'Contact',  dataIndex: 'contact_name', flex: 2},
		 	{ header: 'Description',  dataIndex: 'description', flex: 2},
		 	{ header: 'Amount',  dataIndex: 'amount', flex: 2},
			{ header: 'Request Date', dataIndex: 'request_date', flex: 2 },
			{
				xtype : 'templatecolumn',
				text : "Konfirmasi",
				flex : 3,
				tpl : 'Tanggal Konfirmasi: <b>{confirmed_at}</b>' + '<br />' + '<br />' +
							'Status Konfirmasi:  <b>{is_confirmed}</b>'   
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
		this.downloadButton.enable();
 
		this.deleteObjectButton.enable(); 
		this.unconfirmObjectButton.enable();
		this.confirmObjectButton.enable();
 
		
		selectedObject = this.getSelectedObject();
		
		if( selectedObject && selectedObject.get("is_confirmed") == true ){
			this.confirmObjectButton.hide();
			this.unconfirmObjectButton.show(); 
		}else{
			
			this.confirmObjectButton.show();
			this.unconfirmObjectButton.hide();
		}
	},

	disableRecordButtons: function() {
		this.editObjectButton.disable();
		this.deleteObjectButton.disable();
		this.unconfirmObjectButton.disable();
		this.confirmObjectButton.disable(); 
		this.downloadButton.disable();
		 
		
		selectedObject = this.getSelectedObject();
		
		if( selectedObject && selectedObject.get("is_confirmed") == true ){
			this.confirmObjectButton.hide();
			this.unconfirmObjectButton.show(); 
		}else{
			
			this.confirmObjectButton.show();
			this.unconfirmObjectButton.hide();
		} 
	}
});
