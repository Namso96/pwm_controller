----------------------------------------------------------------------------------
-- Engineer: Osman Ahmed
-- 
-- Create Date: 12.01.2021 20:50:15
-- Design Name: 
-- Module Name: baud_rate_generator 
-- Project Name: UART_LED_CONTROLLER
-- Target Devices: XC7S50
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
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

entity BAUD_GEN is
generic (

    baudrate_factor: integer:= 77

);

 Port (  
        clk, reset: in std_logic;
         s_tick: out std_logic
          );
end BAUD_GEN;

architecture Behavioral of BAUD_GEN is



signal count: unsigned(9 downto 0):= (others=>'0');  


begin
--==================== 
--Process Name: Clk_proc.
--Function: creates a clock tick 16 times the buad rate, for this we need a mod counter of ~78  
-- buadrate of 9600*16=153600, 12MHz/153600 = ~78

clk_proc: process(clk, reset)
begin 
    
    if (reset ='1') then 
        count<= (others=>'0');
    
    elsif (rising_edge(clk)) then 
        
        count<= count +1;
        
        if (count = Baudrate_factor) then 
        
            s_tick<= '1'; 
         count<= (others=>'0');
        else 
        
            s_tick<='0';
        
        end if; 
         
    
    end if;
    
    
end process;


end Behavioral;



