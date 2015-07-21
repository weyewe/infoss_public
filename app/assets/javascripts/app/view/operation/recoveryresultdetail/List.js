Ext.define('AM.view.operation.recoveryresultdetail.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.recoveryresultdetaillist',

  	store: 'RecoveryResultDetails', 
 

	initComponent: function() {
		this.columns = [
		 	{
				xtype : 'templatecolumn',
				text : "Accessory",
				flex : 3,
				tpl : 'SKU: <br /><b>{item_sku}</b>' + '<br />' + '<br />' +
							'<br /> <b>{item_name}</b>'   
			},
			
			{
				xtype : 'templatecolumn',
				text : "Quantity",
				flex : 3,
				tpl : ' <b>{amount}</b>  {item_uom_name}'   
			},
			 
			
			 
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
		this.setTitle("RecoveryResult: " + record.get("code"));
	}
});
