Ext.define('AM.view.operation.blanketorder.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.blanketorderlist',

  	store: 'BlanketOrders',  
 

	initComponent: function() {
		this.columns = [
			// { header: 'ID', dataIndex: 'id'},
			{ header: 'Order No.',  dataIndex: 'code', flex: 1},
			{	header: 'Production No', dataIndex: 'production_no', flex: 2 },
			{	header: 'Contact', dataIndex: 'contact_name', flex: 2 },
			{	header: 'Warehouse', dataIndex: 'warehouse_name', flex: 2 },
			{	header: 'InHouse', dataIndex: 'is_in_house', flex: 2 },
			{	header: 'QTY', dataIndex: 'amount_received', flex: 2 },
			{	header: 'QTY Finished', dataIndex: 'amount_final', flex: 2 },
			{	header: 'QTY Rejected', dataIndex: 'amount_rejected', flex: 2 },
			{	header: 'Order Date', dataIndex: 'order_date', flex: 2 },
			{	header: 'Due Date', dataIndex: 'due_date', flex: 2 },
			{	header: 'Notes', dataIndex: 'notes', flex: 2 },
			{	header: 'Is Completed', dataIndex: 'is_completed', flex: 2 },
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
		
		 
			this.tbar = [this.addObjectButton, this.editObjectButton, this.deleteObjectButton , 
				'-',
					this.confirmObjectButton, this.unconfirmObjectButton,
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
	}
});
