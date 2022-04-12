----------------------------------------------------------------------------------------------------------------------------------
-- Project Name: PmodENC (PmodENC.vhd)
-- Target Devices: Nexys3
-- This project changes the seven segments display when the position of rotary shaft is changed.
-- The number on the 7 segments display is relative to the start position. When the rotary button
-- is pressed, the program resets. The switch controls whether the 7segments display turns on
-- or off. LED 0 and 1 indicated the direction the rotary shaft is turned. LED 0 is on when the shaft
-- is turned right, LED 1 is on when the shaft is turned left.
----------------------------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity Puerta is
Port (
	clk: in std_logic;
	Abrir,Cerrar,stop: in std_logic;
	LS1,LS2: in std_logic;
	motor_izq,motor_der,LEDA,LEDC,rele: out std_logic:='0'
	
);
end Puerta;

architecture Behavioral of Puerta is
-- signals
signal EncO : std_logic_vector (4 downto 0);
signal salida1,salida2: std_logic:='0';
begin

control: process(Abrir,cerrar,LS1,LS2)
begin 
if stop ='0' then 
		--press abrir y LS2 press//enclave y primer LS no presionado (0)  COdigo basico
	if ((Abrir='1' and LS2='1' and Cerrar='0') or (salida2='1' and LS1='0')) then  salida2<='1'; motor_izq<='0'; LEDA<='1'; rele<='0'; motor_der<='1';
	else salida2<='0'; motor_izq<='1'; LEDA<='0'; 
	end if;
	
	if((cerrar='1' and LS1='1' and abrir='0') or (salida1='1' and LS2='0')) then salida1<='1'; motor_der<='0'; LEDC<='1'; rele<='0'; motor_izq<='1';
	else salida1<='0'; motor_der<='1'; LEDC<='0';
	end if;																								--Estas salidas 
																					--detienen el recorrido totalmente, es decir no se termina el ciclo 
if (Abrir='1' and cerrar='1') then motor_izq<='1'; motor_der<='1'; LEDA<='0'; LEDA<='0'; salida1<='0'; salida2<='0'; 
	else
		--completar ciclo si esta a medio camino 
		if (LS1='0' and LS2='0') then 
			if ((Abrir='1') or (salida2='1' and LS1='0')) then  salida2<='1'; motor_izq<='0'; LEDA<='1'; rele<='0'; motor_der<='1';
			else salida2<='0'; motor_izq<='1'; LEDA<='0'; 
			end if;
			
			if((cerrar='1') or (salida1='1' and LS2='0')) then salida1<='1'; motor_der<='0'; LEDC<='1'; rele<='0'; motor_izq<='1';
			else salida1<='0'; motor_der<='1'; LEDC<='0';
			end if;
		end if;
	end if;
--se presiona stop se detiene en cualquier punto
else salida1<='0'; salida2<='0'; motor_der<='1'; motor_izq<='1'; LEDC<='0'; LEDA<='0';
end if;
--variable del STOP
-- if (abrir or cerrar)='1' and (salida1<='1 or salida2<='1) then  --si se presiona el boton opuesto a medio recorrido se detiene el proceso
--salida1<='0'; salida2<='0'; motor_der<='1'; motor_izq<='1'; LEDC<='0'; LEDA<='0';
--	end if;
end process;

end Behavioral;