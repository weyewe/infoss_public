Ext.define('AM.store.Awesomes', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.Awesome'],
  	model: 'AM.model.Awesome',
  	// autoLoad: {start: 0, limit: this.pageSize},
		autoLoad : false, 
  	autoSync: false,
	pageSize : 40, 
	
	
		
		
	sorters : [
		{
			property	: 'id',
			direction	: 'DESC'
		}
	], 

	listeners: {

	} 
});
