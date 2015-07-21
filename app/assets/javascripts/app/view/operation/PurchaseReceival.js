Ext.define('AM.view.operation.PurchaseReceival', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.purchasereceivalProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'purchasereceivallist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'purchasereceivaldetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});