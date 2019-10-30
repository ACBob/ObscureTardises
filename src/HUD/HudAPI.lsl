/*
 *   Obscure Tardises' HUD API
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
#include "Messages.lsl"

key URL_REQUEST_ID; //TODO: Formatted like a constant, yet it changes.

//Urls
string selfURL;
string extURL;
string consoleURL; //Hud is like a messanger. We don't store the Console, the hud does it for us.

REQUEST_URL(){
    llOwnerSay("DBUG: Requesting URL.");
    URL_REQUEST_ID = llRequestURL();
}

default
{
    on_rez(integer start_param)
    {
        llResetScript(); //Sanity Check!
    }
    
    state_entry()
    {

        REQUEST_URL();
        
        llListen(operationschan, "", NULL_KEY, "");
        
    }
    
    link_message(integer linkSender, integer number, string message, key id)
    {
        if (llJsonGetValue(message,["MessageType"])=="Action" && extURL != "")
        {
            llOwnerSay("DBUG : API : "+message);
            SEND_HTTP_MESSAGE(extURL,"","Action",llJsonGetValue(message,["MessageContent"]));
        }
        else if (extURL == "")
        {
            llOwnerSay("DBUG : API : Action sent, yet no id?");
        }
    }
    
    listen(integer channel, string name, key id, string text)
    {
        if(llGetOwner() == llGetOwnerKey(id))
        {
            llOwnerSay(name + " : " + text);
            
            if(llJsonGetValue(text,["MessageType"])=="Information")
            {
                if(llJsonGetValue(text,["MessageAttachment"])=="URL")
                {
                    if(name=="Tardis") //Really dirty.
                    {
                        extURL = llJsonGetValue(text,["MessageContent"]);
                        llOwnerSay("We've recieved the tardis URL at "+extURL+", Going to send it our URL.");
                        
                        SEND_HTTP_MESSAGE(extURL,"HUD-URL","Information",selfURL);
                    }
                    
                }
            }
        }
    }
    
    http_response(key rid, integer status, list metadata, string body)
     {
        if(status==418)
        {
            llOwnerSay("There's been a slight issue, API Side, Code: "+((string)status)+". See following;");
            llOwnerSay(body);
            
        }
        else if(status==200)
        {
            llOwnerSay("DBUG: Status 200, Everything is fine.");
        }
    }
    
    http_request(key id, string method, string body)
    {
        if (id==URL_REQUEST_ID)
        {
            llOwnerSay("DBUG: Our survey says....");
            if (method==URL_REQUEST_DENIED)
            {
                llOwnerSay("URL Request Failed!\nReason: "+body);
            }
            else if(method==URL_REQUEST_GRANTED)
            {
                llOwnerSay("DBUG: URL Request Granted!");
                llOwnerSay(body);
                selfURL = body;
            }
        }
    }
}

