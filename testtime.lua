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
            --db:exec( [[drop table trades]] )

            --local tablesetup = [[CREATE TABLE IF NOT EXISTS trades (id INTEGER PRIMARY KEY, pair, amount, time, openprice, closeprice, pnl);]]
            --local tablesetup = [[CREATE TABLE IF NOT EXISTS trades (id INTEGER PRIMARY KEY, pair, amount, open_time, openprice, close_time, closeprice, pnl);]]

            --db:exec( tablesetup )

            print("os.clock".. os.clock() )
            --`db:exec("INSERT INTO trades VALUES (NULL, 'EURUSD', 500, '7214', 'ASK:1.38359', NULL, NULL);" )
            --print(db:exec("INSERT INTO trades VALUES (NULL, 'EURUSD', -400, '1398500447', '1.38342', NULL,NULL, NULL);"))
           
            local date = os.date( "*t" )    -- returns table of date & time values
            print( date.year, date.month )  -- print year and month
            print( date.hour, date.min )    -- print hour and minutes
            print( date.sec,  date.msec )
--//
print("2014-04-22%2013:32:00")
print(date.year.."-"..date.month.."-"..date.day.." "..date.hour..":"..date.min..":"..date.sec)
    
            print( os.date( "%c" ) ) 
            print( os.date("%Y-%m-%dT%X%z") )

print("os.date: " .. os.date() ) 
print("os.time: " .. os.time() ) 

    
    print("os.time przerobiony: ".. os.date("%c", 1398425785))

    
            --print(os.clock())

            --db:exec( "delete from trades" )
            
            
                         local numberofrows = 0 
                          --for row in db:nrows("SELECT * FROM fxrateshist WHERE pair='EURJPY' ") do
                          for row in db:nrows("SELECT * FROM trades ") do
                            local text = row.id.." "..row.pair.." "..row.open_time.." "..row.openprice.." ".." "..row.amount
                            print(text)
                            print( "clock: ".. os.clock() )
                            print( "trade time: ".. row.open_time )
                            --print( "dif: ".. (os.clock()-row.time) )
                            numberofrows = numberofrows +1
                          end 
                          print ("numberofrows: "..numberofrows )



--                    function M.makeTimeStamp(dateString)
--                        local pattern = "(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)([%+%-])(%d+)%:(%d+)"
--                        local xyear, xmonth, xday, xhour, xminute, 
--                            xseconds, xoffset, xoffsethour, xoffsetmin = dateString:match(pattern)
--                        local convertedTimestamp = os.time({year = xyear, month = xmonth, 
--                            day = xday, hour = xhour, min = xminute, sec = xseconds})
--                        local offset = xoffsethour * 60 + xoffsetmin
--                        if xoffset == "-" then offset = offset * -1 end
--                        return convertedTimestamp + offset
--                    end
                    --This looks much scarier than it really is. The goal is to turn that string into a Unix timestamp (number of seconds since Jan 1, 1970, the standard used by most systems). So we use the string.match() method to fetch the various date and time parts into their own variables: xyear, xmonth,etc.
                    --Next we use the API call os.time() to convert all those individual parts into the timestamp. My code tries to adjust for time zones....
                    --Now you have the time in a nice integer that you can easily manipulate and do date math. Now to determine how many days have passed since that date:
--                    then = makeTimeStamp("2013-01-01T00:00:00Z")
--                    now = os.time()
--                    timeDifference = now - then
--                    daysDifference = math.floor(timeDifference / (24 * 60 * 60)) -- 24 hours, 60 min, 60 seconds.  I think it works out to 86400 seconds in a day or something like that...
--



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