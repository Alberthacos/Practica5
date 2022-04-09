----------------------------------------------------------------------------------------------------------------------------------
-- Module Name: Encoder - Behavioral (Encoder.vhd), component C1
-- Project Name: PmodENC
-- Target Devices: Nexys 3
-- This module defines a component Encoder with a state machine that reads
-- the position of the shaft relative to the starting position.
----------------------------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Encoder is
Port (
    clk: in STD_LOGIC;
    -- signals from the pmod
    A : in STD_LOGIC;
    B : in STD_LOGIC;
    BTN : in STD_LOGIC;
    -- position of the shaft
    EncOut: inout STD_LOGIC_VECTOR (4 downto 0);
    -- direction indicator
    LED: out STD_LOGIC_VECTOR (1 downto 0)
);
end Encoder;

architecture Behavioral of Encoder is
-- FSM states and signals
type stateType is ( idle, R1, R2, R3, L1, L2, L3, add, sub);
signal curState, nextState: stateType;
begin

--clk and button
clock: process (clk, BTN)
begin
    -- if the rotary button is pressed the count resets
    if (BTN='1') then
        curState <= idle;
        EncOut <= "00000";
    elsif (clk'event and clk = '1') then
            -- detect if the shaft is rotated to right or left
            -- right: add 1 to the position at each click
            -- left: subtract 1 from the position at each click
            if curState /= nextState then
                if (curState = add) then
                    if EncOut < "10011" then
                        EncOut <= EncOut+1;
                    else
                        EncOut <= "00000";
                    end if;

                elsif (curState = sub) then
                    if EncOut > "00000" then
                        EncOut <= EncOut-1;
                    else
                        EncOut <= "10011";
                    end if;

                else
                    EncOut <= EncOut;
                end if;

            else
                EncOut <= EncOut;
            end if;
        curState <= nextState;
    end if;
end process;

    -----FSM process
next_state: process (curState, A, B)
begin
case curState is

    --detent position
    when idle =>
        LED<= "00";
        if B = '0' then
            nextState <= R1;
        elsif A = '0' then
            nextState <= L1;
        else
             nextState <= idle;
        end if;

    -- start of right cycle
    --R1
    when R1 =>
        LED<= "01";
        if B='1' then
            nextState <= idle;
        elsif A = '0' then
            nextState <= R2;
        else
            nextState <= R1;
        end if;

    --R2
    when R2 =>
        LED<= "01";
        if A ='1' then
            nextState <= R1;
        elsif B = '1' then
            nextState <= R3;
        else
            nextState <= R2;
        end if;

    --R3
    when R3 =>
            LED<= "01";
        if B ='0' then
            nextState <= R2;
        elsif A = '1' then
            nextState <= add;
        else
            nextState <= R3;
        end if;

    when add =>
        LED<= "01";
        nextState <= idle;

        -- start of left cycle
        --L1
    when L1 =>
            LED<= "10";
        if A ='1' then
            nextState <= idle;
        elsif B = '0' then
            nextState <= L2;
        else
            nextState <= L1;
        end if;
    
        --L2
    when L2 =>
            LED<= "10";
        if B ='1' then
            nextState <= L1;
        elsif A = '1' then
            nextState <= L3;
        else
            nextState <= L2;
        end if;
    
         --L3
    when L3 =>
        LED<= "10";
        if A ='0' then
            nextState <= L2;
        elsif B = '1' then
            nextState <= sub;
        else
            nextState <= L3;
        end if;

    when sub =>
        LED<= "10";
        nextState <= idle;

    when others =>
        LED<= "11";
        nextState <= idle;
end case;

end process;
end Behavioral;