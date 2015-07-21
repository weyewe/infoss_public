Ext.define('AM.view.operation.batchinstance.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.batchinstancelist',

  	store: 'BatchInstances', 
 
 
 
	initComponent: function() {
		this.columns = [ 
			{
				xtype : 'templatecolumn',
				text : "Item",
				sortable : false,
				flex : 1,
				tpl :  '<b>Item SKU</b>: <br />{item_sku}'  + '<br />' +    '<br />' +  
						'<b>Item Name</b>: <br />{item_name}'  + '<br />' +  '<br />' + 
							'<b>Item Type</b>: <br />{item_type_name}'   
			},
			
			{
				xtype : 'templatecolumn',
				text : "Batch",
				sortable : false,
				flex : 1,
				tpl : '<b>Nama</b>: <br />{name}' + '<br /><br />' + 
							'<b>Deskripsi</b>: <br />{description}'  + '<br /><br />' 
			},
			
			{
				xtype : 'templatecolumn',
				text : "Batch",
				sortable : false,
				flex : 1,
				tpl : 'Kuantitas Total: <br />{total_allocated_amount}' + '<br /><br />' + 
							'Belum Digunakan: <br />{amount}'  + '<br /><br />' 
			},
			
			 
			{	header: 'Tanggal Manufacture', dataIndex: 'manufactured_at', flex: 1 }, 
			
  
			
			
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
		
		
	 

		selectedObject = this.getSelectedObject();
 


	},

	disableRecordButtons: function() {
		this.editObjectButton.disable();
		this.deleteObjectButton.disable();
 
		selectedObject = this.getSelectedObject();

 
	}
});
