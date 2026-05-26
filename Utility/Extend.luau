return function<object, attach>(obj: object, objOrInstance: attach): object & attach
	local cache = {}

	local mt = {}
	mt.__index = function(_, key)
		-- Prefer table methods
		local v = rawget(obj, key)
		
		if v ~= nil then
			return v
		end

		-- Bind instance methods safely
		local instValue = objOrInstance[key]
		
		if type(instValue) == "function" then
			return function(_, ...)
				return instValue(objOrInstance, ...)
			end
		end

		return instValue
	end
	
	mt.__tostring = function()
		return tostring(objOrInstance)
	end

	return setmetatable(obj, mt) :: object & attach
end
