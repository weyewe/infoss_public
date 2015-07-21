Ext.define('AM.store.BatchSourceDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.BatchSourceDetail'],
  	model: 'AM.model.BatchSourceDetail',
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
