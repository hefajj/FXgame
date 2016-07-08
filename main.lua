------------------------------------------------------------------------

local composer = require( "composer" )
local mydata = require("mydata")
mydata["sqlitefile"] = "data12.db"

--local pathdelet = system.pathForFile("data10.db", system.DocumentsDirectory)
--print(os.remove(pathdelet))
local launchArgs = ...

if launchArgs and launchArgs.notification then
    --[[ if the application got launched as a result of the user viewing a notification, the notification table contains:

    launchArgs.notification.type - "remote"
    launchArgs.notification.name - "notification"
    launchArgs.notification.sound - "sound file or 'default'"
    launchArgs.notification.alert - "message specified during push"
    launchArgs.notification.badge - "5" -- badge value that was sent
    launchArgs.notification.applicationstate - "inactive"

    --]]
end


require "sqlite3"
local path = system.pathForFile(mydata["sqlitefile"], system.DocumentsDirectory)
db = sqlite3.open( path )   

---print("os.date(os.time(): "..os.date("%c", os.time()))
---  funkcja robiąca wszystkie tabele, indeksy oraz defailtowe zmienne w config

function setupvariables()
            --print(db:exec( [[drop table config]] ))
            print("createobjects")
            --local tablesetup = [[CREATE TABLE IF NOT EXISTS config (id INTEGER PRIMARY KEY, variable, value, change_time INTEGER );]]
            --db:exec(tablesetup)
            local tablesetup = [[CREATE TABLE IF NOT EXISTS config (id INTEGER PRIMARY KEY, variable, value, change_time INTEGER );]]
            db:exec(tablesetup)
             --print(db:exec("INSERT INTO config VALUES(1,'test',0, null) "))
             --print(db:exec("SELECT 1 FROM config WHERE id = 1"))
             --print(db:exec("SELECT 'dasad', 1, 'dasdas'"))
             print(db:exec("INSERT INTO config  select null,'everydayrisk',10, "..os.time().." WHERE NOT EXISTS (SELECT 1 FROM config WHERE variable = 'everydayrisk')"))
             print(db:exec("INSERT INTO config  select null,'trade_every_in_sec',7200, "..os.time().." WHERE NOT EXISTS (SELECT 1 FROM config WHERE variable = 'trade_every_in_sec')"))
             print(db:exec("INSERT INTO config  select null,'starttime_in_sec',28800, "..os.time().." WHERE NOT EXISTS (SELECT 1 FROM config WHERE variable = 'starttime_in_sec')"))
             print(db:exec("INSERT INTO config  select null,'endtime_in_sec',68400, "..os.time().." WHERE NOT EXISTS (SELECT 1 FROM config WHERE variable = 'endtime_in_sec')"))
             print(db:exec("INSERT INTO config  select null,'setupdone',0, "..os.time().." WHERE NOT EXISTS (SELECT 1 FROM config WHERE variable = 'setupdone')"))
             
            print(db:exec("CREATE UNIQUE INDEX IF NOT EXISTS config_ind ON config(variable);"))
            --print(db:exec("DROP INDEX config_ind;"))
            
             --print(db:exec( [[drop table trades]] ))
            local tabletrades = [[CREATE TABLE IF NOT EXISTS trades (id INTEGER PRIMARY KEY, pair, amount, open_time, openprice, close_time, closeprice, pnl, sl, tp, max_open);]]
            print(db:exec( tabletrades ))
            print(db:exec("INSERT INTO trades VALUES (NULL, 'EURUSD', 200, '1398500447', '1.38342', NULL,NULL, NULL);"))
            print(db:exec("INSERT INTO trades VALUES (NULL, 'EURUSD', 400, '1398500447', '1.38342', NULL,NULL, NULL);"))

            --db:exec( [[drop table fxrateshist]] )
            local tablefxrateshist = [[CREATE TABLE IF NOT EXISTS fxrateshist (id INTEGER PRIMARY KEY, pair, time, close);]]
            print(db:exec( tablefxrateshist ))
            --print(tablesetup)

                        --print(db:exec( [[drop table config]] ))


            --print(db:exec("INSERT OR REPLACE INTO config(value, variable) values ("..os.time()..", 'nexttrades')"))
            --print(db:exec("Delete from config where variable ='nexttrades'"))
            mydata["nexttrades"] = os.time() - 50
            mydata["graphupdates"] = 0
            mydata["tradenow"] = 0


            print("os.time(): "..os.time())

            for row in db:nrows("SELECT value FROM config where variable = 'nexttrades'") do
                mydata["nexttrades"] = tonumber(row.value)
                print("nexttrades: "..mydata["nexttrades"])
            end

            for row in db:nrows("SELECT value FROM config where variable = 'everydayrisk'") do
                mydata["everydayrisk"] = tonumber(row.value)
                print("everydayrisk: "..mydata["everydayrisk"])
            end

            for row in db:nrows("SELECT value FROM config where variable = 'trade_every_in_sec'") do
                mydata["trade_every_in_sec"] = tonumber(row.value)
                print("trade_every_in_sec: "..mydata["trade_every_in_sec"])
            end

            for row in db:nrows("SELECT value FROM config where variable = 'starttime_in_sec'") do
                mydata["starttime_in_sec"] = tonumber(row.value)
                print("starttime_in_sec: "..mydata["starttime_in_sec"])
            end

            for row in db:nrows("SELECT value FROM config where variable = 'endtime_in_sec'") do
                mydata["endtime_in_sec"] = tonumber(row.value)
                print("endtime_in_sec: "..mydata["endtime_in_sec"])
            end

            for row in db:nrows("SELECT value FROM config where variable = 'setupdone'") do
                mydata["setupdone"] = tonumber(row.value)
                print("setupdone: "..mydata["setupdone"])
            end


            print("mydata[nexttrades]: "..mydata["nexttrades"])

            if not (mydata["userid"]) then
                for row in db:nrows("SELECT value FROM config where variable = 'userid'") do
                    mydata["userid"] = row.value
                end
                if not (mydata["userid"]) then
                    print("brak userid w bazie")
                    print(db:exec("INSERT INTO config select null,'userid','"..system.getInfo( "deviceID" ).."', "..os.time().." WHERE NOT EXISTS (SELECT 1 FROM config WHERE variable = 'userid')"))
                    for row in db:nrows("SELECT value FROM config where variable = 'userid'") do
                        mydata["userid"] = row.value end
                end
                print( "userid: "..mydata["userid"]) 
            end  
            --mydata["userid"] = "3232dxs2d2d23"



            composer.setVariable( "numberoftrades", 3)
            --composer.setVariable( "numberoftrades", 3 )
            -- Code to initialize your app
end


setupvariables()



            --Handle the applicationExit event to close the db
            local function onSystemEvent( event )
                    if( event.type == "applicationExit" ) then              
                        db:close()
                    end
            end



-- Assumes that "scene1.lua" exists and is configured as a Composer scene
if ((mydata["nexttrades"]-os.time()-5000)>0) then
	print("sec to next trade: "..mydata["nexttrades"]-os.time())
	composer.gotoScene( "quit" )
else 
--
--composer.gotoScene( "welcome" )
--composer.gotoScene( "test3" )
--composer.gotoScene( "trade" )
--composer.gotoScene( "tradeconfirmation" )
composer.gotoScene( "tradehistory" )
--composer.gotoScene( "testtime" )
--composer.gotoScene( "setup" )
--composer.setVariable( "numberoftrades", 4 )

--composer.gotoScene( "calendar" )

end
--composer.setVariable( "numberoftrades", 4 )
-- Code to initialize your app


