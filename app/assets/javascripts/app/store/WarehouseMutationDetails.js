Ext.define('AM.store.WarehouseMutationDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.WarehouseMutationDetail'],
  	model: 'AM.model.WarehouseMutationDetail',
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
