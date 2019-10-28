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

integer vgIntDoorSwing=90;
rotation gRotDoorSwing;
integer locked = FALSE;
integer open;
integer deadlocked = FALSE;

integer listenHandle;

integer lockchan = 7038329; //"key" Converted to Hex, and then Decimal.

default
{
    state_entry(){
        gRotDoorSwing = llEuler2Rot( <vgIntDoorSwing, 0.0, 0.0> * DEG_TO_RAD );   
        listenHandle = llListen(lockchan, "", NULL_KEY, "");
    }
    touch_start(integer touched)
    {
        if (!locked && !deadlocked){
            if(!open){
                llPlaySound("open",1.0);
            }
            else{
                llPlaySound("close",1.0);
            }
            llSetLocalRot( (gRotDoorSwing = ZERO_ROTATION / gRotDoorSwing) * llGetLocalRot() );
            open = !open;
        }
        else{
            llPlaySound("doortry",1.0);
        }
    }

    on_rez(integer start_param)
    {
        llResetScript();
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (llGetOwnerKey(id) == llGetOwner())
        {
            if (open)
            {
                llSetLocalRot( (gRotDoorSwing = ZERO_ROTATION / gRotDoorSwing) * llGetLocalRot() );
                open = !open;
                llPlaySound("fastclose",1.0);
            }
            if (message=="toggle")
            {
                locked = !locked;
                
            }
            else
            {
                if (message=="lock")
                {
                    locked = TRUE;
                }
                else if (message=="unlock")
                {
                    locked = FALSE;
                }
                else if (message=="deadlock")
                {
                    deadlocked = TRUE;
                }
                else if (message=="undeadlock")
                {
                    deadlocked = FALSE;
                }
            }
        }
    }
}

