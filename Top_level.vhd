----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Osman Ahmed
-- 
-- Create Date: 12.01.2021 20:50:15
-- Design Name: 
-- Module Name: Top_level - Behavioral
-- Project Name: UART_LED_CONTROLLER
-- Target Devices: XC7S50
-- Tool Versions: 
-- Description: top level module
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- ll
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

entity Top_level is
 Port ( 
 
           clk: in STD_LOGIC;
           reset: in STD_LOGIC;  
           TX : out STD_LOGIC;
           RX : in STD_LOGIC;
           LED : out STD_LOGIC_VECTOR (3 downto 0);
           PWM_1: out STD_LOGIC
 
 
 );
end Top_level;

architecture Behavioral of Top_level is

component pwm_mod is
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
end component;

component UART_TOP is
  Port (  
           
           clk: in STD_LOGIC;
           reset: in STD_LOGIC;
           
           o_rx_data: out std_logic_vector(7 downto 0);
           o_tx_data: in std_logic_vector(7 downto 0);    
           i_tx_load: in std_logic;
           o_rx_done: out std_logic;  
           
           TX : out STD_LOGIC;
           RX : in STD_LOGIC );
end component;


component command_mod is
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
end component;

signal s_uart_rx_data: std_logic_vector(7 downto 0);
signal s_uart_rx_done: std_logic; 
signal s_uart_tx_data: std_logic_vector(7 downto 0);
signal s_uart_tx_load: std_logic; 
signal s_pwm_duty : std_logic_vector(7 downto 0);


begin


uart_mod: UART_TOP port map (

clk=> clk,
reset=>reset, 
o_rx_data => s_uart_rx_data,
o_tx_data => s_uart_tx_data,
i_tx_load => s_uart_tx_load ,
o_rx_done => s_uart_rx_done ,
TX => TX ,
RX => RX

);

cmd_mod: command_mod port map (

    i_clk => clk,
    i_rst => reset, 
    i_rx_uart_data => s_uart_rx_data,
    i_rx_done => s_uart_rx_done,
    
    o_led => LED,
    o_pwm_duty => s_pwm_duty,
    
    o_tx_uart_data => s_uart_tx_data,
    o_tx_load => s_uart_tx_load 

);


pwm_mod1: pwm_mod port map (

   clk_in => clk,
   rst_in  => reset, 
   pwm_duty=> s_pwm_duty,
   enable_pwm => '1',
    
   pwm_output =>PWM_1

);


end Behavioral;












