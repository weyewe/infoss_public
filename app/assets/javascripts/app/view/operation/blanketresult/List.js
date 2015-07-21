Ext.define('AM.view.operation.blanketresult.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.blanketresultlist',

  	store: 'BlanketResults',  
 

	initComponent: function() {
		this.columns = [
			// { header: 'ID', dataIndex: 'id'},
			{
					xtype : 'templatecolumn',
					text : "Blanket Info",
					flex : 3,
					tpl : 	'Blanket SKU:  <br /><b>{blanket_sku}</b>'    + '<br />' +
								'Nama: <br /><b>{blanket_name}</b>'  + '<br />' + '<br />' +
								
							'Roll Blanket SKU:  <br /><b>{blanket_roll_blanket_item_sku}</b>'    + '<br />' +
								'{blanket_roll_blanket_item_name}'  + '<br />' + '<br />' +	
								
							'LeftBar SKU:  <br /><b>{blanket_left_bar_item_sku}</b>'    + '<br />' +
								'{blanket_left_bar_item_name}'  + '<br />' + '<br />' +
								
							'RightBar SKU:  <br /><b>{blanket_right_bar_item_sku}</b>'    + '<br />' +
								'<b>{blanket_right_bar_item_name}'  
				},
				{ header: 'Scheduled Qty', dataIndex: 'quantity', flex: 1},
				{
					xtype : 'templatecolumn',
					text : "Status Selesai",
					flex : 3,
					tpl : 	'Selesai: <br />  <b>{is_finished}</b>'  + '<br />' + '<br />' +
								'Tanggal: <br />  <b>{finished_at}</b>'   
					 
				},
				{
					xtype : 'templatecolumn',
					text : "Hasil",
					flex : 3,
					tpl : 		'Quantity Finish: <b>{finished_quantity}</b>' + '<br />' + '<br />' +
								'Quantity Reject: <b>{rejected_quantity}</b>' + '<br />' + '<br />' +
								
								'Penggunaan Roll Blanket: <br /> <b>{roll_blanket_usage}</b>' + '<br />' + '<br />' +
								'Defect Roll Blanket: <br /><b>{roll_blanket_defect}</b>'  
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
	
		this.unfinishObjectButton = new Ext.Button({
			text: 'Unfinish',
			action: 'unfinishObject',
			disabled: true,
			hidden : true
		});
		
		 
			this.tbar = [ this.finishObjectButton, this.unfinishObjectButton ,
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
		
		if( selectedObject && selectedObject.get("is_finished") == true ){
			 this.finishObjectButton.hide() 
			 this.unfinishObjectButton.show() ;
		 
			this.unfinishObjectButton.enable();
		}else{
			this.finishObjectButton.show() 
			 this.unfinishObjectButton.hide() ;
		 
			this.finishObjectButton.enable();
		}
	},

	disableRecordButtons: function() {
		this.editObjectButton.disable();
		this.deleteObjectButton.disable();
		this.confirmObjectButton.disable(); 
		this.finishObjectButton.disable();
		this.unfinishObjectButton.disable();
	}
});
