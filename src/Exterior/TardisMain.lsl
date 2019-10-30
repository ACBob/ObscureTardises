/*
 *   Obscure Tardises' Exterior Main file
 *   Copyright (C) 2019  EthbotBot

 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU Affero General Public License as published
 *   by the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.

 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Affero General Public License for more details.
 *
 *   You should have received a copy of the GNU Affero General Public License
 *   along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

#include "IDs.lsl"

integer Landed = FALSE;
integer canLand = TRUE;

integer listenHandle;

string consoleUrl;

vector ConsolePosition;
string ConsoleRegion;

#include "TardisActions.lsl"

RequestConsole(){
    llHTTPRequest(consoleUrl,[HTTP_METHOD,"POST"],"GET-DATA");
}

default
{
    on_rez(integer start_param)
    {
        llResetScript();   
    }
    
    state_entry()
    {
        llRegionSay(lightchannel,"off");
        llRegionSay(lockchan,"deadlock");
        BecomeInvisible();
        Landed = FALSE;
        listenHandle = llListen(operationschan, "", NULL_KEY, "");
        llSensor("",NULL_KEY,(ACTIVE|PASSIVE|SCRIPTED),1,PI);
        llSensorRepeat("",NULL_KEY,(ACTIVE|PASSIVE|SCRIPTED),1,PI,0.5);
    }
    
    sensor(integer num_detected)
    {
        canLand = FALSE;
    }
    no_sensor()
    {
        canLand = TRUE;
    }
    
    link_message(integer LinkSender, integer Number, string message, key id)
    {
        llOwnerSay(message);
        if (TRUE) //I can't be bothered removing this if.
        {
            if (llJsonGetValue(message,["MessageType"])=="Action" && llJsonGetValue(message,["MessageAttachment"])=="FROMHUD")
            {
                string Action = llJsonGetValue(message,["MessageContent"]);
                if (Action=="land")
                {
                    if (!Landed && canLand)
                    {                        
                        llRegionSay(lightchannel,"flash");
                        llPlaySound("landing",1.0);
                        //RequestConsole(); //FIXME: Need to request in a better way.
                        FadeIn(); 
                        BecomeVisible();
                        llRegionSay(lightchannel,"off");
                        Landed = TRUE;
                        llRegionSay(lockchan,"undeadlock");
                    }
                    else if(!canLand)
                    {
                        llRegionSay(lightchannel,"flash");
                        llTriggerSound("tardislandfail",1.0);
                        FunkyLand();
                        llDie();
                    }
                }
                else if(Action=="unland")
                {
                    if (Landed)
                    {
                        llRegionSay(lightchannel,"flash");
                        llSay(lockchan,"lock");
                        llTriggerSound("takeoff",1.0);
                        llRegionSay(lockchan,"deadlock");
                        FadeOut();
                        BecomeInvisible();
                        llRegionSay(lightchannel,"off");
                        Landed = FALSE;
                    }
                }
                else if(Action=="leave")
                {
                    if(Landed)
                    {
                        llSay(lockchan,"lock");
                        llTriggerSound("takeoff",1.0);
                        llRegionSay(lightchannel,"flash");
                        Leave();
                    }
                    else{
                        llDie();
                    }
                }
                else if(Action=="2ground")
                {
                    ToGround();
                }
                else if(Action=="malfunction")
                {
                    llRegionSay(lightchannel,"flash");
                    llTriggerSound("tardislandfail",1.0);
                    FunkyLand();
                    llDie();
                }
            }
        }
    }
}

