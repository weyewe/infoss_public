Ext.define('AM.view.operation.SalesOrder', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.salesorderProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'salesorderlist' ,
				flex : 3 //,
				// html : 'hahaha'
			},
			{
				xtype :'salesorderdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 2
			} 
		],
 
});