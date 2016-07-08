local composer = require( "composer" )
local widget = require( "widget" )
local mydata = require("mydata")
--widget.setTheme( "widget_theme_android" )

local scene = composer.newScene()

function scene:create( event )

    local sceneGroup = self.view



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

            --print("SQL: "..db:nrows("SELECT * FROM config"))
            
            --row = db:first_row("SELECT value FROM config where variable = 'everydayrisk'")
            --print("velue1: "..row.id)

-- -----------------------------------------------------------------------------------------------------------------
-- get values
-- -----------------------------------------------------------------------------------------------------------------
                local everydayrisk
                local Hours_startIndex
                local starttime_startIndex
                local endtime_startIndex
                
                for row in db:nrows("SELECT value FROM config where variable = 'everydayrisk'") do
                    everydayrisk = row.value
                    print("everydayrisk: "..everydayrisk)              end 
                for row in db:nrows("SELECT value FROM config where variable = 'trade_every_in_sec'") do
                    Hours_startIndex =1+(row.value/60/60)
                    if (Hours_startIndex == 1) then
                        Hours_startIndex = 0
                    elseif (Hours_startIndex == 1.5) then
                        Hours_startIndex = 1
                    end
                    print( "Hours_startIndex: "..Hours_startIndex)              end 
                for row in db:nrows("SELECT value FROM config where variable = 'starttime_in_sec'") do
                    starttime_startIndex =row.value/60/60
                    print( "starttime_startIndex: "..starttime_startIndex)              end 
                for row in db:nrows("SELECT value FROM config where variable = 'endtime_in_sec'") do
                    endtime_startIndex = row.value/60/60
                    print("endtime_startIndex: "..endtime_startIndex)              end             



             local numberofrows = 0 
              --for row in db:nrows("SELECT * FROM fxrateshist WHERE pair='EURJPY' ") do
              for row in db:nrows("SELECT * FROM config ") do
                local text = row.id.." "..row.variable.." "..row.value--.." "..row.change_time
                print(text)
                numberofrows = numberofrows +1
              end 
              print ("numberofrows: "..numberofrows )


-- -----------------------------------------------------------------------------------------------------------------
-- wyglad
-- -----------------------------------------------------------------------------------------------------------------

        print("display.contentWidth: " .. display.contentWidth .. " display.contentHeight: " .. display.contentHeight)
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
        --local background = display.newImageRect( "background.png", 570, 360 )
        --sceneGroup:insert( background )
    --display.contentWidth, display.contentHeight     --1280x 720
    --local Setprofile = display.newText( "Set your profile!", 490, 70, native.systemFont, 40 )
            widget.setTheme( "widget_theme_ios7" )
            local background = display.setDefault( "background", 1, 1, 1 )

            local setuyourprofile = display.newImageRect("setuyourprofile.png", 861*display.contentWidth/872, 200*display.contentHeight/1508 )
            setuyourprofile.x = display.contentWidth*358/720
            setuyourprofile.y = display.contentHeight*85/1280
            sceneGroup:insert( setuyourprofile )

            local Risktext2 = display.newText( everydayrisk.." USD", display.contentWidth*60/320,  display.contentHeight*77/480, "Comic Sans MS", display.contentHeight*70/1280 )
            Risktext2:setFillColor( 0, 0, 0)
            sceneGroup:insert( Risktext2 )

            local risk_value = everydayrisk
            -- Slider listener
            local function sliderListener( event )
                print( "Slider at " .. event.value .. "%" )
                Risktext2.text = (event.value) .. " USD"
                risk_value =  (event.value)
            end

            -- Create the widget
            local slider = widget.newSlider
            {
                top = display.contentHeight*250/1280,
                left = display.contentWidth*50/720,
                width = display.contentWidth*600/720,
                orientation = "horizontal",
                value = everydayrisk,  -- Start slider at 10% (optional)
                listener = sliderListener
            }
            sceneGroup:insert(slider)


            local Tradeeverylabel = display.newImageRect("Tradeeverylabel.png", 860*display.contentWidth/872, 159*display.contentHeight/1508 )
            Tradeeverylabel.x = display.contentWidth*158/320
            Tradeeverylabel.y = display.contentHeight*162/480
            sceneGroup:insert( Tradeeverylabel )
                                                  -- touch listener function
                                        function Tradeeverylabel:touch( event )
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
                                        Tradeeverylabel:addEventListener( "touch", Tradeeverylabel )

---        local everytext = display.newText( "Trade every:", 100, 550, 130, 130, "Comic Sans MS", 40 )
---        everytext:setFillColor( 1, 0, 0 )
---        sceneGroup:insert( everytext )---

---        local everytext1 = display.newText( "Start at:", 350, 550, "Comic Sans MS", 40 )
---        everytext1:setFillColor( 1, 0, 0 )
---        sceneGroup:insert( everytext1 )---

---        local everytext2 = display.newText( "End at:", 600, 550, "Comic Sans MS", 40 )
---        everytext2:setFillColor( 1, 0, 0 )
---        sceneGroup:insert( everytext2 )


  
                local Hours = {}
                local starttime = {}
                local endtime = {}

                -- Populate the "Hours" table

                Hours[1] = "0 TurnOff"
                Hours[2] = "30 min"
                Hours[3] = "1 hour"

                for d = 4, 26 do
                    Hours[d] = d-2 .. " hours"
                end

                -- Populate the "starttime" table
                for y = 1, 10 do
                    starttime[y] = "0"..y-1 .. ":00"
                end
                for y = 11, 25 do
                    starttime[y] = y-1 .. ":00"
                end




                -- Configure the picker wheel columns
                local columnData = 
                {
                    -- Hours
                    {
                        align = "left",
                        --width = 100,
                        startIndex = Hours_startIndex+1,
                        labels = Hours
                    },
                    -- starttime
                    {
                        align = "center",
                        --width = 100,
                        startIndex = starttime_startIndex+1,
                        labels = starttime
                    },
                    -- endtime
                    { 
                        align = "left",
                        --width = 120,
                        startIndex = endtime_startIndex+1,
                        labels = starttime
                    }


                }


                -- Create the widget
                local pickerWheel = widget.newPickerWheel
                {
                    --top = display.contentHeight - 500,
                    top = display.contentHeight*0.4,
                    font = native.systemFontBold,
                    --fontSize = 30,
                    --columnColor = { 55, 250, 100, 255 },
                    columns = columnData,
                    --overlayFrameWidth = display.contentWidth,
                    --width = display.contentWidth,

                }
                sceneGroup:insert( pickerWheel )


-- -----------------------------------------------------------------------------------------------------------------
-- handleButtonEvent - I want to trade
-- -----------------------------------------------------------------------------------------------------------------


                local function handleButtonEvent( event )

                    if ( "ended" == event.phase ) then
                        print( "I want to trade! Button was pressed and released" )
                               
                                 
                                 print("risk: "..risk_value)
                                    

                                local values = pickerWheel:getValues()
                            -- Get the value for each column in the wheel (by column index)
                                local trade_every_value = values[1].value
                                local trade_every_in_sec
                                local starttime_value = values[2].value
                                local starttime_in_sec
                                local endtime_value = values[3].value
                                local endtime_in_sec

                                print( trade_every_value, starttime_value, endtime_value )
                                
                                --if (string.sub(Hours,0, string.find (Hours, " "))-1==30) then
                                --if (Hours == "30 min") then
                                -------------------------------------------------------------------------
                                ----risk_value
                                -------------------------------------------------------------------------
                                db = sqlite3.open( path )
                                print(db:exec("UPDATE config SET value="..risk_value..", change_time="..os.time().." WHERE variable='everydayrisk'; "))
                                mydata["everydayrisk"] = risk_value

                                -------------------------------------------------------------------------
                                ----trade_every_value
                                -------------------------------------------------------------------------
                                if ( string.sub(trade_every_value,0, string.find (trade_every_value, " ")-1)-30 == 0) then
                                    trade_every_in_sec = 0.5*60*60
                                else
                                    trade_every_in_sec = string.sub(trade_every_value,0, string.find (trade_every_value, " ")-1)*60*60
                                end
                                print("trade_every_in_sec:"..trade_every_in_sec)
                                print(db:exec("UPDATE config SET value="..trade_every_in_sec..", change_time="..os.time().." WHERE variable='trade_every_in_sec'; "))
                                mydata["trade_every_in_sec"] = trade_every_in_sec
                                -------------------------------------------------------------------------
                                ----starttime_value
                                -------------------------------------------------------------------------
                                if ( string.sub(starttime_value,0,1)=="0") then
                                    starttime_in_sec = string.sub(starttime_value,1,2)*60*60
                                else
                                    starttime_in_sec = string.sub(starttime_value,0,2)*60*60
                                end
                                print("starttime_in_sec:"..starttime_in_sec)
                                print(db:exec("UPDATE config SET value="..starttime_in_sec..", change_time="..os.time().." WHERE variable='starttime_in_sec'; "))
                                mydata["starttime_in_sec"] = starttime_in_sec
                                -------------------------------------------------------------------------
                                ----endtime_in_sec
                                -------------------------------------------------------------------------
                                if ( string.sub(endtime_value,0,1)=="0") then
                                    endtime_in_sec = string.sub(endtime_value,1,2)*60*60
                                else
                                    endtime_in_sec = string.sub(endtime_value,0,2)*60*60
                                end
                                print("endtime_in_sec:"..endtime_in_sec)
                                print(db:exec("UPDATE config SET value="..endtime_in_sec..", change_time="..os.time().." WHERE variable='endtime_in_sec'; "))
                                mydata["endtime_in_sec"] = endtime_in_sec


                            print(db:exec("UPDATE config SET value=1, change_time="..os.time().." WHERE variable='setupdone'; "))
                            mydata["setupdone"] = 1

                           

                            
                            if (mydata["lastscrean"] == "tadeconfirmation") then
                                composer.gotoScene( "tradeconfirmation" )
                            elseif (mydata["lastscrean"] == "welcomeplay") then
                                composer.gotoScene( "trade" )
                            else 
                                composer.gotoScene( "welcome" )
                            end

                    end
                end
                -- Create the widget
                local button1 = widget.newButton
                {

                    x = display.contentWidth/2,
                    y = display.contentHeight*1200/1280,
                    width = 621*display.contentWidth/872,
                    height = 130*display.contentHeight/1508, 
                    defaultFile = "Iwanttotrade.png",
                    overFile = "IwanttotradeOver.png",
                    onEvent = handleButtonEvent
                }
                sceneGroup:insert( button1 )





end

scene:addEventListener( "create", scene )

return scene