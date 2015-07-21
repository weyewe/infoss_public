Ext.define('AM.store.WarehouseMutations', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.WarehouseMutation'],
  	model: 'AM.model.WarehouseMutation',
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
