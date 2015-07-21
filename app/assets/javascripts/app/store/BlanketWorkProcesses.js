Ext.define('AM.store.BlanketWorkProcesses', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.BlanketWorkProcess'],
  	model: 'AM.model.BlanketWorkProcess',
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
