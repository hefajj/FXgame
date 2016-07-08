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


    local background = display.setDefault( "background", 1, 1, 1 )

-- -----------------------------------------------------------------------------------------------------------------
-- sqlite3
-- -----------------------------------------------------------------------------------------------------------------
            --Include sqlite
            require "sqlite3"
            --Open data.db.  If the file doesn't exist it will be created
            local path = system.pathForFile("data9.db", system.DocumentsDirectory)
            db = sqlite3.open( path )   
             
            --Handle the applicationExit event to close the db
            local function onSystemEvent( event )
                    if( event.type == "applicationExit" ) then              
                        db:close()
                    end
            end
-- -----------------------------------------------------------------------------------------------------------------
-- fxgraph
-- -----------------------------------------------------------------------------------------------------------------
   
			math.randomseed(os.time() )

			local fxgraph = display.newLine()
			sceneGroup:insert( fxgraph )
            local maxrate=0
            local minrate=0

            for row in db:nrows("SELECT max(close) as max, min(close) as min FROM fxrateshist where pair ='EURUSD' ") do
              maxrate = row.max
              minrate = row.min
              
              local text = "row.min: "..minrate.." row.max: "..maxrate
              print(text)
            end

            local numberofrows = 0 
            --print all the table contents
            for row in db:nrows("SELECT * FROM fxrateshist WHERE pair='EURUSD' ORDER BY ID  DESC;") do
              local text = row.close
              print(text)
              numberofrows = numberofrows +1
                    fxgraph:append( 

                    display.contentWidth*(1-(((maxrate - minrate)-(row.close-minrate))/(maxrate - minrate)))*0.9+display.contentWidth*0.05, 
                    display.contentHeight*0.7*(0.008*numberofrows)+display.contentHeight*0.09
                                                                                            --0.016 - co taki odsetek wyświetlamy nowy punkt
                    )

            end
            print ("numberofrows: "..numberofrows )



            fxgraph:setStrokeColor( 1, 0, 0, 1 )
            fxgraph.strokeWidth = 8*display.contentHeight/1280


--            fxgraph:append( 
--						display.contentWidth*math.random(1, 99)/100, display.contentHeight*0.15,
--						display.contentWidth*math.random(1, 99)/100, display.contentHeight*0.22,  
--						display.contentWidth*math.random(1, 99)/100, display.contentHeight*0.3, 
--						display.contentWidth*math.random(1, 99)/100, display.contentHeight*0.4, 
--						display.contentWidth*math.random(1, 99)/100, display.contentHeight*0.5, 
--						display.contentWidth*math.random(1, 99)/100, display.contentHeight*0.6, 
--						display.contentWidth*math.random(1, 99)/100, display.contentHeight*0.7, 
--						display.contentWidth*math.random(1, 99)/100, display.contentHeight*0.77, 
--						display.contentWidth*math.random(1, 99)/100, display.contentHeight*0.83
--				)

--            -- Load the relevant LuaSocket modules
--            local http = require("socket.http")
--            local ltn12 = require("ltn12")--

--            -- Create local file for saving data
--            local path = system.pathForFile( "widget-pickerwheel.png", system.DocumentsDirectory )
--            myFile = io.open( path, "w+b" ) --

--            -- Request remote file and save data to local file
--            http.request{
--                url = "http://docs.coronalabs.com/images/simulator/widget-pickerwheel.png", 
--                sink = ltn12.sink.file(myFile),
--            }--

--            -- Display local file
--            testImage = display.newImage("widget-pickerwheel.png",system.DocumentsDirectory,60,50);

--                                                                local function networkListener( event )
--                                                                        if ( event.isError ) then
--                                                                                print( "Network error!")
--                                                                        elseif ( event.phase == "began" ) then
--                                                                                if event.bytesEstimated <= 0 then
--                                                                                        print( "Download starting, size unknown" )
--                                                                                else
--                                                                                        print( "Download starting, estimated size: " .. event.bytesEstimated )
--                                                                                end
--                                                                        elseif ( event.phase == "progress" ) then
--                                                                                if event.bytesEstimated <= 0 then
--                                                                                        print( "Download progress: " .. event.bytesTransferred )
--                                                                                else
--                                                                                        print( "Download progress: " .. event.bytesTransferred .. " of estimated: " .. event.bytesEstimated )
--                                                                                end
--                                                                        elseif ( event.phase == "ended" ) then
--                                                                                print( "Download complete, total bytes transferred: " .. event.bytesTransferred )
--                                                                                testImage = display.newImage("wsidget-pickerwheel.png",system.DocumentsDirectory,60,50);--

--                                                                        end
--                                                                end--

--                                                                local params = {}--

--                                                                -- This tells network.request() that we want the 'began' and 'progress' events...
--                                                                params.progress = "download"--

--                                                                -- This tells network.request() that we want the output to go to a file...
--                                                                params.response = {
--                                                                        filename = "wsidget-pickerwheel.png",
--                                                                        baseDirectory = system.DocumentsDirectory
--                                                                        }--

--                                                                network.request( "http://docs.coronalabs.com/images/simulator/widget-pickerwheel.png", "GET", networkListener,  params )
--local function networkListener( event )
--        if ( event.isError ) then
--                print( "Network error!")
--        else
--                print ( "RESPONSE: " .. event.response )
--        end
--end--

--local headers = {}--

--headers["Content-Type"] = "application/x-www-form-urlencoded"
--headers["Accept-Language"] = "en-US"--

--local body = "color=red&size=small"--

--local params = {}
--params.headers = headers
--params.body = body--

--network.request( "http://127.0.0.1/formhandler.php", "POST", networkListener, params)

--local client = require "resty.websocket.client"

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
    --timer.cancel( event.source ) 
    timer.cancel( timerID )
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