Ext.define('AM.view.operation.recoveryresult.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.recoveryresultlist',

  	store: 'RecoveryResults',  
 

	initComponent: function() {
		this.columns = [
			// { header: 'ID', dataIndex: 'id'},
 
			{
				xtype : 'templatecolumn',
				text : "Produksi",
				flex : 3,
				tpl : 'RIF ID : <br /><b>{roller_identification_form_detail_id}</b>' + '<br />' + '<br />' +
							'SKU Roller: <br /> <b>{roller_builder_sku}</b>'  + '<br />' + 
							' Nama: {roller_builder_name}'  + '<br />' + '<br />' +
							
							'Core Type: <br /> <b>{core_type_case_text}</b>'   
			},
			
			{
				xtype : 'templatecolumn',
				text : "Material ",
				flex : 3,
				tpl : 'Compound Underlayer : <br /><b>{compound_under_layer_name}</b>' + '<br />' +  
					'Penggunaan Underlayer: <br /> <b>{compound_under_layer_usage}</b>'   + '<br />' + '<br />' +
							
							
							'Compound  : <br /><b>{roller_builder_compound_name}</b>' + '<br />' +  
					'Penggunaan : <br /> <b>{compound_usage}</b>'   
							
							
							
							
			},
			
			{
				xtype : 'templatecolumn',
				text : "Status ",
				flex : 3,
				tpl : 'Finish : <br /><b>{is_finished}</b>' + '<br />' +  
						'Tanggal Finish : <br /><b>{finished_at}</b>' + '<br />' +  '<br />' +  
						
					 'Reject : <br /><b>{is_rejected}</b>' + '<br />' +  
						'Tanggal Reject : <br /><b>{rejected_at}</b>'  
					 
							
							
							
							
			},
			
			
		];

		this.addObjectButton = new Ext.Button({
			text: 'Add',
			action: 'addObject'
		});

		this.processObjectButton = new Ext.Button({
			text: 'Process',
			action: 'processObject',
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
	
		this.unconfirmObjectButton = new Ext.Button({
			text: 'Unconfirm',
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
		
		 
			this.tbar = [ this.processObjectButton, 
				'-',
					this.finishObjectButton, this.unfinishObjectButton, 
					'-',
					this.rejectObjectButton,
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
		this.processObjectButton.enable();  
 
		selectedObject = this.getSelectedObject();
		
		if( selectedObject && selectedObject.get("is_finished") == false  && selectedObject.get("is_rejected") == false ){  
			this.finishObjectButton.show(); 
			this.rejectObjectButton.show();  
			
			this.finishObjectButton.enable(); 
			this.rejectObjectButton.enable();  
		} 
		

		if( selectedObject && selectedObject.get("is_finished") == true  && selectedObject.get("is_rejected") == false ){  
			this.unfinishObjectButton.show(); 
			this.unfinishObjectButton.enable();  
		} 
	},

	disableRecordButtons: function() {
		this.processObjectButton.disable();
		this.finishObjectButton.disable();
		this.rejectObjectButton.disable(); 
		this.unfinishObjectButton.disable(); 
		this.unrejectObjectButton.disable(); 
	}
});
