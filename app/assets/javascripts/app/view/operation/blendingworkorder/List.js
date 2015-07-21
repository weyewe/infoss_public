Ext.define('AM.view.operation.blendingworkorder.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.blendingworkorderlist',

  	store: 'BlendingWorkOrders', 
 

	initComponent: function() {
		this.columns = [
			{ header: 'Kode',  dataIndex: 'code', flex: 1},
			{ header: 'Blending Recipe',  dataIndex: 'blending_recipe_name', flex: 1},
			{ header: 'Target Sku',  dataIndex: 'blending_recipe_target_item_sku', flex: 1},
			{ header: 'Target Item',  dataIndex: 'blending_recipe_target_item_name', flex: 1},
			{ header: 'UoM',  dataIndex: 'blending_recipe_target_item_uom_name', flex: 1},
			{ header: 'Warehouse',  dataIndex: 'warehouse_name', flex: 1},
			{ header: 'Description', dataIndex: 'description', flex: 2 },
			{ header: 'Blending Date', dataIndex: 'blending_date', flex: 2 },
			{
				xtype : 'templatecolumn',
				text : "Transaksi",
				flex : 3,
				tpl : 'Status Konfirmasi:  <b>{is_confirmed}</b>'  + '<br />' + '<br />' +
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
			hidden : true
		});

		this.tbar = [this.addObjectButton, this.editObjectButton, this.deleteObjectButton ,
		 				'-',
		 				this.confirmObjectButton, this.unconfirmObjectButton,
						'->',
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
