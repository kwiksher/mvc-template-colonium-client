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
---------------------
---------------------
local json     = require("json")
local _H = display.contentHeight
local _W = display.contentWidth

local function getShapeColor(l)
  local  p = json.decode(l._properties)
   -- for k, v in pairs(p)  do print (k, v) end
  return {p.fill.r, p.fill.g, p.fill.b}
end

_M.getShapeColor = function(l)
	return getShapeColor(l)
end
--
_M.jsonFile = function(file)
    local path = system.pathForFile(file, system.ResouceDirectory )
    local f,err = io.open(path, "r")
    if f==nil then
        print(err)
        return f,err
    else
        local content = f:read("*all")
        f:close()
        return content
    end
end

_M.newText = function(text,obj)
    local newObj = display.newText(text,0,0, native.systemFont,obj.size)
    newObj.x = obj.x
    newObj.y = obj.y+35
    newObj:setFillColor( unpack(getShapeColor(obj)) )
	return newObj
end

_M.newImageRect = function(image, obj)
    local newObj = display.newImageRect(image,obj.width, obj.height)
    newObj.x = obj.x
    newObj.y = obj.y
    return newObj
end

_M.newImageRectForScroll = function(image, obj, placeHolder,i)
    local newObj = display.newImageRect( image, obj.width, obj.height)
    newObj.x = obj.x-(placeHolder.x-placeHolder.width/2) + obj.width*(i-1)
    newObj.y = obj.y-(placeHolder.y-placeHolder.height/2)
	return newObj
end

_M.newTextForScroll = function(text, obj, placeHolder,photo, i)
    local newObj = display.newText(text, 0,0, native.systemFont,obj.size)
    newObj.x = obj.x-(placeHolder.x-placeHolder.width/2) + photo.width*(i-1)
    newObj.y = obj.y-(placeHolder.y-placeHolder.height/2)
    newObj:setFillColor( unpack(getShapeColor(obj)) )
	return newObj
end


_M.newImageRectForTable = function(image, obj, placeHolder)
    local newObj = display.newImageRect( image, obj.width, obj.height)
    newObj.x = obj.x + (placeHolder.width-_W)/2
    newObj.y = obj.y + (placeHolder.height-_H)/2+(_H/2-placeHolder.y)
	return newObj
end

_M.newTextForTable = function(text, obj, placeHolder, params)
  local newObj
  if params ~=nil then
      newObj = display.newText(text, 0,0, params.w, params.h, native.systemFont,obj.size)
  else
      newObj = display.newText(text, 0,0, native.systemFont,obj.size)
  end
  newObj.x = obj.x +(placeHolder.width-_W)/2
  newObj.y= obj.y + (placeHolder.height-_H)/2
  newObj:setFillColor( unpack(getShapeColor(obj)) )
	return newObj
end

return _M