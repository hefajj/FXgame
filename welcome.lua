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

                        
           local fxgame = display.newImageRect("fxgame.png", 239*display.contentWidth/872, 76*display.contentHeight/1508 )
            fxgame.x = display.contentWidth/2
            fxgame.y = display.contentHeight*87/480
            sceneGroup:insert( fxgame )


-- -----------------------------------------------------------------------------------------------------------------
-- playbutton.png
-- -----------------------------------------------------------------------------------------------------------------
                local playbutton 

                local function handleplayEvent( event )

                    if ( "ended" == event.phase ) then
                        --print( "I understand and will be back in 2 hours" )
                        --composer.setVariable( "numberoftrades",composer.getVariable( "numberoftrades" )-1 )
                        if (mydata["setupdone"] == 0) then
                          mydata["lastscrean"] = "welcomeplay"
                          composer.gotoScene( "setup" )
                          else
                          

                          if (mydata["graphupdates"]==3) then
                            composer.gotoScene( "trade" )
                          else 
                             mydata["tradenow"] = 1
                                playbutton:removeSelf()
                                local wait = display.newImageRect("waitbuttonOVER.png", 367*display.contentWidth/872, 417*display.contentHeight/1508 )
                                wait.x = display.contentWidth/2
                                wait.y = display.contentHeight*223/480
                                sceneGroup:insert( wait )
                          end
                      end

                        
                    end
                end
                -- Create the widget
               playbutton= widget.newButton
                {
                    x = display.contentWidth/2, --320
                    y = display.contentHeight*223/480,
                    width = 367*display.contentWidth/872,
                    height = 417*display.contentHeight/1508, 
                    defaultFile = "playbutton.png",
                    overFile = "playbuttonOver.png",
                    onEvent = handleplayEvent
                }

                sceneGroup:insert( playbutton )
              
                --playbutton.defaultFile ="waitbuttonOVER.png"
-- -----------------------------------------------------------------------------------------------------------------
-- tradehistbutt
-- -----------------------------------------------------------------------------------------------------------------


                local function handleplayEvent( event )

                    if ( "ended" == event.phase ) then
                        composer.gotoScene( "tradehistory" )
                    end
                end
                -- Create the widget
                local Balancebutton = widget.newButton
                {
                    x = display.contentWidth/2, --320
                    y = display.contentHeight*365/480,
                    width = 826*display.contentWidth/872,
                    height = 125*display.contentHeight/1508, 
                    defaultFile = "Balancebutton.png",
                    overFile = "BalancebuttonOver.png",
                    onEvent = handleplayEvent
                }
                sceneGroup:insert( Balancebutton )


-- -----------------------------------------------------------------------------------------------------------------
-- Optionsbutton
-- -----------------------------------------------------------------------------------------------------------------


                local function handleplayEvent( event )

                    if ( "ended" == event.phase ) then
                        
                        composer.gotoScene( "setup" )
                    end
                end
                -- Create the widget
                local Optionsbutton = widget.newButton
                {
                    x = display.contentWidth/2, --320
                    y = display.contentHeight*406/480,
                    width = 826*display.contentWidth/872,
                    height = 125*display.contentHeight/1508, 
                    defaultFile = "Optionsbutton.png",
                    overFile = "OptionsbuttonOver.png",
                    onEvent = handleplayEvent
                }
                sceneGroup:insert( Optionsbutton )


-- -----------------------------------------------------------------------------------------------------------------
-- Donatebutton
-- -----------------------------------------------------------------------------------------------------------------


                local function handleplayEvent( event )

                    if ( "ended" == event.phase ) then
                        print( "I understand and will be back in 2 hours" )
                        composer.gotoScene( "graph" )
                    end
                end
                -- Create the widget
                local Donatebutton = widget.newButton
                {
                    x = display.contentWidth/2, --320
                    y = display.contentHeight*446/480,
                    width = 826*display.contentWidth/872,
                    height = 125*display.contentHeight/1508, 
                    defaultFile = "Donatebutton.png",
                    overFile = "DonatebuttonOver.png",
                    onEvent = handleplayEvent
                }
                sceneGroup:insert( Donatebutton )
--                                     -- touch listener function
--                                        function Donatebutton:touch( event )
--                                            if event.phase == "began" then
--                                            
--                                                self.markX = self.x    -- store x location of object
--                                                self.markY = self.y    -- store y location of object
--                                            
--                                            elseif event.phase == "moved" then
--                                            
--                                                local x = (event.x - event.xStart) + self.markX
--                                                local y = (event.y - event.yStart) + self.markY
--                                                
--                                                print("x: " .. x .. " y: " .. y)--

--                                                self.x, self.y = x, y    -- move object based on calculations above--

--                                            end
--                                            
--                                            return true
--                                        end
--                                         
--                                        -- make 'myObject' listen for touch events
--                                        Donatebutton:addEventListener( "touch", Donatebutton )


-- -----------------------------------------------------------------------------------------------------------------
-- Display Balance
-- -----------------------------------------------------------------------------------------------------------------
                  local myNewData
                  local function networkListener_balance( event )
                          if ( event.isError ) then
                                  print( "Network error!")
                          else
                                   print("networkListener_balance ".. event.response)
                                  myNewData = event.response
                                  myNewData = tonumber(string.sub(myNewData,0, string.find (myNewData, "<script")-1))
                                  local Balancetext = display.newText( myNewData.." EUR", 222*display.contentWidth/320, 362*display.contentHeight/480, "Comic Sans MS", 50*display.contentHeight/1280 )
                                  Balancetext:setFillColor( 0, 0, 0)
                                  sceneGroup:insert( Balancetext )
                          end
                  end

                  network.request( "http://signumserwer2.home.pl/getbalance.php?userid="..mydata["userid"].."", "GET", networkListener_balance )
                  print ("http://signumserwer2.home.pl/getbalance.php?userid="..mydata["userid"].."")
-- -----------------------------------------------------------------------------------------------------------------
-- SQLLite
-- -----------------------------------------------------------------------------------------------------------------

                local sceneGroup = self.view
                local decodedData 
                --local pair = "EURJPY"
                local json = require ("json")
                require "sqlite3"



                local SaveData = function (pair)
                        --Include sqlite
                        
                        --Open data.db.  If the file doesn't exist it will be created
  
                         local path = system.pathForFile(mydata["sqlitefile"], system.DocumentsDirectory)
                         db = sqlite3.open( path ) 

                        --Handle the applicationExit event to close the db
                        local function onSystemEvent( event )
                                if( event.type == "applicationExit" ) then              
                                    db:close()
                                end
                        end
                         
                        --db:exec( [[drop table fxrateshist]] )
                        --local tablesetup = [[CREATE TABLE IF NOT EXISTS fxrateshist (id INTEGER PRIMARY KEY, pair, time, close);]]
                        --db:exec( tablesetup )
                        --print(tablesetup)


                      -- save  data to database
                          local counter = 1
                          local index = pair..counter
                          local histdata = decodedData[index]
                          local tablefill = "BEGIN TRANSACTION;"
                          --print(movie)
                          db:exec( [[delete from fxrateshist where pair = ']]..pair..[[']] )

                      while (histdata ~=nil) do

                          tablefill = tablefill ..[[INSERT INTO fxrateshist VALUES (NULL, ']]..pair..[[', NULL, ']]..histdata[2]..[[');]]
                          counter=counter+1
                                index = pair..counter
                                histdata = decodedData[index]
                      end      
                      
                      tablefill = tablefill.."COMMIT;"
                      --print(tablefill)
                      --print("Bedzie inset")
                      db:exec( tablefill )
                      print("insert "..pair.." done")
                      db:close()
                      mydata["graphupdates"] = mydata["graphupdates"]+1


                          if (mydata["graphupdates"]==3 and mydata["tradenow"] == 1) then
                            composer.gotoScene( "trade" )
                          end

                end

                  local function networkListener( event )
                          if ( event.isError ) then
                                  print( "Network error!")
                          else
                                  myNewData = event.response
                                  --print ("From server: "..myNewData)
                                  local  pairloc = string.sub(myNewData,5,10)
                                  --print ("From pairloc: "..pairloc)
                                  myNewData = string.sub(myNewData,11, string.find (myNewData, "<script")-1)
                                  --print ("From server change: ".. myNewData)
                                  decodedData = (json.decode( myNewData))
                          SaveData(pairloc)
                          end
                  end

                  --network.request( "http://signumserwer2.home.pl/gethist.php?pair="..pair, "GET", networkListener )
                  network.request( "http://signumserwer2.home.pl/gethist.php?pair=".."EURJPY", "GET", networkListener )
                  network.request( "http://signumserwer2.home.pl/gethist.php?pair=".."EURUSD", "GET", networkListener )
                  --network.request( "http://signumserwer2.home.pl/gethist.php?pair=".."USDJPY", "GET", networkListener )
                  network.request( "http://signumserwer2.home.pl/gethist.php?pair=".."EURGBP", "GET", networkListener )


                            --local json = require "json"

--
--local centerX = display.contentCenterX
--local centerY = display.contentCenterY
--local _W = display.contentWidth
--local _H = display.contentHeight
--
----display.setDefault( "anchorX", 0.0 )    -- default to TopLeft anchor point for new objects
----display.setDefault( "anchorY", 0.0 )
--
---- Add onscreen text
--
--print( "SQLite demo")
--print( "Creates or opens a local database, Data is shown below")
--
--
----Include sqlite
--require "sqlite3"
----Open data.db.  If the file doesn't exist it will be created
--local path = system.pathForFile("data.db", system.DocumentsDirectory)
--db = sqlite3.open( path )   
-- 
----Handle the applicationExit event to close the db
--local function onSystemEvent( event )
        --if( event.type == "applicationExit" ) then              
            --db:close()
        --end
--end
-- 
----db:exec( [[drop table fxrates]] )
----Setup the table if it doesn't exist
--local tablesetup = [[CREATE TABLE IF NOT EXISTS fxrates (id INTEGER PRIMARY KEY, pair, day, time, open, hight, low, close);]]
--print(tablesetup)
--db:exec( tablesetup )
-- 
--Add rows with a auto index in 'id'. You don't need to specify a set of values because we're populating all of them
--local testvalue = {
--
--
--testvalue[1] = 'Hello'
--testvalue[2] = 'World'
--testvalue[3] = 'Lua'
--local tablefill =[[INSERT INTO fxrates VALUES (NULL, ']]..testvalue[1]..[[',']]..testvalue[2]..[[',  NULL, NULL, NULL, NULL);]]
--local tablefill2 =[[INSERT INTO fxrates VALUES (NULL, ']]..testvalue[2]..[[',']]..testvalue[1]..[[',  NULL, NULL, NULL, NULL);]]
--local tablefill3 =[[INSERT INTO fxrates VALUES (NULL, ']]..testvalue[1]..[[',']]..testvalue[3]..[[',  NULL, NULL, NULL, NULL);]]
--print( tablefill )
--print(db:exec( tablefill ))
--print( tablefill2 )
--print(db:exec( tablefill2 ))
--print( tablefill3 )
--print(db:exec( tablefill3 ))


        --9db:exec( [[delete from fxrates]] )
--        for i = 1, #EURJPY do
--            if EURJPY[i*7-6] then
            --
--                --print( "Row", i, "value is:", testvalue[i*6-5], testvalue[i*6-4], testvalue[i*6-3], testvalue[i*6-2], testvalue[i*6-1], testvalue[i*6] )
--                --local tablefill =[[INSERT INTO fxrates VALUES (NULL, ']]..testvalue[i*7-6]..[[',']]..testvalue[i*7-5]..[[',']]..testvalue[i*7-4]..[[',']]..testvalue[i*7-3]..[[',']]..testvalue[i*7-2]..[[',']]..testvalue[i*7-1]..[[',']]..testvalue[i*7-0]..[[');]]
--                --local tablefill =[[INSERT INTO fxrates VALUES (NULL, ']]..EURJPY[i*7-6]..[[',']]..EURJPY[i*7-5]..[[',']]..EURJPY[i*7-4]..[[',']]..EURJPY[i*7-3]..[[',']]..EURJPY[i*7-2]..[[',']]..EURJPY[i*7-1]..[[',']]..EURJPY[i*7-0]..[[');]]
--                --print( tablefill )
--                --print(db:exec( tablefill ))
--                --db:exec( tablefill )
--            end
            --
            --
--        end


--db:exec( tablefill3 )

--db:exec( [[drop table fxrates]] )

 
--print the sqlite version to the terminal
--print( "version " .. sqlite3.version() )
--local numberofrows = 0 
-- --local mydata = require("mydata")
--
----print all the table contents
--for row in db:nrows("SELECT * FROM fxrates WHERE pair='EURJPY' ") do
--  local text = row.time.." "..row.open
--  print(text)
--  numberofrows = numberofrows +1
--  --mydata[numberofrows] = row.open
--  --print("numberofrows: " .. numberofrows.."mydata[row]: "..mydata[numberofrows])
--  --local t = display.newText(text, 20, 120 + (20 * row.id), native.systemFont, 16)
--  --t:setFillColor(1,0,1)
--end
--print ("numberofrows: "..numberofrows )

--print("mydata1: "..mydata[1])

--print(db:nrows("SELECT max(open) as max, min(open) as min FROM fxrates"))

--print all the table contents
--for row in db:nrows("SELECT max(open) as max, min(open) as min FROM fxrates") do
--  local text = row.min.." "..row.max
--  print(text)
--  --local t = display.newText(text, 20, 120 + (20 * row.id), native.systemFont, 16)
--  --t:setFillColor(1,0,1)
--end




--print(db:exec("SELECT max(row.open), min(row.open) FROM fxrates"))

--setup the system listener to catch applicationExit
--Runtime:addEventListener( "system", onSystemEvent )

            local function onSystemEvent( event )
            if event.type == "applicationExit" then
            if db and db:isopen() then
            db:close()
            end
            end
            end
            Runtime:addEventListener( "system", onSystemEvent )




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