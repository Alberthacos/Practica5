----c?digo para controlar los pasos de un motor PAP a trav?s de dos interruptores con Gray
--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
--
--
--ENTITY MotorPAP IS PORT(
--CLK: in STD_LOGIC; -- reloj de 50MHz para la nexys 2
----sw : IN std_logic_vector (1 downto 0); --interruptores
--otro_led: out std_logic;
--leds, puerto : OUT std_logic_vector (1 to 4)); --leds testigos y salida al puerto para el motor
--END MotorPAP;
--
--ARCHITECTURE motor OF MotorPAP IS
--signal conta_1250us: integer range 1 to 62500:=1; -- pulso1 de 1250us@400Hz (0.25ms) 62500
--signal sw: std_logic_vector(1 downto 0);
-- signal contador: integer range 0 to 24999999 := 0;
--signal SAL_400Hz: STD_LOGIC; -- reloj de 400Hz
--
--begin
--process (CLK,SAL_400Hz) begin
--
--	
--if rising_edge(CLK) then
--
--
--	if (contador = 24999999) then
--		contador <= 0;
--		otro_led <='1';
--	else
--		otro_led <='0';
--		if (conta_1250us = 800000) then --cuenta 1250us (50MHz=62500)
--		-- if (conta_1250us = 125000) then --cuenta 1250us (100MHz=125000)
--		SAL_400Hz <= NOT(SAL_400Hz); --genera un barrido de 2.5ms
--		conta_1250us <= 1;
--		else
--			conta_1250us <= conta_1250us + 1;
--		end if;
--
--		contador <= contador+1;
--	end if;
--end if;
--
--
--IF SAL_400Hz'EVENT and SAL_400Hz='1' THEN sw <= sw + '1';
--	case sw is
--	when "00" => leds <= "1100"; puerto <= "1100";
--	when "01" => leds <= "0110"; puerto <= "0110";
--	when "10" => leds <= "0011"; puerto <= "0011";
--	when others => leds <= "1001"; puerto <= "1001";
--	end case;
--end if;
------
--
--
--
--end process;
--end motor; --fin de la arquitectura



























--código para controlar los pasos de un motor PAP a través de dos interruptores con Gray
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY MotorPAP IS PORT(
CLK: in STD_LOGIC; -- reloj de 50MHz para la nexys 2
--sw : IN std_logic_vector (1 downto 0); --interruptores
leds, puerto : OUT std_logic_vector (1 to 4)); --leds testigos y salida al puerto para el motor
END MotorPAP;

ARCHITECTURE motor OF MotorPAP IS

signal conta_1250us: integer range 1 to 2000000:=1; -- pulso1 de 1250us@400Hz (0.25ms) 62500
signal sw: std_logic_vector(1 downto 0);
signal SAL_400Hz: STD_LOGIC; -- reloj de 400Hz

begin
process (CLK,SAL_400Hz) begin


if rising_edge(CLK) then
	if (conta_1250us = 2000000) then --cuenta 1250us (50MHz=62500)
			-- if (conta_1250us = 125000) then --cuenta 1250us (100MHz=125000)
			SAL_400Hz <= NOT(SAL_400Hz); --genera un barrido de 2.5ms
			conta_1250us <= 1;
	else
			conta_1250us <= conta_1250us + 1;
	end if;
end if;


IF SAL_400Hz'EVENT and SAL_400Hz='1' THEN sw <= sw + '1';
	case sw is
	when "00" => leds <= "1100"; puerto <= "1100";
	when "01" => leds <= "0110"; puerto <= "0110";
	when "10" => leds <= "0011"; puerto <= "0011";
	when others => leds <= "1001"; puerto <= "1001";
	end case;
end if;


end process;
end motor; --fin de la arquitectura