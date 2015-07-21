Ext.define('AM.view.master.PaymentVoucher', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.paymentvoucherProcess',
	 
		
		items : [
			{
				xtype : 'paymentvoucherlist' ,
				flex : 1 
			} 
		]
});