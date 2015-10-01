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
-----------------------------
-----------------------------
-- defined in testcase/unittest.lua
-- local evtList = {
-- 	{name = "mod_user", API="addUser", page="view.page.mod_user"}}
--
-- view/page/testcases.lua exexfutes the following function when you tap the row entry
-- _G.Router:dispatchEvent({name="mod_user"}, "addUser", "page.mod_user", params)
-----------------------------
-----------------------------
local composer = require( "composer" )
local coronium = require("extlib.mod_coronium")
local userModel = require("model.user")
local listener = {}
-----------------------------
-----------------------------
listener.mod_user = function(event, ...)
	local API, page = ...
	print(API..":"..page)
	_M[API](page)
end
-----------------------------
-- Add API functions here
-----------------------------
_M.addUser = function(page)
  local user = userModel.create("test1@kwiksher.com", "12345678", "yamamoto", "naoya")
	coronium:registerUser( user, function(ret)
		table.print(ret)
		  composer.gotoScene(page, {params =	{ API = "addUser", model = user, result = ret.result, error = ret.error}})
	end)
end
-----------------------------
-----------------------------
_G.Router:addEventListener("mod_user", listener)
return _M