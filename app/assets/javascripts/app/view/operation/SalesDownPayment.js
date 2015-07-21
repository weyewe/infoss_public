Ext.define('AM.view.operation.SalesDownPayment', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.salesdownpaymentProcess',
	 
		
		items : [
			{
				xtype : 'salesdownpaymentlist' ,
				flex : 1 
			} 
		]
});