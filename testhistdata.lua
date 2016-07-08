local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()
require "pubnub.pubnub"
require "pubnub.PubnubUtil"

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------


            -- "scene:create()"
            function scene:create( event )




                        --local t = display.newText("poczatek", 20, 80, null, 16)
                        --t:setFillColor( 1, 0, 1 )

----local sqlite3 = require "sqlite3"
----
------Open data.db.  If the file doesn't exist it will be created
----local path = system.pathForFile("data4.db", system.DocumentsDirectory)
----db = sqlite3.open( path )      
----
----db:exec[[
----  CREATE TABLE test (id INTEGER PRIMARY KEY, content);
----  INSERT INTO test VALUES (NULL, 'Hello World');
----  INSERT INTO test VALUES (NULL, 'Hello Lua');
----  INSERT INTO test VALUES (NULL, 'Hello Sqlite3');
----  INSERT INTO test VALUES (NULL, 'Hello World');
----  INSERT INTO test VALUES (NULL, 'Hello Lua');
----  INSERT INTO test VALUES (NULL, 'Hello Sqlite3');
----  INSERT INTO test VALUES (NULL, 'Hello World');
----
----]]
----
----for i=1,50 do
----  print(i)
----  db:exec[[
  ----
----  INSERT INTO test VALUES (NULL, 'Hello World');
----  INSERT INTO test VALUES (NULL, 'Hello Lua');
----  INSERT INTO test VALUES (NULL, 'Hello Sqlite3')
----]]
----end
----print( "version " .. sqlite3.version() )
----
----for row in db:nrows("SELECT * FROM test") do
----  print(row.content)
  ----
----end
                --local pair = "EURJPY"


                local sceneGroup = self.view
                local decodedData 
                local pair = "EURJPY"
                local json = require ("json")


                local SaveData = function (pair)
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
                         
                        --db:exec( [[drop table fxrateshist]] )
                        --Setup the table if it doesn't exist
                        --local tablesetup = [[CREATE TABLE IF NOT EXISTS fxrateshist (id INTEGER PRIMARY KEY, sourceid, pair, day, time, open, hight, low, close);]]
                        local tablesetup = [[CREATE TABLE IF NOT EXISTS fxrateshist (id INTEGER PRIMARY KEY, pair, time, close);]]
                        db:exec( tablesetup )
                        print(tablesetup)


                      -- save  data to database
                          local counter = 1
                         
                          local index = pair..counter
                          local histdata = decodedData[index]
                          local tablefill = "BEGIN TRANSACTION;"
                          --print(movie)
                          db:exec( [[delete from fxrateshist where pair = ']]..pair..[[']] )

                      while (histdata ~=nil) do

                          --tablefill = tablefill ..[[INSERT INTO fxrateshist VALUES (NULL, ']]..histdata[1]..[[',']]..pair..[[', NULL,  NULL,NULL, NULL, NULL, ']]..histdata[2]..[[');]]
                          tablefill = tablefill ..[[INSERT INTO fxrateshist VALUES (NULL, ']]..pair..[[', NULL, ']]..histdata[2]..[[');]]
                          --tablefill = [[INSERT INTO fxrateshist VALUES (NULL, ']]..histdata[1]..[[',']]..pair..[[');]]
                          --print(tablefill)
                          --db:exec( tablefill )
                          counter=counter+1
                                index = pair..counter
                                histdata = decodedData[index]
                      end      
                      
                      tablefill = tablefill.."COMMIT;"
                      --print(tablefill)
                      print("Bedzie inset")
                      db:exec( tablefill )
                      print("insert done")

--                       local t = display.newText("insert done", 20, 30, null, 16)
--                       t:setFillColor( 1, 0, 1 )
                      --   Everything is saved to SQLite database; close database
                      -- db:close()
                      --Load database contents to screen
                      -- open database  

--- PRINT DATA
--                        local path = system.pathForFile("movies.sqlite", system.DocumentsDirectory)
--                        db = sqlite3.open( path ) 
--                        print(path)
--                        --print all the table contents
                          local numberofrows = 0 
                          --for row in db:nrows("SELECT * FROM fxrateshist WHERE pair='EURJPY' ") do
                          for row in db:nrows("SELECT * FROM fxrateshist ") do
                            local text = row.id.." "..row.pair.." "..row.close
                            print(text)
                            numberofrows = numberofrows +1
                          end 
                          print ("numberofrows: "..numberofrows )

                    db:close()
                  end

                  local function networkListener( event )
                          if ( event.isError ) then
                                  print( "Network error!")
                          else
                                  myNewData = event.response
                                  print ("From server: "..myNewData)
                                  local  pairloc = string.sub(myNewData,5,10)
                                  print ("From pairloc: "..pairloc)
                                  myNewData = string.sub(myNewData,11, string.find (myNewData, "<script")-1)
                                  print ("From server change: ".. myNewData)
                                  decodedData = (json.decode( myNewData))
                          SaveData(pairloc)
                          end
                  end

                  --network.request( "http://signumserwer2.home.pl/gethist.php?pair="..pair, "GET", networkListener )
                  network.request( "http://signumserwer2.home.pl/gethist.php?pair=".."EURJPY", "GET", networkListener )
                  network.request( "http://signumserwer2.home.pl/gethist.php?pair=".."EURUSD", "GET", networkListener )
                  network.request( "http://signumserwer2.home.pl/gethist.php?pair=".."USDJPY", "GET", networkListener )

                            --local json = require "json"

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