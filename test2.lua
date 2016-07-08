local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------


            -- "scene:create()"
            function scene:create( event )

                local sceneGroup = self.view

                -- Initialize the scene here.
                -- Example: add display objects to "sceneGroup", add touch listeners, etc.



                    local widget = require( "widget" )

                    -- Create two tables to hold data for days and years      
                    local days = {}
                    local years = {}

                    -- Populate the "days" table
                    for d = 1, 31 do
                        days[d] = d
                    end

                    -- Populate the "years" table
                    for y = 1, 48 do
                        years[y] = 1969 + y
                    end

                    -- Configure the picker wheel columns
                    local columnData = 
                    {
                        -- Months
                        { 
                            align = "left",
                            width = 200,
                            startIndex = 5,
                            labels = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }
                        },
                        -- Days
                        {
                            align = "center",
                            width = 80,
                            startIndex = 18,
                            labels = days
                        },
                        -- Years
                        {
                            align = "center",
                            width = 140,
                            startIndex = 10,
                            labels = years
                        }
                    }

                    -- Image sheet options and declaration
                    local options = {
                        frames = 
                        {
                            { x=0, y=0, width=420, height=300 },
                            { x=420, y=0, width=420, height=300 },
                            { x=840, y=0, width=8, height=300 }
                        },
                        sheetContentWidth = 848,
                        sheetContentHeight = 300
                    }
                    local pickerWheelSheet = graphics.newImageSheet( "pickerWheel.png", options )

                    -- Create the widget
                    local pickerWheel = widget.newPickerWheel
                    {
                        top = display.contentHeight - 320,
                        columns = columnData,
                        sheet = pickerWheelSheet,
                        overlayFrame = 1,
                        overlayFrameWidth = 420,
                        overlayFrameHeight = 300,
                        backgroundFrame = 2,
                        backgroundFrameWidth = 420,
                        backgroundFrameHeight = 300,
                        seperatorFrame = 3,
                        seperatorFrameWidth = 8,
                        seperatorFrameHeight = 300
                    }

                    -- Get the table of current values for all columns
                    -- This can be performed on a button tap, timer execution, or other event
                    local values = pickerWheel:getValues()

                    -- Get the value for each column in the wheel (by column index)
                    local currentMonth = values[1].value
                    local currentDay = values[2].value
                    local currentYear = values[3].value

                    print( currentMonth, currentDay, currentYear )

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