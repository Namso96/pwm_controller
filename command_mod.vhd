----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Osman Ahmed
-- 
-- Create Date: 12.01.2021 20:50:15
-- Design Name: 
-- Module Name: command_mod
-- Project Name: UART_LED_CONTROLLER
-- Target Devices: XC7S50
-- Tool Versions: 
-- Description: command controller for uart data 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- packge for commands
use work.const_pkg.all;

entity command_mod is
  Port (
  
    
    i_clk: in std_logic;
    i_rst: in std_logic;  
    i_rx_uart_data: in std_logic_vector(7 downto 0);
    i_rx_done: in std_logic; 
    
    o_led: out std_logic_vector(3 downto 0); 
    o_pwm_duty: out std_logic_vector(7 downto 0);
    
    o_tx_uart_data: out std_logic_vector(7 downto 0);
    o_tx_load: out std_logic
    
   );
end command_mod;

architecture Behavioral of command_mod is

type main_fsm is (idle, cmd_decode, cmd_set_led, cmd_set_pwm, invalid_cmd);
signal state_reg: main_fsm:= idle; 
signal command_reg: std_logic_vector(7 downto 0);
signal data_cmd_reg: std_logic_vector(7 downto 0);
begin

main_proc: process(i_clk)
begin 
if (rising_edge(i_clk)) then 

    
    case state_reg is 
    
        when idle =>
        
            o_tx_load<= '0';
           
            -- rx data from uart ready 
            if (i_rx_done ='1') then 
                
                
                command_reg<=i_rx_uart_data;  
                state_reg<= cmd_decode;
            else 
            
                state_reg<= idle;
            
            end if;
        --======== decode all commands 
        when cmd_decode => 
        
            -- decode the commands 
            case command_reg is 
            
                when SET_COMMAND_LED =>
                        
                        state_reg<= cmd_set_led;
                
                when SET_PWM_COMMAND =>
                
                     state_reg<= cmd_set_pwm;    
                       
                when others =>
                
                    state_reg<= invalid_cmd;
                
            end case;
        
        --========= excute commands 
        when cmd_set_led =>
        
            if (i_rx_done='1') then 
            
                o_led(0)<=i_rx_uart_data(0); 
                o_led(1)<=i_rx_uart_data(1);
                o_led(2)<=i_rx_uart_data(2);
                o_led(3)<=i_rx_uart_data(3);
                
                state_reg<= idle;
            
            else 
            
                state_reg<= cmd_set_led;
                
            end if; 
            
        when cmd_set_pwm => 
        
            if (i_rx_done='1') then 
            
                o_pwm_duty<= i_rx_uart_data;
                
                state_reg<= idle;
            
            else 
            
                state_reg<= cmd_set_pwm;
                
            end if; 
        
        
        
        when invalid_cmd =>
        
            o_tx_uart_data<= INVALID_COMMAND;
            o_tx_load<= '1'; -- begin tx
            
            state_reg<= idle; 
        
        
    end case;


end if;

end process;



end Behavioral;






