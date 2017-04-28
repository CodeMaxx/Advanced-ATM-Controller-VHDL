--------------------------------------------------------------------------------
---
---  CHIPS - 2.0 Simple Web App Demo
---
---  :Author: Jonathan P Dawson
---  :Date: 17/10/2013
---  :email: chips@jondawson.org.uk
---  :license: MIT
---  :Copyright: Copyright (C) Jonathan P Dawson 2013
---
--------------------------------------------------------------------------------
---
---
---              +-------------+     +--------------+               
---              | SERVER      |     | USER DESIGN  |
---              +-------------+     +--------------+
---              |             |     |              |
---              |             >----->              |
---              |             |     |              |
---              |             <-----<              >-------> LEDS
---              |             |     |              |               
---              |             |     |              |
---              |             |     |              |
---              |             |     +----^----v----+
---              |             |          |    |
---              |             |     +----^----v----+
---              |             |     | UART         |
---              |             |     +--------------+
---              |             |     |              >-------> RS232-TX
---              |             |     |              |
---              +---v-----^---+     |              <-------< RS232-RX 
---                  |     |         +--------------+
---              +---v-----^---+           
---              | ETHERNET    |           
---              | MAC         |           
---              +-------------+           
---              |             |           
---              |             |           
---[RXCLK] ----->+             +------> [TXCLK]           
---              |             |           
--- 125MHZ ----->+             +------> [GTXCLK]           
---              |             |           
---  [RXD] ----->+             +------> [TXD]
---              |             |           
--- [RXDV] ----->+             +------> [TXEN]           
---              |             |           
--- [RXER] ----->+             +------> [TXER]           
---              |             |           
---              |             |
---              +-------------+
---

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

library ethernet_mac;
use ethernet_mac.ethernet_types.all;

entity GigaBee is
	port(
		CLK_IN    : in    std_logic;

		--PHY INTERFACE  
		PHY_RESET : out   std_logic;
		RXDV      : in    std_logic;
		RXER      : in    std_logic;
		RXCLK     : in    std_logic;
		RXD       : in    std_logic_vector(7 downto 0);
		TXCLK     : in    std_logic;
		GTXCLK    : out   std_logic;
		TXD       : out   std_logic_vector(7 downto 0);
		TXEN      : out   std_logic;
		TXER      : out   std_logic;
		MDC       : out   std_logic;
		MDIO      : inout std_logic;

		--LEDS
		GPIO_LEDS : out   std_logic_vector(3 downto 0);

		--RS232 INTERFACE
		--Note that the TE0603 does not have an IC for serial I/O by default
		RS232_RX  : in    std_logic;
		RS232_TX  : out   std_logic
	);
end entity GigaBee;

architecture RTL of GigaBee is
	component SERVER is
		port(
			CLK               : in  std_logic;
			RST               : in  std_logic;

			--ETH RX STREAM
			INPUT_ETH_RX      : in  std_logic_vector(15 downto 0);
			INPUT_ETH_RX_STB  : in  std_logic;
			INPUT_ETH_RX_ACK  : out std_logic;

			--ETH TX STREAM
			output_eth_tx     : out std_logic_vector(15 downto 0);
			OUTPUT_ETH_TX_STB : out std_logic;
			OUTPUT_ETH_TX_ACK : in  std_logic;

			--SOCKET RX STREAM
			INPUT_SOCKET      : in  std_logic_vector(15 downto 0);
			INPUT_SOCKET_STB  : in  std_logic;
			INPUT_SOCKET_ACK  : out std_logic;

			--SOCKET TX STREAM
			OUTPUT_SOCKET     : out std_logic_vector(15 downto 0);
			OUTPUT_SOCKET_STB : out std_logic;
			OUTPUT_SOCKET_ACK : in  std_logic
		);
	end component;

	component USER_DESIGN is
		port(
			CLK                 : in  std_logic;
			RST                 : in  std_logic;

			OUTPUT_LEDS         : out std_logic_vector(15 downto 0);
			OUTPUT_LEDS_STB     : out std_logic;
			OUTPUT_LEDS_ACK     : in  std_logic;

			INPUT_SPEED         : in  std_logic_vector(15 downto 0);
			INPUT_SPEED_STB     : in  std_logic;
			INPUT_SPEED_ACK     : out std_logic;

			--SOCKET RX STREAM
			INPUT_SOCKET        : in  std_logic_vector(15 downto 0);
			INPUT_SOCKET_STB    : in  std_logic;
			INPUT_SOCKET_ACK    : out std_logic;

			--SOCKET TX STREAM
			OUTPUT_SOCKET       : out std_logic_vector(15 downto 0);
			OUTPUT_SOCKET_STB   : out std_logic;
			OUTPUT_SOCKET_ACK   : in  std_logic;

			--RS232 RX STREAM
			INPUT_RS232_RX      : in  std_logic_vector(15 downto 0);
			INPUT_RS232_RX_STB  : in  std_logic;
			INPUT_RS232_RX_ACK  : out std_logic;

			--RS232 TX STREAM
			OUTPUT_RS232_TX     : out std_logic_vector(15 downto 0);
			OUTPUT_RS232_TX_STB : out std_logic;
			OUTPUT_RS232_TX_ACK : in  std_logic
		);
	end component;

	--clock tree signals
	signal clkin1       : std_logic;
	-- Output clock buffering
	signal clkfb        : std_logic;
	signal clk0         : std_logic;
	signal clkfx        : std_logic;
	signal CLK_50       : std_logic;
	signal CLK_125      : std_logic;
	signal INTERNAL_RST : std_logic;
	signal LOCKED       : std_logic;

	signal OUTPUT_LEDS     : std_logic_vector(15 downto 0);
	signal OUTPUT_LEDS_STB : std_logic;
	signal OUTPUT_LEDS_ACK : std_logic;

	signal INPUT_SPEED     : std_logic_vector(15 downto 0);
	signal INPUT_SPEED_STB : std_logic;
	signal INPUT_SPEED_ACK : std_logic;

	--ETH RX STREAM
	signal ETH_RX     : std_logic_vector(15 downto 0);
	signal ETH_RX_STB : std_logic;
	signal ETH_RX_ACK : std_logic;

	--ETH TX STREAM
	signal ETH_TX     : std_logic_vector(15 downto 0);
	signal ETH_TX_STB : std_logic;
	signal ETH_TX_ACK : std_logic;

	--RS232 RX STREAM
	signal INPUT_RS232_RX     : std_logic_vector(15 downto 0);
	signal INPUT_RS232_RX_STB : std_logic;
	signal INPUT_RS232_RX_ACK : std_logic;

	--RS232 TX STREAM
	signal OUTPUT_RS232_TX     : std_logic_vector(15 downto 0);
	signal OUTPUT_RS232_TX_STB : std_logic;
	signal OUTPUT_RS232_TX_ACK : std_logic;

	--SOCKET RX STREAM
	signal INPUT_SOCKET     : std_logic_vector(15 downto 0);
	signal INPUT_SOCKET_STB : std_logic;
	signal INPUT_SOCKET_ACK : std_logic;

	--SOCKET TX STREAM
	signal OUTPUT_SOCKET     : std_logic_vector(15 downto 0);
	signal OUTPUT_SOCKET_STB : std_logic;
	signal OUTPUT_SOCKET_ACK : std_logic;

	-- Ethernet MAC
	signal TXD_INTERNAL : std_ulogic_vector(7 downto 0);
	signal LINK_UP      : std_ulogic;
	signal SPEED        : t_ethernet_speed;
	signal RX_RESET     : std_ulogic;
	signal RX_EMPTY     : std_ulogic;
	signal RX_RD_EN     : std_ulogic;
	signal RX_DATA      : t_ethernet_data;
	signal TX_RESET     : std_ulogic;
	signal TX_DATA      : t_ethernet_data;
	signal TX_WR_EN     : std_ulogic;
	signal TX_FULL      : std_ulogic;

begin
	TXD <= std_logic_vector(TXD_INTERNAL);

	ethernet_with_fifos_inst : entity ethernet_mac.ethernet_with_fifos
		generic map(
			MIIM_PHY_ADDRESS      => "00111",
			MIIM_RESET_WAIT_TICKS => 1250000 -- 10 ms at 125 MHz clock, minimum: 5 ms
		)
		port map(
			clock_125_i    => clk0,
			reset_i        => INTERNAL_RST,
			mii_tx_clk_i   => TXCLK,
			mii_tx_er_o    => TXER,
			mii_tx_en_o    => TXEN,
			mii_txd_o      => TXD_INTERNAL,
			mii_rx_clk_i   => RXCLK,
			mii_rx_er_i    => RXER,
			mii_rx_dv_i    => RXDV,
			mii_rxd_i      => std_ulogic_vector(RXD),
			gmii_gtx_clk_o => GTXCLK,
			rgmii_rx_ctl_i => '0',
			miim_clock_i   => CLK_125,
			mdc_o          => MDC,
			mdio_io        => MDIO,
			link_up_o      => LINK_UP,
			speed_o        => SPEED,
			tx_clock_i     => CLK_50,
			tx_reset_o     => TX_RESET,
			tx_data_i      => TX_DATA,
			tx_wr_en_i     => TX_WR_EN,
			tx_full_o      => TX_FULL,
			rx_clock_i     => CLK_50,
			rx_reset_o     => RX_RESET,
			rx_empty_o     => RX_EMPTY,
			rx_rd_en_i     => RX_RD_EN,
			rx_data_o      => RX_DATA

-- Force 1000 Mbps/GMII in simulation only
-- pragma translate_off
, speed_override_i         => SPEED_1000MBPS
		-- pragma translate_on

		);

	SERVER_INST_1 : SERVER port map(
			CLK               => CLK_50,
			RST               => TX_RESET,

			--ETH RX STREAM
			INPUT_ETH_RX      => ETH_RX,
			INPUT_ETH_RX_STB  => ETH_RX_STB,
			INPUT_ETH_RX_ACK  => ETH_RX_ACK,

			--ETH TX STREAM
			OUTPUT_ETH_TX     => ETH_TX,
			OUTPUT_ETH_TX_STB => ETH_TX_STB,
			OUTPUT_ETH_TX_ACK => ETH_TX_ACK,

			--SOCKET STREAM
			INPUT_SOCKET      => INPUT_SOCKET,
			INPUT_SOCKET_STB  => INPUT_SOCKET_STB,
			INPUT_SOCKET_ACK  => INPUT_SOCKET_ACK,

			--SOCKET STREAM
			OUTPUT_SOCKET     => OUTPUT_SOCKET,
			OUTPUT_SOCKET_STB => OUTPUT_SOCKET_STB,
			OUTPUT_SOCKET_ACK => OUTPUT_SOCKET_ACK
		);

	USER_DESIGN_INST_1 : USER_DESIGN port map(
			CLK                 => CLK_50,
			RST                 => TX_RESET,
			OUTPUT_LEDS         => OUTPUT_LEDS,
			OUTPUT_LEDS_STB     => OUTPUT_LEDS_STB,
			OUTPUT_LEDS_ACK     => OUTPUT_LEDS_ACK,
			INPUT_SPEED         => INPUT_SPEED,
			INPUT_SPEED_STB     => INPUT_SPEED_STB,
			INPUT_SPEED_ACK     => INPUT_SPEED_ACK,

			--RS232 RX STREAM
			INPUT_RS232_RX      => INPUT_RS232_RX,
			INPUT_RS232_RX_STB  => INPUT_RS232_RX_STB,
			INPUT_RS232_RX_ACK  => INPUT_RS232_RX_ACK,

			--RS232 TX STREAM
			OUTPUT_RS232_TX     => OUTPUT_RS232_TX,
			OUTPUT_RS232_TX_STB => OUTPUT_RS232_TX_STB,
			OUTPUT_RS232_TX_ACK => OUTPUT_RS232_TX_ACK,

			--SOCKET STREAM
			INPUT_SOCKET        => OUTPUT_SOCKET,
			INPUT_SOCKET_STB    => OUTPUT_SOCKET_STB,
			INPUT_SOCKET_ACK    => OUTPUT_SOCKET_ACK,

			--SOCKET STREAM
			OUTPUT_SOCKET       => INPUT_SOCKET,
			OUTPUT_SOCKET_STB   => INPUT_SOCKET_STB,
			OUTPUT_SOCKET_ACK   => INPUT_SOCKET_ACK
		);

	mac_adaptor_inst : entity work.chips_mac_adaptor
		port map(
			clock_i        => CLK_50,
			reset_i        => TX_RESET,
			tx_data_o      => tx_data,
			tx_wr_en_o     => tx_wr_en,
			tx_full_i      => tx_full,
			rx_empty_i     => rx_empty,
			rx_rd_en_o     => rx_rd_en,
			rx_data_i      => rx_data,
			chips_tx_i     => ETH_TX,
			chips_tx_stb_i => ETH_TX_STB,
			chips_tx_ack_o => ETH_TX_ACK,
			chips_rx_o     => ETH_RX,
			chips_rx_stb_o => ETH_RX_STB,
			chips_rx_ack_i => ETH_RX_ACK
		);

	SERIAL_OUTPUT_INST_1 : entity work.serial_output generic map(
			CLOCK_FREQUENCY => 50000000,
			BAUD_RATE       => 115200
		) port map(
			CLK => CLK_50,
			RST => INTERNAL_RST,
			TX => RS232_TX,
			IN1 => OUTPUT_RS232_TX(7 downto 0),
			IN1_STB => OUTPUT_RS232_TX_STB,
			IN1_ACK => OUTPUT_RS232_TX_ACK
		);

	SERIAL_INPUT_INST_1 : entity work.SERIAL_INPUT generic map(
			CLOCK_FREQUENCY => 50000000,
			BAUD_RATE       => 115200
		) port map(
			CLK => CLK_50,
			RST => INTERNAL_RST,
			RX => RS232_RX,
			OUT1 => INPUT_RS232_RX(7 downto 0),
			OUT1_STB => INPUT_RS232_RX_STB,
			OUT1_ACK => INPUT_RS232_RX_ACK
		);

	INPUT_RS232_RX(15 downto 8) <= (others => '0');

	process
	begin
		wait until rising_edge(CLK_50);

		if OUTPUT_LEDS_STB = '1' then
			GPIO_LEDS <= not OUTPUT_LEDS(3 downto 0);
		end if;
		OUTPUT_LEDS_ACK <= '1';

		INPUT_SPEED_STB          <= '1';
		INPUT_SPEED(15 downto 2) <= (others => '0');
		INPUT_SPEED(1 downto 0)  <= std_logic_vector(SPEED);

	end process;
	--GPIO_LEDS <= (not link_up) & (not std_logic_vector(speed)) & (not RX_RESET);

	reset_generator_inst : entity work.reset_generator
		-- pragma translate_off
		generic map(
			RESET_DELAY => 10
		)
		-- pragma translate_on
		port map(
			clock_i  => CLK_125,
			locked_i => LOCKED,
			reset_o  => INTERNAL_RST
		);

	-------------------------
	-- Output     Output     
	-- Clock     Freq (MHz)  
	-------------------------
	-- CLK_OUT1    50.000      
	-- CLK_OUT3   125.000    

	----------------------------------
	-- Input Clock   Input Freq (MHz) 
	----------------------------------
	-- primary         125.000        


	-- Input buffering
	--------------------------------------
	clkin1_buf : IBUFG
		port map(O => clkin1,
			     I => CLK_IN);

	-- Clocking primitive
	--------------------------------------
	-- Instantiation of the DCM primitive
	--    * Unused inputs are tied off
	--    * Unused outputs are labeled unused
	dcm_sp_inst : DCM_SP
		generic map(CLKDV_DIVIDE       => 2.000,
			        CLKFX_DIVIDE       => 5,
			        CLKFX_MULTIPLY     => 2,
			        CLKIN_DIVIDE_BY_2  => FALSE,
			        CLKIN_PERIOD       => 8.0,
			        CLKOUT_PHASE_SHIFT => "NONE",
			        CLK_FEEDBACK       => "1X",
			        DESKEW_ADJUST      => "SYSTEM_SYNCHRONOUS",
			        PHASE_SHIFT        => 0,
			        STARTUP_WAIT       => FALSE)
		port map(
			-- Input clock
			CLKIN    => clkin1,
			CLKFB    => clkfb,
			-- Output clocks
			CLK0     => clk0,
			CLK90    => open,
			CLK180   => open,
			CLK270   => open,
			CLK2X    => open,
			CLK2X180 => open,
			CLKFX    => clkfx,
			CLKFX180 => open,
			CLKDV    => open,
			-- Ports for dynamic phase shift
			PSCLK    => '0',
			PSEN     => '0',
			PSINCDEC => '0',
			PSDONE   => open,
			-- Other control and status signals
			LOCKED   => LOCKED,
			STATUS   => open,
			RST      => '0',
			-- Unused pin, tie low
			DSSEN    => '0');

	PHY_RESET <= not INTERNAL_RST;

	-- Output buffering
	-------------------------------------
	clkfb <= CLK_125;

	BUFG_INST2 : BUFG
		port map(O => CLK_125,
			     I => clk0);

	BUFG_INST3 : BUFG
		port map(O => CLK_50,
			     I => clkfx);

end architecture RTL;
