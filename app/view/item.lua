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
local EvtD = require("lib.EventDispatcher")
---------------------
---------------------
local data =  [[{
  "name":"Beacon_SF_001",
  "objectId": "photo002",
  "latitude": "37.785945",
  "longitude":"-122.419801",
  "icon_url":"http://kwiksher.com/tutorials/Multi/p1_icon01.png"
   }
]]

local dataTable = json.decode(data)

local function _name(self, template)
  local text = self.data.name
  local obj = display.newText( text, 0, 0, native.systemFont, 48)
  obj.x   = template.x
  obj.y   = template.y
  obj:setFillColor( 0 )
  return obj
end

local function newImageRect(filename, baseDir, template, listener)
  if not template.width then
    print("error newImageRect:"..filename)
    return
  end
  local obj = display.newImageRect(filename, baseDir ,template.width, template.height)
  obj.x, obj.y = template.x ,template.y
  obj.filePath =filename
  if listener then
    listener(obj)
  end
end

local function _image(self, url, _template, filename, listener)
  local filename = filename
  local template = _template
  local baseDir  = system.TemporaryDirectory
  if filename==nil or string.len(filename) == 0 then
      print("filename is empty with "..url)
      -- print(debug.traceback())
      filename = "img/no_image.png"
      baseDir  = system.ResourceDirectory
      timer.performWithDelay(10,
        function() newImageRect(filenameme, baseDir, template, listener) end)
  else
    local function networkListener( event )
      if ( event.isError ) then
        print( "Network error - download failed" )
        filename = "img/no_image.png"
        baseDir  = system.ResourceDirectory
        newImageRect(filename, baseDir, template, listener)
      elseif ( event.phase == "began" ) then
        -- print( "Progress Phase: began" )
      elseif ( event.phase == "ended" ) then
        filename =  event.response.filename
        baseDir =  event.response.baseDirectory
        if not filename then
          print("no filename in _image for ".. url)
          filename = "img/no_image.png"
          baseDir  = system.ResourceDirectory
        end
        newImageRect(filename, baseDir, template, listener)
      end
    end
    local params = {}
    params.progress = true
    network.download(url, "GET", networkListener, params, filename..".png", system.TemporaryDirectory)
  end
end

local function _icon(self, template, listener)
  -- print("icon_"..self.data.uuid)
  -- print(url)
  _image(self.data.icon_url, template, "icon_"..self.data.uuid, listener)
end

local function _mapURL(self, latitude, longitude, icon)
  local lt0 = 37.786555
  local lg0 = -122.422119
  local markers ="markers=color:blue%7Clabel:S%7C"..lt0..","..lg0
  markers = markers.."&markers=icon:"..icon.."%7color:green%7Clabel:B%7C"..latitude..","..longitude
  local mapURL = "http://maps.google.com/maps/api/staticmap?center="..latitude..","..longitude.."&size=".."320".."x".."320".."&zoom=18&sensor=false&"..markers
   -- print(mapURL)
  return mapURL
end

local function _GPS(self, template, listener)
  local mapURL = _mapURL(self.data.latitude, self.data.longitude, self.data.icon_url)
  local filename = "playerMap"..self.data.objectId
  _image(mapURL, template, filename, listener)
end

local function _updateMap(self, latitude, longitude, _target)
  local mapURL = _mapURL(latitude, longitude, self.data.icon_url)
  local filename = "playerMap"..self.data.objectId
  local baseDir  = system.TemporaryDirectory
  local function networkListener( event )
    if ( event.isError ) then
      print( "Network error - download failed" )
      filename = "img/no_image.png"
      baseDir  = system.ResourceDirectory
    elseif ( event.phase == "began" ) then
      -- print( "Progress Phase: began" )
    elseif ( event.phase == "ended" ) then
      filename =  event.response.filename
      baseDir =  event.response.baseDirectory
      if not filename then
        filename = "img/no_image.png"
        baseDir  = system.ResourceDirectory
      end
      local paint = {
        type = "image",
        filename = filename,
        baseDir = baseDir
      }
      _target.fill = paint
    end
  end
  local params = {}
  params.progress = true
  network.download(url, "GET", networkListener, params, filename..".png", system.TemporaryDirectory)
end
---------------------
-- API
---------------------
_Class.new = function(data)
	local this =  EvtD()
 	this.data = data
  return setmetatable( this, _Class_mt)
end
--
-- _Class.name = _name
--
function _Class:name(template, listener)
  return _name(self, template, listener)
end
--
function _Class:icon(template, listener)
  return _icon(self, template, listener)
end
--
function _Class:GPS(template, listener)
  return _GPS(self, template, listener)
end

function _Class:updateMap(latitude, longitude, _target)
  return _updateMap(self, latitude, longitude, _target)
end
--
function _Class:image(url, template, filename, listener)
    return _image(self, url, template, filename, listener)
end
--
return _Class