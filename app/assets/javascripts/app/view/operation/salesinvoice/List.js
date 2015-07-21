Ext.define('AM.view.operation.salesinvoice.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.salesinvoicelist',

  	store: 'SalesInvoices',  
 

	initComponent: function() {
		this.columns = [
			// { header: 'ID', dataIndex: 'id'},
			{ header: 'Kode',  dataIndex: 'code', flex: 1},
 


			{
				xtype : 'templatecolumn',
				text : "Deskripsi",
				flex : 3,
				tpl : 	'Customer:  <b>{delivery_order_sales_order_contact_name}</b>'  + '<br />' + '<br />' +
						'Nomor Surat:  <b>{nomor_surat}</b>'  + '<br />' + '<br />' +
						 
						'Description:  <b>{description}</b>'  
			},
			
			{
				xtype : 'templatecolumn',
				text : "Receivable",
				flex : 3,
				tpl : 	'Total:  <br /> <b>{amount_receivable} {delivery_order_sales_order_exchange_name}</b>'  + '<br />' + '<br />' +
						'Exchange Rate:  <b>{exchange_rate_amount}</b>'  + '<br />' + '<br />' +
						'Tax (%):  <b>{tax_value}</b>'  
			},
 
  
			{
				xtype : 'templatecolumn',
				text : "Invoice",
				flex : 3,
				tpl : 	'Tanggal Invoice:  <br /><b>{invoice_date}</b>'  + '<br />' + '<br />' +
							'Due: <br /> <b>{due_date}</b>' 
			},
			{
				xtype : 'templatecolumn',
				text : "Konfirmasi",
				flex : 3,
				tpl : 	'Status Konfirmasi:  <br /> <b>{is_confirmed}</b>'  + '<br />' + '<br />' +
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
		
		this.searchField = new Ext.form.field.Text({
			name: 'searchField',
			hideLabel: true,
			width: 200,
			emptyText : "Search",
			checkChangeBuffer: 300
		});
		
		this.downloadButton = new Ext.Button({
			text: 'Print',
			action: 'downloadObject',
			disabled: true
		});
		
		this.filterButton  = new Ext.Button({
			text: 'Filter',
			action: 'filterObject' 
		});
		
		 
			this.tbar = [this.addObjectButton, this.editObjectButton, this.deleteObjectButton , 
				'-',
					this.confirmObjectButton, this.unconfirmObjectButton,
					this.downloadButton, 
					'->',
					this.filterButton ,
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
