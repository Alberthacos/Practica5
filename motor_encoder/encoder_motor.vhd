--c�digo para controlar los pasos de un motor PAP a trav�s de un encoder mecanico
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY motor_encoder IS PORT(

	CLK: in STD_LOGIC; -- reloj de 50MHz para la amiba2
	Entradas : in STD_LOGIC_VECTOR (7 downto 4); -- to the lower row of connector JA
	AN : out STD_LOGIC_VECTOR (3 downto 0); -- controls the display digits
	SEG: out STD_LOGIC_VECTOR (6 downto 0); -- controls what digit to display
	puertos,leds : OUT std_logic_vector (1 to 4); --leds testigos y salida al puerto para el motor, representa el encdedido de las bobinas
	LED: out STD_LOGIC_VECTOR (1 downto 0)  -- Led indicates the direction the shaft (encoder)
	);
END motor_encoder;

architecture Behavioral of motor_encoder is
-- signals
    signal EncO : std_logic_vector (4 downto 0);
    signal AO, BO: std_logic;
begin

C0: entity work.Debouncer
port map ( 
clk=>clk, 
Ain=>Entradas(4), 
Bin=>Entradas(5), 
Aout=> AO, 
Bout=> BO);

C1: entity work.Encoder
port map ( 
clk=>clk, 
A=>AO, 
B=>BO, 
BTN=>Entradas(6), 
EncOut=>EncO, 
puertos => puertos,
leds => leds,
LED=>LED
);

C2: entity work.DisplayController
port map (
clk=>clk, 
SWT=>Entradas(7), 
DispVal=>EncO, 
anode=>an, 
segOut=>seg );

--C4: entity work.MotorPAP
--port map(
--CLK  => CLK,
--leds => leds,
--puerto => puerto
--);
end Behavioral;
