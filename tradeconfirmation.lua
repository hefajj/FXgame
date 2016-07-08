local composer = require( "composer" )
local widget = require( "widget" )
widget.setTheme( "widget_theme_ios7" )

local scene = composer.newScene()
local mydata = require("mydata")
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    local background = display.setDefault( "background", 1, 1, 1 )

    local widgetGroup = display.newGroup()
    local tradedetailgroup = display.newGroup()
    sceneGroup:insert( widgetGroup )

--        local Kwadratgorny = display.newRect( display.contentWidth/2, 70, display.contentWidth-20, 110 )
--        Kwadratgorny.strokeWidth = 3
--        --Kwadratgorny:setFillColor( 0.5 )
--        Kwadratgorny:setStrokeColor( 0, 0, 0 )
--        sceneGroup:insert( Kwadratgorny )

        print("display.contentWidth: " .. display.contentWidth .. " display.contentHeight: " .. display.contentHeight)

--            local Setprofile = display.newImageRect("settings.png", 140, 66 )
--            --local rowArrow = display.newImageRect( row, "settings.png", 18, 26 )
--            Setprofile.x = display.contentWidth*88/720
--            Setprofile.y = display.contentHeight*60/1280


                local function handlesettingsEvent( event )

                    if ( "ended" == event.phase ) then
                        --print( "I understand and will be back in 2 hours" )
                        mydata["lastscrean"] = "tadeconfirmation"
                        composer.gotoScene( "setup" )
                    end
                end
                -- Create the widget
                local settings = widget.newButton
                {
                    x = display.contentWidth*88/720,
                    y = display.contentHeight*60/1280,
                    width = 140*display.contentWidth/720,                       --width of the image file(s)
                    height = 66*display.contentHeight/1280,                       --height of the image file(s)
                    defaultFile = "settings.png",
                    overFile = "settingsOver.png",

                    --labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
                    --fontSize = 30,
                    --font = native.systemFontBold,
                    --id = "trade",
                    --label = "I understand and will be back in 2 hours!",

                    onEvent = handlesettingsEvent
                }
                sceneGroup:insert( settings )


        print("liczba transakcji do wykonania" .. composer.getVariable( "numberoftrades" ))

        local Setprofile2 = display.newText( "Trade confirmation: ", display.contentWidth*204/720, display.contentHeight*238/1280, "Comic Sans MS", 40*display.contentWidth/720 )
        Setprofile2:setFillColor( 0, 0, 0)
        widgetGroup:insert( Setprofile2 )




--            local multiText = display.newText( "Wait 2 hours and:  Your trades will be automatycly closed We will notyfy you  You will see results of trading  You will do another 3 trades", display.contentWidth*342/720, display.contentHeight*898/1280, display.contentWidth*0.9, 400, "Comic Sans MS", 40 )
--            multiText:setFillColor( 0, 0, 0)
--            widgetGroup:insert( multiText )

            local nextsteps = display.newImageRect("nextsteps.png", 792*display.contentWidth/872, 378*display.contentHeight/1508 )
            --local rowArrow = display.newImageRect( row, "settings.png", 18, 26 )
            nextsteps.x = display.contentWidth*328/720
            nextsteps.y = display.contentHeight*842/1280
            widgetGroup:insert( nextsteps )
                                      -- touch listener function
                                        function nextsteps:touch( event )
                                            if event.phase == "began" then
                                            
                                                self.markX = self.x    -- store x location of object
                                                self.markY = self.y    -- store y location of object
                                            
                                            elseif event.phase == "moved" then
                                            
                                                local x = (event.x - event.xStart) + self.markX
                                                local y = (event.y - event.yStart) + self.markY
                                                
                                                print("x: " .. x .. " y: " .. y)

                                                self.x, self.y = x, y    -- move object based on calculations above

                                            end
                                            
                                            return true
                                        end
                                         
                                        -- make 'myObject' listen for touch events
                                        nextsteps:addEventListener( "touch", nextsteps )


                local function handleButtonEvent( event )

                    if ( "ended" == event.phase ) then
                        print( "I understand and will be back in 2 hours" )
                        composer.gotoScene( "quit" )
                    end
                end
                -- Create the widget
                local button1 = widget.newButton
                {
                    x = display.contentWidth/2,
                    y = 1200*display.contentHeight/1280,
                    width = 791*display.contentWidth/872,                        --width of the image file(s)
                    height = 132*display.contentHeight/1508,                       --height of the image file(s)
                    defaultFile = "willbeback.png",
                    overFile = "willbebackOver.png",

                    --labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
                    --fontSize = 30,
                    --font = native.systemFontBold,
                    --id = "trade",
                    --label = "I understand and will be back in 2 hours!",

                    onEvent = handleButtonEvent
                }
                widgetGroup:insert( button1 )
--                            local button1 = widget.newButton
--                            {
--                                defaultFile = "buttonRed.png",
--                                overFile = "buttonRedOver.png",
--                                label = "Button 1 Label",
--                                emboss = true,
--                                onPress = button1Press,
--                                onRelease = button1Release,
--                            }



                widgetGroup:insert( button1 )
-----------------------------------------------------------------------------------------------------------------------------------------


-- create a constant for the left spacing of the row content
local LEFT_PADDING = 10

--Set the background to white
display.setDefault( "background", 1, 1, 1 )

--Create a group to hold our widgets & images


-- Create a background to go behind our tableView
--local background = display.newImage( widgetGroup, "bg.jpg", 0, 0, true )
--background.anchorX = 0; background.anchorY = 0      -- TopLeft anchor

---- The gradient used by the title bar
--local titleGradient = {
--    type = 'gradient',
--    color1 = { 189/255, 203/255, 220/255, 255/255 }, 
--    color2 = { 89/255, 116/255, 152/255, 255/255 },
--    direction = "down"
--}--

---- Create toolbar to go at the top of the screen
--local titleBar = display.newRect( display.contentCenterX, 0, display.contentWidth, 100 )
--titleBar:setFillColor( titleGradient ) 
--titleBar.y = display.screenOriginY + titleBar.contentHeight * 0.5--

---- create embossed text to go on toolbar
--local titleText = display.newEmbossedText( "My List", display.contentCenterX, titleBar.y, native.systemFontBold, 60 )--

----create a shadow underneath the titlebar (for a nice touch)
--local shadow = display.newImage( "shadow.png" )
--shadow.anchorX = 0; shadow.anchorY = 0      -- TopLeft anchor
--shadow.x, shadow.y = 0, titleBar.y + titleBar.contentHeight * 0.5
--shadow.xScale = 320 / shadow.contentWidth
--shadow.alpha = 0.45

--Text to show which item we selected
local itemSelected = display.newText( "You selected item ", 0, 0, native.systemFontBold, 28 )
itemSelected.x = display.contentWidth + itemSelected.contentWidth * 0.5
itemSelected.y = display.contentCenterY
widgetGroup:insert( itemSelected )

-- Forward reference for our back button & tableview
local backButton, list

-- -----------------------------------------------------------------------------------------------------------------
-- sqlite3
-- -----------------------------------------------------------------------------------------------------------------
            --Include sqlite
            require "sqlite3"
            --Open data.db.  If the file doesn't exist it will be created
            local path = system.pathForFile(mydata["sqlitefile"], system.DocumentsDirectory)
            db = sqlite3.open( path )   
             
            --Handle the applicationExit event to close the db
            local function onSystemEvent( event )
                    if( event.type == "applicationExit" ) then              
                        db:close()
                    end
            end
            
            local tradesdone  = {}
            local tradesdone_detail  = {}

             local numberofrows = 1
              for row in db:nrows("select * from (SELECT * FROM trades ORDER BY ID DESC LIMIT 3) order by id asc") do
                --local text = 
                local text = row.id.." "..row.pair.." "..row.open_time.." "..row.openprice.." "..row.amount.." "..row.sl.." "..row.tp
                print(text)
                local sign
                if (tonumber(row.amount)<0) then 
                    sign = "SELL"
                    row.amount = row.amount*(-1) 
                else
                    sign = "BUY"
                end
                --if (row.amount<0) then row.amount*(-1) else row.amount end
                    
                tradesdone[numberofrows] = sign.." "..row.amount.." "..row.pair.." "..row.openprice
                tradesdone_detail[numberofrows.."_1"] = "id: "..row.id
                tradesdone_detail[numberofrows.."_2"] = "sign: "..sign
                tradesdone_detail[numberofrows.."_3"] = "amount: "..row.amount
                tradesdone_detail[numberofrows.."_4"] = "pair: "..row.pair
                tradesdone_detail[numberofrows.."_5"] = "openprice: "..row.openprice
                tradesdone_detail[numberofrows.."_6"] = "open time: "..os.date("%c", row.open_time)
                tradesdone_detail[numberofrows.."_7"] = "sl: "..row.sl
                if (row.close_time ~= nil) then tradesdone_detail[numberofrows.."_8"] = "close_time: "..row.close_time    
                    else tradesdone_detail[numberofrows.."_8"] = "close_time: " end
                
                if (row.closeprice ~= nil) then tradesdone_detail[numberofrows.."_9"] = "closeprice: "..row.closeprice
                    else tradesdone_detail[numberofrows.."_9"] = "closeprice: " end
                
                if (row.pnl ~= nil) then tradesdone_detail[numberofrows.."_10"] = "pnl: "..row.pnl
                    else tradesdone_detail[numberofrows.."_10"] = "pnl: " end
               

                numberofrows = numberofrows +1
              end 
              print ("numberofrows: "..numberofrows )
-- -----------------------------------------------------------------------------------------------------------------
-- trades
-- -----------------------------------------------------------------------------------------------------------------
 
--local tradesdone = {" 500 EURUSD" , "Long 500 EURCHF", "Short 457 USDJPY", "Short 457 USDJPY"}


-- Handle row rendering
local function onRowRender( event )
    local phase = event.phase
    local row = event.row
    
    --local rowHeight = row.contentHeight


    -- in graphics 2.0, the group contentWidth / contentHeight are initially 0, and expand once elements are inserted into the group.
    -- in order to use contentHeight properly, we cache the variable before inserting objects into the group

    local groupContentHeight = row.contentHeight
    
    local rowTitle = display.newText( row, row.index .. "    " .. tradesdone[row.index], 0, 0, native.systemFontBold, 40*display.contentHeight/1280 )
    rowTitle:setFillColor( 0, 0, 0)
    -- in Graphics 2.0, the row.x is the center of the row, no longer the top left.
    rowTitle.x = LEFT_PADDING
    -- we also set the anchorX of the text to 0, so the object is x-anchored at the left
    rowTitle.anchorX = 0
    rowTitle.y = groupContentHeight * 0.5
    


    --local rowArrow = display.newImage( row, "rowArrow.png", false )
    local rowArrow = display.newImageRect( row, "rowArrow.png", 18*display.contentHeight/1280, 26*display.contentHeight/1280 )
    --local image = display.newImageRect( "image.png", 100, 100 )
    rowArrow.x = row.contentWidth - LEFT_PADDING
    rowArrow.y = groupContentHeight * 0.5

    -- we set the image anchorX to 1, so the object is x-anchored at the right
    rowArrow.anchorX = 1
    
end

local tradedetail = {}

-- Hande row touch events
local function onRowTouch( event )
    local phase = event.phase
    local row = event.target
    
    if "press" == phase then
        print( "Pressed row: " .. row.index )

    elseif "release" == phase then
        -- Update the item selected text
        print( "release: ")
        itemSelected.text = "You selected item " .. row.index
        
        --Transition out the list, transition in the item selected text and the back button

        for i=1,6 do
            
            local options = 
            {
                --parent = textGroup,
                text = tradesdone_detail[row.index.."_"..i],     
                x = 350*display.contentWidth/720,
                y = (30*display.contentHeight/1280)+(i*40),
                width = display.contentWidth*0.8,     --required for multi-line and alignment
                font = "Comic Sans MS", --native.systemFontBold,   
                fontSize = 40*display.contentHeight/1280,
                align = "left"  --new alignment parameter
            }
            --tradedetail[i] = display.newText( tradesdone_detail[row.index.."_"..i], 150*display.contentWidth/720, (180*display.contentHeight/1280)+(i*40), "Comic Sans MS", 50*display.contentHeight/1280, "left")
            tradedetail[i] = display.newText(options)
            tradedetail[i]:setFillColor( 0, 0, 0)
            widgetGroup:insert( tradedetail[i] )
        end
        
        --sceneGroup:insert( tradedetailgroup )


        -- The table x origin refers to the center of the table in Graphics 2.0, so we translate with half the object's contentWidth
        --transition.to( Setprofile, { x = Setprofile.x - 800, time = 400, transition = easing.outExpo } )
        transition.to( Setprofile2, { x = Setprofile2.x - 800, time = 400, transition = easing.outExpo } )
        --transition.to( multiText, { x = multiText.x - 800, time = 400, transition = easing.outExpo } )
        transition.to( nextsteps, { x = nextsteps.x - 800, time = 400, transition = easing.outExpo } )
        transition.to( button1, { x = button1.x - 800, time = 400, transition = easing.outExpo } )
        transition.to( settings, { x = settings.x - 800, time = 400, transition = easing.outExpo } )

        transition.to( list, { x = - list.contentWidth * 0.5, time = 400, transition = easing.outExpo } )
        transition.to( itemSelected, { x = display.contentCenterX, time = 400, transition = easing.outExpo } )
        transition.to( backButton, { alpha = 1, time = 400, transition = easing.outQuad } )
        
        print( "Tapped and/or Released row: " .. row.index )
    end
end

-- Create a tableView
list = widget.newTableView
{
    top =  display.contentHeight*250/1000,
    width = display.contentWidth, 
    height = 300*display.contentWidth/720,
    hideBackground = true,
    --maskFile = "mask-320x448.png",
    onRowRender = onRowRender,
    rowTouchDelay = 5,
    onRowTouch = onRowTouch,
}

--Insert widgets/images into a group
widgetGroup:insert( list )
--widgetGroup:insert( titleBar )
--widgetGroup:insert( titleText )
--widgetGroup:insert( shadow )

---[[ **Remove This**
-- insert rows into list (tableView widget)
for i = 1, 3 do
    list:insertRow
    {
        height = 150*display.contentHeight/1280,
        rowHeight = 100*display.contentHeight/1280,
        rowColor = 
        { 
            default = { 0, 0, 0, 0 },
        },
    }
end
--]]

--Handle the back button release event
local function onBackRelease()
    --Transition in the list, transition out the item selected text and the back button

        --tradedetail = "fsdfs"
        for i=1,6 do
            tradedetail[i]:removeSelf()
        end
        
    -- The table x origin refers to the center of the table in Graphics 2.0, so we translate with half the object's contentWidth
        --transition.to( Setprofile, { x = Setprofile.x + 800, time = 400, transition = easing.outExpo } )
        transition.to( Setprofile2, { x = Setprofile2.x + 800, time = 400, transition = easing.outExpo } )
        --transition.to( multiText, { x = multiText.x + 800, time = 400, transition = easing.outExpo } )
        transition.to( nextsteps, { x = nextsteps.x + 800, time = 400, transition = easing.outExpo } )
        transition.to( button1, { x = button1.x + 800, time = 400, transition = easing.outExpo } )
        transition.to( settings, { x = settings.x + 800, time = 400, transition = easing.outExpo } )


    transition.to( list, { x = list.contentWidth * 0.5, time = 400, transition = easing.outExpo } )
    transition.to( itemSelected, { x = display.contentWidth + itemSelected.contentWidth * 0.5, time = 400, transition = easing.outExpo } )
    transition.to( backButton, { alpha = 0, time = 400, transition = easing.outQuad } )
end

--Create the back button
backButton = widget.newButton
{
    width = 298*display.contentWidth/720,
    height = 56*display.contentHeight/1280,
    label = "<< Back", 
    labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
    fontSize = 30,
    font = native.systemFontBold,
    labelYOffset = - 1,
    onRelease = onBackRelease
}



backButton.alpha = 0
backButton.x = display.contentCenterX
backButton.y = display.contentHeight*0.9
widgetGroup:insert( backButton )



-------------------------------------------------------------------------------------------------------------------------------------------------







    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.

    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.

    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.


    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene