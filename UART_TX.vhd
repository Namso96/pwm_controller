----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Osman Ahmed
-- 
-- Create Date: 19.09.2020 12:46:31
-- Design Name: 
-- Module Name: UART_TX
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

use IEEE.NUMERIC_STD.ALL;

entity Uart_TX is
 Port (  clk: in std_logic;
         reset: in std_logic;
         clk_ticks: in std_logic;
         din: in std_logic_vector(7 downto 0);
         tx_load: in std_logic; -- best to set it to rxdone
         
         
         tx_done: out std_logic;
         tx: out std_logic       
   );
end Uart_TX;

architecture Behavioral of Uart_TX is

type tx_sm is (idle, tx_start, tx_data, tx_stop );

signal state_reg: tx_sm:=idle; 
signal TX_LED: std_logic;
--clock tick counter
signal  s_reg: unsigned (3 downto 0);

signal d_reg: std_logic_vector(7 downto 0); -- data 

signal n_reg: unsigned (2 downto 0); -- data bit counter  

signal tx_reg: std_logic; -- data out 

signal edge1, edge2, clk_tick_edge: std_logic:='0';

begin



edge_proc: process(clk)
begin 

if (rising_edge(clk)) then 

edge1<= clk_ticks;
edge2<= edge1; 

clk_tick_edge<= not edge2 and edge1; -- rising edge 

end if;


end process;


clk_proc: process (reset, clk)

begin 

if (reset='1') then 
state_reg<= idle;
s_reg<= (others=>'0');
d_reg<= (others=>'0');
n_reg<=(others=>'0');
tx<='0';

elsif (clk'event and clk='1') then


    case state_reg is 
        when idle =>
            tx<= '1'; -- keep line high in idle
             
            if tx_load='1' then  
                state_reg<= tx_start; 
                s_reg<= (others=>'0'); -- clear counter 
                d_reg<= din; 
            end if; 
        
        when tx_start =>
        tx<='0'; -- send start bit 
        
        if (clk_tick_edge='1') then 
             if (s_reg= 15) then 
                 state_reg<= tx_data; -- after 15 ticks send data
                 s_reg<= (others=>'0'); -- clear counters 
                 n_reg<= (others=>'0');
             else 
                s_reg<= s_reg+1; -- if sreg not 15 ++ counter
              end if; 
         end if;
         
        when tx_data =>
        
        -- assign LSB to t_next when is assinged to txreg evey clk cycle 
        -- tx_reg is then assingn to tx outside the process 
        tx<= d_reg(0); 
        TX_LED<= d_reg(0);
        
        if (clk_tick_edge ='1') then 
        
             if (s_reg=15) then 
                 s_reg<= (others=>'0');
                 d_reg<= '0' & d_reg(7 downto 1);
                 
                 if (n_reg= 7) then 
                    state_reg<= tx_stop; 
                 else 
                    n_reg<= n_reg+1; 
                 end if;
             
             else 
                s_reg<= s_reg+1; 
             end if; 
         end if; 
         
         when tx_stop=> 
             tx<= '1'; -- pull line high for stop 
             if (clk_tick_edge='1') then 
                 if (s_reg=15) then 
                     state_reg<= idle; -- after 15 clck ticks go back into idle 
                     tx_done<= '1'; 
                 else 
                    s_reg<= s_reg+1; 
                  
                 end if; 
             end if; 
     end case; 


end if;
end process; 




 
 end Behavioral; 
