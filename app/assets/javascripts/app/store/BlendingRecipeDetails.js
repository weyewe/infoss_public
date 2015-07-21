Ext.define('AM.store.BlendingRecipeDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.BlendingRecipeDetail'],
  	model: 'AM.model.BlendingRecipeDetail',
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
