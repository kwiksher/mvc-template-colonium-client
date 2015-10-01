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
local composer = require( "composer" )
local widget = require( "widget" )
local json = require "json"
-------------------------------------------------------------------------------
local scene = composer.newScene()
local sceneGroup = nil -- main group for all page elements
-------------------------------------------------------------------------------
local LEFT_PADDING = 10
local halfW = display.contentCenterX
local halfH = display.contentCenterY
local width = display.actualContentWidth
local list
-------------------------------------------------------------------------------
--
-- Called when the scene's view does not exist:
function scene:create( event )
  -- view is not yet visible
  local sceneGroup = self.view

  local view = display.newGroup()
  -- Create toolbar to go at the top of the screen
  local titleBar = display.newRect( view, halfW, 0, width, 32 )
  titleBar.fill = { type = 'gradient', color1 = { .74, .8, .86, 1 }, color2 = { .35, .45, .6, 1 } }
  titleBar.y = display.screenOriginY + titleBar.contentHeight * 0.5
  local titleText = display.newEmbossedText( view, _G.app, halfW, titleBar.y, native.systemFontBold, 20 )
  sceneGroup:insert(titleBar)
  sceneGroup:insert(titleText)

  local preview = display.newGroup()
  preview:translate( halfW + width, halfH )
  local onBackRelease = function()
    transition.to( list, { x = width * 0.5 + display.screenOriginX, time = 400, transition = easing.outExpo } )
    transition.to( preview, { x = width + preview.contentWidth * 0.5, time = 400, transition = easing.outExpo } )
  end
  -- Back button
  local backButton = widget.newButton
  {
    x = 0,
    y = ( display.contentHeight / 2 )-30,
    width = 298,
    height = 56,
    label = "Back",
    labelYOffset = - 1,
    onRelease = onBackRelease
  }
  preview:insert( backButton )

-- Handle row rendering
  local function onRowRender( event )
    local phase = event.phase
    local row = event.row
    -- Precalculate y position. NOTE: row's height will change as we add children
    local y = row.contentHeight * 0.25
    local rowTitle = display.newText( row, row.id.name, 0, 0, native.systemFontBold, 14 )
    local rowDesc = display.newText( row, row.id.desc, 0, 0, native.systemFont, 10 )
    local rowArrow = display.newImage( row, "image/rowArrow.png", false )

    -- Left-align title
    rowTitle.anchorX = 0
    rowTitle.x = LEFT_PADDING
    rowTitle.y = y
    rowTitle:setFillColor( 0 )
    -- Right-align the arrow
    rowArrow.anchorX = 1
    rowArrow.x = width - LEFT_PADDING
    rowArrow.y = y

    rowDesc.anchorX = 0
    rowDesc.anchorY = 0
    rowDesc.x = LEFT_PADDING
    rowDesc.y = rowTitle.y + 10
    rowDesc:setFillColor( 0 )
  end

  -- Hande row touch events
  local function onRowTouch( event )
    local phase = event.phase
    local row = event.target
    if "tap" == phase then
      transition.to( list, { x = - width * 0.5 + display.screenOriginX, time = 400, transition = easing.outExpo } )
      transition.to( preview, { x = display.contentCenterX, time = 400, transition = easing.outExpo, onComplete = function()
          if string.len(row.id.evt.name) > 0 and string.len(row.id.evt.API) then
            _G.Router:dispatchEvent({name = row.id.evt.name}, row.id.evt.API, row.id.evt.page)
          else
            composer.gotoScene( row.id.evt.page )
          end
        end} )
    end
  end
  --
  -- Create a tableView
  list = widget.newTableView
  {
    top = titleBar.contentHeight + display.screenOriginY,
    left = display.screenOriginX,
    width = width,
    height = display.actualContentHeight - titleBar.contentHeight,
    onRowRender = onRowRender,
    onRowTouch = onRowTouch,
  }
  -- list is child of main view
  -- Load effect list
  -------------------------------------------------------------------------------
  local tbl = require "testcase.unittest"
  -- Read unit test list from json
  for i = 1, #tbl do
    list:insertRow{
      id = tbl[i], -- use name of effect as id
      height = 100,
      width = width,
      category = "foo"
    }
  end

-- nameTxt positioning
  sceneGroup:insert(preview)
  sceneGroup:insert(list)

end -- ends scene:create

-- Called when the scene's view is about to 'will/load' or 'did/appear':
function scene:show( event )
   local sceneGroup = self.view
   if event.phase == "did" then
   end --ends phase did
end -- ends scene:show

function scene:hide( event )
   if event.phase == "will" then
   elseif event.phase == "did" then
   end
end

function scene:destroy( event )
    print("------- destroy ------")
    local currentscene = "page_"..curPage
    composer.viewlist[currentscene].delete(layer)
       -- Remove all unecessary composer items
   --composer.pageSwap = nil
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene
