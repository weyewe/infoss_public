Ext.define('AM.view.operation.StockAdjustment', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.stockadjustmentProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'stockadjustmentlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'stockadjustmentdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});