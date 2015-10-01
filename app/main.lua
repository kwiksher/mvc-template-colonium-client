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
require("socket.url")
require("extlib.util")
require("extlib.Deferred")
require("extlib.Callbacks")
local composer = require( "composer" )
local EvtD     = require("extlib.EventDispatcher")
------------------------------------------------------------
------------------------------------------------------------
_G = {}
_G.coronium = require("extlib.mod_coronium")
_G.app    = "TestCoroniumApp"
_G.Router = EvtD()
_G.appId  = "192.168.56.101"
_G.apiKey = "2d0aa65e-208e-4e70-993c-e36a34bac6aa"
_G.coronium:init( { appId = _G.appId, apiKey = _G.apiKey })
_G.coronium.showStatus = false
--
composer.gotoScene( "view.page.testcases")
display.setStatusBar( display.HiddenStatusBar )
display.setDefault( "background", .1, .9, .9 )
------------------------------------------------------------
------------------------------------------------------------
-- local _u       = require("model.user")
-- print(_u.const.family_name)
--[[
local UserDispObj = require("view.user")
local user = UserDispObj.new({
  family_name="yamamoto",
  given_name="naoya",
  email="support@kwiksher.com",
  password="12345678",
  fb_id="",
  })
user:familyName({x=100, y=100, width= 400, height = 50})
]]