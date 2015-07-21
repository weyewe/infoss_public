Ext.define('AM.view.operation.paymentvoucherdetail.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.paymentvoucherdetaillist',

  	store: 'PaymentVoucherDetails', 
 

	initComponent: function() {
		this.columns = [
		 
			{ header: 'Payable Code',  dataIndex: 'payable_source_code', flex: 1},
			{ header: 'Currency',  dataIndex: 'payable_exchange_name', flex: 1},
			{ header: 'Amount Paid',  dataIndex: 'amount_paid', flex: 1},
			{ header: 'Rate',  dataIndex: 'rate', flex: 1},
			{ header: 'Actual Amount',  dataIndex: 'amount', flex: 1},
			{ header: 'PPh 23',  dataIndex: 'pph_23', flex: 1},
			{ header: 'PPh 21',  dataIndex: 'pph_21', flex: 1},
			 
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
		this.setTitle("PaymentVoucher: " + record.get("code"));
	}
});
