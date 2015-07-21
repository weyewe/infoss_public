Ext.define('AM.view.operation.VirtualOrder', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.virtualorderProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'virtualorderlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'virtualorderdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});