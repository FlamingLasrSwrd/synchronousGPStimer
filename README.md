Created By: Elijah K Dunn  
University of Kansas Physics Dept  
Create Date:    21:13:17 10/05/2012  
Design Name:	Timer Module  
Project Name:	SATRA  
Target Devices: CoolRunner II CPLDs; Digilent Nexys 3 FPGA  
Description:  
VHDL implementation of a timing module for a two channel SATRA antenna system. The output from a trigger channel is converted to iTime (time until rising edge) using a bit counter. The input clock signal determines resolution. One clock pulse = one bit of a 25-bit number. The bit counter is reset by a one pulse per second output from a GPS module. MSB of SPI output indicates channel A ('1') or channel B ('0') data.  
Revision: V.02
