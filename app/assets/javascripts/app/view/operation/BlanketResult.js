Ext.define('AM.view.operation.BlanketResult', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.blanketresultProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'blanketresultlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'blanketresultdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});