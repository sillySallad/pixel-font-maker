setmetatable(_G, {
	__index = function(g, k)
		error(string.format("get _G.%s", k))
	end,
	__newindex = function(g, k, v)
		error(string.format("set _G.%s = %s", k, v))
	end,
})
