Ext.define('AM.view.operation.Closing', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.closingProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'closinglist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'closingdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});