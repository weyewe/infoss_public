Ext.define('AM.view.operation.RollerIdentificationForm', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.rolleridentificationformProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'rolleridentificationformlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'rolleridentificationformdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});