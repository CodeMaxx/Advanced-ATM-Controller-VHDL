----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:26:12 03/15/2017 
-- Design Name: 
-- Module Name:    top_module - Behavioral 
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
--library ethernet_mac;
--use ethernet_mac.ethernet_types.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_module is
    Port(
	 -- FX2LP interface ---------------------------------------------------------------------------
		fx2Clk_in      : in    std_logic;                    -- 48MHz clock from FX2LP
		fx2Addr_out    : out   std_logic_vector(1 downto 0); -- select FIFO: "00" for EP2OUT, "10" for EP6IN
		fx2Data_io     : inout std_logic_vector(7 downto 0); -- 8-bit data to/from FX2LP

		-- When EP2OUT selected:
		fx2Read_out    : out   std_logic;                    -- asserted (active-low) when reading from FX2LP
		fx2OE_out      : out   std_logic;                    -- asserted (active-low) to tell FX2LP to drive bus
		fx2GotData_in  : in    std_logic;                    -- asserted (active-high) when FX2LP has data for us

		-- When EP6IN selected:
		fx2Write_out   : out   std_logic;                    -- asserted (active-low) when writing to FX2LP
		fx2GotRoom_in  : in    std_logic;                    -- asserted (active-high) when FX2LP has room for more data from us
		fx2PktEnd_out  : out   std_logic;                    -- asserted (active-low) when a host read needs to be committed early

		-- Onboard peripherals -----------------------------------------------------------------------
		sseg_out       : out   std_logic_vector(7 downto 0); -- seven-segment display cathodes (one for each segment)
		anode_out      : out   std_logic_vector(3 downto 0); -- seven-segment display anodes (one for each digit)
		led_out        : out   std_logic_vector(7 downto 0); -- eight LEDs
		sw_in          : in    std_logic_vector(7 downto 0);  -- eight switches
		
		  --clk : in  STD_LOGIC;
        reset : in  STD_LOGIC;
--        data_in_sliders : in  STD_LOGIC_VECTOR (7 downto 0);
		load_bank_id : in STD_LOGIC;
        next_data_in : in  STD_LOGIC;
        done: in STD_LOGIC;
        start: in STD_LOGIC
		  		-- Unbuffered 125 MHz clock input
		--clock_125_i      : in    std_ulogic;
		--  -- MII (Media-independent interface)
		--mii_tx_clk_i     : in    std_ulogic;
		--mii_tx_er_o      : out   std_ulogic;
		--mii_tx_en_o      : out   std_ulogic;
		--mii_txd_o        : out   std_ulogic_vector(7 downto 0);
		--mii_rx_clk_i     : in    std_ulogic;
		--mii_rx_er_i      : in    std_ulogic;
		--mii_rx_dv_i      : in    std_ulogic;
		--mii_rxd_i        : in    std_ulogic_vector(7 downto 0);

		---- GMII (Gigabit media-independent interface)
		--gmii_gtx_clk_o   : out   std_ulogic;

		------ RGMII (Reduced pin count gigabit media-independent interface)
		----rgmii_tx_ctl_o   : out   std_ulogic;
		----rgmii_rx_ctl_i   : in    std_ulogic;

		---- MII Management Interface
		---- Clock, can be identical to clock_125_i
		---- If not, adjust MIIM_CLOCK_DIVIDER accordingly
		----miim_clock_i     : in    std_ulogic;
		--mdc_o            : out   std_ulogic;
		--mdio_io          : inout std_ulogic
		  
		  );
end top_module;

architecture Behavioral of top_module is
	 component ATM_main_controller
		port(clk : in  STD_LOGIC;
        reset_button : in  STD_LOGIC;
        data_in_sliders : in  STD_LOGIC_VECTOR (7 downto 0);
        next_data_in_button : in  STD_LOGIC;
        done_button: in STD_LOGIC;
        start_button: in STD_LOGIC;
        data_out_leds : out  STD_LOGIC_VECTOR (7 downto 0);
		  data_to_be_encrypted: out STD_LOGIC_VECTOR (63 downto 0);
		  data_to_be_decrypted: out STD_LOGIC_VECTOR (63 downto 0);
		  encrypted_data: in STD_LOGIC_VECTOR (63 downto 0);
		  decrypted_data: in STD_LOGIC_VECTOR (63 downto 0);
		  encrypted_data_comm: out STD_LOGIC_VECTOR (63 downto 0);
		  decrypted_data_comm: in STD_LOGIC_VECTOR (63 downto 0);
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
);
	 end component;
	

	 --component mac_communication
	 --	port(
		--  clk : in STD_LOGIC;
	 -- 	  start_mac_comm : in STD_LOGIC;
		--  done_mac_comm : out STD_LOGIC;
		--  data_send_mac_comm : in STD_LOGIC_VECTOR (63 downto 0);
		--  data_response_mac_comm : out STD_LOGIC_VECTOR (63 downto 0);
		--  is_suf_atm : in STD_LOGIC;
		  
		--  request_mac_comm : out STD_LOGIC;
		--  is_suf_atm_request : out STD_LOGIC;
		--  data_request_mac_comm : out STD_LOGIC_VECTOR (63 downto 0);
		--  data_reply_to_request_mac_comm : in STD_LOGIC_VECTOR (63 downto 0);
		--  reply_mac_comm_valid : in STD_LOGIC;
		--  reply_mac_comm_notvalid : in STD_LOGIC
		--  );
	 --end component;

    component debouncer
        port(clk: in STD_LOGIC;
            button: in STD_LOGIC;
            button_deb: out STD_LOGIC);
    end component;
	
    component encrypter
        port(clk: in STD_LOGIC;
            reset : in  STD_LOGIC;
            plaintext: in STD_LOGIC_VECTOR (63 downto 0);
            start: in STD_LOGIC;
            ciphertext: out STD_LOGIC_VECTOR (63 downto 0);
            done: out STD_LOGIC);
    end component;

    component decrypter
        port(clk: in STD_LOGIC;
            reset : in  STD_LOGIC;
            ciphertext: in STD_LOGIC_VECTOR (63 downto 0);
            start: in STD_LOGIC;
            plaintext: out STD_LOGIC_VECTOR (63 downto 0);
            done: out STD_LOGIC);
    end component;
	 component communication 
		PORT( 
			clk : in  STD_LOGIC;
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
			chanAddr_in  : in std_logic_vector(6 downto 0);
			-- Host >> FPGA pipe:
			h2fData_in   : in std_logic_vector(7 downto 0);  
			h2fValid_in  : in std_logic;                     
			h2fReady_out  : out std_logic;                     
			-- Host << FPGA pipe:
			f2hData_out   : out std_logic_vector(7 downto 0);  
			f2hValid_out  : out std_logic;                     
			f2hReady_in  : in std_logic                   
		);
	end component;
	
	component comm_fpga_fx2 
	port(
		clk_in         : in    std_logic;                     -- 48MHz clock from FX2LP
		reset_in       : in    std_logic;                     -- synchronous active-high reset input
		reset_out      : out   std_logic;                     -- synchronous active-high reset output

		-- FX2LP interface ---------------------------------------------------------------------------
		fx2FifoSel_out : out   std_logic;                     -- select FIFO: '0' for EP2OUT, '1' for EP6IN
		fx2Data_io     : inout std_logic_vector(7 downto 0);  -- 8-bit data to/from FX2LP

		-- When EP2OUT selected:
		fx2Read_out    : out   std_logic;                     -- asserted (active-low) when reading from FX2LP
		fx2GotData_in  : in    std_logic;                     -- asserted (active-high) when FX2LP has data for us

		-- When EP6IN selected:
		fx2Write_out   : out   std_logic;                     -- asserted (active-low) when writing to FX2LP
		fx2GotRoom_in  : in    std_logic;                     -- asserted (active-high) when FX2LP has room for more data from us
		fx2PktEnd_out  : out   std_logic;                     -- asserted (active-low) when a host read needs to be committed early

		-- Channel read/write interface --------------------------------------------------------------
		chanAddr_out   : out   std_logic_vector(6 downto 0);  -- the selected channel (0-127)

		-- Host >> FPGA pipe:
		h2fData_out    : out   std_logic_vector(7 downto 0);  -- data lines used when the host writes to a channel
		h2fValid_out   : out   std_logic;                     -- '1' means "on the next clock rising edge, please accept the data on h2fData_out"
		h2fReady_in    : in    std_logic;                     -- channel logic can drive this low to say "I'm not ready for more data yet"

		-- Host << FPGA pipe:
		f2hData_in     : in    std_logic_vector(7 downto 0);  -- data lines used when the host reads from a channel
		f2hValid_in    : in    std_logic;                     -- channel logic can drive this low to say "I don't have data ready for you"
		f2hReady_out   : out   std_logic                      -- '1' means "on the next clock rising edge, put your next byte of data on f2hData_in"
		);
		end component;
		
		
		-- Channel read/write interface -----------------------------------------------------------------
	signal chanAddr  : std_logic_vector(6 downto 0);  -- the selected channel (0-127)

	-- Host >> FPGA pipe:
	signal h2fData   : std_logic_vector(7 downto 0);  -- data lines used when the host writes to a channel
	signal h2fValid  : std_logic;                     -- '1' means "on the next clock rising edge, please accept the data on h2fData"
	signal h2fReady  : std_logic;                     -- channel logic can drive this low to say "I'm not ready for more data yet"

	-- Host << FPGA pipe:
	signal f2hData   : std_logic_vector(7 downto 0);  -- data lines used when the host reads from a channel
	signal f2hValid  : std_logic;                     -- channel logic can drive this low to say "I don't have data ready for you"
	signal f2hReady  : std_logic;                     -- '1' means "on the next clock rising edge, put your next byte of data on f2hData"
	-- ----------------------------------------------------------------------------------------------

	-- Needed so that the comm_fpga_fx2 module can drive both fx2Read_out and fx2OE_out
	signal fx2Read   : std_logic;

	-- Reset signal so host can delay startup
	signal fx2Reset  : std_logic;



	--signal mac_address_i : t_mac_address;
	--signal rgmii_tx_ctl_o   : std_ulogic;
	--signal rgmii_rx_ctl_i   : std_ulogic;
	--signal link_up_o        : std_ulogic;
	--signal speed_o          : t_ethernet_speed;
	--signal speed_override_i : t_ethernet_speed := SPEED_UNSPECIFIED;
	--signal tx_reset_o       : std_ulogic;
	--signal rx_reset_o       : std_ulogic;


	--signal tx_data_i        : t_ethernet_data;
	--signal tx_wr_en_i       : std_ulogic;
	--signal tx_full_o        : std_ulogic;

	--signal rx_empty_o       : std_ulogic;
	--signal rx_rd_en_i       : std_ulogic;
	--signal rx_data_o        : t_ethernet_data;






signal restriction_2000: STD_LOGIC_VECTOR (7 downto 0);
signal restriction_1000: STD_LOGIC_VECTOR (7 downto 0);
signal restriction_500: STD_LOGIC_VECTOR (7 downto 0);
signal restriction_100: STD_LOGIC_VECTOR (7 downto 0);
signal restriction_total: STD_LOGIC_VECTOR (31 downto 0);
signal debounced_next_data_in_button: STD_LOGIC;
signal debounced_load_bank_id: STD_LOGIC;
signal debounced_done_button: STD_LOGIC := '0';
signal debounced_reset_button: STD_LOGIC := '0';
signal debounced_start_button: STD_LOGIC;
signal data_to_be_encrypted: STD_LOGIC_VECTOR (63 downto 0);
signal data_to_be_decrypted: STD_LOGIC_VECTOR (63 downto 0);
signal encrypted_data: STD_LOGIC_VECTOR (63 downto 0);
signal decrypted_data: STD_LOGIC_VECTOR (63 downto 0);
signal done_decrypt: STD_LOGIC;
signal done_encrypt: STD_LOGIC;
signal start_decrypt: STD_LOGIC;
signal start_encrypt: STD_LOGIC;
signal start_comm : STD_LOGIC;
signal done_comm : STD_LOGIC;
signal is_suf_atm: STD_LOGIC;
signal encrypted_data_comm: STD_LOGIC_VECTOR (63 downto 0);
signal decrypted_data_comm: STD_LOGIC_VECTOR (63 downto 0);
signal done_or_reset : STD_LOGIC;

--signal start_mac_comm : STD_LOGIC;
--signal done_mac_comm : STD_LOGIC;
--signal data_send_mac_comm : STD_LOGIC_VECTOR (63 downto 0);
--signal data_response_mac_comm : STD_LOGIC_VECTOR (63 downto 0);
		  
--signal request_mac_comm : STD_LOGIC;
--signal is_suf_atm_request : STD_LOGIC;
--signal data_request_mac_comm : STD_LOGIC_VECTOR (63 downto 0);
--signal data_reply_to_request_mac_comm : STD_LOGIC_VECTOR (63 downto 0);
--signal reply_mac_comm_valid : STD_LOGIC;
--signal reply_mac_comm_notvalid : STD_LOGIC;






begin
	done_or_reset <= debounced_done_button or debounced_reset_button;
	-- CommFPGA module
	fx2Read_out <= fx2Read;
	fx2OE_out <= fx2Read;
	fx2Addr_out(0) <=  -- So fx2Addr_out(1)='0' selects EP2OUT, fx2Addr_out(1)='1' selects EP6IN
		'0' when fx2Reset = '0'
		else 'Z';
	
	comm_fpga : comm_fpga_fx2
		port map(
			clk_in         => fx2Clk_in,
			reset_in       => '0',
			reset_out      => fx2Reset,
			
			-- FX2LP interface
			fx2FifoSel_out => fx2Addr_out(1),
			fx2Data_io     => fx2Data_io,
			fx2Read_out    => fx2Read,
			fx2GotData_in  => fx2GotData_in,
			fx2Write_out   => fx2Write_out,
			fx2GotRoom_in  => fx2GotRoom_in,
			fx2PktEnd_out  => fx2PktEnd_out,

			-- DVR interface -> Connects to application module
			chanAddr_out   => chanAddr,
			h2fData_out    => h2fData,
			h2fValid_out   => h2fValid,
			h2fReady_in    => h2fReady,
			f2hData_in     => f2hData,
			f2hValid_in    => f2hValid,
			f2hReady_out   => f2hReady
		);

debouncer1: debouncer
              port map (clk => fx2Clk_in,
                        button => next_data_in,
                        button_deb => debounced_next_data_in_button);

debouncer2: debouncer
              port map (clk => fx2Clk_in,
                        button => done,
                        button_deb => debounced_done_button);

debouncer3: debouncer
              port map (clk => fx2Clk_in,
                        button => reset,
                        button_deb => debounced_reset_button);

debouncer4: debouncer
              port map (clk => fx2Clk_in,
                        button => start,
                        button_deb => debounced_start_button);

debouncer5: debouncer
			port map (clk => fx2Clk_in,
                        button => load_bank_id,
                        button_deb => debounced_load_bank_id);

encrypt: encrypter
              port map (clk => fx2Clk_in,
                        reset => done_or_reset,
                        plaintext => data_to_be_encrypted,
                        start => start_encrypt,
                        ciphertext => encrypted_data,
                        done => done_encrypt);

decrypt: decrypter
              port map (clk => fx2Clk_in,
                        reset => done_or_reset,
                        ciphertext => data_to_be_decrypted,
						start => start_decrypt,
                        plaintext => decrypted_data,
                        done => done_decrypt);

ATM_Main_cont : ATM_main_controller
				port map( 
							clk => fx2Clk_in,
							reset_button => debounced_reset_button,
						   data_in_sliders => sw_in,
						   next_data_in_button => debounced_next_data_in_button,
						   done_button => debounced_done_button,
						   start_button => debounced_start_button,
						   data_out_leds => led_out,
							data_to_be_encrypted => data_to_be_encrypted,
							encrypted_data => encrypted_data,
							data_to_be_decrypted => data_to_be_decrypted,
							decrypted_data => decrypted_data,
							start_encrypt => start_encrypt,
							start_decrypt => start_decrypt,
							done_encrypt => done_encrypt,
							done_decrypt => done_decrypt,
							encrypted_data_comm => encrypted_data_comm,
						   decrypted_data_comm => decrypted_data_comm,
						   start_comm => start_comm,
						   done_comm => done_comm,
						   is_suf_atm => is_suf_atm,
						   restriction_2000 => restriction_2000,
							restriction_1000 => restriction_1000,
							restriction_500 => restriction_500,
							restriction_100 => restriction_100,
							restriction_total => restriction_total,
							load_bank_id => debounced_load_bank_id
							--start_mac_comm => start_mac_comm,
							--done_mac_comm => done_mac_comm,
							--data_send_mac_comm => data_send_mac_comm,
							--data_response_mac_comm => data_response_mac_comm,
							--request_mac_comm => request_mac_comm,
							--is_suf_atm_request => is_suf_atm_request,
							--data_request_mac_comm => data_request_mac_comm,
							--data_reply_to_request_mac_comm => data_reply_to_request_mac_comm,
							--reply_mac_comm_valid => reply_mac_comm_valid,
							--reply_mac_comm_notvalid => reply_mac_comm_notvalid
							);

comm : communication
		port map(	clk => fx2Clk_in,
							-- DVR interface -> Connects to comm_fpga module
							chanAddr_in  => chanAddr,
							h2fData_in   => h2fData,
							h2fValid_in  => h2fValid,
							h2fReady_out => h2fReady,
							f2hData_out  => f2hData,
							f2hValid_out => f2hValid,
							f2hReady_in  => f2hReady,
							reset => done_or_reset,
							start_comm => start_comm,
						   done_comm => done_comm,
						   is_suf_atm => is_suf_atm,
							data_send => encrypted_data_comm,
						    data_recieved => decrypted_data_comm,
							restriction_2000 => restriction_2000,
							restriction_1000 => restriction_1000,
							restriction_500 => restriction_500,
							restriction_100 => restriction_100,
							restriction_total => restriction_total
					);
--mac_comm : mac_communication
--		port map(
--			clk => fx2Clk_in,
--							start_mac_comm => start_mac_comm,
--							done_mac_comm => done_mac_comm,
--							data_send_mac_comm => data_send_mac_comm,
--							data_response_mac_comm => data_response_mac_comm,
--							request_mac_comm => request_mac_comm,
--							is_suf_atm_request => is_suf_atm_request,
--							data_request_mac_comm => data_request_mac_comm,
--							data_reply_to_request_mac_comm => data_reply_to_request_mac_comm,
--							reply_mac_comm_valid => reply_mac_comm_valid,
--							reply_mac_comm_notvalid => reply_mac_comm_notvalid,
--							is_suf_atm => is_suf_atm
--			);

	--ethernet_with_mac : entity ethernet_mac.ethernet_with_fifos
	--port map(
	--		clock_125_i => clock_125_i,
	--		reset_i => '0',
	--		mac_address_i => mac_address_i,
	--		mii_tx_clk_i => mii_tx_clk_i,
	--		mii_tx_er_o => mii_tx_er_o,
	--		mii_tx_en_o => mii_tx_en_o,
	--		mii_txd_o => mii_txd_o,
	--		mii_rx_clk_i => mii_rx_clk_i,
	--		mii_rx_er_i => mii_rx_er_i,
	--		mii_rx_dv_i => mii_rx_dv_i,
	--		mii_rxd_i => mii_rxd_i,
	--		gmii_gtx_clk_o => gmii_gtx_clk_o,
	--		rgmii_tx_ctl_o => rgmii_tx_ctl_o,
	--		rgmii_rx_ctl_i => rgmii_rx_ctl_i,
	--		miim_clock_i => fx2Clk_in,
	--		mdc_o => mdc_o,
	--		mdio_io => mdio_io,
	--		link_up_o => link_up_o,
	--		speed_o => speed_o,
	--		speed_override_i => speed_override_i,
	--		tx_clock_i => fx2Clk_in,
	--		tx_reset_o => tx_reset_o,
	--		tx_data_i => tx_data_i,
	--		tx_wr_en_i => tx_wr_en_i,
	--		tx_full_o => tx_full_o,
	--		rx_clock_i => fx2Clk_in,
	--		rx_reset_o => rx_reset_o,
	--		rx_empty_o => rx_empty_o,
	--		rx_rd_en_i => rx_rd_en_i,
	--		rx_data_o => rx_data_o
	--	);
end Behavioral;