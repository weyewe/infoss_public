Ext.define('AM.store.SubTypes', {
	extend: 'Ext.data.Store',
	require : ['AM.model.SubType'],
	model: 'AM.model.SubType',
	// autoLoad: {start: 0, limit: this.pageSize},
	autoLoad : false, 
	autoSync: false,
	pageSize : 10, 
	
	sorters : [
		{
			property	: 'id',
			direction	: 'DESC'
		}
	], 
	listeners: {

	} 
});
