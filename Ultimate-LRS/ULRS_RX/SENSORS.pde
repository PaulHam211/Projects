/*****************************************************************************************************
***         Ultimate LRS - Long Range RC & Data Link using 2 x 1W 433 MHz OrangeRX modules         ***
***                                                                                                ***
*** Copyright 2014-2015 Benoit Joassart    benoit@joassart.com                                     ***
***                                        rcgroups.com : flipflap                                 ***
***                     Project website : http://www.itluxembourg.lu/site/                         ***
***                                                                                                ***
*** Contains code from OpenLRS ( http://code.google.com/p/openlrs/ )                               ***
***   Copyright 2010-2012 Melih Karakelle ( http://www.flytron.com ) (forum nick name: Flytron)    ***
***                     Jan-Dirk Schuitemaker ( http://www.schuitemaker.org/ ) (CrashingDutchman)  ***
***                     Etienne Saint-Paul ( http://www.gameseed.fr ) (forum nick name: Etienne)   ***
***                     thUndead (forum nick name: thUndead)                                       ***
***                                                                                                ***
******************************************************************************************************

					This file is part of Ultimate LRS.

					Ultimate LRS is free software: you can redistribute it and/or modify
					it under the terms of the GNU General Public License as published by
					the Free Software Foundation, either version 3 of the License, or
					(at your option) any later version.

					Ultimate LRS is distributed in the hope that it will be useful,
					but WITHOUT ANY WARRANTY; without even the implied warranty of
					MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
					GNU General Public License for more details.

					You should have received a copy of the GNU General Public License
					along with Ultimate LRS.  If not, see <http://www.gnu.org/licenses/>.

					This project must be compiled with Arduino 1.5.8.
*/

// not used
void MMA7455_Init()
{
	Wire.beginTransmission(0x1D);
	Wire.write(0x16);
	Wire.write(0x25);
	Wire.endTransmission();
}

// not used
void MMA7455_Calibrate()
{
	int tmpx = 0;
	int tmpy = 0;
	int tmpz = 0;
	acc_offx = 0;
	acc_offy = 0;
	acc_offz = 0;

	for (char i = 0; i < 20; i++)
	{
		delay(10);
		MMA7455_Read();
		tmpx += AccX;
		tmpy += AccY;
		tmpz += AccZ;
	}

	acc_offx = tmpx / 20;
	acc_offy = tmpy / 20;
	acc_offz = (tmpz / 20) - 64;
}

// not used
void MMA7455_Read()
{
	byte buff[8];
	Wire.beginTransmission(0x1D);
	Wire.write(0x06); //read from here
	Wire.endTransmission();
	Wire.requestFrom(0x1D, 3);
	int i = 0;

	while (Wire.available())
	{
		buff[i] = Wire.read();
		i++;
	}

	Wire.endTransmission();
	AccX = buff[0];

	if (AccX > 127)
	{
		AccX = -(256 - AccX);
	}

	AccY = buff[1];

	if (AccY > 127)
	{
		AccY = -(256 - AccY);
	}

	AccZ = buff[2];

	if (AccZ > 127)
	{
		AccZ = -(256 - AccZ);
	}

	AccX -= acc_offx;
	AccY -= acc_offy;
	AccZ -= acc_offz;
}

// not used
void initHMC5883L()
{
	delay(5);
	Wire.beginTransmission(0x1E);
	Wire.write(0x02);
	Wire.write(0x00);
	Wire.endTransmission();
}

// not used
void HMC5883L_Read()
{
	Wire.beginTransmission(0x1E);
	Wire.write(0x03);
	Wire.endTransmission();
	delay(5);
	Wire.requestFrom(0x1E, 6);
	int i = 0;
	byte buff[6];

	while (Wire.available())
	{
		buff[i] = Wire.read();
		i++;
	}

	Wire.endTransmission();
	MagX = buff[0] << 8;
	MagX |= buff[1];
	MagZ = buff[2] << 8;
	MagZ |= buff[3];
	MagY = buff[4] << 8;
	MagY |= buff[5];
}




