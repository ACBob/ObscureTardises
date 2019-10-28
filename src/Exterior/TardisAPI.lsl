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
string hudURL; //Hud is like a messanger. We don't store the Console, the hud does it for us.

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

SEND_SCRIPT_MESSAGE(string MESSAGE_ATTACHMENT, string MESSAGE_TYPE, string MESSAGE_CONTENT)
{
    string Message = llList2Json(JSON_OBJECT,["MessageType",MESSAGE_TYPE,"MessageAttachment",MESSAGE_ATTACHMENT,"MessageContent",MESSAGE_CONTENT]);
    llOwnerSay("DBUG: "+" : "+Message);
    llMessageLinked(LINK_THIS,0,Message,"");
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
    
    listen(integer channel, string name, key id, string text)
    {
        if(llGetOwner() == llGetOwnerKey(id))
        {
            llOwnerSay(name + " : " + text);
            
            if(llJsonGetValue(text,["MessageType"])=="Information")
            {
                if(llJsonGetValue(text,["MessageAttachment"])=="URL")
                {
                    if(name=="HUD" || name=="GUD_STAND-IN") //Really dirty.
                    {
                        hudURL = llJsonGetValue(text,["MessageContent"]);
                        llOwnerSay(hudURL);
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
                
                SEND_MESSAGE(operationschan, "URL", "Information", selfURL);
            }
        }
        else if (method=="POST")
        {
            llOwnerSay("DBUG: Recieved a POST event.");
            llOwnerSay(body);
            
            if(llJsonGetValue(body,["MessageType"])=="Information")
            {
                if(llJsonGetValue(body,["MessageAttachment"])=="HUD-URL")
                {
                    hudURL = llJsonGetValue(body,["MessageContent"]);
                    llOwnerSay("We've recieved the hud URL at "+hudURL+", Going to send it our URL.");
                    
                    llHTTPResponse(id,200,"A-Okay");
                    
                }
            }
            else if(llJsonGetValue(body,["MessageType"])=="Action")
            {
                llOwnerSay("Was told to do "+llJsonGetValue(body,["MessageContent"])+" So telling the tardis.");
                SEND_SCRIPT_MESSAGE("FROMHUD","Action",llJsonGetValue(body,["MessageContent"]));
            }
        }
    }
}

