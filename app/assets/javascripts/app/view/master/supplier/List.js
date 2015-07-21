Ext.define('AM.view.master.supplier.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.supplierlist',

  	store: 'Suppliers', 
 

	initComponent: function() {
		this.columns = [
			{ header: 'ID', dataIndex: 'id'}, 
			{
				xtype : 'templatecolumn',
				text : "Badan Usaha",
				flex : 1,
				tpl : 'Badan Usaha: <b>{name}</b>' + '<br />'  + 
						'Contact No: <b>{contact_no}</b>' + '<br />'  + '<br />'  +
						'<b>Deskripsi</b>: <br />{description}' + '<br />'  +  '<br />'  +
						'<b>Alamat</b>: <br />{address}' + '<br />'  + '<br />'  +
						'<b>Alamat Pengiriman</b>: <br />{delivery_address}' + '<br />'  + '<br />'  +
						
						'Payment Term: {default_payment_term}' + '<br />'   
								
			},
			
			{
				xtype : 'templatecolumn',
				text : "Tax Info",
				flex : 1,
				tpl : 'NPWP: <b>{npwp}</b>' + '<br />'  + 
								'Wajib Pajak: <b>{is_taxable}</b>' + '<br />'  +
								'Code Tax: {tax_code}' + '<br />'  +
								'Nama faktur pajak: <br /> {nama_faktur_pajak}'     
			},
			{
				xtype : 'templatecolumn',
				text : "Contact Person",
				flex : 1,
				tpl : 'PIC: <b>{pic}</b>' + '<br />'  + 
								'Contact No: <b>{pic_contact_no}</b>' + '<br />'  +
								'Email: <br /> {email}' 
			},
			
			 { header: 'ContactGroup', dataIndex: 'contact_group_name'}, 
		];

		this.addObjectButton = new Ext.Button({
			text: 'Add ',
			action: 'addObject'
		});

		this.editObjectButton = new Ext.Button({
			text: 'Edit ',
			action: 'editObject',
			disabled: true
		});

		this.deleteObjectButton = new Ext.Button({
			text: 'Delete ',
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



		this.tbar = [this.addObjectButton, this.editObjectButton, this.deleteObjectButton, this.searchField ];
		this.bbar = Ext.create("Ext.PagingToolbar", {
			store	: this.store, 
			displayInfo: true,
			displayMsg: 'Displaying  {0} - {1} of {2}',
			emptyMsg: "N/Ay" 
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
	},

	disableRecordButtons: function() {
		this.editObjectButton.disable();
		this.deleteObjectButton.disable();
	}
});
