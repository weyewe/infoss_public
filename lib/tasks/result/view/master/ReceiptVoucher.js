Ext.define('AM.view.master.ReceiptVoucher', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.receiptvoucherProcess',
	 
		
		items : [
			{
				xtype : 'receiptvoucherlist' ,
				flex : 1 
			} 
		]
});