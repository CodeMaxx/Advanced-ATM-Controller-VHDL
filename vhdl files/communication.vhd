----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:38:05 03/15/2017 
-- Design Name: 
-- Module Name:    communication - Behavioral 
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
use ieee.numeric_std.all;

use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity communication is
	GENERIC( wait_cycles : STD_LOGIC_VECTOR (27 downto 0) := x"ee6b280");
	PORT( 
		  clk : in STD_LOGIC;
		  reset : in STD_LOGIC;
		  is_suf_atm: in STD_LOGIC;
		  start_comm : in STD_LOGIC;
		  done_comm : out STD_LOGIC;
		  data_send: in STD_LOGIC_VECTOR (63 downto 0);
		  data_recieved: out STD_LOGIC_VECTOR (63 downto 0);
		  restriction_2000: out STD_LOGIC_VECTOR (7 downto 0);
		  restriction_1000: out STD_LOGIC_VECTOR (7 downto 0);
		  restriction_500: out STD_LOGIC_VECTOR (7 downto 0);
		  restriction_100: out STD_LOGIC_VECTOR (7 downto 0);
		  restriction_total: out STD_LOGIC_VECTOR (31 downto 0);
		  chanAddr_in  : in std_logic_vector(6 downto 0);  -- the selected channel (0-127)
		  data_balance : out STD_LOGIC_VECTOR (31 downto 0);
		  comm_success : out STD_LOGIC;
	-- Host >> FPGA pipe:
	h2fData_in   : in std_logic_vector(7 downto 0);  -- data lines used when the host writes to a channel
	h2fValid_in  : in std_logic;                     -- '1' means "on the next clock rising edge, please accept the data on h2fData"
	h2fReady_out  : out std_logic;                     -- channel logic can drive this low to say "I'm not ready for more data yet"
	
	-- Host << FPGA pipe:
	f2hData_out   : out std_logic_vector(7 downto 0);  -- data lines used when the host reads from a channel
	f2hValid_out  : out std_logic;                     -- channel logic can drive this low to say "I don't have data ready for you"
	f2hReady_in  : in std_logic                   -- '1' means "on the next clock rising edge, put your next byte of data on f2hData"
		  
		  );
end communication;

architecture Behavioral of communication is 
signal channel0value : std_logic_vector(7 downto 0) := "00000000";
signal checkuser : std_logic_vector(7 downto 0) := "00000000";
signal a : std_logic_vector(7 downto 0) := "00000000";
signal b : std_logic_vector(7 downto 0) := "00000000";
signal c : std_logic_vector(7 downto 0) := "00000000";
signal d : std_logic_vector(7 downto 0) := "00000000";
signal e : std_logic_vector(7 downto 0) := "00000000";
signal f : std_logic_vector(7 downto 0) := "00000000";
signal g : std_logic_vector(7 downto 0) := "00000000";
signal h : std_logic_vector(7 downto 0) := "00000000";
signal x1 : std_logic_vector(7 downto 0) := "00000000";
signal x2 : std_logic_vector(7 downto 0) := "00000000";
signal x3 : std_logic_vector(7 downto 0) := "00000000";
signal x4 : std_logic_vector(7 downto 0) := "00000000";
signal b1 : std_logic_vector(7 downto 0) := "00000000";
signal b2 : std_logic_vector(7 downto 0) := "00000000";
signal b3 : std_logic_vector(7 downto 0) := "00000000";
signal b4 : std_logic_vector(7 downto 0) := "00000000";
signal temp : std_logic_vector(27 downto 0) := x"0000000";

begin
	with is_suf_atm select channel0value <=
					"00000001" when '1',
					"00000010" when others;	
	with checkuser select done_comm <= 
					'1' when "00000001",
					'1' when "00000010",
					'1' when "00000011",
					'1' when "00000100",
					'0' when others;	
	process(clk,reset,temp)
	begin
		--f2hValid_out <= '1';
		--h2fReady_out <= '1';
		if(checkuser = "0") then
			if(temp < wait_cycles) then
				temp <= temp + "1";
				comm_success <= '1';
			elsif(temp < wait_cycles + "11") then
				temp <= temp + "1";
				comm_success <= '0';
			else
				comm_success <= '0';
				temp <= x"0000000";
			end if;
		else
			comm_success <= '1';
			temp <= x"0000000";
		end if;
		if(reset = '1') then
			checkuser <= "00000000";
		elsif(rising_edge(clk)) then
			h2fReady_out <= '1';
			if(h2fValid_in = '1') then
				if(chanAddr_in = "0010100") then
					restriction_2000 <= h2fData_in;
				elsif(chanAddr_in = "0010101") then
					restriction_1000 <= h2fData_in;
				elsif(chanAddr_in = "0010110") then
					restriction_500 <= h2fData_in;
				elsif(chanAddr_in = "0010111") then
					restriction_100 <= h2fData_in;
				elsif(chanAddr_in = "0011000") then
					x1 <= h2fData_in;
				elsif(chanAddr_in = "0011001") then
					x2 <= h2fData_in;
				elsif(chanAddr_in = "0011010") then
					x3 <= h2fData_in;
				elsif(chanAddr_in = "0011011") then
					x4 <= h2fData_in;
				end if;
					restriction_total <= x1 & x2 & x3 & x4;
			end if;
			if(start_comm = '1') then
				if(f2hReady_in = '1') then
					f2hValid_out <= '1';
					if(chanAddr_in = "0000000") then
						f2hData_out <= channel0value;
					elsif(chanAddr_in = "0000001") then
						f2hData_out <= data_send(63 downto 56);
					elsif(chanAddr_in = "0000010") then
						f2hData_out <= data_send(55 downto 48);
					elsif(chanAddr_in = "0000011") then
						f2hData_out <= data_send(47 downto 40);
					elsif(chanAddr_in = "0000100") then
						f2hData_out <= data_send(39 downto 32);
					elsif(chanAddr_in = "0000101") then
						f2hData_out <= data_send(31 downto 24);
					elsif(chanAddr_in = "0000110") then
						f2hData_out <= data_send(23 downto 16);
					elsif(chanAddr_in = "0000111") then
						f2hData_out <= data_send(15 downto 8);
					elsif(chanAddr_in = "0001000") then
						f2hData_out <= data_send(7 downto 0);
					end if;
				end if;
				h2fReady_out <= '1';
				if(h2fValid_in = '1') then
					if(chanAddr_in = "0001001") then
						checkuser <= h2fData_in;
					elsif(chanAddr_in = "0001010") then
						a <= h2fData_in;
					elsif(chanAddr_in = "0001011") then
						b <= h2fData_in;
					elsif(chanAddr_in = "0001100") then
						c <= h2fData_in;
					elsif(chanAddr_in = "0001101") then
						d <= h2fData_in;
					elsif(chanAddr_in = "0001110") then
						e <= h2fData_in;
					elsif(chanAddr_in = "0001111") then
						f <= h2fData_in;
					elsif(chanAddr_in = "0010000") then
						g <= h2fData_in;
					elsif(chanAddr_in = "0010001") then
						h <= h2fData_in;
					elsif(chanAddr_in = "0011110") then
						b1 <= h2fData_in;
					elsif(chanAddr_in = "0011111") then
						b2 <= h2fData_in;
					elsif(chanAddr_in = "0100000") then
						b3 <= h2fData_in;
					elsif(chanAddr_in = "0100001") then
						b4 <= h2fData_in;
					end if;
					data_recieved <= a & b & c & d & e & f & g & h;
					data_balance <= b1 & b2 & b3 & b4;
				end if;
			else
				f2hValid_out <= '0';
				h2fReady_out <= '0';
			end if;
		end if;
	end process;
end Behavioral;

