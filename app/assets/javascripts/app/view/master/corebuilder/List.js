Ext.define('AM.view.master.corebuilder.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.corebuilderlist',

  	store: 'CoreBuilders', 
 

	initComponent: function() {
		this.columns = [
			{ header: 'ID', dataIndex: 'id'},
			{ header: 'Base Sku', dataIndex: 'base_sku'},
			{ header: 'Name', dataIndex: 'name'},
			{ header: 'Description', dataIndex: 'description'},
			{ header: 'Machine', dataIndex: 'machine_name'},
			{ header: 'Type', dataIndex: 'core_builder_type_case'},
			{ header: 'Used Sku', dataIndex: 'sku_used_core'},
			{ header: 'QTY', dataIndex: 'used_core_item_amount'},
			{ header: 'UoM', dataIndex: 'uom_name'},
			{ header: 'New Sku', dataIndex: 'sku_new_core'},
			{ header: 'QTY', dataIndex: 'new_core_item_amount'},
			{ header: 'UoM', dataIndex: 'uom_name'},
			{ header: 'CD', dataIndex: 'cd'},
			{ header: 'TL', dataIndex: 'tl'},
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
		
		this.markAsDeceasedObjectButton = new Ext.Button({
			text: 'Deceased',
			action: 'markasdeceasedObject',
			disabled: true
		});

		this.unmarkAsDeceasedObjectButton = new Ext.Button({
			text: 'Cancel Deceased',
			action: 'unmarkasdeceasedObject',
			disabled: true,
			hidden :true 
		});
		
		this.markAsRunAwayObjectButton = new Ext.Button({
			text: 'Run Away',
			action: 'markasrunawayObject',
			disabled: true
		});



		this.tbar = [this.addObjectButton, this.editObjectButton, this.deleteObjectButton ,
		 				'-',
						this.searchField,
						'->',
						this.markAsDeceasedObjectButton,
						this.unmarkAsDeceasedObjectButton,
						this.markAsRunAwayObjectButton
						
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
		
		
		this.markAsRunAwayObjectButton.enable();

		this.unmarkAsDeceasedObjectButton.enable();
		this.markAsDeceasedObjectButton.enable();

		selectedObject = this.getSelectedObject();

		if( selectedObject && selectedObject.get("is_deceased") == true ){
			this.unmarkAsDeceasedObjectButton.show();
			this.markAsDeceasedObjectButton.hide();
		}else{
			this.unmarkAsDeceasedObjectButton.hide();
			this.markAsDeceasedObjectButton.show();
		}


	},

	disableRecordButtons: function() {
		this.editObjectButton.disable();
		this.deleteObjectButton.disable();
		this.markAsDeceasedObjectButton.disable();
		this.unmarkAsDeceasedObjectButton.disable();
		this.markAsRunAwayObjectButton.disable();

		selectedObject = this.getSelectedObject();

		if( selectedObject && selectedObject.get("is_deceased") == true ){
			this.unmarkAsDeceasedObjectButton.show();
			this.markAsDeceasedObjectButton.hide();
		}else{
			this.unmarkAsDeceasedObjectButton.hide();
			this.markAsDeceasedObjectButton.show();
		}
	}
});