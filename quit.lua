local composer = require( "composer" )
local widget = require( "widget" )
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

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.

                --display.setDefault( "background", 1 )
                local background = display.setDefault( "background", 1, 1, 1 )


            local comeback = display.newImageRect("comeback.png", 660*display.contentWidth/872, 422*display.contentHeight/1508 )
            comeback.x = display.contentWidth/2
            comeback.y = display.contentHeight*141/480
            sceneGroup:insert( comeback )

    -- -----------------------------------------------------------------------------------------------------------------
-- Timer
-- -----------------------------------------------------------------------------------------------------------------
---            
---                local timeDelay = 500       -- Timer value
---                text = display.newText( "59", display.contentCenterX, 105, native.systemFontBold, 160 )
---                text:setFillColor( 0, 0, 0 )---

---                function text:timer( event )
---                    
---                    local count = event.coun---

---                    print( "Table listener called " .. count .. " time(s)" )
---                    self.text = coun---

---                    if count >= 20 then
---                        timer.cancel( event.source ) -- after the 20th iteration, cancel timer
---                    end
---                ---

---                -- Register to call t's timer method 50 times
---                timerID = timer.performWithDelay( timeDelay, text, 5---
---


    -- -----------------------------------------------------------------------------------------------------------------
-- Clock
-- -----------------------------------------------------------------------------------------------------------------
    



        local hourField = display.newText( "", display.contentWidth*50/320, display.contentHeight*198/480, native.systemFontBold, display.contentHeight*20/480 )
        hourField:setFillColor( 0, 0, 0 )
        sceneGroup:insert( hourField )

        local minuteField = display.newText( "", display.contentWidth*122/320, display.contentHeight*198/480, native.systemFontBold, display.contentHeight*20/480 )
        minuteField:setFillColor( 0, 0, 0)
        sceneGroup:insert( minuteField )

        local secondField = display.newText(  "", display.contentWidth*218/320, display.contentHeight*198/480, native.systemFontBold, display.contentHeight*20/480 )
        secondField:setFillColor( 0, 0, 0 )
        sceneGroup:insert( secondField )

        local function updateTime()
            --local time = os.date("*t")
            local time = os.date("!*t", (mydata["nexttrades"]-os.time()))
            --local time = os.date("*t", 0)
            --print("time left:" ..(mydata["nexttrades"]-os.time()))
            
            
            local hourText = time.hour
            if (hourText < 10) then hourText = "0" .. hourText end
            hourField.text = hourText
            
            local minuteText = time.min
            if (minuteText < 10) then minuteText = "0" .. minuteText end
            minuteField.text = minuteText
            
            local secondText = time.sec
            if (secondText < 10) then secondText = "0" .. secondText end
            secondField.text = secondText
        end

        updateTime() -- run once on startup, so correct time displays immediately


        -- Update the clock once per second
        local clockTimer = timer.performWithDelay( 1000, updateTime, -1 )

    -- -----------------------------------------------------------------------------------------------------------------
-- quit event button and event
-- -----------------------------------------------------------------------------------------------------------------
         
                local function handleplayEvent( event )

                    if ( "ended" == event.phase ) then
                        print( "quit event" )
                        os.exit()
                    end
                end
                -- Create the widget
                local playbutton = widget.newButton
                {
                    x = display.contentWidth/2,
                    y = display.contentHeight*313/480,

                    width = 312*display.contentWidth/872,
                    height = 125*display.contentHeight/1508, 

                    defaultFile = "quit.png",
                    overFile = "quitOver.png",
                    onEvent = handleplayEvent
                }
                sceneGroup:insert( playbutton )




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