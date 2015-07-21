Ext.define('AM.store.BlanketResultDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.BlanketResultDetail'],
  	model: 'AM.model.BlanketResultDetail',
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
