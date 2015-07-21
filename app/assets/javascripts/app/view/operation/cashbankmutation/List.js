Ext.define('AM.view.operation.cashbankmutation.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.cashbankmutationlist',

  	store: 'CashBankMutations', 
 

	initComponent: function() {
		this.columns = [
			{ header: 'ID', dataIndex: 'id'},
			{ header: 'Code', dataIndex: 'code'},
			{ header: 'No Bukti', dataIndex: 'no_bukti'},
			{ header: 'Source CashBank', dataIndex: 'source_cash_bank_name'},
			{ header: 'Target CashBank', dataIndex: 'target_cash_bank_name'},
			{ header: 'Tanggal Mutasi', dataIndex: 'mutation_date'},
			{ header: 'Amount', dataIndex: 'amount'},
			{
				xtype : 'templatecolumn',
				text : "Konfirmasi",
				flex : 3,
				tpl : 	'Status Konfirmasi:  <b>{is_confirmed}</b>'  + '<br />' + '<br />' +
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
		
		this.searchField = new Ext.form.field.Text({
			name: 'searchField',
			hideLabel: true,
			width: 200,
			emptyText : "Search",
			checkChangeBuffer: 300
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
			hidden :true 
		});
		
		
		this.tbar = [this.addObjectButton, this.editObjectButton, this.deleteObjectButton ,
		
							
		 				'-',
		 				this.confirmObjectButton, 
		 				this.unconfirmObjectButton,
		 				'-',
						this.searchField,
						'->',
						
		];
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
		this.confirmObjectButton.enable(); 
		this.unconfirmObjectButton.enable(); 



		selectedObject = this.getSelectedObject();

		if( selectedObject && selectedObject.get("is_confirmed") == true ){
			this.unconfirmObjectButton.show();
			this.confirmObjectButton.hide();
		}else{
			this.unconfirmObjectButton.hide();
			this.confirmObjectButton.show();
		}


	},

	disableRecordButtons: function() {
		
		this.editObjectButton.disable();
		this.deleteObjectButton.disable();
		this.confirmObjectButton.disable(); 
		this.unconfirmObjectButton.disable(); 
		
		selectedObject = this.getSelectedObject();

		if( selectedObject && selectedObject.get("is_confirmed") == true ){
			this.unconfirmObjectButton.show();
			this.confirmObjectButton.hide();
		}else{
			this.unconfirmObjectButton.hide();
			this.confirmObjectButton.show();
		}

	}
});
