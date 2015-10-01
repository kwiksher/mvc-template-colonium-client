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
local sceneName = ...
local composer = require( "composer" )
local scene = composer.newScene(sceneName)
local sceneGroup = nil
--
-- local SignupDispObj     = require("view.signup")
local UserDispObj     = require("view.user")
local _u              = require("model.user").const
--
local _W = display.contentWidth
local _H = display.contentHeight
--
local tmpls = {}
--
-- local user = SignupDispObj.new()
local user = UserDispObj.new()
------------------------------------------------------------
------------------------------------------------------------
function scene:create( event )
  local sceneGroup = self.view
  tmpls.familyName = self:getObjectByName( _u.family_name )
  tmpls.givenName  = self:getObjectByName( _u.given_name )
  tmpls.email      = self:getObjectByName( _u.email )
  tmpls.password   = self:getObjectByName( _u.password )
  tmpls.facebookID = self:getObjectByName( _u.fb_id )
  tmpls.result     = self:getObjectByName( "result")
  --
  -- !!! set data from controller here !!!
  --
  user.data = event.params.model
  --
  user.objects = {}
  user.objects[_u.family_name] = user:familyName(tmpls.familyName)
  user.objects[_u.given_name]  = user:givenName(tmpls.givenName)
  user.objects[_u.email]       = user:email(tmpls.email)
  user.objects[_u.password]    = user:password(tmpls.password)
  for k, v in pairs(user.objects) do
    sceneGroup:insert(v)
  end
  sceneGroup:insert(tmpls.result)
end
--
--
function scene:show( event )
  local sceneGroup = self.view
  if event.phase == "did" then
    --
    -- !!! set data from controller here !!!
    --
    if event.params ~= nil and event.params.API == "addUser" then
      local data = event.params.model
      if data~= nil and event.params.result ~= nil then
        tmpls.result.text = data.objectId
        table.print(data)
        user.objects[_u.family_name].text = data.familyName
        user.objects[_u.given_name].text  = data.givenName
        user.objects[_u.email].text      = data.email
        user.objects[_u.password].text   = data.password
        tmpls.result.text = event.params.API.." success"
      else
        table.print(event.params.error)
        tmpls.result.text = event.params.API.." failed"
      end
    end
  end
end
--
--
function scene:hide( event )
   if event.phase == "will" then
   elseif event.phase == "did" then
   end
end
--
--
function scene:destroy( event )
    local currentscene = "page_"..curPage
    composer.viewlist[currentscene].delete(layer)
end
--
--
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene
