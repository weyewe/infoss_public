Ext.define('AM.store.ContactGroups', {
	extend: 'Ext.data.Store',
	require : ['AM.model.ContactGroup'],
	model: 'AM.model.ContactGroup',
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
