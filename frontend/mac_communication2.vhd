----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:54:35 04/28/2017 
-- Design Name: 
-- Module Name:    mac_communication2 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mac_communication2 is
port(
		  clk : in STD_LOGIC;
	  	  start_mac_comm : in STD_LOGIC;
		  done_mac_comm : out STD_LOGIC;
		  data_send_mac_comm : in STD_LOGIC_VECTOR (63 downto 0);
		  data_response_mac_comm : out STD_LOGIC_VECTOR (63 downto 0);
		  is_suf_atm : in STD_LOGIC;
		  
		  request_mac_comm : out STD_LOGIC;
		  is_suf_atm_request : out STD_LOGIC;
		  data_request_mac_comm : out STD_LOGIC_VECTOR (63 downto 0);
		  data_reply_to_request_mac_comm : in STD_LOGIC_VECTOR (63 downto 0);
		  reply_mac_comm_valid : in STD_LOGIC;
		  reply_mac_comm_notvalid : in STD_LOGIC
		  );
end mac_communication2;

architecture Behavioral of mac_communication2 is

begin


end Behavioral;

