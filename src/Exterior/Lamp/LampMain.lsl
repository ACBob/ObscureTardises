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

FlashingLight(){
    llParticleSystem(
        [
            PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_DROP,
            PSYS_SRC_BURST_RADIUS,0,
            PSYS_SRC_ANGLE_BEGIN,0,
            PSYS_SRC_ANGLE_END,0,
            PSYS_SRC_TARGET_KEY,llGetKey(),
            PSYS_PART_START_COLOR,<1.000000,1.000000,1.000000>,
            PSYS_PART_END_COLOR,<1.000000,1.000000,1.000000>,
            PSYS_PART_START_ALPHA,1,
            PSYS_PART_END_ALPHA,0.3,
            PSYS_PART_START_GLOW,0.2,
            PSYS_PART_END_GLOW,0,
            PSYS_PART_BLEND_FUNC_SOURCE,PSYS_PART_BF_SOURCE_ALPHA,
            PSYS_PART_BLEND_FUNC_DEST,PSYS_PART_BF_ONE_MINUS_SOURCE_ALPHA,
            PSYS_PART_START_SCALE,<1.200000,1.200000,0.000000>,
            PSYS_PART_END_SCALE,<2.400000,2.400000,0.000000>,
            PSYS_SRC_TEXTURE,"",
            PSYS_SRC_MAX_AGE,0,
            PSYS_PART_MAX_AGE,1.1,
            PSYS_SRC_BURST_RATE,0.999,
            PSYS_SRC_BURST_PART_COUNT,1,
            PSYS_SRC_ACCEL,<0.000000,0.000000,0.000000>,
            PSYS_SRC_OMEGA,<0.000000,0.000000,0.000000>,
            PSYS_SRC_BURST_SPEED_MIN,0,
            PSYS_SRC_BURST_SPEED_MAX,0,
            PSYS_PART_FLAGS,
                0 |
                PSYS_PART_EMISSIVE_MASK |
                PSYS_PART_INTERP_COLOR_MASK |
                PSYS_PART_INTERP_SCALE_MASK
        ]);
    }

NoLight(){
    llParticleSystem([]);
}

integer lightchannel = -7104884; //"lit" in hex.

integer lightlisten;

default
{
    on_rez(integer start_param){
        llResetScript();
    }
    
    state_entry()
    {
        lightlisten = llListen(lightchannel, "", NULL_KEY, "");
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if(llGetOwnerKey(id) == llGetOwner())
        {
            if (message=="flash")
            {
                FlashingLight();
            }
            else if (message=="off")
            {
                NoLight();
            }
        }
    }
}

