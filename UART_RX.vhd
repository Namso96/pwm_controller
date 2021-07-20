----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Osman Ahmed
-- 
-- Create Date: 19.09.2020 12:46:31
-- Design Name: 
-- Module Name: UART_RX
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

entity UART_RX is
Port (  clk, reset : in std_logic;
        rx: in std_logic;
        clk_ticks: in std_logic;
        
        
        rx_done: out std_logic; 
        dout: out std_logic_vector(7 downto 0)
        
  );
end UART_RX;



architecture arch of UART_RX is

type rx_fsm is (idle, start, data, stop);
signal state_reg: rx_fsm:= idle; 
signal s_reg, n_reg: unsigned(3 downto 0):= (others=>'0');
signal d_reg : std_logic_vector(7 downto 0):= (others=>'0');
signal RX_LED: std_logic;
signal edge1, edge2, clk_tick_edge: std_logic:='0'; 


begin 

edge_proc: process(clk)
begin 

if (rising_edge(clk)) then 

edge1<= clk_ticks;
edge2<= edge1; 

clk_tick_edge<= not edge2 and edge1; 

end if;


end process;






Main_proc: process (clk, reset)
begin 



if(rising_edge(clk)) then 
    
    if (reset='1') then 
    
        dout<= (others=>'0');
        rx_led<= '0';
        rx_done<='0'; 
        s_reg<= (others=>'0');
        n_reg<=(others=>'0');
    
    else
        
        
        case state_reg is 
        
        when idle => 
        
            d_reg<= (others=>'0');
            s_reg<=(others=>'0'); 
            n_reg<=(others=>'0');
            rx_done<='0';
            RX_LED<='0'; 
            if (rx='0') then 
            
            state_reg<= start; 
            
            
            s_reg<=(others=>'0'); 
            else 
            state_reg<= idle;
            end if; 
        
        when start =>
            
            if (clk_tick_edge='1') then
            
                if (s_reg=7) then 
                    state_reg<= data;
                     s_reg<= (others=>'0');
                     n_reg<=(others=>'0');
                else 
                    s_reg<= s_reg +1;
                    state_reg<=start;
                end if;
            end if; 
            
         when data => 
            
            if (clk_tick_edge='1') then 
            
                if (s_reg=15) then 
                
                    d_reg<= rx & d_reg(7 downto 1);
                    s_reg<=(others=>'0');
                        
                        if (n_reg=7) then 
                        
                            state_reg<= stop; 
                            s_reg<= (others=>'0');
                            n_reg<=(others=>'0');
                             
                        else 
                            n_reg<= n_reg+1;
                            state_reg<= data; 
                        end if;
                 else
                 
                    s_reg<= s_reg+1;
                 end if; 
              end if;
          
          when stop => 
          
            if (clk_tick_edge='1') then 
            
                if (s_reg=15) then 
                    rx_done<='1';
                    s_reg<= (others=>'0');
                    RX_LED<='1';
                    dout<= d_reg;
                    state_reg<= idle;
                
                else 
                    s_reg<= s_reg +1; 
                    state_reg<= stop;
                end if;
             end if;  
           end case; 



end if;
end if; 
end process; 






end ARCH; 
