Ext.define('AM.view.master.blanket.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.blanketlist',

  	store: 'Blankets', 
 

	initComponent: function() {
		this.columns = [
			{ header: 'ID', dataIndex: 'id'},
			{ header: 'Sku', dataIndex: 'sku'},
			{ header: 'Name', dataIndex: 'name'},
			{ header: 'QTY', dataIndex: 'amount'},
			{ header: 'AC', dataIndex: 'ac'},	
			{ header: 'AR', dataIndex: 'ar'},
			{ header: 'Thickness', dataIndex: 'thickness'},
			{ header: 'Machine', dataIndex: 'machine_name'},
			{ header: 'Adhesive1', dataIndex: 'adhesive_name'},
			{ header: 'Adhesive2', dataIndex: 'adhesive2_name'},
			{ header: 'Roll Blanket', dataIndex: 'roll_blanket_item_name'},
			{ header: 'Bar1', dataIndex: 'left_bar_item_name'},
			{ header: 'Bar2', dataIndex: 'right_bar_item_name'},
			{ header: 'Customer', dataIndex: 'contact_name'},
			{ header: 'Application', dataIndex: 'application_case'},
			{ header: 'Cropping', dataIndex: 'cropping_type'},
			{ header: 'AC', dataIndex: 'ac'},
			{ header: 'AR', dataIndex: 'ar'},
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

		this.tbar = [this.addObjectButton, this.editObjectButton, this.deleteObjectButton ,
		 				'-',
						this.searchField,
						
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
	},

	disableRecordButtons: function() {
		this.editObjectButton.disable();
		this.deleteObjectButton.disable();
	}
});
