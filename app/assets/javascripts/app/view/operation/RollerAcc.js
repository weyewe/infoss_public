Ext.define('AM.view.operation.RollerAcc', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.rolleraccProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'rolleracclist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'rolleraccdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});