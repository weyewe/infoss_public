Ext.define('AM.store.Tables', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.Table'],
  	model: 'AM.model.Table',
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
