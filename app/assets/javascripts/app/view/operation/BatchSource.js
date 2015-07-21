Ext.define('AM.view.operation.BatchSource', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.batchsourceProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'batchsourcelist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'batchsourcedetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});