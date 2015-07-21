Ext.define('AM.view.master.employee.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.employeelist',

  	store: 'Employees', 
 

	initComponent: function() {
		this.columns = [
			{ header: 'ID', dataIndex: 'id'}, 
			{
				xtype : 'templatecolumn',
				text : "Pegawai",
				flex : 1,
				tpl : 'Nama: <b>{name}</b>' + '<br />'  + 
						'Contact No: <b>{contact_no}</b>' + '<br />'  + 
						'Email: {email}' + '<br />'  + '<br />'  +
						'<b>Deskripsi</b>: <br />{description}' + '<br />'  +  '<br />'  +
						'<b>Alamat</b>: <br />{address}' + '<br />'  + '<br />' 
						 
								
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
