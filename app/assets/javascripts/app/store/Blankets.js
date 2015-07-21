Ext.define('AM.store.Blankets', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.Blanket'],
  	model: 'AM.model.Blanket',
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
