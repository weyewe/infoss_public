Ext.define('AM.store.RollerBuilders', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.RollerBuilder'],
  	model: 'AM.model.RollerBuilder',
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
