Ext.define('AM.view.operation.rolleracc.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.rolleracclist',

  	store: 'RollerAccs',  
 

	initComponent: function() {
		this.columns = [
			// { header: 'ID', dataIndex: 'id'},
			{ header: 'RIF Id', dataIndex: 'detail_id', flex: 1},
			{ header: 'Roller No',  dataIndex: 'roller_no', flex: 1},
    		{ header: 'Material',  dataIndex: 'material_case_text', flex: 1},
    		{ header: 'Core SKU',  dataIndex: 'core_builder_sku', flex: 2},
    		{ header: 'Core',  dataIndex: 'core_builder_name', flex: 2},
    		{ header: 'Roller Type',  dataIndex: 'roller_type_name', flex: 2},
    		{ header: 'Machine',  dataIndex: 'machine_name', flex: 2},
    		{ header: 'Repair',  dataIndex: 'repair_request_case_text', flex: 2},
    		{ header: 'RD',  dataIndex: 'rd', flex: 1},
    		{ header: 'CD',  dataIndex: 'cd', flex: 1},
    		{ header: 'WL',  dataIndex: 'wl', flex: 1},
    		{ header: 'TL',  dataIndex: 'gl', flex: 1},
    		{ header: 'Groove Length',  dataIndex: 'groove_length', flex: 1},
    		{ header: 'QTY Grooves',  dataIndex: 'groove_amount', flex: 1},
		 
			
			
			
			
 
			{
				xtype : 'templatecolumn',
				text : "Transaksi",
				flex : 3,
				tpl : 'Tanggal Transaksi: <b>{transaction_datetime}</b>' + '<br />' + '<br />' +
							'Status Konfirmasi:  <b>{is_confirmed}</b>'  + '<br />' + '<br />' +
							'Tanggal Konfirmasi: <b>{confirmed_at}</b>' 
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
		
		 
			this.tbar = [
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
