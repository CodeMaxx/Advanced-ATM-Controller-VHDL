library ieee;
use ieee.std_logic_1164.all;

library ethernet_mac;
use ethernet_mac.framing_common.all;
use ethernet_mac.crc32.all;

entity gigabee_tb is
end entity;

architecture behavioral of gigabee_tb is

	--Inputs
	signal CLK_IN           : std_logic                    := '0';
	signal RXDV             : std_logic                    := '0';
	signal RXER             : std_logic                    := '0';
	signal RXCLK            : std_logic                    := '0';
	signal RXD              : std_logic_vector(7 downto 0) := (others => '0');
	signal TXCLK            : std_logic                    := '0';

	--BiDirs
	signal MDIO : std_logic;

	--Outputs
	signal PHY_RESET        : std_logic;
	signal GTXCLK           : std_logic;
	signal TXD              : std_logic_vector(7 downto 0);
	signal TXEN             : std_logic;
	signal TXER             : std_logic;
	signal MDC              : std_logic;
	signal GPIO_LEDS        : std_logic_vector(3 downto 0);

	-- Clock period definitions
	constant CLK_IN_period       : time := 8 ns;
	constant mii_tx_clk_i_period : time := 40 ns;
	constant mii_rx_clk_i_period : time := 40 ns;

	constant SPEED_10100 : boolean := FALSE;

	-- ARP Request

	type t_memory is array (natural range <>) of std_logic_vector(7 downto 0);

	-- ICMP Ping Request
	constant test_packet_1 : t_memory := (
		x"FF", x"FF", x"FF", x"FF", x"FF", x"FF",
		x"54", x"EE", x"75", x"34", x"2a", x"7e",
		x"08", x"00",
		x"45", x"00", x"00", x"54", x"c0", x"04", x"40", x"00", x"40",
		x"01", x"f5", x"4c",
		x"c0", x"a8", x"01", x"05",
		x"c0", x"a8", x"01", x"01",
		x"08", x"00",
		x"95", x"80",
		x"0c", x"4f", x"00", x"01",
		x"b6", x"c4", x"7d", x"55", x"00", x"00", x"00", x"00",
		x"5f", x"42", x"04", x"00", x"00", x"00", x"00", x"00",
		x"10", x"11", x"12", x"13", x"14", x"15", x"16", x"17", x"18", x"19", x"1a", x"1b",
		x"1c", x"1d", x"1e", x"1f", x"20", x"21", x"22", x"23", x"24", x"25", x"26", x"27", x"28",
		x"29", x"2a", x"2b", x"2c", x"2d", x"2e", x"2f", x"30", x"31", x"32", x"33", x"34", x"35",
		x"36", x"37"
	);

	-- ARP Reply
	constant test_packet_2 : t_memory := (
		x"FF", x"FF", x"FF", x"FF", x"FF", x"FF",
		x"54", x"EE", x"75", x"34", x"2a", x"7e",
		x"08", x"06",
		x"00", x"01", x"08", x"00",
		x"06", x"04", x"00", x"02",
		x"54", x"EE", x"75", x"34", x"2a", x"7e",
		x"c0", x"a8", x"02", x"05",
		x"00", x"01", x"02", x"03", x"04", x"05",
		x"c0", x"a8", x"02", x"02"
	);

	-- ARP Request
	constant test_packet_3 : t_memory := (
		x"FF", x"FF", x"FF", x"FF", x"FF", x"FF",
		x"54", x"EE", x"75", x"34", x"2a", x"7e",
		x"08", x"06",
		x"00", x"01", x"08", x"00",
		x"06", x"04", x"00", x"01",
		x"54", x"EE", x"75", x"34", x"2a", x"7e",
		x"c0", x"a8", x"01", x"05",
		x"ff", x"ff", x"ff", x"ff", x"ff", x"ff",
		x"c0", x"a8", x"01", x"01",
		-- Padding
		x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00",
		x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00"
	);

	constant test_packet : t_memory := test_packet_3;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut : entity work.gigabee port map(
			CLK_IN    => CLK_IN,
			PHY_RESET => PHY_RESET,
			RXDV      => RXDV,
			RXER      => RXER,
			RXCLK     => RXCLK,
			RXD       => RXD,
			TXCLK     => TXCLK,
			GTXCLK    => GTXCLK,
			TXD       => TXD,
			TXEN      => TXEN,
			TXER      => TXER,
			MDC       => MDC,
			MDIO      => MDIO,
			GPIO_LEDS => GPIO_LEDS,
			RS232_RX  => '0'
		);

	-- Clock process definitions
	CLK_IN_process : process
	begin
		CLK_IN <= '0';
		wait for CLK_IN_period / 2;
		CLK_IN <= '1';
		wait for CLK_IN_period / 2;
	end process;

	mii_tx_clk_i_process : process
	begin
		TXCLK <= '0';
		wait for mii_tx_clk_i_period / 2;
		TXCLK <= '1';
		wait for mii_tx_clk_i_period / 2;
	end process;

	-- Stimulus process
	stim_proc : process is
		procedure mii_put1(
			-- lolisim
			-- crashes if (others => '0') is used instead of "00000000"
			data : in std_logic_vector(7 downto 0) := "00000000";
			dv   : in std_logic                    := '1';
			er   : in std_logic                    := '0') is
		begin
			RXCLK <= '0';
			RXDV  <= dv;
			RXER  <= er;
			RXD   <= data;
			wait for mii_rx_clk_i_period / 2;
			RXCLK <= '1';
			wait for mii_rx_clk_i_period / 2;
		end procedure;

		procedure mii_put(
			data : in std_logic_vector(7 downto 0) := "00000000";
			dv   : in std_logic                    := '1';
			er   : in std_logic                    := '0') is
		begin
			if SPEED_10100 = TRUE then
				mii_put1("0000" & data(3 downto 0), dv, er);
				mii_put1("0000" & data(7 downto 4), dv, er);
			else
				mii_put1(data, dv, er);
			end if;
		end procedure;

		procedure mii_toggle is
		begin
			mii_put(dv => '0', er => '0', data => open);
		end procedure;

		variable fcs : t_crc32;

	begin
		wait until PHY_RESET = '1';
		wait for CLK_IN_period * 1100;
		while TRUE loop
			for i in 0 to 10 loop
				mii_toggle;
			end loop;
			mii_put(std_logic_vector(START_FRAME_DELIMITER_DATA));

			fcs := (others => '1');
			for j in test_packet'range loop
				mii_put(test_packet(j));
				fcs := update_crc32(fcs, std_ulogic_vector(test_packet(j)));
			end loop;
			--			for j in 1 to 1000 loop
			--				mii_put(x"23");
			--			end loop;
			for b in 0 to 3 loop
				mii_put(std_logic_vector(fcs_output_byte(fcs, b)));
			end loop;

			while TRUE loop
				mii_toggle;
			end loop;
		end loop;
		wait;
	end process;

end architecture;