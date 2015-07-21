Ext.define('AM.view.operation.recoveryworkprocess.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.recoveryworkprocesslist',

  	store: 'RecoveryWorkProcesss',  
 

	initComponent: function() {
		this.columns = [
			// { header: 'ID', dataIndex: 'id'},
			{ header: 'RIF Id', dataIndex: 'roller_identification_form_detail_id', flex: 1},
			{ header: 'Sku Roller',  dataIndex: 'roller_builder_sku', flex: 1},
    		{ header: 'Roller',  dataIndex: 'roller_builder_name', flex: 1},
    		{ header: 'Core Type',  dataIndex: 'core_type_case_text', flex: 2},
    		{ header: 'Rejected Date',  dataIndex: 'rejected_date', flex: 2},
    		{ header: 'Finished Date',  dataIndex: 'finished_date', flex: 2},
			
		];

		this.addObjectButton = new Ext.Button({
			text: 'Add',
			action: 'addObject'
		});

		this.editObjectButton = new Ext.Button({
			text: 'Process',
			action: 'editObject',
			disabled: true
		});

		this.deleteObjectButton = new Ext.Button({
			text: 'Delete',
			action: 'deleteObject',
			disabled: true
		});
		
		this.confirmObjectButton = new Ext.Button({
			text: 'Confirm',
			action: 'confirmObject',
			disabled: true
		});
		
		this.finishObjectButton = new Ext.Button({
			text: 'Finish',
			action: 'finishObject',
			disabled: true
		});
		
		this.rejectObjectButton = new Ext.Button({
			text: 'Reject',
			action: 'rejectObject',
			disabled: true
		});
		
		this.unconfirmObjectButton = new Ext.Button({
			text: 'Unconfirm',
			action: 'unconfirmObject',
			disabled: true,
			hidden : true
		});
		
		this.unfinishObjectButton = new Ext.Button({
			text: 'Unfinisih',
			action: 'unfinishObject',
			disabled: true,
			hidden : true
		});
		
		this.unrejectObjectButton = new Ext.Button({
			text: 'Unreject',
			action: 'unrejectObject',
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
		
		 
			this.tbar = [ this.editObjectButton, 
				'-',
					this.finishObjectButton, this.rejectObjectButton,this.unfinishObjectButton,
					this.unrejectObjectButton,
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
