Ext.define('AM.store.Templates', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.Template'],
  	model: 'AM.model.Template',
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
