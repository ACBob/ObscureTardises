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

integer lockchan = 7038329;
default
{
    touch_start(integer total_number)
    {
        if (llDetectedKey(0) == llGetOwnerKey(llGetOwner())){
            llRegionSay(lockchan,"toggle");
            llPlaySound("lock",0.2);
        }
        else
        {
            llInstantMessage(llDetectedKey(0),"The Owner has been Notified of your Intrustion.");
            llOwnerSay(llGetDisplayName(llDetectedKey(0))+" Has attempted to unlock the TARDIS.");
            llSleep(1);
        }
    }
}

