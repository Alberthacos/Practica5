--código para controlar los pasos de un motor PAP a través de dos interruptores con Gray
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

ENTITY MotorPAP IS PORT(
sw : IN std_logic_vector (1 downto 0); --interruptores
leds, puerto : OUT std_logic_vector (1 to 4)); --leds testigos y salida al puerto para el motor
END MotorPAP;

ARCHITECTURE motor OF MotorPAP IS
begin
process (sw) begin
case sw is
when "00" => leds <= "1000"; puerto <= "1000";
when "01" => leds <= "0100"; puerto <= "0100";
when "11" => leds <= "0010"; puerto <= "0010";
when others => leds <= "0001"; puerto <= "0001";
end case;
end process;
end motor; --fin de la arquitectura