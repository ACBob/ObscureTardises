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

string URL;
string HudUrl;

integer UseEmail = FALSE;

integer operationschan = -743630; //wE ARE THE TARDIS! THIS IS OUR LIFEBLOOD! ARRARARGHRAGRHAGHG

default
{
    on_rez(integer start_param)
    {
        //llResetScript();
        
    }
    
    state_entry()
    {
        llRequestURL();
    }

    touch_start(integer total_number)
    {
        //Psh, everyone does this. No idea why.
    }
    http_request(key rid, string method, string body)
    {
        if(method==URL_REQUEST_GRANTED)
        {
            URL = body;
            llRegionSay(operationschan,URL);
        }
        else if(method==URL_REQUEST_DENIED)
        {
            llOwnerSay("Our URL Attempt Failed! Attempting again...");
            llRequestURL();
            llSleep(1);
            /*UseEmail=TRUE;
            llOwnerSay("URL Request failed. Using Email now...");
            llOwnerSay("Although that's not implemented.");*/
        }
        
        else if(method=="POST")
        {
            if(body=="GET-DATA")
            {
                string responseData = llList2Json(JSON_OBJECT,["ResponseType","CONSOLE-INFORMATION","Position",(string)llGetPos(),"Region",llGetRegionName()]);
                llHTTPResponse(rid,200,responseData);
            }
            else if(llJsonGetValue(body,["CommandType"])=="HUD-URL")
            {
                HudUrl = llJsonGetValue(body,["URL"]);
                llHTTPResponse(rid,200,"recieved hud");
            }
            else
            {
                llHTTPResponse(rid,418,"I'm a little teapot. Short and stout. Here is my handle, here is my spout.");
            }
        } 
            
    }
}

