Ext.define('AM.view.operation.CashBankAdjustment', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.cashbankadjustmentProcess',
	 
		
		items : [
			{
				xtype : 'cashbankadjustmentlist' ,
				flex : 1 
			} 
		]
});