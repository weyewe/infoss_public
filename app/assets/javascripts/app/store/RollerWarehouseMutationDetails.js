Ext.define('AM.store.RollerWarehouseMutationDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.RollerWarehouseMutationDetail'],
  	model: 'AM.model.RollerWarehouseMutationDetail',
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
