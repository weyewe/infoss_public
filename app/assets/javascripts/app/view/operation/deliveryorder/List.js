Ext.define('AM.view.operation.deliveryorder.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.deliveryorderlist',

  	store: 'DeliveryOrders',  
 

	initComponent: function() {
		this.columns = [
			// { header: 'ID', dataIndex: 'id'},
			{ header: 'Kode',  dataIndex: 'code', flex: 1},
			{ header: 'Nomor Surat', dataIndex: 'nomor_surat', flex: 2 },
			
			{
				xtype : 'templatecolumn',
				text : "Description",
				flex : 3,
				tpl : 	'Tanggal Delivery: <br />  <b>{delivery_date}</b>'  + '<br />' + '<br />' +
							'Gudang: <br /> <b>{warehouse_name}</b>'  + '<br />' + '<br />' +
							'SalesOrder: <br /><b>{sales_order_nomor_surat}</b>'
			},
			
		
			
			
 
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
					this.filterButton,
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
