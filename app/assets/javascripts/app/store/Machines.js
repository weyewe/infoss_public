Ext.define('AM.store.Machines', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.Machine'],
  	model: 'AM.model.Machine',
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
