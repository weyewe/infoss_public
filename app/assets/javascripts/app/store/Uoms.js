Ext.define('AM.store.Uoms', {
	extend: 'Ext.data.Store',
	require : ['AM.model.Uom'],
	model: 'AM.model.Uom',
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
