Ext.define('AM.view.template.Template', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.templateProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'templatelist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'templatedetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});