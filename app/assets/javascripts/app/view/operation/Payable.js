Ext.define('AM.view.operation.Payable', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.payableProcess',
	 
		
		items : [
			{
				xtype : 'payablelist' ,
				flex : 1 
			} 
		]
});