Ext.define('AM.store.BlanketWarehouseMutations', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.BlanketWarehouseMutation'],
  	model: 'AM.model.BlanketWarehouseMutation',
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
