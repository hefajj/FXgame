local composer = require( "composer" )
local widget = require( "widget" )
widget.setTheme( "widget_theme_ios7" )

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
    local background = display.setDefault( "background", 1, 1, 1 )
    local mydata = require("mydata")
    local pair = "EURUSD"
    local button1
    local totherlefttrade
    local totherighttrade
  


    if (composer.getVariable( "numberoftrades" ) == 3) then
        pair = "EURUSD"
    elseif (composer.getVariable( "numberoftrades" ) == 2) then
        pair = "EURJPY"
    elseif (composer.getVariable( "numberoftrades" ) == 1) then
        pair = "EURGBP"
    else 
        pair = "EURUSD"
    end

-- -----------------------------------------------------------------------------------------------------------------
-- topframe
-- -----------------------------------------------------------------------------------------------------------------


            local topframe = display.newImageRect("topframe.png", 860*display.contentWidth/872, 186*display.contentHeight/1508 )
            topframe.x = display.contentWidth*358/720
            topframe.y = display.contentHeight*85/1280
            sceneGroup:insert( topframe )



-- -----------------------------------------------------------------------------------------------------------------
-- TOP timer
-- -----------------------------------------------------------------------------------------------------------------
    

      timertext = display.newText( "5 sec", 180*display.contentWidth/720, 70*display.contentHeight/1280, native.systemFontBold, 100*display.contentHeight/1280 )
      timertext:setFillColor( 0, 0, 0 )
      sceneGroup:insert( timertext )

      function timertext:timer( event )
        
        local count = event.count

        --print( "Table listener called " .. count .. " time(s)" )
        self.text = 5-count .. " sec"

        if count >= 5 then
          print( "koniec" )
          timer.cancel( event.source ) -- after the 20th iteration, cancel timer
        end
      end

      -- Register to call t's timer method 50 times
      timerID = timer.performWithDelay( 1000, timertext, 50 )

-- -----------------------------------------------------------------------------------------------------------------
-- display rates
-- -----------------------------------------------------------------------------------------------------------------

            local BIDratext = display.newText( "", 35*display.contentWidth/320, 450*display.contentHeight/480, "Comic Sans MS", 25*display.contentHeight/1280 )
            BIDratext:setFillColor( 0, 0, 0)
            sceneGroup:insert( BIDratext )


            local ASKratext = display.newText( "", 226*display.contentWidth/320, 450*display.contentHeight/480, "Comic Sans MS", 25*display.contentHeight/1280 )
            ASKratext:setFillColor( 0, 0, 0)
            sceneGroup:insert( ASKratext )

-- -----------------------------------------------------------------------------------------------------------------
-- handle trade events
-- -----------------------------------------------------------------------------------------------------------------
                local stoploss
                local takeprofit
                local tradetime
                local nexttradetime
                local rate
                local amount
                local rate



                  local function networkListener( event )
                          if ( event.isError ) then
                                  print( "Network error!")
                          else
                                  myNewData = event.response
                                  myNewData = tonumber(string.sub(myNewData,0, string.find (myNewData, "<script")-1))
                                  amount = tonumber(myNewData)
                                  print ("amount: "..amount)

                                  local tablefill = [[INSERT INTO trades VALUES (NULL, ']]..pair..[[',']]..amount..[[', ']]..tradetime..[[', ']]..rate..[[', NULL,NULL, NULL,]]..stoploss..[[, ]]..takeprofit..[[, null);]]
                                  print(tablefill)
                                  print(db:exec( tablefill ))

                                  nextstep ()
                                  --print("wyslano trade, odpowiedz: "..string.sub(myNewData,0, string.find (myNewData, "<script")-1))
                          end
                  end

                local function handletotherighttradeEvent( event )

                    if ( "ended" == event.phase ) then

       --     local tablesetup = [[CREATE TABLE IF NOT EXISTS trades (id INTEGER PRIMARY KEY, pair, amount, time, openprice, closeprice, pnl);]]
                      
                      aftertraderemovebuttons()

                      stoploss= string.sub(ASKratext.text,5,15)
                      stoploss = math.round((stoploss -(stoploss*0.003))*100000)*0.00001
                      takeprofit= string.sub(ASKratext.text,5,15)
                      takeprofit = math.round((takeprofit +(takeprofit*0.003))*100000)*0.00001
                      tradetime = os.time()
                      nexttradetime = mydata["trade_every_in_sec"]-60
                      rate = string.sub(ASKratext.text,5,15)
                      amount = 500

                      --local tablefill = [[INSERT INTO trades VALUES (NULL, ']]..pair..[[', 500, ']]..tradetime..[[', ']]..string.sub(ASKratext.text,5,15)..[[',NULL, NULL, NULL,]]..stoploss..[[, ]]..takeprofit..[[, null);]]
                      --print(tablefill)
                      --print(db:exec( tablefill ))
                      network.request( "http://signumserwer2.home.pl/savetrade.php?userid="..mydata["userid"].."&tradeid=fsd&pair="..pair.."&amount="..amount.."&open_time="..tradetime.."&openprice="..rate.."&maxopen="..nexttradetime.."&everydayrisk="..mydata["everydayrisk"].."&trade_every_in_sec="..mydata["trade_every_in_sec"].."&starttime_in_sec="..mydata["starttime_in_sec"].."&endtime_in_sec="..mydata["endtime_in_sec"].."", "GET", networkListener )
                      

                    end
                end

                local function handletotheleftotradeEvent( event )

                    if ( "ended" == event.phase ) then
                        aftertraderemovebuttons()

                        stoploss= string.sub(ASKratext.text,5,15)
                        stoploss = math.round((stoploss +(stoploss*0.003))*100000)*0.00001
                        takeprofit= string.sub(ASKratext.text,5,15)
                        takeprofit = math.round((takeprofit -(takeprofit*0.003))*100000)*0.00001
                        amount = -500
                        --math.randomseed()
                        --print(math.random()) 
                        tradetime = os.time()
                        nexttradetime = mydata["trade_every_in_sec"]-60
                        rate = string.sub(BIDratext.text,5,15)
                        --local tablefill = [[INSERT INTO trades VALUES (NULL, ']]..pair..[[', -500, ']]..tradetime..[[', ']]..rate..[[', NULL,NULL, NULL,]]..stoploss..[[, ]]..takeprofit..[[, null);]]
                        --print(tablefill)
                        --print(db:exec( tablefill ))

                        network.request( "http://signumserwer2.home.pl/savetrade.php?userid="..mydata["userid"].."&tradeid=fsd&pair="..pair.."&amount="..amount.."&open_time="..tradetime.."&openprice="..rate.."&maxopen="..nexttradetime.."&everydayrisk="..mydata["everydayrisk"].."&trade_every_in_sec="..mydata["trade_every_in_sec"].."&starttime_in_sec="..mydata["starttime_in_sec"].."&endtime_in_sec="..mydata["endtime_in_sec"].."", "GET", networkListener )
                     end

                end
--                local date = os.date( "*t" )    -- returns table of date & time values
--              print( date.year, date.month )  -- print year and month
--              print( date.hour, date.min ) 
--              print( system.getTimer() ) 


                local function handleskiptradeEvent( event )

                    if ( "ended" == event.phase ) then
                        aftertraderemovebuttons()
                        tradetime = os.time()
                        amount = 0
                        nexttradetime = mydata["trade_every_in_sec"]-60
                        stoploss = 0
                        takeprofit = 0
                        rate = 0
                        --local tablefill = [[INSERT INTO trades VALUES (NULL, ']]..pair..[[', 0, ']]..tradetime..[[', 0,  0, 0, 0, 0, 0,0);]]
                        --print(tablefill)
                        --db:exec( tablefill )
                        
                        network.request( "http://signumserwer2.home.pl/savetrade.php?userid="..mydata["userid"].."&tradeid=fsd&pair="..pair.."&amount=0&open_time="..tradetime.."&maxopen="..nexttradetime.."", "GET", networkListener )
                     end
                end

                function aftertraderemovebuttons()
                        button1:removeSelf()
                        totherlefttrade:removeSelf()
                        totherighttrade:removeSelf()
                        BIDratext:removeSelf()
                        ASKratext:removeSelf()
                        --cancel( timerID )
                        --timer.cancel(timerID)
                        timertext:removeSelf()
                        topframe:removeSelf()
                        topframe = display.newImageRect("topframe_wait.png", 860*display.contentWidth/872, 186*display.contentHeight/1508 )
                        topframe.x = display.contentWidth*358/720
                        topframe.y = display.contentHeight*85/1280
                        sceneGroup:insert( topframe )
                end

                function nextstep()
                             composer.setVariable( "numberoftrades",composer.getVariable( "numberoftrades" )-1 )

                             if (composer.getVariable( "numberoftrades" ) == 0) then
                                    print("Zrobiono wszystkie deale" )

                                    -- -----------------------------------------------------------------------------------------------------------------
                                    -- Zapamietej czas nastepnych deali
                                    mydata["nexttrades"] = os.time()+mydata["trade_every_in_sec"]
                                    print("INSERT OR REPLACE INTO config(value, variable) values ("..mydata["nexttrades"]..", 'nexttrades')")
                                    print(db:exec("INSERT OR REPLACE INTO config(value, variable) values ("..mydata["nexttrades"]..", 'nexttrades')"))

                                    -- -----------------------------------------------------------------------------------------------------------------
                                    -- Ustaw notyfikacje
                                        system.cancelNotification()

                                        local futureTime = tonumber(mydata["trade_every_in_sec"])--1 * 30  --9 minute alarm "snooze"
                                        local options = {
                                            alert = "It is time to trade!",
                                            --badge = native.getProperty( "applicationIconBadgeNumber" ) + 1,
                                            --sound = "alarm.caf",
                                            custom = { msg = "Alarm" }
                                        }
                                        local notificationID = system.scheduleNotification( futureTime, options )

                                      timertext2 = display.newText( "ustawiono notyfikacje", 180*display.contentWidth/720, 300*display.contentHeight/1280, native.systemFontBold, 100*display.contentHeight/1280 )
                                      timertext2:setFillColor( 0, 0, 0 )
                                      sceneGroup:insert( timertext2 )

                                      print("timer.performWithDelay(")
                                  timer5 = timer.performWithDelay( 2000, composer.removeScene( "trade", true )) 
                                  timer2 =timer.performWithDelay( 2000, composer.gotoScene( "tradeconfirmation" ))
                            else
                                    print("Nastepny deal" )
                                    composer.removeScene( "trade", true )
                                    composer.gotoScene( "trade" )  
                            end
                end



                --network.request( "http://signumserwer2.home.pl/savetrade.php?userid=fd&tradeid=fsd&pair=EURUSD&amount=-500&open_time=3232&openprice=3.1212&sl=2.3232&tp=2.3323&maxopen=323223", "GET", networkListener )
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
            --print(db:exec( [[drop table trades]] ))
            --local tablesetup = [[CREATE TABLE IF NOT EXISTS trades (id INTEGER PRIMARY KEY, pair, amount, open_time, openprice, close_time, closeprice, pnl, sl, tp, max_open);]]


            --print(db:exec( tablesetup ))
            --print(db:exec("INSERT INTO trades VALUES (NULL, 'EURUSD', 200, '1398500447', '1.38342', NULL,NULL, NULL);"))
            --print(db:exec("INSERT INTO trades VALUES (NULL, 'EURUSD', 400, '1398500447', '1.38342', NULL,NULL, NULL);"))

            
            if not (mydata["trade_every_in_sec"]) then
                  for row in db:nrows("SELECT value FROM config where variable = 'trade_every_in_sec'") do
                    mydata["trade_every_in_sec"] = row.value
                    end
                    print( "trade_every_in_sec: "..mydata["trade_every_in_sec"]) 
              end  
              

            



-- -----------------------------------------------------------------------------------------------------------------
-- fxgraph
-- -----------------------------------------------------------------------------------------------------------------
   
            math.randomseed(os.time() )

            local fxgraph = display.newLine()
            sceneGroup:insert( fxgraph )
            local maxrate=0
            local minrate=0

            for row in db:nrows("SELECT max(close) as max, min(close) as min FROM fxrateshist where pair ='"..pair.."' ") do
              maxrate = row.max
              minrate = row.min
              
              local text = "row.min: "..minrate.." row.max: "..maxrate
              --print(text)
            end

            local numberofrows = 0 
            --print all the table contents
            for row in db:nrows("SELECT * FROM fxrateshist WHERE pair='"..pair.."' ORDER BY ID  DESC;") do
              local text = row.close
              --print(text)
              numberofrows = numberofrows +1
                    fxgraph:append( 

                    display.contentWidth*(1-(((maxrate - minrate)-(row.close-minrate))/(maxrate - minrate)))*0.9+display.contentWidth*0.05, 
                    display.contentHeight*0.64*(0.009*numberofrows)+display.contentHeight*0.16
                                                                                            --0.016 - co taki odsetek wyświetlamy nowy punkt
                    )

            end
            print ("numberofrows: "..numberofrows )



            fxgraph:setStrokeColor( 1, 0, 0, 1 )
            fxgraph.strokeWidth = 8*display.contentHeight/1280





-- -----------------------------------------------------------------------------------------------------------------
-- Pubnub
-- -----------------------------------------------------------------------------------------------------------------
            local pairchannel = 'dadasdasddargr45t4g4e4'..pair



              pubnub_obj = pubnub.new({
                  publish_key   = "demo",
                  subscribe_key = "demo",
                  secret_key    = nil,
                  ssl           = nil,
                  origin        = "pubsub.pubnub.com"
              })
              --CHAT_CHANNEL = 'dadasdasddargr45t4g4e4EURJPY'
              --message =''
              --message.msgtext =''
                function history(channel, count, reverse)
                    pubnub_obj:history({
                        channel = pairchannel,
                        count = count,
                        reverse = reverse,
                        callback = function(response)
                            --textout(response)
                            print('Pubnub Histor: '.. response[1][1])
                            --print('Pubnub Histor: '..response[1][2])
                            --print('Pubnub Histor: '..response[1][3])
                            ASKratext.text = "ASK:"..string.sub(response[1][1],string.find (response[1][1], ";")+1)
                            BIDratext.text = "BID:"..string.sub(response[1][1],0, string.find (response[1][1], ";")-1)
                                                     -- if message.msgtext == nil then
--                            print('Pubnub: '..message)

                                -- -----------------------------------------------------------------------------------------------------------------
                                -- trade buttons
                                -- -----------------------------------------------------------------------------------------------------------------
                                   

                                                -- Create the widget
                                                totherighttrade = widget.newButton
                                                {
                                                    x = display.contentWidth-display.contentWidth/5,
                                                    y = display.contentHeight*0.9,
                                                    labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
                                                    fontSize = display.contentWidth/20,
                                                    font = native.systemFontBold,
                                                    id = "trade",
                                                    label = "It will go right >>>",
                                                    onEvent = handletotherighttradeEvent
                                                }
                                                sceneGroup:insert( totherighttrade )


                                                -- Create the widget
                                                totherlefttrade = widget.newButton
                                                {
                                                    x = display.contentWidth/5,
                                                    y = display.contentHeight*0.9,
                                                    labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
                                                    fontSize = display.contentWidth/20,
                                                    font = native.systemFontBold,
                                                    id = "trade",
                                                    label = "<<< It will go left",
                                                    onEvent = handletotheleftotradeEvent
                                                }
                                                sceneGroup:insert( totherlefttrade )
                                -- -----------------------------------------------------------------------------------------------------------------
                                -- Skip trade button
                                -- -----------------------------------------------------------------------------------------------------------------
                                    


                                                -- Create the widget
                                                button1 = widget.newButton
                                                {
                                                    x = display.contentWidth-display.contentWidth/5,
                                                    y = display.contentHeight*0.03,
                                                    labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
                                                    fontSize = display.contentWidth/30,
                                                    font = native.systemFontBold,

                                                    id = "trade",
                                                    label = "SKIP THIS TRADE!",
                                                    onEvent = handleskiptradeEvent
                                                }
                                                
                                                sceneGroup:insert( button1 )



                            
                        end,
                        error = function (response)
                            ---textout(response)
                            print("Pubnub: "..response or "pubnub: Connection Error")
                        end
                    })
                end

                history( pairchannel, 1, false )


                              --ASKratext.text = "ASK:"..string.sub(message,string.find (message, ";")+1)
                              --BIDratext.text = "BID:"..string.sub(message,0, string.find (message, ";")-1)
              function subscribe( channel )
                  pubnub_obj:subscribe({
                      channel = channel,
                      connect = function()
                          print('Connected to channel ')
                          print(channel)
                      end,
                      callback = function(message)
                          --print(message)
                          ASKratext.text = "ASK:"..string.sub(message,string.find (message, ";")+1)
                          BIDratext.text = "BID:"..string.sub(message,0, string.find (message, ";")-1)
                          --print("wiadomosc")
                          --textout(message)
                           -- if message.msgtext == nil then
                            --if message ~= "" then
--                                print('Pubnub split find: '..string.find (message, ";"))
--                                print('Pubnub string.sub: '..string.sub(message,0,5))    
                            --end
                      end,
                      error = function()
                          textout("Oh no!!! Dropped 3G Conection!")
                      end,

                  })
              end


              function send_a_message(text)
                  pubnub_obj:publish({
                      channel  = CHAT_CHANNEL,
                      message  = { msgtext = text },
                      callback = function(info)
                      end
                  })
              end

              function disconnect()
                  pubnub_obj:unsubscribe({
                      channel = CHAT_CHANNEL
                  })
                  --textout('Disconnected!')
                   print('Pubnub: Disconnected!')
              end

              subscribe(pairchannel)
              --send_a_message("cosd kamial i------------- jidjasidjasi")





        local Risktext = display.newText( pair.." 1m chart:", 100*display.contentWidth/720, 180*display.contentHeight/1280, "Comic Sans MS", 25*display.contentHeight/1280 )
        Risktext:setFillColor( 0, 0, 0)
        sceneGroup:insert( Risktext )





-- -----------------------------------------------------------------------------------------------------------------
-- fxgraph
-- -----------------------------------------------------------------------------------------------------------------
    
--			math.randomseed(os.time() )
--			print(math.random(100, 300)) 
--
--			local fxgraph = display.newLine()
--			sceneGroup:insert( fxgraph )
--			fxgraph:append( 
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
--
--
--            fxgraph:setStrokeColor( 1, 0, 0, 1 )
--            fxgraph.strokeWidth = 8*display.contentHeight/1280



				--local myRoundedRect = display.newRoundedRect( 0, 0, 150, 50, 12 )
				--myRoundedRect.strokeWidth = 3
				--myRoundedRect:setFillColor( 0.5 )
				--myRoundedRect:setStrokeColor( 1, 0, 0 )


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