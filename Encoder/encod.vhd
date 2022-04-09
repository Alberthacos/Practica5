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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity PmodENC is
Port (
	clk: in std_logic;
	JA : in STD_LOGIC_VECTOR (7 downto 4); -- to the lower row of connector JA
	an : out STD_LOGIC_VECTOR (3 downto 0); -- controls the display digits
	seg: out STD_LOGIC_VECTOR (6 downto 0); -- controls what digit to display
	Led: out STD_LOGIC_VECTOR (1 downto 0) -- Led indicates the direction the shaft
);
end PmodENC;
architecture Behavioral of PmodENC is
-- signals
signal EncO : std_logic_vector (4 downto 0);
signal AO, BO: std_logic;
begin

C0: entity work.Debouncer
port map ( clk=>clk, Ain=>JA(4), Bin=>JA(5), Aout=> AO, Bout=> BO);

C1: entity work.Encoder
port map ( clk=>clk, A=>AO, B=>BO, BTN=>JA(6), EncOut=>EncO, LED=>Led);

C2: entity work.DisplayController
port map (clk=>clk, SWT=>JA(7), DispVal=>EncO, anode=>an, segOut=>seg );

end Behavioral;