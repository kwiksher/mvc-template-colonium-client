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
local _Class = {}
local _Class_mt = {__index=_Class}
---------------------
---------------------
local _H = display.contentHeight
local _W = display.contentWidth
local json     = require("json")
local Item     = require("view.item")
---------------------
---------------------
local data =  [[{
  "family_name":"yamamoto",
  "given_name":"naoya",
  "email":"support@kwiksher.com",
  "password":"12345678",
  "fb_id":"",
  }
]]

local dataTable = json.decode(data)

local function _familyName(self, tmplt)
  local text = self.data.family_name
  local obj = display.newText( text, 0, 0, native.systemFont, 24)
  obj.x   = tmplt.x
  obj.y   = tmplt.y
  obj:setFillColor( 0 )
  return obj
end

local function _givenName(self, tmplt)
  local text = self.data.given_name
  local obj = display.newText( text, 0, 0, native.systemFont, 24)
  obj.x   = tmplt.x
  obj.y   = tmplt.y
  obj:setFillColor( 0 )
  return obj
end

local function _email(self, tmplt)
  local text = self.data.email
  local obj = display.newText( text, 0, 0, native.systemFont, 24)
  obj.x   = tmplt.x
  obj.y   = tmplt.y
  obj:setFillColor( 0 )
  return obj
end

local function _password(self, tmplt)
  local text = self.data.password
  local obj = display.newText( text, 0, 0, native.systemFont, 24)
  obj.x   = tmplt.x
  obj.y   = tmplt.y
  obj:setFillColor( 0 )
  return obj
end

local function _facebookID(self, tmplt)
  local text = self.data.fb_id
  local obj = display.newText( text, 0, 0, native.systemFont, 24)
  obj.x   = tmplt.x
  obj.y   = tmplt.y
  obj:setFillColor( 0 )
  return obj
end
--------------------
-- APIs
---------------------
_Class.new = function(data)
	local this = Item.new(data)
  return setmetatable( this, _Class_mt)
end
	--
function _Class:familyName (tmplt)
  tmplt.alpha = 0
	return _familyName(self, tmplt)
end

function _Class:givenName(tmplt)
  tmplt.alpha = 0
    return _givenName(self, tmplt)
end

function _Class:email(tmplt)
  tmplt.alpha = 0
  return _email(self, tmplt)
end

function _Class:password(tmplt)
  tmplt.alpha = 0
  return _password(self, tmplt)
end

function _Class:facebookID(tmplt)
  tmplt.alpha = 0
  return _facebookID(self, tmplt)
end
--
return _Class