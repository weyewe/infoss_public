Ext.define('AM.store.CoreBuilders', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.CoreBuilder'],
  	model: 'AM.model.CoreBuilder',
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
