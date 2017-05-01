----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:25:41 03/15/2017 
-- Design Name: 
-- Module Name:    ATM_main_controller - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ATM_main_controller is
 Generic (	value2000 : std_logic_vector(10 downto 0) := "11111010000";
    		value1000 : std_logic_vector(9 downto 0) := "1111101000";
    		value500 : std_logic_vector(8 downto 0) := "111110100";
    		value100 : std_logic_vector(6 downto 0) := "1100100"
    		);
	Port(clk : in  STD_LOGIC;
			reset_button : in  STD_LOGIC;
			data_in_sliders : in  STD_LOGIC_VECTOR (7 downto 0);
			next_data_in_button : in  STD_LOGIC;
			done_button: in STD_LOGIC;
			start_button: in STD_LOGIC;
			data_out_leds : out  STD_LOGIC_VECTOR (7 downto 0);
			data_to_be_encrypted: out STD_LOGIC_VECTOR (63 downto 0);
			data_to_be_decrypted: out STD_LOGIC_VECTOR (63 downto 0);
			encrypted_data: in STD_LOGIC_VECTOR (63 downto 0);
			encrypted_data_comm: out STD_LOGIC_VECTOR (63 downto 0);
			decrypted_data_comm: in STD_LOGIC_VECTOR (63 downto 0);
			decrypted_data: in STD_LOGIC_VECTOR (63 downto 0);
			start_encrypt : out STD_LOGIC;
			start_decrypt : out STD_LOGIC;
			done_encrypt : in STD_LOGIC;
			done_decrypt : in STD_LOGIC;
			start_comm : out STD_LOGIC;
			done_comm : in STD_LOGIC;
			is_suf_atm: out STD_LOGIC;
			restriction_2000: in STD_LOGIC_VECTOR (7 downto 0);
			restriction_1000: in STD_LOGIC_VECTOR (7 downto 0);
			restriction_500: in STD_LOGIC_VECTOR (7 downto 0);
			restriction_100: in STD_LOGIC_VECTOR (7 downto 0);
			restriction_total: in STD_LOGIC_VECTOR (31 downto 0);
			load_bank_id: in STD_LOGIC

			--start_mac_comm : out STD_LOGIC;
			--done_mac_comm : in STD_LOGIC;
			--data_send_mac_comm : out STD_LOGIC_VECTOR (63 downto 0);
			--data_response_mac_comm : in STD_LOGIC_VECTOR (63 downto 0);

			--request_mac_comm : in STD_LOGIC;
			--is_suf_atm_request : in STD_LOGIC;
			--data_request_mac_comm : in STD_LOGIC_VECTOR (63 downto 0);
			--data_reply_to_request_mac_comm : out STD_LOGIC_VECTOR (63 downto 0);
			--reply_mac_comm_valid : out STD_LOGIC;
			--reply_mac_comm_notvalid : out STD_LOGIC

			--data_balance : in STD_LOGIC_VECTOR (31 downto 0);
			--comm_success : in STD_LOGIC
		   );
end ATM_main_controller;

architecture Behavioral of ATM_main_controller is

	component timer
		port (clk: in STD_LOGIC;
				blink: out STD_LOGIC;
				i: out STD_LOGIC);
	end component;
	



	component read_multiple_data_bytes
	port (clk : in  STD_LOGIC;
				reset : in STD_LOGIC;
				data_in : in  STD_LOGIC_VECTOR (7 downto 0);
				next_data : in  STD_LOGIC;
				data : out  STD_LOGIC_VECTOR (63 downto 0);
				done : out STD_LOGIC;
				data_received : out STD_LOGIC_VECTOR (2 downto 0));
	end component;


	signal current_user_bank_id : STD_LOGIC_VECTOR(4 downto 0);
	signal bank_id : STD_LOGIC_VECTOR(4 downto 0);
	signal timer_inp : STD_LOGIC;
	signal read_input_done: STD_LOGIC;
	signal state: STD_LOGIC_VECTOR(4 downto 0) := "00000";
	signal state2: STD_LOGIC_VECTOR(4 downto 0) := "00000";
	signal n2000, n500, n100, n1000 : std_logic_vector(7 downto 0) := x"00";
	signal data_collected_so_far : STD_LOGIC_VECTOR(2 downto 0);
	signal d2000, d1000, d500, d100 : std_logic_vector(7 downto 0) := x"00";
	signal is_blink : STD_LOGIC;
	signal count_blink : std_logic_vector(2 downto 0) := "000";
	signal double_time: STD_LOGIC := '0';
	signal data_to_be_encrypted_signal : STD_LOGIC_VECTOR (63 downto 0);
	signal done_or_reset : STD_LOGIC;
	signal finish_display : STD_LOGIC := '0';
	signal money : std_logic_vector(31 downto 0);
	signal substate : STD_LOGIC_VECTOR(2 downto 0) := "000";
	signal is_suf_atm_signal : STD_LOGIC;

--signal data_balance_signal : STD_LOGIC_VECTOR(31 downto 0);
--	type balance is array (0 to 4) of std_logic_vector(31 downto 0);
--	type id_or_password is array (0 to 4) of std_logic_vector(15 downto 0);
--	signal cache_user_balance : balance;
--	signal cache_user_id : id_or_password;
--	signal cache_user_password : id_or_password;
--	signal temp_user_id : std_logic_vector(15 downto 0);
--	signal temp_user_balance : std_logic_vector(31 downto 0);
--	signal temp_user_password : std_logic_vector(15 downto 0);
--	signal substate2 : std_logic_vector(2 downto 0) := "000";
--	signal substate3 : std_logic := '0';
--	signal substate4 : std_logic_vector(3 downto 0):= "0000";
--	signal check : std_logic_vector(3 downto 0) := "0000";

begin
	done_or_reset <= reset_button or done_button;
	timer1: timer
		port map(clk => clk,
					blink => timer_inp,
					i => is_blink);
					
	data_inp: read_multiple_data_bytes
					  port map (clk => clk,
									reset => done_or_reset,
									data_in => data_in_sliders,
									next_data => next_data_in_button,
									data => data_to_be_encrypted_signal,
									data_received => data_collected_so_far,
									done => read_input_done);
									
	process(state,start_button,reset_button,clk)
	begin
		if(rising_edge(clk)) then
			if(load_bank_id = '1') then
				bank_id <= data_in_sliders(4 downto 0);
			end if;

			--if(request_mac_comm = '1' and state2 = "00000") then
			--	data_to_be_decrypted <= data_request_mac_comm;
			--	start_decrypt <= '1';
			--	state2 <= "00001";
			--elsif(state2 = "00001" and done_decrypt = '1') then
			--	if(bank_id = decrypted_data(52 downto 48)) then 
			--		state2 <= "00010";
			--		is_suf_atm <= is_suf_atm_request;
			--		encrypted_data_comm <= data_request_mac_comm;
			--		start_comm <= '1';
			--	else
			--		reply_mac_comm_notvalid <= '1';
			--		state2 <= "00000";
			--	end if;
			--elsif(state2 = "00010" and done_comm = '1') then
			--	start_comm <= '0';
			--	data_reply_to_request_mac_comm <= decrypted_data_comm;
			--	reply_mac_comm_valid <= '1';
			--	state2 <= "00000";
			--else
			--	reply_mac_comm_valid <= '0';
			--	reply_mac_comm_notvalid <= '0';
			--end if;	

			if(reset_button = '1') then
				state <= "00000";				-- ready state
				n100 <= X"00";
				n500 <= X"00";
				n1000 <= X"00";
				n2000 <= X"00";
			elsif(state = "00000" and start_button = '1') then
				state <= "00001";				--get_user_input state
			elsif(state = "00001" and read_input_done = '1') then
				current_user_bank_id <= data_to_be_encrypted_signal(52 downto 48);
				data_to_be_encrypted <= data_to_be_encrypted_signal;
				if(substate="000") then
					money <= data_to_be_encrypted_signal(31 downto 0);
					substate <= "001";
				elsif(substate = "001") then
					if(money >= value2000 and d2000 < restriction_2000 and n2000 - d2000 > 0) then
						money <= money - value2000;
						d2000 <= d2000 + "1";
					else
						substate <= "010";
					end if;
				elsif(substate = "010") then
					if(money >= value1000 and d1000 < restriction_1000 and n1000 - d1000 > 0) then
						money <= money - value1000;
						d1000 <= d1000 + "1";
					else
						substate <= "011";
					end if;
				elsif(substate = "011") then
					if(money >= value500 and d500 < restriction_500 and n500 - d500 > 0) then
						money <= money - value500;
						d500 <= d500 + "1";
					else
						substate <= "100";
					end if;
				elsif(substate = "100") then
					if(money >= value100 and d100 < restriction_100 and n100 - d100 > 0) then
						money <= money - value100;
						d100 <= d100 + "1";
					else
						substate <= "101";
					end if;
				elsif(substate = "101") then
					if(money = "0") then
						is_suf_atm <= '1';
						is_suf_atm_signal <= '1';
					end if;
					state <= "00010";				--send data for encryption
					start_encrypt <= '1';
				end if;
			elsif(state = "00010" and done_encrypt = '1' and current_user_bank_id = bank_id) then
				start_encrypt <= '0';
				state <= "00011";				--communicating_with_backend
				encrypted_data_comm <= encrypted_data;
				start_comm <= '1';
			elsif(state = "00011" and done_comm = '1' ) then
				start_comm <= '0';
				state <= "00100";				--backend communication done + decrption start
				data_to_be_decrypted <= decrypted_data_comm;
				start_decrypt <= '1';
			elsif(state = "00100" and done_decrypt = '1' and decrypted_data(33) = '1' and decrypted_data(34) = '1') then
				if(decrypted_data(31 downto 0) <= restriction_total) then
					start_decrypt <= '0';
					money <= decrypted_data(31 downto 0);
					state <= "00101";						 						--user with sufficient balance and less than restricted total
				else
					start_decrypt <= '0';
					state <= "01111";
				end if;
			elsif(state = "00100" and done_decrypt = '1' and decrypted_data(33) = '1' and decrypted_data(34) = '0') then
				start_decrypt <= '0';
				state <= "00110"; 						--user with insufficient balance
			elsif(state = "00100" and done_decrypt = '1' and  decrypted_data(32) = '1') then
				start_decrypt <= '0';
				state <= "00111";				--admin
				n2000 <= data_to_be_encrypted_signal(31 downto 24);
				n1000 <= data_to_be_encrypted_signal(23 downto 16);
				n500 <= data_to_be_encrypted_signal(15 downto 8);
				n100 <= data_to_be_encrypted_signal(7 downto 0);
			elsif(state = "00100" and done_decrypt = '1' and decrypted_data(33) = '0' and decrypted_data(32) = '0') then
				start_decrypt <= '0';
				state <= "00000";
			

			elsif(state = "00010" and done_encrypt = '1') then --- User of different bank
				state <= "00000";
			


--elsif(state = "00011" and done_comm = '1' and comm_success = '0') then
--				start_comm <= '0';
--				start_comm_signal <= '0';
--				if(cache_user_id(0) = data_to_be_encrypted_signal(63 downto 48) and cache_user_password(0) = data_to_be_encrypted_signal(47 downto 32)) then
--					if(cache_user_balance(0) < data_to_be_encrypted_signal(31 downto 0)) then
--						state <= "00110"; 						--user with insufficient balance
--					else
--						if(is_suf_atm_signal = '1') then
--							cache_user_balance(0) <= cache_user_balance(0) - data_to_be_encrypted_signal(31 downto 0);
--						end if;
--						money <= data_to_be_encrypted_signal(31 downto 0);
--						state <= "00101";
--					end if;
--				elsif(cache_user_id(1) = data_to_be_encrypted_signal(63 downto 48) and cache_user_password(1) = data_to_be_encrypted_signal(47 downto 32)) then
--					if(cache_user_balance(1) < data_to_be_encrypted_signal(31 downto 0)) then
--						state <= "00110"; 						--user with insufficient balance
--					else
--						if(is_suf_atm_signal = '1') then
--							cache_user_balance(1) <= cache_user_balance(1) - data_to_be_encrypted_signal(31 downto 0);
--						end if;
--						money <= data_to_be_encrypted_signal(31 downto 0);
--						state <= "00101";
--					end if;
--				elsif(cache_user_id(2) = data_to_be_encrypted_signal(63 downto 48) and cache_user_password(2) = data_to_be_encrypted_signal(47 downto 32)) then
--					if(cache_user_balance(2) < data_to_be_encrypted_signal(31 downto 0)) then
--						state <= "00110"; 						--user with insufficient balance
--					else
--						if(is_suf_atm_signal = '1') then
--							cache_user_balance(2) <= cache_user_balance(2) - data_to_be_encrypted_signal(31 downto 0);
--						end if;
--						money <= data_to_be_encrypted_signal(31 downto 0);
--						state <= "00101";
--					end if;
--				elsif(cache_user_id(3) = data_to_be_encrypted_signal(63 downto 48) and cache_user_password(3) = data_to_be_encrypted_signal(47 downto 32)) then
--					if(cache_user_balance(3) < data_to_be_encrypted_signal(31 downto 0)) then
--						state <= "00110"; 						--user with insufficient balance
--					else
--						if(is_suf_atm_signal = '1') then
--							cache_user_balance(3) <= cache_user_balance(3) - data_to_be_encrypted_signal(31 downto 0);
--						end if;
--						money <= data_to_be_encrypted_signal(31 downto 0);
--						state <= "00101";
--					end if;
--				elsif(cache_user_id(4) = data_to_be_encrypted_signal(63 downto 48) and cache_user_password(4) = data_to_be_encrypted_signal(47 downto 32)) then
--					if(cache_user_balance(4) < data_to_be_encrypted_signal(31 downto 0)) then
--						state <= "00110"; 						--user with insufficient balance
--					else
--						if(is_suf_atm_signal = '1') then
--							cache_user_balance(4) <= cache_user_balance(4) - data_to_be_encrypted_signal(31 downto 0);
--						end if;
--						money <= data_to_be_encrypted_signal(31 downto 0);
--						state <= "00101";
--					end if;
--				else
--					state <= "01000";
--				end if;







			--elsif(state = "00010" and done_encrypt = '1') then --- User of different bank
			--	start_encrypt <= '0';
			--	state <= "10011";
			--	data_send_mac_comm <= encrypted_data;
			--	start_mac_comm <= '1';
			--elsif(state = "10011" and done_mac_comm = '1' ) then
			--	start_mac_comm <= '0';
			--	state <= "10100";				--backend communication done + decryption start
			--	data_to_be_decrypted <= data_response_mac_comm;
			--	start_decrypt <= '1';
			--elsif(state = "10100" and done_decrypt = '1' and decrypted_data(33) = '1' and decrypted_data(34) = '1' and restriction_total <= decrypted_data(31 downto 0)) then
			--	start_decrypt <= '0';
			--	money <= decrypted_data(31 downto 0);
			--	state <= "10101"; 						--user with sufficient balance and less than restricted total
			--elsif(state = "10100" and done_decrypt = '1' and decrypted_data(33) = '1' and decrypted_data(34) = '1' and restriction_total > decrypted_data(31 downto 0)) then
			--	state <= "11111";
			--elsif(state = "10100" and done_decrypt = '1' and decrypted_data(33) = '1' and decrypted_data(34) = '0') then
			--	state <= "10110"; 						--user with insufficient balance
			--elsif(state = "10100" and done_decrypt = '1' and  decrypted_data(32) = '1') then
			--	state <= "00000";
			--elsif(state = "10100" and done_decrypt = '1' and decrypted_data(33) = '0' and decrypted_data(32) = '0') then
			--	state <= "00000";


			--elsif(state = "00100" and done_decrypt = '1' and decrypted_data(33) = '1') then
			--	start_decrypt <= '0';
			--	state <= "11111";
			--	data_balance_signal <= data_balance;
			--elsif state = "11111" then
			--	if(substate2 /= "111") then
			--		if(cache_user_id(0) = data_to_be_encrypted_signal(63 downto 48)) then
			--			check <= "0001";
			--			cache_user_balance(0) <= data_balance_signal;
			--			substate2 <= "111";
			--		elsif(cache_user_id(1) = data_to_be_encrypted_signal(63 downto 48)) then
			--			check <= "0010";
			--			if(substate2 = "000") then
			--				temp_user_id <= cache_user_id(0);
			--				temp_user_password <= cache_user_password(0);
			--				temp_user_balance <= cache_user_balance(0);
			--				substate2 <= "001";
			--			elsif(substate2 = "001") then
			--				cache_user_id(0) <= cache_user_id(1);
			--				cache_user_balance(0) <= data_balance_signal;
			--				cache_user_password(0) <= cache_user_password(1);
			--				substate2 <= "010";
			--			elsif(substate2 = "010") then
			--				cache_user_id(1) <= temp_user_id;
			--				cache_user_password(1) <= temp_user_password;
			--				cache_user_balance(1) <= temp_user_balance;
			--				substate2 <= "111";
			--			end if;
			--		elsif(cache_user_id(2) = data_to_be_encrypted_signal(63 downto 48)) then
			--			check <= "0011";
			--			if(substate2 = "000") then
			--				temp_user_id <= cache_user_id(0);
			--				temp_user_password <= cache_user_password(0);
			--				temp_user_balance <= cache_user_balance(0);
			--				substate2 <= "001";
			--			elsif(substate2 = "001") then
			--				cache_user_id(0) <= cache_user_id(2);
			--				cache_user_balance(0) <= data_balance_signal;
			--				cache_user_password(0) <= cache_user_password(2);
			--				substate2 <= "010";
			--			elsif(substate2 = "010") then
			--				cache_user_id(2) <= cache_user_id(1);
			--				cache_user_balance(2) <= cache_user_balance(1);
			--				cache_user_password(2) <= cache_user_password(1);
			--				substate2 <= "011";
			--			elsif(substate2 = "011") then
			--				cache_user_id(1) <= temp_user_id;
			--				cache_user_password(1) <= temp_user_password;
			--				cache_user_balance(1) <= temp_user_balance;
			--				substate2 <= "111";
			--			end if;
			--		elsif(cache_user_id(3) = data_to_be_encrypted_signal(63 downto 48)) then
			--			check <= "0100";
			--			if(substate2 = "000") then
			--				temp_user_id <= cache_user_id(0);
			--				temp_user_password <= cache_user_password(0);
			--				temp_user_balance <= cache_user_balance(0);
			--				substate2 <= "001";
			--			elsif(substate2 = "001") then
			--				cache_user_id(0) <= cache_user_id(3);
			--				cache_user_balance(0) <= data_balance_signal;
			--				cache_user_password(0) <= cache_user_password(3);
			--				substate2 <= "010";
			--			elsif(substate2 = "010") then
			--				cache_user_id(3) <= cache_user_id(2);
			--				cache_user_balance(3) <= cache_user_balance(2);
			--				cache_user_password(3) <= cache_user_password(2);
			--				substate2 <= "011";
			--			elsif(substate2 = "011") then
			--				cache_user_id(2) <= cache_user_id(1);
			--				cache_user_balance(2) <= cache_user_balance(1);
			--				cache_user_password(2) <= cache_user_password(1);
			--				substate2 <= "100";
			--			elsif(substate2 = "100") then
			--				cache_user_id(1) <= temp_user_id;
			--				cache_user_password(1) <= temp_user_password;
			--				cache_user_balance(1) <= temp_user_balance;
			--				substate2 <= "111";
			--			end if;
			--		elsif(cache_user_id(4) = data_to_be_encrypted_signal(63 downto 48)) then
			--			check <= "0101";
			--			if(substate2 = "000") then
			--				temp_user_id <= cache_user_id(0);
			--				temp_user_password <= cache_user_password(0);
			--				temp_user_balance <= cache_user_balance(0);
			--				substate2 <= "001";
			--			elsif(substate2 = "001") then
			--				cache_user_id(0) <= cache_user_id(4);
			--				cache_user_balance(0) <= data_balance_signal;
			--				cache_user_password(0) <= cache_user_password(4);
			--				substate2 <= "010";
			--			elsif(substate2 = "010") then
			--				cache_user_id(4) <= cache_user_id(3);
			--				cache_user_balance(4) <= cache_user_balance(3);
			--				cache_user_password(4) <= cache_user_password(3);
			--				substate2 <= "011";
			--			elsif(substate2 = "011") then
			--				cache_user_id(3) <= cache_user_id(2);
			--				cache_user_balance(3) <= cache_user_balance(2);
			--				cache_user_password(3) <= cache_user_password(2);
			--				substate2 <= "100";
			--			elsif(substate2 = "100") then
			--				cache_user_id(2) <= cache_user_id(1);
			--				cache_user_id(4) <= cache_user_id(3);
			--				cache_user_balance(4) <= cache_user_balance(3);
			--				cache_user_password(4) <= cache_user_password(3);
			--				substate2 <= "010";
			--			elsif(substate2 = "010") then
			--				cache_user_id(3) <= cache_user_id(2);
			--				cache_user_balance(3) <= cache_user_balance(2);
			--				cache_user_password(3) <= cache_user_password(2);
			--				substate2 <= "011";
			--			elsif(substate2 = "011") then
			--				cache_user_id(2) <= cache_user_id(1);
			--				cache_user_balance(2) <= cache_user_balance(1);
			--				cache_user_password(2) <= cache_user_password(1);
			--				substate2 <= "100";
			--			elsif(substate2 = "100") then
			--				cache_user_id(1) <= cache_user_id(0);
			--				cache_user_password(1) <= cache_user_id(0);
			--				cache_user_balance(1) <= cache_user_balance(0);
			--				substate2 <= "101";
			--			elsif(substate2 = "101") then
			--				cache_user_id(0) <= data_to_be_encrypted_signal(63 downto 48);
			--				cache_user_balance(0) <= data_to_be_encrypted_signal(31 downto 0);
			--				cache_user_password(0) <= data_to_be_encrypted_signal(47 downto 32);
			--				substate2 <= "111";
			--			end if;
			--		end if;
			--	else
			--		if(decrypted_data(34) = '1') then
			--			if(decrypted_data(31 downto 0) <= restriction_total) then
			--				start_decrypt <= '0';
			--				money <= decrypted_data(31 downto 0);
			--				state <= "00101";						 						--user with sufficient balance and less than restricted total
			--			else
			--				start_decrypt <= '0';
			--				state <= "01111";
			--			end if;
			--		else
			--			start_decrypt <= '0';
			--			state <= "00110"; 						--user with insufficient balance
			--		end if;
			--	end if;
							cache_user_balance(2) <= cache_user_balance(1);
							cache_user_password(2) <= cache_user_password(1);						
							substate2 <= "101";
						elsif(substate2 = "101") then
							cache_user_id(1) <= temp_user_id;
							cache_user_password(1) <= temp_user_password;
							cache_user_balance(1) <= temp_user_balance;
							substate2 <= "111";
						end if;
					else
						check <= "1111";
						if(substate2 = "000") then





















			elsif(done_button = '1') then
				state <= "00000";
			end if;
			
			
			
			if(state = "00000") then
				data_out_leds <= "00000000";				--ready state
				count_blink <= "000";
				is_suf_atm <= '0';
				is_suf_atm_signal <= '0';
				substate <= "000";
				money <= X"00000000";
				start_decrypt <= '0';
				start_comm <= '0';
				--start_mac_comm <= '0';
				start_encrypt <= '0';
				double_time <= '1';
				d2000 <= X"00";
				d1000 <= X"00";
				d500 <= X"00";
				d100 <= X"00";
				finish_display <= '0';
			elsif(state = "00001") then
				data_out_leds <= timer_inp & data_collected_so_far & "0000";	--get_user_input
			elsif(state = "00011" or state = "10011") then
				data_out_leds <= timer_inp & timer_inp & "000000";		--communicating_with_backend
			elsif((state = "00111" or state = "10111") and count_blink < "101") then
				data_out_leds <= 	timer_inp & timer_inp & timer_inp & "00000"; -- admin (Loading cash)
				if(is_blink = '1') then
					count_blink <= count_blink + "001";
				end if;
			elsif((state = "00111" or state = "10111") and count_blink = "101") then
				data_out_leds <= "00000000";
			elsif((state = "00110" or state = "10110") and count_blink < "011") then		--user with insufficient balance
				if(timer_inp = '1') then	data_out_leds <= "11111111";
				else	data_out_leds <= "00000000";
				end if;
				if(is_blink = '1') then
					count_blink <= count_blink + "001";
				end if;
			elsif((state = "00110"  or state = "10110") and count_blink < "101") then
				if(timer_inp = '1') then	data_out_leds <= "11110000";
				else	data_out_leds <= "00000000";
				end if;
				if(is_blink = '1') then
					count_blink <= count_blink + "001";
				end if;
			elsif((state = "00110" or state = "10110") and count_blink = "101") then
				data_out_leds <= "00000000";
			elsif(state = "00101" or state = "10101") then								--user with sufficient balance
				if(decrypted_data(63 downto 35) = X"00000000") then
					if(is_suf_atm_signal = '1') then
						if(is_blink = '1' and double_time = '0') then
							double_time <= '1';
							if(count_blink < "101") then
								count_blink <= count_blink + "1";
							end if;
						elsif(is_blink = '1' and double_time = '1') then
							double_time <= '0';
							if(count_blink < "101") then
								count_blink <= count_blink + "1";
							end if;
						end if;
						data_out_leds <= money(7 downto 0);
						if(double_time = '0') then
							if(money >= "11111010000" and d2000 < restriction_2000 and n2000 > 0) then
								if(timer_inp = '1') then	data_out_leds <= "11111000";
								else	data_out_leds <= "00000000";
								end if;
								if(is_blink = '1') then
									d2000 <= d2000 + "00000001";
									money <= money - "11111010000";
									n2000 <= n2000 - "00000001";
								end if;
							elsif(money >= "1111101000" and d1000 < restriction_1000 and n1000 > 0) then
								if(timer_inp = '1') then	data_out_leds <= "11110100";
								else	data_out_leds <= "00000000";
								end if;
								if(is_blink = '1') then
									d1000 <= d1000 + "00000001";
									money <= money - "1111101000";
									n1000 <= n1000 - "00000001";
								end if;
							elsif(money >= "111110100" and d500 < restriction_500 and n500 > 0) then
								if(timer_inp = '1') then	data_out_leds <= "11110010";
								else	data_out_leds <= "00000000";
								end if;
								if(is_blink = '1') then
									d500 <= d500 + "00000001";
									money <= money - "111110100";
									n500 <= n500 - "00000001";
								end if;
							elsif(money >= "1100100" and d100 < restriction_100 and n100 > 0) then
								if(timer_inp = '1') then	data_out_leds <= "11110001";
								else	data_out_leds <= "00000000";
								end if;
								if(is_blink = '1') then
									d100 <= d100 + "00000001";
									money <= money - "1100100";
									n100 <= n100 - "00000001";
								end if;
							elsif(count_blink < "101") then
								if(timer_inp = '1') then	data_out_leds <= "11110000";
								else	data_out_leds <= "00000000";
								end if;
							else
								data_out_leds <= "00000000";
								finish_display <= '1';
							end if;
						elsif(finish_display = '0') then
							if(timer_inp = '1') then	data_out_leds <= "11110000";
							else	data_out_leds <= "00000000";
							end if;
						else
							data_out_leds <= "00000000";
						end if;
					else
						if(count_blink < "110") then
							if(timer_inp = '1') then	data_out_leds <= "11111111";
							else	data_out_leds <= "00000000";
							end if;
							if(is_blink = '1') then
								count_blink <= count_blink + "001";
							end if;
						elsif(count_blink = "110") then
							data_out_leds <= "00000000";
						end if;
					end if;
				end if;
			elsif(state = "01111" and count_blink < "101") then
				data_out_leds <= timer_inp & timer_inp & timer_inp & timer_inp & timer_inp & "000"; -- Blinking due to restriction on total money
				if(is_blink = '1') then
					count_blink <= count_blink + "001";
				end if;
			elsif((state = "01111" or state = "11111") and count_blink >= "101") then
				data_out_leds <= "00000000";
			end if;
		end if;
	end process;
end Behavioral;