Ext.define('AM.store.BlendingRecipes', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.BlendingRecipe'],
  	model: 'AM.model.BlendingRecipe',
  	// autoLoad: {start: 0, limit: this.pageSize},
		autoLoad : false, 
  	autoSync: false,
	pageSize : 20, 
	
	
		
		
	sorters : [
		{
			property	: 'id',
			direction	: 'DESC'
		}
	], 

	listeners: {

	} 
});
