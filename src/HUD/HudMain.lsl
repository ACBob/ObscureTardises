/*
 *   Obscure Tardises' HUD Main file
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

list HudChoicesPageZero = ["Remat",">","Demat","Summon","Lock","Take off","?","Config","-"];

list HudChoicesPageOne = ["-","<","-","Malfunction","-","-","Fall To Ground","-","-"];//

list HudLockChoices = ["Back","-","-","-","Toggle","-","Lock","-","Unlock"];
integer operationschan = -743630; //Communications with the Tardis.

integer HudChannel = -687564; //"hud" in Hex.
integer HudPage = 0;
integer HudLockChannel = -687565; //1 More than HudChannel. Could be an Enum!
integer listenId;
integer OpsID;

integer lockchan = 7038329; //For locking 

ShowDialog(){
    if(HudPage==0)
        llDialog(llGetOwnerKey(llGetOwner()), "\nPage: "+(string)HudPage, HudChoicesPageZero, HudChannel);
    if(HudPage==1)
        llDialog(llGetOwnerKey(llGetOwner()), "\nPage: "+(string)HudPage, HudChoicesPageOne, HudChannel);
    listenId = llListen(HudChannel, "", NULL_KEY, "");
}

ShowLock(){
    llDialog(llGetOwnerKey(llGetOwner()), "\n", HudLockChoices, HudLockChannel);
    listenId = llListen(HudLockChannel, "", NULL_KEY, "");
}

ShowHelp(){
    llOwnerSay("
    What do the buttons mean? 
    ? - Help. 
    - - Substitute, to make it look nicer. 
    Summon - Summon the Tardis. 
    Take Off - Makes the Tardis enter the vortex. 
    Remat - Undisperse the Tardis. 
    Demat - Disperses the Tardis. Not to be confused with Take Off.
    Lock - Brings up the Locking Menu.
    > - Next Page.
    < - Previous Page.");
}

#include "Messages.lsl"

default
{
    state_entry()
    {
        //llSay(0, "Hello, Avatar!");
    }

    touch_start(integer total_number)
    {
        ShowDialog();
    }
    listen(integer channel, string name, key id, string message){
        if(llGetOwnerKey(id) == llGetOwner()){
            
            if (message=="-"||message=="Back") //If the message is "-" OR "Back"
            {
                ShowDialog();
            }
            else if(message==">"){
                HudPage++;
                ShowDialog();
            }
            else if(message=="<"){
                HudPage--;
                ShowDialog();
            }
            
            else if (channel==HudLockChannel){
                if(message=="Lock"){
                    llRegionSay(lockchan,"lock");
                }
                else if(message=="Unlock"){
                    llRegionSay(lockchan,"unlock");
                }
                else if(message=="Toggle"){
                    llRegionSay(lockchan,"toggle");
                }
            }
            
            else if (channel==HudChannel){
                if(HudPage==0){
                    if(message=="?"){
                        ShowHelp();
                        ShowDialog();
                    }
                    
                    else if(message=="Lock"){
                        ShowLock();
                    }
                    
                    else if(message=="Demat"){
                        SEND_SCRIPT_MESSAGE("","Action","unland");
                    }
                    
                    else if(message=="Remat"){
                        SEND_SCRIPT_MESSAGE("","Action","land");
                    }
                    else if(message=="Take off"){
                        SEND_SCRIPT_MESSAGE("","Action","leave");
                    }
                    else if(message=="Summon"){
                        SEND_SCRIPT_MESSAGE("","Action","leave");
                        llRezObject("Tardis", llGetPos() + <3.0,0.0,0.75>*llGetRot(), <0.0,0.0,0.0>, llGetRot(), 0);
                        llSleep(0.2);
                        SEND_SCRIPT_MESSAGE("","Action","land");
                    }
                }
                else if(HudPage==1){
                    if(message=="Fall To Ground"){
                        llRegionSay(operationschan,"2ground");
                    }
                    else if(message=="Malfunction"){
                        SEND_SCRIPT_MESSAGE("","Action","malfunction");
                        llRezObject("Tardis", llGetPos() + <3.0,0.0,0.75>*llGetRot(), <0.0,0.0,0.0>, llGetRot(), 0);
                        llSleep(0.2);
                        SEND_SCRIPT_MESSAGE("","Action","malfunction");
                    }
                }
            }
        }
    }
}

