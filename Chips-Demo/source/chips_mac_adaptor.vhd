library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library ethernet_mac;
use ethernet_mac.ethernet_types.all;
use ethernet_mac.framing_common.all;

entity chips_mac_adaptor is
	port(
		-- Common clock for MAC and chips
		clock_i        : in  std_ulogic;
		reset_i        : in  std_ulogic;

		-- MAC FIFO interface
		tx_data_o      : out t_ethernet_data;
		tx_wr_en_o     : out std_ulogic;
		tx_full_i      : in  std_ulogic;

		rx_empty_i     : in  std_ulogic;
		rx_rd_en_o     : out std_ulogic;
		rx_data_i      : in  t_ethernet_data;

		-- Chips interface
		chips_tx_i     : in  std_logic_vector(15 downto 0);
		chips_tx_stb_i : in  std_logic;
		chips_tx_ack_o : out std_logic;

		chips_rx_o     : out std_logic_vector(15 downto 0);
		chips_rx_stb_o : out std_logic;
		chips_rx_ack_i : in  std_logic
	);
end entity;

architecture rtl of chips_mac_adaptor is
	type t_tx_state is (
		TX_IDLE,
		TX_WRITE_SIZE_LO_BYTE,
		TX_FORWARD_HI_BYTE,
		TX_FORWARD_LO_BYTE
	);
	signal tx_state : t_tx_state := TX_IDLE;
	type t_rx_state is (
		RX_IDLE,
		RX_READ_HI_BYTE,
		RX_READ_LO_BYTE,
		RX_WAIT_ACK
	);
	signal rx_state : t_rx_state := RX_IDLE;

	signal tx_lo_byte_buf             : t_ethernet_data                      := (others => '0');
	signal tx_forward_bytes_remaining : natural range 0 to MAX_PACKET_LENGTH := 0;

begin
	tx_chips_to_ethernet_copy_proc : process(clock_i)
	begin
		if rising_edge(clock_i) then
			-- Default output values
			chips_tx_ack_o <= '0';
			tx_wr_en_o     <= '0';

			if reset_i = '1' then
				tx_state <= TX_IDLE;
			else
				case tx_state is
					when TX_IDLE =>
						chips_tx_ack_o <= not tx_full_i;
						if chips_tx_stb_i = '1' then
							-- Read and forward data size
							tx_data_o                  <= t_ethernet_data(chips_tx_i(15 downto 8));
							tx_wr_en_o                 <= '1';
							tx_lo_byte_buf             <= t_ethernet_data(chips_tx_i(7 downto 0));
							tx_state                   <= TX_WRITE_SIZE_LO_BYTE;
							tx_forward_bytes_remaining <= to_integer(unsigned(chips_tx_i));
						end if;
					when TX_WRITE_SIZE_LO_BYTE =>
						tx_data_o  <= tx_lo_byte_buf;
						tx_wr_en_o <= '1';
						tx_state   <= TX_FORWARD_HI_BYTE;
					when TX_FORWARD_HI_BYTE =>
						chips_tx_ack_o <= not tx_full_i;
						if chips_tx_stb_i = '1' then
							-- Write data
							tx_forward_bytes_remaining <= tx_forward_bytes_remaining - 1;
							tx_data_o                  <= t_ethernet_data(chips_tx_i(15 downto 8));
							tx_wr_en_o                 <= '1';
							-- Capture for next state (chips may change the value so it needs to be buffered)
							tx_lo_byte_buf             <= t_ethernet_data(chips_tx_i(7 downto 0));

							if tx_forward_bytes_remaining = 1 then
								-- This was the last one
								tx_state <= TX_IDLE;
							else
								tx_state <= TX_FORWARD_LO_BYTE;
							end if;
						end if;
					when TX_FORWARD_LO_BYTE =>
						-- Write data
						tx_forward_bytes_remaining <= tx_forward_bytes_remaining - 1;
						tx_data_o                  <= tx_lo_byte_buf;
						tx_wr_en_o                 <= '1';
						if tx_forward_bytes_remaining = 1 then
							-- This was the last one
							tx_state <= TX_IDLE;
						else
							-- Set ACK so the data can already be present in the next cycle
							-- (assuming chips is fast enough)
							chips_tx_ack_o <= not tx_full_i;
							tx_state       <= TX_FORWARD_HI_BYTE;
						end if;
				end case;
			end if;
		end if;
	end process;

	rx_ethernet_to_chips_copy_proc : process(clock_i)
	begin
		if rising_edge(clock_i) then
			chips_rx_stb_o <= '0';
			rx_rd_en_o     <= '0';
			if reset_i = '1' then
				rx_state <= RX_IDLE;
			else
				case rx_state is
					when RX_IDLE =>
						if rx_empty_i = '0' then
							rx_state   <= RX_READ_HI_BYTE;
							rx_rd_en_o <= '1';
						end if;
					when RX_READ_HI_BYTE =>
						chips_rx_o(15 downto 8) <= std_logic_vector(rx_data_i);
						if rx_empty_i = '0' then
							rx_state   <= RX_READ_LO_BYTE;
							rx_rd_en_o <= '1';
						else
							-- This was the end of the packet
							rx_state <= RX_IDLE;
						end if;
					when RX_READ_LO_BYTE =>
						chips_rx_o(7 downto 0) <= std_logic_vector(rx_data_i);
						-- Signal data available
						chips_rx_stb_o         <= '1';
						rx_state               <= RX_WAIT_ACK;
						if rx_empty_i = '1' then
							-- We have overrun the buffer ->
							-- The packet is received completely and is of uneven length
							-- Zero out the unused bits
							chips_rx_o(7 downto 0) <= (others => '0');
						end if;
					when RX_WAIT_ACK =>
						-- Continue signaling as long as data is not ACKed
						chips_rx_stb_o <= not chips_rx_ack_i;
						if chips_rx_ack_i = '1' then
							if rx_empty_i = '1' then
								-- No more data to read
								rx_state <= RX_IDLE;
							else
								-- Continue and read next byte
								rx_state   <= RX_READ_HI_BYTE;
								rx_rd_en_o <= '1';
							end if;
						end if;
				end case;
			end if;
		end if;
	end process;

end architecture;

