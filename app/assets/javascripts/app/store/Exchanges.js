Ext.define('AM.store.Exchanges', {
	extend: 'Ext.data.Store',
	require : ['AM.model.Exchange'],
	model: 'AM.model.Exchange',
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
