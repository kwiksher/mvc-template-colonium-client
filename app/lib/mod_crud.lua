-- Sample code is licensed under the MIT License, the same license that Lua is licensed under:
-- Copyright © 2011-2015 Kwiksher LLP.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
------------------------------------------------------------
------------------------------------------------------------
local _M = {}
----------------------------------------------------------------------------------
-- CORONIUM: Initialize
----------------------------------------------------------------------------------
local json     = require( "json" )
local coronium = _G.coronium

_M.listener = nil
----------------------------------------------------------------------------------
--  requests from lua as same as ajax request in backbone's sync func
--    contacts:create
--    contacts:1:read
--    contacts:1:	date
--    contacts:1:delete
----------------------------------------------------------------------------------
local function _create(field, data, listener)
	coronium:run("mongo",
		{type="message", data = data, action=field..":create"}, listener)
end

local index = 1

local function _read(field, data, listener)
	coronium:run( "mongo",
		{type="message", data = data, action=field..":"..index..":read"}, listener)
end

local function _update(field, data, listener)
	coronium:run( "mongo",
		{type="message", data = data, action=field..":"..index..":update"}, listener)
end

local function _delete(field, data, listener)
	coronium:run( "mongo",
		{type="message", data = data, action=field..":"..index..":delete"}, listener)
end

local function _uplodaFile(fileMetaTable, listener)
	-- local fileMetaTable = { filename = "image.png", baseDir = system.DocumentsDirectory, destDir = "imgs" }
	-- local function onFileUpload( event )
	--   if not event.error then
	--     print( event.result.objectId )
	--   end
	-- end

	--File is uploading...
	local function onFileProgress( event )
	  print( event.bytesTransferred )
	end

	coronium:uploadFile( fileMetaTable, listener, onFileProgress )
end

local function _removeFile()
end
---------------------------------------------------------------------------------

local tmpl=[[
{{#messages}}
+ {{id}}
* {{_func}}
{{/messages}}
]]

local view_model = {
	 messages = nil,
	_func = nil
}
--------------------------
-- sending each data in messages to coronium
--------------------------
local _funcTable = {}
_funcTable["create"] = _create
_funcTable["read"]   = _read
_funcTable["update"] = _update
_funcTable["delete"] = _delete

_M.run = function (func, data)
	view_model._func = _funcTable[func]
	view_model.messages = data
	local output = lustache:render(tmpl, view_model)
end

_M.create = _create
_M.read   = _read
_M.update = _update
_M.delete = _delete
_M.uploadFile = _uplodaFile
_M.removeFile = _removeFile
return _M


-- tmpl=[[
-- {{#messages}}
-- + {{id}}
-- * {{_func}}
-- {{/messages}}
-- ]]

-- view_model = {
-- 	messages = {}
-- 	_func = function(self)
-- 	  end
-- }
-- --------------------------
-- --
-- --------------------------
-- view_mdodel._func = create
-- view_model.messages = {
-- 	{"id":1,"firstName":"Alice","lastName":"","phoneNumber":""},
-- 	{"id":2,"firstName":"Ben",  "lastName":"","phoneNumber":""},
-- 	{"id":3,"firstName":"Carol","lastName":"","phoneNumber":""},
-- }
-- output = lustache:render(tmpl, view_model)

-------------
-- response
-----------
--[[
{type="message", data = { success= true,
	data = {
		    id = 1,
		    firstName = "Alice",
		    lastName  = "Arten",
		    phoneNumber = "555-0184"
		  }
	  }
}

{type="message", data = { success= true,
	data = {
		success = true,
		data = {
		    total = 3,
		    list = {
					{
					    id= 1,
					    firstName =  "Alice",
					    lastName = "Arten",
					    phoneNumber =  "555-0184"
					},
					{
					    id= 2,
					    firstname = "Ben",
					    lastname = "Berton",
					    phoneNumber = "555-0184"
					},
					{
					    id= 3,
					    firstname = "Carol",
					    lastname = "Carton",
					    phoneNumber = "555-0184"
					}
		    }
		  }
		}
	}
}
--]]

--[[
local crud = require("cloud.crud")
print(string.sub("data:image\/jpeg;base64,12345",24))

]]