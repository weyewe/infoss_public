Ext.define('AM.view.master.BlendingRecipe', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.blendingrecipeProcess',
	 
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		header: false, 
		headerAsText : false,
		selectedParentId : null,
		
		
		items : [
			{
				xtype : 'blendingrecipelist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'blendingrecipedetaillist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
 
});