Ext.define('AM.store.BlanketWarehouseMutationDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.BlanketWarehouseMutationDetail'],
  	model: 'AM.model.BlanketWarehouseMutationDetail',
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
