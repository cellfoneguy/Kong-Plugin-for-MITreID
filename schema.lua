return{
	no_consumer = true,
	fields = {
		bar = {type = "string", required = true}
	},
	self_check = function(schema, plugin_t, dao, is_updating)
		return true
	end
}