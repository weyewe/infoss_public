Ext.define('AM.view.operation.HomeAssignment', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.homeassignmentProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'homeassignmentlist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'homeassignmentdetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});