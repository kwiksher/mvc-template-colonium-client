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
---------------------
--
---------------------
local _H = display.contentHeight
local _W = display.contentWidth
local Item     = require("view.item")
---------------------
--
---------------------
local data =  [[{
  "family_name":"yamamoto",
  "given_name":"naoya",
  "email":"support@kwiksher.com",
  "password":"12345678",
  "fb_id":"",
  }
]]

local function fieldHandler( textField )
  return function( event )
    if ( "began" == event.phase ) then
      -- This is the "keyboard has appeared" event
      -- In some cases you may want to adjust the interface when the keyboard appears.
    elseif ( "ended" == event.phase ) then
      -- This event is called when the user stops editing a field: for example, when they touch a different field
      print( textField().text )
    elseif ( "editing" == event.phase ) then
    elseif ( "submitted" == event.phase ) then
      -- This event occurs when the user presses the "return" key (if available) on the onscreen keyboard
      print( textField().text )
      -- Hide keyboard
      native.setKeyboardFocus( nil )
    end
  end
end

local function _familyName(self, tmpls)
  local text = self.data.family_name
  local obj = display.newTextField(0, 0, tmpls.width, tmpls.height)
  obj.x   = tmpls.x
  obj.y   = tmpls.y
  obj:addEventListener( "userInput", fieldHandler( function() return obj end ) )
  self.fields["family_name"] = obj
  return obj
end

local function _givenName(self, tmpls)
  local text = self.data.given_name
  local obj = display.newTextField(0, 0, tmpls.width, tmpls.height)
  obj.x   = tmpls.x
  obj.y   = tmpls.y
  obj:addEventListener( "userInput", fieldHandler( function() return obj end ) )
  self.fields["given_name"]  = obj
  return obj
end

local function _email(self, tmpls)
  local text = self.data.email
  local obj = display.newTextField(0, 0, tmpls.width, tmpls.height)
  obj.x   = tmpls.x
  obj.y   = tmpls.y
  obj.inputType = "email"
  obj:addEventListener( "userInput", fieldHandler( function() return obj end ) )
  obj.fields["email"] = obj
  return obj
end

local function _password(self, tmpls)
  local text = self.data.password
  local obj = display.newTextField(0, 0, tmpls.width, tmpls.height)
  obj.x   = tmpls.x
  obj.y   = tmpls.y
  obj.isSecure = true
  obj:addEventListener( "userInput", fieldHandler( function() return obj end ) )
  obj.fields["password"] = obj
  return obj
end

local function _facebookID(self, tmpls)
  local text = self.data.fb_id
  local obj = display.newTextField(0, 0, tmpls.width, tmpls.height)
  obj.x   = tmpls.x
  obj.y   = tmpls.y
  obj:addEventListener( "userInput", fieldHandler( function() return obj end ) )
  obj.fields["fb_id"] = obj
  return obj
end
--------------------
-- API
---------------------
Class.new = function(data)
  local this = Item.new(data)
  this.params = data
  this.fields = {}
  --
  this.familyName = function(self, tmpls)
    return _familyName(self, tmpls)
  end

  this.givenName = function(self, tmpls)
    return _givenName(self, tmpls)
  end

  this.email = function(self, tmpls)
    return _email(self, tmpls)
  end

  this.password = function(self, tmpls)
    return _password(self, tmpls)
  end

  this.facebookID= function(self, tmpls)
    return _facebookID(self, tmpls)
  end

  this.getParams = function()
    return {
      family_name = this.fields.family_name.text,
      given_name  = this.fields.given_name.text,
      email       = this.fields.email.text,
      password    = this.fields.password.text,
      fb_id       = this.fields.fb_id.text
    }
  end

  this.check = function()
  end

	return this
end
--
return _Class