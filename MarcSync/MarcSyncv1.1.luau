local tokens = {
	["DataToken"] = "eyJhbGciOiJIUzI1NiIsInR5cCI6Im1hcmNzeW5jQWNjZXNzIn0.eyJkYXRhYmFzZUlkIjoiOTUyNDA1YTctNjcyNi00MTZhLWFhOTAtZDA4OWFkNzFkMTYyIiwidXNlcklkIjoiNDliNWZjOTItMTIwNi00YjQ4LWExYjktMTMzNDdkZTM2ODY5IiwidG9rZW5JZCI6IjY5M2EzMDYxMTgwZTkwMjExMmU5NDE5NyIsIm5iZiI6MTc2NTQyMTE1MywiZXhwIjo4ODE2NTMzNDc1MywiaWF0IjoxNzY1NDIxMTUzLCJpc3MiOiJtYXJjc3luYyJ9.lmrtoqpYoUDfGPMyLqJUQV0BAGBtTw55ZrUg4ywLKDE"
}

local HttpService = game:GetService("HttpService")

local function InitTypes()
	local types = {}

	type EntryData = {
		[string]: any
	}

	type ClientOptions = {
		retryCount: number
	}

	types.EntryData = {} :: EntryData
	types.ClientOptions = {} :: ClientOptions

	return types
end
local Types = InitTypes()

local function InitAuthorizationError()
	return {
		InvalidAccessToken = function(message: string):string
			return ("[MarcSync Exception] InvalidAccessToken: %s"):format(message)
		end
	}
end
local AuthorizationError = InitAuthorizationError()

local function InitCollectionError()
	return {
		CollectionNotFound = function(message: string):string
			return ("[MarcSync Exception] CollectionNotFound: %s"):format(message)
		end,
		CollectionAlreadyExists = function(message: string):string
			return ("[MarcSync Exception] CollectionAlreadyExists: %s"):format(message)
		end
	}
end
local CollectionError = InitCollectionError()

local function InitEntryError()
	return {
		InvalidEntryData = function(message: string):string
			return ("[MarcSync Exception] InvalidEntryData: %s"):format(message)
		end,
		EntryNotFound = function(message: string):string
			return ("[MarcSync Exception] EntryNotFound: %s"):format(message)
		end
	}
end
local EntryError = InitEntryError()

local function InitUtils()
	local utils = {}

	function errorHandler(callInformation: {}, resultBody: any, resultObject: {}, retryCount: number)
		local Error;
		if typeof(resultBody) == typeof({}) and resultBody["message"] then
			Error = resultBody["message"]
		elseif typeof(resultBody) == typeof("") then
			Error = resultBody
		else
			Error = "An Unexpected Error occoured."
		end

		local statusCode = resultObject["StatusCode"]
		if callInformation.type == "collection" then
			if statusCode == 401 then
				Error = AuthorizationError.InvalidAccessToken("InvalidAccessToken")
			elseif statusCode == 404 then
				Error = CollectionError.CollectionNotFound("CollectionNotFound")
			elseif statusCode == 400 then
				Error = CollectionError.CollectionAlreadyExists("CollectionAlreadyExists")
			end
		elseif callInformation.type == "entry" then
			if statusCode == 401 then
				Error = AuthorizationError.InvalidAccessToken("InvalidAccessToken")
			elseif statusCode == 404 then
				Error = CollectionError.CollectionNotFound("CollectionNotFound")
			elseif statusCode == 400 then
				Error = EntryError.InvalidEntryData("InvalidEntryData")
			end
		end

		if(statusCode ~= 400 and statusCode ~= 401) then
			if retryCount > 0 then
				warn("[MarcSync HTTPRequest Handler] MarcSync HTTP Request failed with error: "..Error.." and status code: "..statusCode..". Retrying Request. ("..retryCount..") retries left")
				task.wait(3)
				return utils.makeHTTPRequest(callInformation.type, callInformation.method, callInformation.url, callInformation.body, callInformation.authorization, {retryCount = retryCount - 1})
			end
		end

		return {["success"] = false, ["errorMessage"] = Error}
	end

	function utils.makeHTTPRequest(type: string, method: string, url: string, body: {}, authorization: string, options: Types.ClientOptions):{["success"]: boolean, ["message"]: string}
		local resultObj;
		local resultBody;
		
		local success = pcall(function()
			if body then body = HttpService:JSONEncode(body) end
			
			if (method == "GET" or method == "HEAD") then
				resultObj = (syn and syn.request or http_request){Method=method,Url=url,Headers={["Authorization"]=authorization,["Content-Type"]="application/json"}}
							
				resultBody = HttpService:JSONDecode(resultObj["Body"])
			else
				resultObj = (syn and syn.request or http_request){Method=method, Url=url, Headers={["Authorization"]=authorization,["Content-Type"]="application/json"}, Body=body}
				resultBody = HttpService:JSONDecode(resultObj["Body"])
			end
		end)
		
		if success and resultBody and resultBody["success"] then
			if resultBody["warning"] then warn('[MarcSync HTTPRequest Handler] MarcSync HTTP Request returned warning for URL "'..url..'" with body: "'..HttpService:JSONEncode(body)..'": '..resultBody["warning"]) end
			return resultBody
		end
		
		return errorHandler({
			type = type,
			method = method,
			url = url,
			body = body,
			authorization = authorization
		}, resultBody, resultObj, options.retryCount)
	end

	return utils
end
local Utils = InitUtils()

local function InitEntry()
	local Entry = {}

	Entry.getValue = function(self:typeof(Entry), key:string):any
		if not key then return nil end
		return self._entryData[key]
	end

	Entry.getValues = function(self:typeof(Entry)):Types.EntryData
		return self._entryData
	end

	Entry.updateValues = function(self:typeof(Entry), data:Types.EntryData):number
		local result = Utils.makeHTTPRequest("entry", "PUT", "https://api.marcsync.dev/v0/entries/"..self._tableId, {["filters"]={["_id"]=self._objectId},["data"]=data}, self._accessToken, self._options);
		
		if result["success"] and result["modifiedEntries"] and result["modifiedEntries"] > 0 then
			for i,v in pairs(data) do
				self._entryData[i] = v
			end
		elseif not result["success"] then
			error(result["errorMessage"])
		end

		return result["modifiedEntries"]
	end

	Entry.delete = function(self:typeof(Entry))
		if typeof(self) ~= "table" then error("Please use : instead of .") end
		local result = Utils.makeHTTPRequest("entry", "DELETE", "https://api.marcsync.dev/v0/entries/"..self._tableId, {["filters"]={["_id"]=self._objectId}}, self._accessToken, self._options);
		
		if not result["success"] then error(result["errorMessage"]) end
		self = nil

	end

	return {
		new = function(tableId:string, entryData:Types.EntryData, accessToken:string, options: Types.ClientOptions):typeof(Entry)
			if not tableId or not entryData or not entryData["_id"] or not accessToken then error("[MarcSync: Entry] Tried creating invalid Entry Object.") end
			local self = {}
			self._tableId = tableId
			self._entryData = entryData
			self._objectId = entryData["_id"]
			self._accessToken = accessToken
			self._options = options

			self = setmetatable(self, {
				__index = Entry
			})

			return self
		end
	}
end
local Entry = InitEntry()

local function InitCollection()
	local Collection = {}

	Collection.createEntry = function(self:typeof(Collection), data:Types.EntryData):typeof(Entry.new())
		if not self._collectionName then error("[MarcSync: Collection] Invalid Object created or trying to access an destroied object.") end
		local result = Utils.makeHTTPRequest("entry", "POST", "https://api.marcsync.dev/v0/entries/"..self._collectionName, {["data"]=data}, self._accessToken, self._options);
		
		if result["success"] and result["objectId"] then
			data["_id"] = result["objectId"]
			result = Entry.new(self._collectionName, data, self._accessToken, self._options)
		else
			error(result["errorMessage"])
		end

		return result
	end

	Collection.updateEntries = function(self:typeof(Collection), filters:Types.EntryData, data:Types.EntryData):number
		if not self._collectionName then error("[MarcSync: Collection] Invalid Object created or trying to access an destroied object.") end
		local result = 	Utils.makeHTTPRequest("entry", "PUT", "https://api.marcsync.dev/v0/entries/"..self._collectionName, {["filters"]=filters,["data"]=data}, self._accessToken, self._options);
		if not result["success"] then error(result["errorMessage"]) end

		return result["modifiedEntries"]
	end

	Collection.getEntries = function(self:typeof(Collection), filters:Types.EntryData):{[number]:typeof(Entry.new())}
		if not self._collectionName then error("[MarcSync: Collection] Invalid Object created or trying to access an destroied object.") end
		if not filters then filters = {} end
		local result = Utils.makeHTTPRequest("entry", "DELETE", "https://api.marcsync.dev/v0/entries/"..self._collectionName.."?isQuery=true", {["filters"]=filters}, self._accessToken, self._options);
		if result["success"] and result["entries"] then
			local _result = {}
			for index,entry in pairs(result["entries"]) do
				_result[index] = Entry.new(self._collectionName, entry, self._accessToken, self._options)
			end
			result = _result
		else
			error(result["errorMessage"])
		end

		return result
	end

	Collection.deleteEntries = function(self:typeof(Collection), filters:Types.EntryData):number
		if not self._collectionName then error("[MarcSync: Collection] Invalid Object created or trying to access an destroied object.") end
		local result = Utils.makeHTTPRequest("DELETE", "https://api.marcsync.dev/v0/entries/"..self._collectionName, {["filters"]=filters}, self._accessToken, self._options);
		if not result["success"] then error(result["errorMessage"]) end

		return result["deletedEntries"]
	end

	Collection.drop = function(self:typeof(Collection))
		if not self._collectionName then error("[MarcSync: Collection] Invalid Object created or trying to access an destroied object.") end
		local result = Utils.makeHTTPRequest("collection", "DELETE", "https://api.marcsync.dev/v0/collection/"..self._collectionName, {}, self._accessToken, self._options);
		if not result["success"] then error(result["errorMessage"]) end
		self = nil
	end

	return {
		new = function(collectionName: string, accessToken: string, options: Types.ClientOptions):typeof(Collection)
			local self = {}
			self._collectionName = collectionName
			self._accessToken = accessToken
			self._options = options

			self = setmetatable(self, {
				__index = Collection
			})

			return self
		end
	}
end
local Collection = InitCollection()

-- DO NOT EDIT THE FOLLOWING LINES BELOW, UNLESS YOU KNOW WHAT YOU ARE DOING!

local MarcSyncClient = {}

MarcSyncClient.getVersion = function(self:typeof(MarcSyncClient), clientId: number?):string
	self:_checkInstallation()
	local url = ""
	if clientId then url = "/"..clientId end
	local result = Utils.makeHTTPRequest("", "GET", "https://api.marcsync.dev/v0/utils/version"..url, nil, nil, self._options);
	return result["version"]
end

MarcSyncClient.createCollection = function(self:typeof(MarcSyncClient), collectionName: string):typeof(Collection.new())
	if not self._accessToken then error("[MarcSync] Please set a Token before using MarcSync.") end
	if not collectionName then error("No CollectionName Provided") end
	local result = Utils.makeHTTPRequest("collection", "POST", "https://api.marcsync.dev/v0/collection/"..collectionName, {}, self._accessToken, self._options);

	if not result["success"] then error(result["errorMessage"]) end
	result = Collection.new(collectionName, self._accessToken, self._options)

	return result
end
MarcSyncClient.fetchCollection = function(self:typeof(MarcSyncClient), collectionName: string):typeof(Collection.new())
	self:_checkInstallation()
	if not collectionName then error("No CollectionName Provided") end
	local result = Utils.makeHTTPRequest("collection", "GET", "https://api.marcsync.dev/v0/collection/"..collectionName, {}, self._accessToken, self._options);
	
	if not result["success"] then error(result["errorMessage"]) end
	result = Collection.new(collectionName, self._accessToken, self._options)

	return result
end
MarcSyncClient.getCollection = function(self:typeof(MarcSyncClient), collectionName: string):typeof(Collection.new())
	if typeof(self) ~= "table" then error("Please use : instead of .") end
	self:_checkInstallation()
	if not collectionName then error("No CollectionName Provided") end
	return Collection.new(collectionName, self._accessToken, self._options)
end

return {
	new = function(accessToken: string, options: Types.ClientOptions?):typeof(MarcSyncClient)
		if not accessToken then warn("Token not provided while creating a new MarcSync Object.") end
		if not tokens[accessToken] then warn("Token provided for creating a new MarcSync Object not Found in Token Table, using it as token instead.") else accessToken = tokens[accessToken] end
		local self = {}
		self._accessToken = accessToken
		self._options = options or {retryCount = 3}
		self._checkInstallation = function()
			if not self then error("Please Setup MarcSync before using MarcSync.") end
			if not self._accessToken then error("[MarcSync] Please set a Token before using MarcSync.") end
		end

		self = setmetatable(self, {
			__index = MarcSyncClient
		})

		return self
	end
}
