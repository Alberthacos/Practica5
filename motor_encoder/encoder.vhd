----------------------------------------------------------------------------------------------------------------------------------
-- Module Name: Encoder - Behavioral (Encoder.vhd), component C1
-- Project Name: PmodENC
-- Target Devices: Nexys 3
--angulo de paso: 5.625°
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
	puertos,leds: OUT std_logic_vector (1 to 4); --leds testigos y salida al puerto para el motor, representa el encdedido de las bobinas
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
signal conter: integer range 1 to 3;
signal ciclo1,ciclo2: integer range 0 to 10:=0;
signal conta_1250us: integer range 1 to 60000:=1; -- pulso1 de 1250us@400Hz (0.25ms) 62500
signal SAL_400Hz: STD_LOGIC; -- reloj de 400Hz
signal sw1,sw2: std_logic_vector(3 downto 0):="0000";
signal sd1,sd2: std_logic:='0';
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
                     --  conter <=1;
                    else
                        EncOut <= "00000";
                    --    conter <=3;
                     --   conter <=1;
                      
                    end if;

                elsif (curState = sub) then
                    if EncOut > "00000" then
                        EncOut <= EncOut-1;
                     --  conter <=2;
                    else
                        EncOut <= "10011";
                 --       conter <=3;                      
                        -- conter <=2;
                       
                    end if;

                else
                    EncOut <= EncOut;
                  --  conter <= 3;
                   
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
    when idle =>  conter<=3;
        LED<= "00"; 
        if B = '0' then
            nextState <= R1; conter<=1;
        elsif A = '0' then
            nextState <= L1; conter<=2;
        else
             nextState <= idle;
        end if;

    -- start of right cycle
    --R1
    when R1 => conter<=3; conter<=1;
        LED<= "01";
        if B='1' then
            nextState <= idle;
        elsif A = '0' then
            nextState <= R2;
        else
            nextState <= R1;
        end if;

    --R2
    when R2 =>-- conter<=3; conter <=1;
        LED<= "01";
        if A ='1' then
            nextState <= R1;
        elsif B = '1' then
            nextState <= R3;
        else
            nextState <= R2;
        end if;

    --R3
    when R3 => conter<=3; conter <=1;
            LED<= "01";
        if B ='0' then
            nextState <= R2;
        elsif A = '1' then
            nextState <= add;
        else
            nextState <= R3;
        end if;

    when add => conter <=3; conter <=1;
        LED<= "01";
        nextState <= idle;

        -- start of left cycle
        --L1
    when L1 => conter<=3; conter <=2;
            LED<= "10";
        if A ='1' then
            nextState <= idle;
        elsif B = '0' then
            nextState <= L2;
        else
            nextState <= L1;
        end if;
    
        --L2
    when L2 => conter<=3; conter <=2;
            LED<= "10";
        if B ='1' then
            nextState <= L1;
        elsif A = '1' then
            nextState <= L3;
        else
            nextState <= L2;
        end if;
    
         --L3
    when L3 => conter<=3; conter <=2;
        LED<= "10";
        if A ='0' then
            nextState <= L2;
        elsif B = '1' then
            nextState <= sub;
        else
            nextState <= L3;
        end if;

    when sub => conter <=3; conter <=2;
        LED<= "10";
        nextState <= idle;

    when others =>
        LED<= "11";
        nextState <= idle; 
end case;
end process;

puerto: process(CLK,conter) begin
    
        if rising_edge(CLK) then
            if (conta_1250us = 60000) then --cuenta 1250us (50MHz=62500)
                    -- if (conta_1250us = 125000) then --cuenta 1250us (100MHz=125000)
                    SAL_400Hz <= NOT(SAL_400Hz); --genera un barrido de 2.5ms
                    conta_1250us <= 1;
            else
                    conta_1250us <= conta_1250us + 1;
            end if;
        end if;

    
 
IF SAL_400Hz'EVENT and SAL_400Hz='1'  then
    if (conter = 1 or sd1= '1') and sd2 ='0' then
        if sw1 /= "0100" and ciclo1 /=10 THEN sw1 <= sw1 + '1';
                case sw1 is
                when "0000" => leds <= "1100"; puertos <= "1100"; sd1 <='1';
                when "0001" => leds <= "0110"; puertos <= "0110"; sd1 <='1';
                when "0010" => leds <= "0011"; puertos <= "0011"; sd1 <='1';
                when others => leds <= "1001"; puertos <= "1001"; sd1 <='1'; ciclo1 <= ciclo1+1; sw1 <="0000"; --leds <= "0000"; puertos <= "0000"; 
                end case;
               
        end if;

    elsif (conter = 2 or sd2 ='1') and sd1 ='0'then 
        if sw2 /= "0100" and ciclo2 /=10  THEN sw2 <= sw2 + '1';
                case sw2 is
                when "0000" => leds <= "1001"; puertos <= "1001"; sd2 <='1';--1001
                when "0001" => leds <= "0011"; puertos <= "0011"; sd2 <='1';--0011
                when "0010" => leds <= "0110"; puertos <= "0110"; sd2 <='1';--0110
                when others => leds <= "1100"; puertos <= "1100"; sd2 <='1'; ciclo2 <= ciclo2+1; sw2 <= "0000"; sd2 <='1'; --leds <= "0000"; puertos <= "0000"; --1100 
                end case;
                
        end if;
    else sw1 <="0000"; ciclo1 <=0; sw2 <="0000"; ciclo2 <=0;-- leds<="0000"; puertos<="0000";
    end if;
    if (ciclo1 = 10 or ciclo2 = 10) then leds <= "0000"; puertos <= "0000"; sd1 <='0'; sd2 <='0'; end if;
    
end if;

    end process;

end Behavioral;