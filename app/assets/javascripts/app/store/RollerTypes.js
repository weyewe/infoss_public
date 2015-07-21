Ext.define('AM.store.RollerTypes', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.RollerType'],
  	model: 'AM.model.RollerType',
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
