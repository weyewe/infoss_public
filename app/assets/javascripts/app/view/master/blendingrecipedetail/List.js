Ext.define('AM.view.master.blendingrecipedetail.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.blendingrecipedetaillist',

  	store: 'BlendingRecipeDetails', 
 

	initComponent: function() {
		this.columns = [
		 
			{ header: 'Sku',  dataIndex: 'item_sku', flex: 1},
			{ header: 'Name',  dataIndex: 'item_name', flex: 1},
    		{ header: 'Quantity',  dataIndex: 'amount', flex: 1},
    		{ header: 'Uom',  dataIndex: 'item_uom_name', flex: 2},
			 
		];
		

		this.addObjectButton = new Ext.Button({
			text: 'Add',
			action: 'addObject',
			disabled : true 
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


		this.tbar = [this.addObjectButton,  this.editObjectButton, this.deleteObjectButton ]; 
		this.bbar = Ext.create("Ext.PagingToolbar", {
			store	: this.store, 
			displayInfo: true,
			displayMsg: 'Details {0} - {1} of {2}',
			emptyMsg: "No details" 
		});

		this.callParent(arguments);
	},
 
	loadMask	: true,
	 
	
	getSelectedObject: function() {
		return this.getSelectionModel().getSelection()[0];
	},
	
	enableAddButton: function(){
		this.addObjectButton.enable();
	},
	
	disableAddButton: function(){
		this.addObjectButton.disable();
	},

	enableRecordButtons: function() {
		this.editObjectButton.enable();
		this.deleteObjectButton.enable();
	},

	disableRecordButtons: function() {
		this.editObjectButton.disable();
		this.deleteObjectButton.disable();
	},
	
	setObjectTitle : function(record){
		this.setTitle("BlendingRecipe: " + record.get("id"));
	}
});
