----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Osman Ahmed
-- 
-- Create Date: 18.07.2021 15:16:35
-- Design Name: 
-- Module Name: pwm_mod - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- PWM for motor control
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pwm_mod is
generic(
    pwm_freq: integer:= 50;
    sys_freq: integer := 12000000;
    pwm_res: integer:= 8
);
 Port (
 
    clk_in, rst_in : in std_logic; 
    pwm_duty: in std_logic_vector(pwm_res - 1 downto 0);
    enable_pwm: in std_logic; 
    
    pwm_output: out std_logic
 
  );
end pwm_mod;

architecture Behavioral of pwm_mod is

constant pwm_period : integer := sys_freq/pwm_freq; 
signal ton_period: integer range 0 to pwm_period := 0;
signal ton_div: integer range 0 to pwm_period := 0;

signal clk_counter : integer range 0 to pwm_period; 
signal duty_counter: integer range 0 to pwm_period; 

begin

main_proc: process(clk_in, rst_in) 
begin 
if(rst_in = '1') then 

    pwm_output<= '0';  
    clk_counter<= 0;
    duty_counter<= 0; 

else
    
    if (rising_edge(clk_in))then 
    
        if (clk_counter = pwm_period - ton_period) then 
        
            if  (duty_counter = ton_period) then
             -- clear counters and latch in new duty cycle
             pwm_output<= '0'; 
             duty_counter<= 0;
             clk_counter<= 0;
        
             ton_period<= (to_integer(unsigned(pwm_duty)) * pwm_period) / ((2**pwm_res) - 1);
                  
            else 
            
            pwm_output<= '1';  
            duty_counter<= duty_counter +1;
            
            end if;
        
        else
        
            clk_counter <= clk_counter  +1;
            pwm_output<= '0'; 
        
        end if;
    
    end if;

end if;

end process; 

end Behavioral;


















