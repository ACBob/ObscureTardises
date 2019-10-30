/*
 *   Obscure Tardises' Fading Functions
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

BecomeInvisible()
{
    llSetLinkAlpha(LINK_SET, 0.0, ALL_SIDES);
}

BecomeVisible()
{
    llSetLinkAlpha(LINK_SET, 1.0, ALL_SIDES);
}

ToGround()
{
    rotation Rotation = llGetRot();
    llSetPos(llGetPos()-<0.0,0.0,llGround(ZERO_VECTOR)>);  
    llSetRot(llEuler2Rot(llGroundContour(<0.0,0.0,llGround(ZERO_VECTOR)>+<0.0,0.0,Rotation.z>))); 
}

FadeIn()
{
    float i;
    for (i=0;i<0.3;i+=0.01)
    {
        llSetLinkAlpha(LINK_SET,i,ALL_SIDES);
        llSleep(0.001);
    }
    for (i=0.3;i>0.1;i-=0.01)
    {
        llSetLinkAlpha(LINK_SET,i,ALL_SIDES);
        llSleep(0.001);
    }
    for (i=0.1;i<0.5;i+=0.01)
    {
        llSetLinkAlpha(LINK_SET,i,ALL_SIDES);
        llSleep(0.001);
    }
    for (i=0.5;i>0.25;i-=0.01)
    {
        llSetLinkAlpha(LINK_SET,i,ALL_SIDES);
        llSleep(0.001);
    }
    for (i=0.25;i<1.0;i+=0.01)
    {
        llSetLinkAlpha(LINK_SET,i,ALL_SIDES);
        llSleep(0.001);
    }
    
}

FadeOut()
{
    float i;
    for (i=1.0;i>0.7;i-=0.01)
    {
        llSetLinkAlpha(LINK_SET,i,ALL_SIDES);
        llSleep(0.001);
    }
    for (i=0.7;i<0.9;i+=0.01)
    {
        llSetLinkAlpha(LINK_SET,i,ALL_SIDES);
        llSleep(0.001);
    }
    for (i=0.9;i>0.5;i-=0.01)
    {
        llSetLinkAlpha(LINK_SET,i,ALL_SIDES);
        llSleep(0.001);
    }
    for (i=0.5;i<0.75;i+=0.01)
    {
        llSetLinkAlpha(LINK_SET,i,ALL_SIDES);
        llSleep(0.001);
    }
    for (i=0.75;i>0.0;i-=0.01)
    {
        llSetLinkAlpha(LINK_SET,i,ALL_SIDES);
        llSleep(0.001);
    }
    
}

FunkyLand(){
    float i;
    for (i=0;i<0.5;i+=0.01)
    {
        llSetLinkAlpha(LINK_SET,i,ALL_SIDES);
        llSleep(0.001);
    }
    for (i=0.5;i>0.3;i-=0.01)
    {
        llSetLinkAlpha(LINK_SET,i,ALL_SIDES);
        llSleep(0.001);
    }
    for (i=0.3;i<0.4;i+=0.01)
    {
        llSetLinkAlpha(LINK_SET,i,ALL_SIDES);
        llSleep(0.001);
    }
    for (i=0.4;i>0.1;i-=0.01)
    {
        llSetLinkAlpha(LINK_SET,i,ALL_SIDES);
        llSleep(0.001);
    }
    for (i=0.1;i<0.7;i+=0.01)
    {
        llSetLinkAlpha(LINK_SET,i,ALL_SIDES);
        llSleep(0.001);
    }
    for (i=0.7;i<0.0;i-=0.01)
    {
        llSetLinkAlpha(LINK_SET,i,ALL_SIDES);
        llSleep(0.001);
    }
    for (i=0.0;i<0.89;i+=0.01)
    {
        llSetLinkAlpha(LINK_SET,i,ALL_SIDES);
        llSleep(0.001);
    }
    llSleep(0.7);
    for (i=1.0;i>0.35;i-=0.01)
    {
        llSetLinkAlpha(LINK_SET,i,ALL_SIDES);
        llSleep(0.001);
    }
    for (i=0.35;i>0.6;i+=0.01)
    {
        llSetLinkAlpha(LINK_SET,i,ALL_SIDES);
        llSleep(0.001);
    }
    for (i=0.6;i>0.1;i-=0.01)
    {
        llSetLinkAlpha(LINK_SET,i,ALL_SIDES);
        llSleep(0.001);
    }
}

Leave(){
    FadeOut();
    BecomeInvisible();
    llDie(); //Kills us.
}
