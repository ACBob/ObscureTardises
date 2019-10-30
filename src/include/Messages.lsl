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
