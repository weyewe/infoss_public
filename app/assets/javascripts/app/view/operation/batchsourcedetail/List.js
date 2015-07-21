Ext.define('AM.view.operation.batchsourcedetail.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.batchsourcedetaillist',

  	store: 'BatchSourceDetails', 
 

	initComponent: function() {
		this.columns = [
		  
			
			 
    		{ header: 'Status',  dataIndex: 'status_text', flex: 1} ,
    		{ header: 'Jumlah Alokasi',  dataIndex: 'amount', flex: 1} ,
    		{
				xtype : 'templatecolumn',
				text : "Tujuan Alokasi",
				flex : 3,
				tpl : 'Batch: <br /><b>{batch_instance_name}</b>' + '<br />' + '<br />' +
						'Total Tersedia: <b>{batch_instance_total_allocated_amount}</b>' + '<br />' + '<br />' +
							'Yg belum digunakan:  <b>{batch_instance_amount}</b>'   
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


		this.tbar = [this.addObjectButton,   this.deleteObjectButton ]; 
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
		this.setTitle("BatchSource: " + record.get("code"));
	}
});
