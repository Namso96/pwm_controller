----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Osman Ahmed
-- 
-- Create Date: 12.01.2021 20:50:15
-- Design Name: 
-- Module Name: uart_top_level
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UART_TOP is
  Port (  
           
           clk: in STD_LOGIC;
           reset: in STD_LOGIC;
           
           o_rx_data: out std_logic_vector(7 downto 0);
           o_tx_data: in std_logic_vector(7 downto 0);    
           i_tx_load: in std_logic;
           o_rx_done: out std_logic;  
           
           TX : out STD_LOGIC;
           RX : in STD_LOGIC );
end UART_TOP;

architecture Behavioral of UART_TOP is


component UART_RX is port (
        clk, reset : in std_logic;
        rx: in std_logic;
        
        
        clk_ticks: in std_logic;
        
        
        rx_done: out std_logic;
       
        dout: out std_logic_vector(7 downto 0)
       
        
        );
        end component; 
        
        

component UART_TX is port (
         clk: in std_logic;
         reset: in std_logic;
         clk_ticks: in std_logic;
         din: in std_logic_vector(7 downto 0);
         tx_load: in std_logic; -- best to set it to rxdone
         
         
         tx_done: out std_logic;
         tx: out std_logic  
        
        );
        end component; 
        
component BAUD_GEN is         
generic (

        baudrate_factor: integer:= 77

);

Port (  
        clk, reset: in std_logic;
        s_tick: out std_logic
          );
end component;        


signal s_clk, s_reset : std_logic;
signal s_rx: std_logic;
signal s_clk_ticks: std_logic;


signal s_rx_done: std_logic;
SIGNAL s_RX_LED: std_logic;
signal s_dout:  std_logic_vector(7 downto 0);




--tx signals 
signal s_din: std_logic_vector(7 downto 0); 
signal s_tx_load: std_logic;
signal s_tx_led: std_logic; 
signal s_tx_done: std_logic;
signal s_tx: std_logic; 

begin


rx_mod: UART_RX PORT MAP (

clk=>clk,
reset=>reset,
rx=>RX,
clk_ticks=> s_clk_ticks,
 rx_done=> o_rx_done,

 dout=>o_rx_data

);

tx_mod: UART_TX port map (

clk=> clk,
reset=> reset,
clk_ticks=>s_clk_ticks,
din=> o_tx_data,
tx_load=> i_tx_load,

tx_done=> s_tx_done,
tx=> TX

);

Baud_mod: BAUD_GEN PORT MAP (


 clk => clk, 
 reset=> reset ,
 s_tick => s_clk_ticks

);
















--sw_proc: process (switch )
--begin 


--case (switch ) is 
    
--    when "00" =>
    
--        s_din<= s_dout; 
    
--    when "01"=>
    
--        s_din<= "01000001";
    
--    when others => 
    
--        s_din<= s_dout; 

--end case; 


--end process; 





end Behavioral;








