----------------------------------------------------------------------------------------------------------------------------------
-- Module Name: DisplayController - Behavioral (DisplayController.vhd), component C2
-- Project Name: PmodENC
-- Target Devices: Nexys 3
-- This module defines a DisplayController that controls the seven segments display to work with
-- the output of the Encoder
----------------------------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity DisplayController is
Port (
clk : in std_logic;
--signal from the Pmod
SWT: in std_logic;
--output from the Encoder
DispVal : in STD_LOGIC_VECTOR (4 downto 0);
--controls the display digits
anode: out std_logic_vector(3 downto 0);
--controls which digit to display
segOut : out STD_LOGIC_VECTOR (6 downto 0));
end DisplayController;
architecture Behavioral of DisplayController is
-- signals
signal sclk: std_logic_vector (17 downto 0);
signal seg: std_logic_vector (6 downto 0);
begin
process(clk, SWT)
begin
-- turns off the seven segments display when the switch is off
--or else turn on the seven segments display
if (SWT = '0') then
anode<="1111";
--refresh each digit
elsif clk'event and clk = '1' then
-- 0ms refersh digit 0
    if sclk = "000000000000000000" then
        anode<="1110";
        segOut <= seg;
        sclk <= sclk +1;
        -- 1ms refresh digit 1
    elsif sclk = "011000011010100000" then
    -- display a 1 on the tenth digit if the number is greater than 9
        if DispVal > "01001" then
        segOut <= "1111001";
        anode<="1101";
        end if;
        sclk <= sclk +1;
    -- 2ms
    elsif sclk = "110000110101000000" then
        sclk <= "000000000000000000";
    else
        sclk <= sclk +1;
    end if;
end if;
end process;

with DispVal select
-- gfedcba DERECHA ES NUEVA IZQUIERDA PARA AMIBA
seg <= "0000001" when "00000", --0      10000000
"1111001" when "00001", --1
"0010010" when "00010", --2 0100100
"0000110" when "00011", --3 0110000
"1001100" when "00100", --4 0011001
"0100100" when "00101", --5 0010010 00
"0100000" when "00110", --6 0000010
"0001111" when "00111", --7 1111000
"0000000" when "01000", --8 0000000
"0000100" when "01001", --9 0010000
"0000001" when "01010", --10 1000000
"1001111" when "01011", --11 1111001
"0010010" when "01100", --12 0100100
"0000110" when "01101", --13 0110000
"1001100" when "01110", --14 0011001
"0100100" when "01111", --15 0010010
"0100000" when "10000", --16 0000010
"0001111" when "10001", --17 1111000
"0000000" when "10010", --18
"0000100" when "10011", --19 0010000
"0111111" when others;
end Behavioral;