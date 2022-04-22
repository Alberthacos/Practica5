
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Puerta is
Port (
	clk: in std_logic;
	Abrir,Cerrar,stop: in std_logic;
	LS1,LS2: in std_logic;
	seg: out std_logic_vector(7 downto 0);
	AN: out std_logic_vector(7 downto 0);
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
		--press abrir y LS2 press//enclave y primer LS no presionado (0)  COdigo basico
	if ((Abrir='1' and LS2='1' and Cerrar='0') or (salida2='1' and LS1='0')) then  salida2<='1'; motor_izq<='0'; LEDA<='1'; rele<='0'; motor_der<='1';
	else salida2<='0'; motor_izq<='1'; LEDA<='0'; 
	end if;
	
	if((cerrar='1' and LS1='1' and abrir='0') or (salida1='1' and LS2='0')) then salida1<='1'; motor_der<='0'; LEDC<='1'; rele<='0'; motor_izq<='1';
	else salida1<='0'; motor_der<='1'; LEDC<='0';
	end if;			--Estas salidas 
																					--detienen el recorrido totalmente, es decir no se termina el ciclo 
if (Abrir='1' and cerrar='1') then motor_izq<='1'; motor_der<='1'; LEDA<='0'; LEDA<='0'; salida1<='0'; salida2<='0'; 
 end if;

if (salida1='1' or salida2='1') then Seg<="01110000"; AN<="11101111";
else seg<="00110000"; AN<="01111111";
end if;

end process;

end Behavioral;