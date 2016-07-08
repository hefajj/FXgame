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

                local sceneGroup = self.view




-- -----------------------------------------------------------------------------------------------------------------
-- Pubnub
-- -----------------------------------------------------------------------------------------------------------------

              chat = pubnub.new({
                  publish_key   = "demo",
                  subscribe_key = "demo",
                  secret_key    = nil,
                  ssl           = nil,
                  origin        = "pubsub.pubnub.com"
              })
              CHAT_CHANNEL = 'dadasdasddargr45t4g4e4EURUSD'
              --message =''
              --message.msgtext =''

              function connect()
                  chat:subscribe({
                      channel  = CHAT_CHANNEL,
                      connect  = function()
                          --textout('Connected!')
                          print('Pubnub Connected!')
                      end,
                      callback = function(message)
                          --textout(message.msgtext)
                          if message.msgtext == nil then
                            print('Pubnub: '..message)
                          end
                      end,
                      error = function(message)
                          --textout(message or "Connection Error")
                          print("Pubnub: "..message or "pubnub: Connection Error")
                      end
                  })
              end


              function send_a_message(text)
                  chat:publish({
                      channel  = CHAT_CHANNEL,
                      message  = { msgtext = text },
                      callback = function(info)
                      end
                  })
              end

              function disconnect()
                  chat:unsubscribe({
                      channel = CHAT_CHANNEL
                  })
                  --textout('Disconnected!')
                   print('Pubnub: Disconnected!')
              end

              connect()
              --send_a_message("cosd kamial i------------- jidjasidjasi")

-- -----------------------------------------------------------------------------------------------------------------
--
-- -----------------------------------------------------------------------------------------------------------------

                -- local background = display.setDefault( "background", 1, 1, 1 )
                -- Initialize the scene here.
                -- Example: add display objects to "sceneGroup", add touch listeners, etc.

                      local sqlite3 = require ("sqlite3")
                      local myNewData 
                      local json = require ("json")
                      local decodedData 
                      local SaveData = function ()
                      --save new data to a sqlite file
                      -- open SQLite database, if it doesn't exist, create database
                        local path = system.pathForFile("movies.sqlite", system.DocumentsDirectory)
                        db = sqlite3.open( path ) 
                        print(path)
                      -- setup the table if it doesn't exist
                        local tablesetup = "CREATE TABLE IF NOT EXISTS mymovies (id INTEGER PRIMARY KEY, movie, year);"
                        db:exec( tablesetup )
                        print(tablesetup)
                      -- save  data to database
                          local counter = 1
                          local index = "movie"..counter
                          local movie = decodedData[index]
                          print(movie)
                      while (movie ~=nil) do
                          local tablefill ="INSERT INTO mymovies VALUES (NULL,'" .. movie[1] .. "','" .. movie[2] .."');"
                          print(tablefill)
                          db:exec( tablefill )
                          counter=counter+1
                                 index = "movie"..counter
                                     movie = decodedData[index]
                      end      
                      --   Everything is saved to SQLite database; close database
                          db:close()
                      --Load database contents to screen
                      -- open database  
                        local path = system.pathForFile("movies.sqlite", system.DocumentsDirectory)
                        db = sqlite3.open( path ) 
                        print(path)
                        --print all the table contents
                        local sql = "SELECT * FROM mymovies"
                        for row in db:nrows(sql) do
                                local text = row.movie.." "..row.year
                                local t = display.newText(text, 20, 30 * row.id, native.systemFont, 24)
                                t:setFillColor(255,255,255)
                        end    
                        db:close()
                      end
                      local function networkListener( event )
                              if ( event.isError ) then
                                      print( "Network error!")
                              else
                                      myNewData = event.response
                                      print ("From server: "..myNewData)
                                      myNewData = string.sub(myNewData,0, string.find (myNewData, "<script")-1)
                                      print ("From server change: ".. myNewData)
                                      decodedData = (json.decode( myNewData))
                          SaveData()
                              end
                      end

                            network.request( "http://signumserwer2.home.pl/sql.php", "GET", networkListener )

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