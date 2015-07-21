Ext.define('AM.view.master.rollerbuilder.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.rollerbuilderlist',

  	store: 'RollerBuilders', 
 

	initComponent: function() {
		this.columns = [
			{ header: 'ID', dataIndex: 'id'},
			{ header: 'Base sku', dataIndex: 'base_sku'},
			{ header: 'Name', dataIndex: 'name'},
			{ header: 'Description', dataIndex: 'description'},
			{ header: 'RollerType', dataIndex: 'roller_type_name'},
			{ header: 'RD', dataIndex: 'rd'},
			{ header: 'CD', dataIndex: 'cd'},
			{ header: 'RL', dataIndex: 'rl'},
			{ header: 'WL', dataIndex: 'wl'},
			{ header: 'TL', dataIndex: 'tl'},
			{ header: 'Used Sku', dataIndex: 'sku_roller_used_core'},
			{ header: 'QTY', dataIndex: 'roller_used_core_item_amount'},
			{ header: 'UoM', dataIndex: 'uom_name'},
			{ header: 'New Sku', dataIndex: 'sku_roller_new_core'},
			{ header: 'QTY', dataIndex: 'roller_new_core_item_amount'},
			{ header: 'UoM', dataIndex: 'uom_name'},
			{ header: 'Machine', dataIndex: 'machine_name'},
			{ header: 'Compound', dataIndex: 'compound_name'},
			{ header: 'Adhesive', dataIndex: 'adhesive_name'},
			{ header: 'Core Sku', dataIndex: 'core_builder_sku'},
			{ header: 'Crown', dataIndex: 'is_crowning'},
			{ header: 'Size', dataIndex: 'crowning_size'},
			{ header: 'Groove', dataIndex: 'is_grooving'},
			{ header: 'W', dataIndex: 'grooving_width'},
			{ header: 'D', dataIndex: 'grooving_depth'},
			{ header: 'P', dataIndex: 'grooving_position'},
			{ header: 'Chamfer', dataIndex: 'is_chamfer'},
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
	},

	disableRecordButtons: function() {
		this.editObjectButton.disable();
		this.deleteObjectButton.disable();
	}
});
