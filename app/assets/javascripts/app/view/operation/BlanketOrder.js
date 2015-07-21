Ext.define('AM.view.operation.BlanketOrder', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.blanketorderProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'blanketorderlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'blanketorderdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});