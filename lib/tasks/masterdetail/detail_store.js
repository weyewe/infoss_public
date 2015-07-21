Ext.define('AM.store.TemplateDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.TemplateDetail'],
  	model: 'AM.model.TemplateDetail',
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
