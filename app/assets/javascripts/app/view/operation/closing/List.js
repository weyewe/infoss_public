Ext.define('AM.view.operation.closing.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.closinglist',

  	store: 'Closings',  
 

	initComponent: function() {
		this.columns = [
			// { header: 'ID', dataIndex: 'id'},
			{ 	header: 'Period',  dataIndex: 'period', flex: 1},
			{ 	header: 'Year',  dataIndex: 'year_period', flex: 1},
			{	header: 'Beginning', dataIndex: 'beginning_period', flex: 2 },
			{	header: 'End Date', dataIndex: 'end_date_period', flex: 2 },
			{	header: 'AR/AP inclusive', dataIndex: 'is_year_closing', flex: 2 },
			{
				xtype : 'templatecolumn',
				text : "Closing",
				flex : 3,
				tpl : 	'Status Closing:  <b>{is_closed}</b>'  + '<br />' + '<br />' +
							'Tanggal Konfirmasi: <b>{closed_at}</b>' 
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
			text: 'Close',
			action: 'confirmObject',
			disabled: true
		});
	
		this.unconfirmObjectButton = new Ext.Button({
			text: 'Reopen',
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
		
		if( selectedObject && selectedObject.get("is_closed") == true ){
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
		this.unconfirmObjectButton.disable();
		this.confirmObjectButton.disable(); 
		
		selectedObject = this.getSelectedObject();
		
		if( selectedObject && selectedObject.get("is_closed") == true ){
			this.confirmObjectButton.hide();
			this.unconfirmObjectButton.show(); 
		}else{
			
			this.confirmObjectButton.show();
			this.unconfirmObjectButton.hide();
		}
	}
});
