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

integer lockchan = 7038329; //For locking when materializing/dematerializing.
integer operationschan = -743630; //"t60" in Hex.
integer lightchannel = -7104884; //For the lights.
integer portchan = 1952803941;

key URL_REQUEST_ID; //Formatted like a constant, yet it changes.

//Urls
string selfURL;
string extURL;
string consoleURL; //Hud is like a messanger. We don't store the Console, the hud does it for us.

REQUEST_URL(){
    llOwnerSay("DBUG: Requesting URL.");
    URL_REQUEST_ID = llRequestURL();
}

SEND_MESSAGE(integer CHANNEL, string MESSAGE_ATTACHMENT, string MESSAGE_TYPE, string MESSAGE_CONTENT)
 {
    string Message = llList2Json(JSON_OBJECT,["MessageType",MESSAGE_TYPE,"MessageAttachment",MESSAGE_ATTACHMENT,"MessageContent",MESSAGE_CONTENT]);
    llOwnerSay("DBUG: "+(string)CHANNEL+" : "+Message);
    llRegionSay(CHANNEL,Message);
}

SEND_HTTP_MESSAGE(string URL, string MESSAGE_ATTACHMENT, string MESSAGE_TYPE, string MESSAGE_CONTENT)
{
     string Message = llList2Json(JSON_OBJECT,["MessageType",MESSAGE_TYPE,"MessageAttachment",MESSAGE_ATTACHMENT,"MessageContent",MESSAGE_CONTENT]);
    llOwnerSay("DBUG: "+(string)URL+" : "+Message);
    llHTTPRequest(URL,[HTTP_METHOD,"POST"],Message);
}

default
{
    on_rez(integer start_param)
    {
        llResetScript(); //Sanity Check!
    }
    
    state_entry()
    {
        string Message = llList2Json(JSON_OBJECT,["MessageType","Information","MessageContent","Testing..."]);
        llOwnerSay(Message);
        llRegionSay(operationschan,Message);
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

