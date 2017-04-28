//////////////////////////////////////////////////////////////////////////////
//name : user_design
//input : input_speed:16
//input : input_socket:16
//input : input_rs232_rx:16
//output : output_rs232_tx:16
//output : output_leds:16
//output : output_socket:16
//source_file : user_design.c
///===========
///
///Created by C2CHIP

//////////////////////////////////////////////////////////////////////////////
// Register Allocation
// ===================
//         Register                 Name                   Size          
//            0             HTTP_OK return address            2            
//            1                    array                    2            
//            2             variable header_length            2            
//            3             variable body_length            2            
//            4               variable length               2            
//            5                variable index               2            
//            6             variable packet_count            2            
//            7                    array                    2            
//            8                    array                    2            
//            9             find return address             2            
//            10            variable find return value            2            
//            11                   array                    2            
//            12              variable search               2            
//            13               variable start               2            
//            14                variable end                2            
//            15               variable value               2            
//            16                   array                    2            
//            17                   array                    2            
//            18            user_design return address            2            
//            19              variable length               2            
//            20                 variable i                 2            
//            21               variable index               2            
//            22                   array                    2            
//            23               variable word                2            
//            24               variable speed               2            
//            25               variable leds                2            
//            26               variable start               2            
//            27                variable end                2            
//            28                   array                    2            
//            29                   array                    2            
//            30                   array                    2            
//            31             temporary_register             2            
//            32             temporary_register             2            
//            33             temporary_register             2            
//            34             temporary_register             4            
//            35             temporary_register             2            
//            36             temporary_register            252           
//            37             temporary_register            228           
//            38             temporary_register             10           
//            39             temporary_register             80           
//            40             temporary_register             82           
//            41             temporary_register             2            
//            42             temporary_register            2920          
//            43             temporary_register            1464          
//            44            put_socket return address            2            
//            45                 variable i                 2            
//            46            stdout_put_char return address            2            
//            47                 variable i                 2            
//            48            print_string return address            2            
//            49                   array                    2            
//            50                 variable i                 2            
//            51            print_udecimal return address            2            
//            52             variable udecimal              2            
//            53               variable digit               2            
//            54            variable significant            2            
//            55            print_decimal return address            2            
//            56              variable decimal              2            
//            57            variable socket_high            2            
//            58            variable socket_data            2            
//            59            socket_put_char return address            2            
//            60                 variable x                 2            
//            61            socket_flush return address            2            
//            62            socket_put_string return address            2            
//            63                   array                    2            
//            64                 variable i                 2            
//            65            socket_put_decimal return address            2            
//            66               variable value               2            
//            67              variable digit_0              2            
//            68              variable digit_1              2            
//            69              variable digit_2              2            
//            70              variable digit_3              2            
//            71              variable digit_4              2            
//            72            variable significant            2            
//            73            HTTP_Not_Found return address            2            
//            74            variable header_length            2            
//            75                   array                    2            
module user_design(input_speed,input_socket,input_rs232_rx,input_speed_stb,input_socket_stb,input_rs232_rx_stb,output_rs232_tx_ack,output_leds_ack,output_socket_ack,clk,rst,output_rs232_tx,output_leds,output_socket,output_rs232_tx_stb,output_leds_stb,output_socket_stb,input_speed_ack,input_socket_ack,input_rs232_rx_ack);
  integer file_count;
  real fp_value;
  input [15:0] input_speed;
  input [15:0] input_socket;
  input [15:0] input_rs232_rx;
  input input_speed_stb;
  input input_socket_stb;
  input input_rs232_rx_stb;
  input output_rs232_tx_ack;
  input output_leds_ack;
  input output_socket_ack;
  input clk;
  input rst;
  output [15:0] output_rs232_tx;
  output [15:0] output_leds;
  output [15:0] output_socket;
  output output_rs232_tx_stb;
  output output_leds_stb;
  output output_socket_stb;
  output input_speed_ack;
  output input_socket_ack;
  output input_rs232_rx_ack;
  reg [15:0] timer;
  reg timer_enable;
  reg stage_0_enable;
  reg stage_1_enable;
  reg stage_2_enable;
  reg [10:0] program_counter;
  reg [10:0] program_counter_0;
  reg [51:0] instruction_0;
  reg [5:0] opcode_0;
  reg [6:0] dest_0;
  reg [6:0] src_0;
  reg [6:0] srcb_0;
  reg [31:0] literal_0;
  reg [10:0] program_counter_1;
  reg [5:0] opcode_1;
  reg [6:0] dest_1;
  reg [31:0] register_1;
  reg [31:0] registerb_1;
  reg [31:0] literal_1;
  reg [6:0] dest_2;
  reg [31:0] result_2;
  reg write_enable_2;
  reg [15:0] address_2;
  reg [15:0] data_out_2;
  reg [15:0] data_in_2;
  reg memory_enable_2;
  reg [15:0] address_4;
  reg [31:0] data_out_4;
  reg [31:0] data_in_4;
  reg memory_enable_4;
  reg [15:0] s_output_rs232_tx_stb;
  reg [15:0] s_output_leds_stb;
  reg [15:0] s_output_socket_stb;
  reg [15:0] s_output_rs232_tx;
  reg [15:0] s_output_leds;
  reg [15:0] s_output_socket;
  reg [15:0] s_input_speed_ack;
  reg [15:0] s_input_socket_ack;
  reg [15:0] s_input_rs232_rx_ack;
  reg [15:0] memory_2 [2529:0];
  reg [51:0] instructions [1422:0];
  reg [31:0] registers [75:0];

  //////////////////////////////////////////////////////////////////////////////
  // MEMORY INITIALIZATION                                                      
  //                                                                            
  // In order to reduce program size, array contents have been stored into      
  // memory at initialization. In an FPGA, this will result in the memory being 
  // initialized when the FPGA configures.                                      
  // Memory will not be re-initialized at reset.                                
  // Dissable this behaviour using the no_initialize_memory switch              
  
  initial
  begin
    memory_2[2048] = 105;
    memory_2[2049] = 110;
    memory_2[2050] = 112;
    memory_2[2051] = 117;
    memory_2[4] = 72;
    memory_2[5] = 84;
    memory_2[6] = 84;
    memory_2[7] = 80;
    memory_2[8] = 47;
    memory_2[9] = 49;
    memory_2[10] = 46;
    memory_2[11] = 49;
    memory_2[12] = 32;
    memory_2[13] = 52;
    memory_2[14] = 48;
    memory_2[15] = 52;
    memory_2[16] = 32;
    memory_2[17] = 78;
    memory_2[18] = 111;
    memory_2[19] = 116;
    memory_2[20] = 32;
    memory_2[21] = 70;
    memory_2[22] = 111;
    memory_2[23] = 117;
    memory_2[24] = 110;
    memory_2[25] = 100;
    memory_2[26] = 13;
    memory_2[27] = 10;
    memory_2[28] = 68;
    memory_2[29] = 97;
    memory_2[30] = 116;
    memory_2[31] = 101;
    memory_2[32] = 58;
    memory_2[33] = 32;
    memory_2[34] = 84;
    memory_2[35] = 104;
    memory_2[36] = 117;
    memory_2[37] = 32;
    memory_2[38] = 79;
    memory_2[39] = 99;
    memory_2[40] = 116;
    memory_2[41] = 32;
    memory_2[42] = 51;
    memory_2[43] = 49;
    memory_2[44] = 32;
    memory_2[45] = 49;
    memory_2[46] = 57;
    memory_2[47] = 58;
    memory_2[48] = 49;
    memory_2[49] = 54;
    memory_2[50] = 58;
    memory_2[51] = 48;
    memory_2[52] = 48;
    memory_2[53] = 32;
    memory_2[54] = 50;
    memory_2[55] = 48;
    memory_2[56] = 49;
    memory_2[57] = 51;
    memory_2[58] = 13;
    memory_2[59] = 10;
    memory_2[60] = 83;
    memory_2[61] = 101;
    memory_2[62] = 114;
    memory_2[63] = 118;
    memory_2[64] = 101;
    memory_2[65] = 114;
    memory_2[66] = 58;
    memory_2[67] = 32;
    memory_2[68] = 99;
    memory_2[69] = 104;
    memory_2[70] = 105;
    memory_2[71] = 112;
    memory_2[72] = 115;
    memory_2[73] = 45;
    memory_2[74] = 119;
    memory_2[75] = 101;
    memory_2[76] = 98;
    memory_2[77] = 47;
    memory_2[78] = 48;
    memory_2[79] = 46;
    memory_2[80] = 48;
    memory_2[81] = 13;
    memory_2[82] = 10;
    memory_2[83] = 67;
    memory_2[84] = 111;
    memory_2[85] = 110;
    memory_2[86] = 116;
    memory_2[87] = 101;
    memory_2[88] = 110;
    memory_2[89] = 116;
    memory_2[90] = 45;
    memory_2[91] = 84;
    memory_2[92] = 121;
    memory_2[93] = 112;
    memory_2[94] = 101;
    memory_2[95] = 58;
    memory_2[96] = 32;
    memory_2[97] = 116;
    memory_2[98] = 101;
    memory_2[99] = 120;
    memory_2[100] = 116;
    memory_2[101] = 47;
    memory_2[102] = 104;
    memory_2[103] = 116;
    memory_2[104] = 109;
    memory_2[105] = 108;
    memory_2[106] = 13;
    memory_2[107] = 10;
    memory_2[108] = 67;
    memory_2[109] = 111;
    memory_2[110] = 110;
    memory_2[111] = 116;
    memory_2[112] = 101;
    memory_2[113] = 110;
    memory_2[114] = 116;
    memory_2[115] = 45;
    memory_2[116] = 76;
    memory_2[117] = 101;
    memory_2[118] = 110;
    memory_2[119] = 103;
    memory_2[120] = 116;
    memory_2[121] = 104;
    memory_2[122] = 58;
    memory_2[123] = 32;
    memory_2[124] = 48;
    memory_2[125] = 13;
    memory_2[126] = 10;
    memory_2[127] = 13;
    memory_2[128] = 10;
    memory_2[129] = 0;
    memory_2[2178] = 34;
    memory_2[2179] = 115;
    memory_2[132] = 72;
    memory_2[133] = 84;
    memory_2[134] = 84;
    memory_2[135] = 80;
    memory_2[136] = 47;
    memory_2[137] = 49;
    memory_2[138] = 46;
    memory_2[139] = 49;
    memory_2[140] = 32;
    memory_2[141] = 50;
    memory_2[142] = 48;
    memory_2[143] = 48;
    memory_2[144] = 32;
    memory_2[145] = 79;
    memory_2[146] = 75;
    memory_2[147] = 13;
    memory_2[148] = 10;
    memory_2[149] = 68;
    memory_2[150] = 97;
    memory_2[151] = 116;
    memory_2[152] = 101;
    memory_2[153] = 58;
    memory_2[154] = 32;
    memory_2[155] = 84;
    memory_2[156] = 104;
    memory_2[157] = 117;
    memory_2[158] = 32;
    memory_2[159] = 79;
    memory_2[160] = 99;
    memory_2[161] = 116;
    memory_2[162] = 32;
    memory_2[163] = 51;
    memory_2[164] = 49;
    memory_2[165] = 32;
    memory_2[166] = 49;
    memory_2[167] = 57;
    memory_2[168] = 58;
    memory_2[169] = 49;
    memory_2[170] = 54;
    memory_2[171] = 58;
    memory_2[172] = 48;
    memory_2[173] = 48;
    memory_2[174] = 32;
    memory_2[175] = 50;
    memory_2[176] = 48;
    memory_2[177] = 49;
    memory_2[178] = 51;
    memory_2[179] = 13;
    memory_2[180] = 10;
    memory_2[181] = 83;
    memory_2[182] = 101;
    memory_2[183] = 114;
    memory_2[184] = 118;
    memory_2[185] = 101;
    memory_2[186] = 114;
    memory_2[187] = 58;
    memory_2[188] = 32;
    memory_2[189] = 99;
    memory_2[190] = 104;
    memory_2[191] = 105;
    memory_2[192] = 112;
    memory_2[193] = 115;
    memory_2[194] = 45;
    memory_2[195] = 119;
    memory_2[196] = 101;
    memory_2[197] = 98;
    memory_2[198] = 47;
    memory_2[199] = 48;
    memory_2[200] = 46;
    memory_2[201] = 48;
    memory_2[202] = 13;
    memory_2[203] = 10;
    memory_2[204] = 67;
    memory_2[205] = 111;
    memory_2[206] = 110;
    memory_2[207] = 116;
    memory_2[208] = 101;
    memory_2[209] = 110;
    memory_2[210] = 116;
    memory_2[211] = 45;
    memory_2[212] = 84;
    memory_2[213] = 121;
    memory_2[214] = 112;
    memory_2[215] = 101;
    memory_2[216] = 58;
    memory_2[217] = 32;
    memory_2[218] = 116;
    memory_2[219] = 101;
    memory_2[220] = 120;
    memory_2[221] = 116;
    memory_2[222] = 47;
    memory_2[223] = 104;
    memory_2[224] = 116;
    memory_2[225] = 109;
    memory_2[226] = 108;
    memory_2[227] = 13;
    memory_2[228] = 10;
    memory_2[229] = 67;
    memory_2[230] = 111;
    memory_2[231] = 110;
    memory_2[232] = 116;
    memory_2[233] = 101;
    memory_2[234] = 110;
    memory_2[235] = 116;
    memory_2[236] = 45;
    memory_2[237] = 76;
    memory_2[238] = 101;
    memory_2[239] = 110;
    memory_2[240] = 103;
    memory_2[241] = 116;
    memory_2[242] = 104;
    memory_2[243] = 58;
    memory_2[244] = 32;
    memory_2[245] = 0;
    memory_2[246] = 13;
    memory_2[247] = 10;
    memory_2[248] = 13;
    memory_2[249] = 10;
    memory_2[250] = 0;
    memory_2[2299] = 115;
    memory_2[2300] = 32;
    memory_2[253] = 10;
    memory_2[254] = 0;
    memory_2[255] = 10;
    memory_2[256] = 0;
    memory_2[2305] = 114;
    memory_2[2306] = 101;
    memory_2[2091] = 62;
    memory_2[2308] = 32;
    memory_2[2309] = 98;
    memory_2[2310] = 121;
    memory_2[2311] = 32;
    memory_2[2312] = 60;
    memory_2[2092] = 108;
    memory_2[2314] = 32;
    memory_2[2315] = 104;
    memory_2[2316] = 114;
    memory_2[2317] = 101;
    memory_2[2318] = 102;
    memory_2[2093] = 101;
    memory_2[2320] = 34;
    memory_2[2321] = 104;
    memory_2[2322] = 116;
    memory_2[2323] = 116;
    memory_2[2324] = 112;
    memory_2[2094] = 100;
    memory_2[2326] = 47;
    memory_2[2327] = 47;
    memory_2[2055] = 121;
    memory_2[2329] = 121;
    memory_2[2330] = 97;
    memory_2[2095] = 32;
    memory_2[2332] = 100;
    memory_2[2333] = 99;
    memory_2[2334] = 104;
    memory_2[2335] = 105;
    memory_2[2336] = 112;
    memory_2[2096] = 50;
    memory_2[2338] = 46;
    memory_2[2339] = 111;
    memory_2[2340] = 114;
    memory_2[2341] = 103;
    memory_2[2342] = 34;
    memory_2[2097] = 60;
    memory_2[2344] = 67;
    memory_2[2345] = 104;
    memory_2[2346] = 105;
    memory_2[2347] = 112;
    memory_2[2348] = 115;
    memory_2[2098] = 47;
    memory_2[2350] = 50;
    memory_2[2351] = 46;
    memory_2[2352] = 48;
    memory_2[2353] = 60;
    memory_2[2354] = 47;
    memory_2[2099] = 105;
    memory_2[2356] = 62;
    memory_2[2357] = 32;
    memory_2[2056] = 112;
    memory_2[2359] = 110;
    memory_2[2360] = 100;
    memory_2[2100] = 110;
    memory_2[2362] = 60;
    memory_2[2363] = 97;
    memory_2[2364] = 32;
    memory_2[2365] = 104;
    memory_2[2366] = 114;
    memory_2[2101] = 112;
    memory_2[2368] = 102;
    memory_2[2369] = 61;
    memory_2[2370] = 34;
    memory_2[2371] = 104;
    memory_2[2372] = 116;
    memory_2[2102] = 117;
    memory_2[2374] = 112;
    memory_2[2375] = 115;
    memory_2[2376] = 58;
    memory_2[2377] = 47;
    memory_2[2378] = 47;
    memory_2[2103] = 116;
    memory_2[2380] = 105;
    memory_2[2381] = 116;
    memory_2[2382] = 104;
    memory_2[2383] = 117;
    memory_2[2384] = 98;
    memory_2[2104] = 62;
    memory_2[2386] = 99;
    memory_2[2387] = 111;
    memory_2[2057] = 101;
    memory_2[2389] = 47;
    memory_2[2390] = 112;
    memory_2[2105] = 9;
    memory_2[2392] = 101;
    memory_2[2393] = 114;
    memory_2[2394] = 108;
    memory_2[2395] = 105;
    memory_2[2396] = 110;
    memory_2[2106] = 60;
    memory_2[2398] = 47;
    memory_2[2399] = 101;
    memory_2[2400] = 116;
    memory_2[2401] = 104;
    memory_2[2402] = 101;
    memory_2[2107] = 105;
    memory_2[2404] = 110;
    memory_2[2405] = 101;
    memory_2[2406] = 116;
    memory_2[2407] = 95;
    memory_2[2408] = 109;
    memory_2[2108] = 110;
    memory_2[2410] = 99;
    memory_2[2411] = 34;
    memory_2[2412] = 62;
    memory_2[2413] = 101;
    memory_2[2414] = 116;
    memory_2[2109] = 112;
    memory_2[2416] = 101;
    memory_2[2417] = 114;
    memory_2[2058] = 61;
    memory_2[2419] = 101;
    memory_2[2420] = 116;
    memory_2[2110] = 117;
    memory_2[2422] = 109;
    memory_2[2423] = 97;
    memory_2[2424] = 99;
    memory_2[2425] = 60;
    memory_2[2426] = 47;
    memory_2[2111] = 116;
    memory_2[2428] = 62;
    memory_2[2429] = 46;
    memory_2[2430] = 60;
    memory_2[2431] = 47;
    memory_2[2432] = 112;
    memory_2[2112] = 32;
    memory_2[2434] = 60;
    memory_2[2435] = 47;
    memory_2[2436] = 98;
    memory_2[2437] = 111;
    memory_2[2438] = 100;
    memory_2[2113] = 116;
    memory_2[2440] = 62;
    memory_2[2441] = 60;
    memory_2[2442] = 47;
    memory_2[2443] = 104;
    memory_2[2444] = 116;
    memory_2[2114] = 121;
    memory_2[2446] = 108;
    memory_2[2447] = 62;
    memory_2[2059] = 34;
    memory_2[2449] = 87;
    memory_2[2450] = 101;
    memory_2[2115] = 112;
    memory_2[2452] = 99;
    memory_2[2453] = 111;
    memory_2[2454] = 109;
    memory_2[2455] = 101;
    memory_2[2456] = 32;
    memory_2[2116] = 101;
    memory_2[2379] = 103;
    memory_2[2459] = 32;
    memory_2[2460] = 116;
    memory_2[2458] = 111;
    memory_2[2462] = 101;
    memory_2[2117] = 61;
    memory_2[2464] = 71;
    memory_2[2465] = 105;
    memory_2[2466] = 103;
    memory_2[2467] = 97;
    memory_2[2468] = 66;
    memory_2[2118] = 34;
    memory_2[2470] = 101;
    memory_2[2471] = 32;
    memory_2[2472] = 67;
    memory_2[2473] = 104;
    memory_2[2474] = 105;
    memory_2[2119] = 99;
    memory_2[2476] = 115;
    memory_2[2477] = 45;
    memory_2[2060] = 99;
    memory_2[2461] = 104;
    memory_2[2480] = 48;
    memory_2[2120] = 104;
    memory_2[2482] = 100;
    memory_2[2483] = 101;
    memory_2[2484] = 109;
    memory_2[2485] = 111;
    memory_2[2486] = 33;
    memory_2[2121] = 101;
    memory_2[2488] = 0;
    memory_2[2489] = 67;
    memory_2[2490] = 111;
    memory_2[2463] = 32;
    memory_2[2492] = 110;
    memory_2[2122] = 99;
    memory_2[2494] = 99;
    memory_2[2495] = 116;
    memory_2[2496] = 32;
    memory_2[2497] = 121;
    memory_2[2498] = 111;
    memory_2[2123] = 107;
    memory_2[2500] = 114;
    memory_2[2501] = 32;
    memory_2[2502] = 119;
    memory_2[2503] = 101;
    memory_2[2504] = 98;
    memory_2[2124] = 98;
    memory_2[2506] = 98;
    memory_2[2507] = 114;
    memory_2[2061] = 104;
    memory_2[2509] = 119;
    memory_2[2510] = 115;
    memory_2[2125] = 111;
    memory_2[2512] = 114;
    memory_2[2513] = 32;
    memory_2[2514] = 116;
    memory_2[2515] = 111;
    memory_2[2516] = 32;
    memory_2[2126] = 120;
    memory_2[2518] = 57;
    memory_2[2519] = 50;
    memory_2[2520] = 46;
    memory_2[2521] = 49;
    memory_2[2522] = 54;
    memory_2[2127] = 34;
    memory_2[2524] = 46;
    memory_2[2525] = 49;
    memory_2[2526] = 46;
    memory_2[2469] = 101;
    memory_2[2528] = 10;
    memory_2[2128] = 32;
    memory_2[2129] = 110;
    memory_2[2062] = 101;
    memory_2[2403] = 114;
    memory_2[2130] = 97;
    memory_2[2131] = 109;
    memory_2[2132] = 101;
    memory_2[2133] = 61;
    memory_2[2475] = 112;
    memory_2[2134] = 34;
    memory_2[2063] = 99;
    memory_2[2135] = 108;
    memory_2[2136] = 101;
    memory_2[2478] = 50;
    memory_2[2137] = 100;
    memory_2[2479] = 46;
    memory_2[2138] = 52;
    memory_2[2139] = 34;
    memory_2[2064] = 107;
    memory_2[2481] = 32;
    memory_2[2140] = 32;
    memory_2[2337] = 115;
    memory_2[2141] = 118;
    memory_2[2142] = 97;
    memory_2[2143] = 108;
    memory_2[2144] = 117;
    memory_2[2065] = 98;
    memory_2[2145] = 101;
    memory_2[2487] = 10;
    memory_2[2146] = 61;
    memory_2[2147] = 34;
    memory_2[2148] = 68;
    memory_2[2149] = 34;
    memory_2[2066] = 111;
    memory_2[2491] = 110;
    memory_2[2150] = 62;
    memory_2[2151] = 108;
    memory_2[2493] = 101;
    memory_2[2152] = 101;
    memory_2[2153] = 100;
    memory_2[2154] = 32;
    memory_2[2067] = 120;
    memory_2[2155] = 51;
    memory_2[2156] = 60;
    memory_2[2391] = 107;
    memory_2[2157] = 47;
    memory_2[2499] = 117;
    memory_2[2158] = 105;
    memory_2[2159] = 110;
    memory_2[2068] = 34;
    memory_2[2409] = 97;
    memory_2[2160] = 112;
    memory_2[2161] = 117;
    memory_2[2162] = 116;
    memory_2[2163] = 62;
    memory_2[2505] = 32;
    memory_2[2164] = 9;
    memory_2[2069] = 32;
    memory_2[2165] = 60;
    memory_2[2166] = 98;
    memory_2[2508] = 111;
    memory_2[2167] = 117;
    memory_2[2168] = 116;
    memory_2[2169] = 116;
    memory_2[2070] = 110;
    memory_2[2511] = 101;
    memory_2[2170] = 111;
    memory_2[2343] = 62;
    memory_2[2171] = 110;
    memory_2[2172] = 32;
    memory_2[2173] = 116;
    memory_2[2174] = 121;
    memory_2[2071] = 97;
    memory_2[2175] = 112;
    memory_2[2517] = 49;
    memory_2[2176] = 101;
    memory_2[2177] = 61;
    memory_2[2072] = 109;
    memory_2[2180] = 117;
    memory_2[2181] = 98;
    memory_2[2523] = 56;
    memory_2[2182] = 109;
    memory_2[2445] = 109;
    memory_2[2183] = 105;
    memory_2[2385] = 46;
    memory_2[2184] = 116;
    memory_2[2073] = 101;
    memory_2[2185] = 34;
    memory_2[2527] = 49;
    memory_2[2186] = 32;
    memory_2[2187] = 118;
    memory_2[2529] = 0;
    memory_2[2188] = 97;
    memory_2[2189] = 108;
    memory_2[2074] = 61;
    memory_2[2415] = 104;
    memory_2[2190] = 117;
    memory_2[2191] = 101;
    memory_2[2192] = 61;
    memory_2[2193] = 34;
    memory_2[2194] = 83;
    memory_2[2075] = 34;
    memory_2[2195] = 117;
    memory_2[2196] = 98;
    memory_2[2197] = 109;
    memory_2[2198] = 105;
    memory_2[2199] = 116;
    memory_2[2076] = 108;
    memory_2[2200] = 34;
    memory_2[2349] = 45;
    memory_2[2201] = 62;
    memory_2[2202] = 85;
    memory_2[2203] = 112;
    memory_2[2204] = 100;
    memory_2[2077] = 101;
    memory_2[2418] = 110;
    memory_2[2205] = 97;
    memory_2[2206] = 116;
    memory_2[2052] = 116;
    memory_2[2207] = 101;
    memory_2[2208] = 32;
    memory_2[2209] = 76;
    memory_2[2078] = 100;
    memory_2[2210] = 69;
    memory_2[2211] = 68;
    memory_2[2212] = 115;
    memory_2[2213] = 60;
    memory_2[2214] = 47;
    memory_2[2079] = 51;
    memory_2[2215] = 98;
    memory_2[2216] = 117;
    memory_2[2448] = 0;
    memory_2[2217] = 116;
    memory_2[2388] = 109;
    memory_2[2218] = 116;
    memory_2[2219] = 111;
    memory_2[2080] = 34;
    memory_2[2220] = 110;
    memory_2[2221] = 62;
    memory_2[2222] = 60;
    memory_2[2223] = 47;
    memory_2[2224] = 102;
    memory_2[2081] = 32;
    memory_2[2421] = 95;
    memory_2[2225] = 111;
    memory_2[2226] = 114;
    memory_2[2227] = 109;
    memory_2[2228] = 62;
    memory_2[2229] = 60;
    memory_2[2082] = 118;
    memory_2[2230] = 112;
    memory_2[2355] = 97;
    memory_2[2231] = 62;
    memory_2[2053] = 32;
    memory_2[2232] = 84;
    memory_2[2233] = 104;
    memory_2[2234] = 105;
    memory_2[2083] = 97;
    memory_2[2235] = 115;
    memory_2[2236] = 32;
    memory_2[2237] = 60;
    memory_2[2238] = 97;
    memory_2[2239] = 32;
    memory_2[2084] = 108;
    memory_2[2240] = 104;
    memory_2[2241] = 114;
    memory_2[2242] = 101;
    memory_2[2243] = 102;
    memory_2[2244] = 61;
    memory_2[2085] = 117;
    memory_2[2245] = 34;
    memory_2[2358] = 97;
    memory_2[2246] = 104;
    memory_2[2247] = 116;
    memory_2[2248] = 116;
    memory_2[2249] = 112;
    memory_2[2086] = 101;
    memory_2[2451] = 108;
    memory_2[2250] = 115;
    memory_2[2251] = 58;
    memory_2[2252] = 47;
    memory_2[2253] = 47;
    memory_2[2254] = 103;
    memory_2[2087] = 61;
    memory_2[2255] = 105;
    memory_2[2256] = 116;
    memory_2[2054] = 116;
    memory_2[2257] = 104;
    memory_2[2258] = 117;
    memory_2[2259] = 98;
    memory_2[2088] = 34;
    memory_2[2260] = 46;
    memory_2[2361] = 32;
    memory_2[2261] = 99;
    memory_2[2262] = 111;
    memory_2[2263] = 109;
    memory_2[2264] = 47;
    memory_2[2089] = 67;
    memory_2[2265] = 112;
    memory_2[2266] = 107;
    memory_2[2267] = 101;
    memory_2[2268] = 114;
    memory_2[2269] = 108;
    memory_2[2090] = 34;
    memory_2[2270] = 105;
    memory_2[2271] = 110;
    memory_2[2272] = 103;
    memory_2[2273] = 47;
    memory_2[2274] = 67;
    memory_2[2275] = 104;
    memory_2[2276] = 105;
    memory_2[2277] = 112;
    memory_2[2278] = 115;
    memory_2[2279] = 45;
    memory_2[2433] = 62;
    memory_2[2280] = 68;
    memory_2[2281] = 101;
    memory_2[2282] = 109;
    memory_2[2283] = 111;
    memory_2[2284] = 34;
    memory_2[2285] = 62;
    memory_2[2286] = 112;
    memory_2[2287] = 114;
    memory_2[2288] = 111;
    memory_2[2289] = 106;
    memory_2[2290] = 101;
    memory_2[2367] = 101;
    memory_2[2291] = 99;
    memory_2[2292] = 116;
    memory_2[2293] = 60;
    memory_2[2294] = 47;
    memory_2[2295] = 97;
    memory_2[2296] = 62;
    memory_2[2297] = 32;
    memory_2[2298] = 105;
    memory_2[2301] = 112;
    memory_2[2302] = 111;
    memory_2[2303] = 119;
    memory_2[2304] = 101;
    memory_2[2397] = 103;
    memory_2[2307] = 100;
    memory_2[2439] = 121;
    memory_2[2313] = 97;
    memory_2[2457] = 116;
    memory_2[2427] = 97;
    memory_2[2319] = 61;
    memory_2[2373] = 116;
    memory_2[2325] = 58;
    memory_2[2328] = 112;
    memory_2[2331] = 110;
    memory_2[1717] = 60;
    memory_2[1718] = 104;
    memory_2[1719] = 116;
    memory_2[1720] = 109;
    memory_2[1721] = 108;
    memory_2[1722] = 62;
    memory_2[1723] = 60;
    memory_2[1724] = 104;
    memory_2[1725] = 101;
    memory_2[1726] = 97;
    memory_2[1727] = 100;
    memory_2[1728] = 62;
    memory_2[1729] = 60;
    memory_2[1730] = 116;
    memory_2[1731] = 105;
    memory_2[1732] = 116;
    memory_2[1733] = 108;
    memory_2[1734] = 101;
    memory_2[1735] = 62;
    memory_2[1736] = 101;
    memory_2[1737] = 116;
    memory_2[1738] = 104;
    memory_2[1739] = 101;
    memory_2[1740] = 114;
    memory_2[1741] = 110;
    memory_2[1742] = 101;
    memory_2[1743] = 116;
    memory_2[1744] = 95;
    memory_2[1745] = 109;
    memory_2[1746] = 97;
    memory_2[1747] = 99;
    memory_2[1748] = 32;
    memory_2[1749] = 67;
    memory_2[1750] = 104;
    memory_2[1751] = 105;
    memory_2[1752] = 112;
    memory_2[1753] = 115;
    memory_2[1754] = 45;
    memory_2[1755] = 50;
    memory_2[1756] = 46;
    memory_2[1757] = 48;
    memory_2[1758] = 32;
    memory_2[1759] = 71;
    memory_2[1760] = 105;
    memory_2[1761] = 103;
    memory_2[1762] = 97;
    memory_2[1763] = 66;
    memory_2[1764] = 101;
    memory_2[1765] = 101;
    memory_2[1766] = 32;
    memory_2[1767] = 68;
    memory_2[1768] = 101;
    memory_2[1769] = 109;
    memory_2[1770] = 111;
    memory_2[1771] = 60;
    memory_2[1772] = 47;
    memory_2[1773] = 116;
    memory_2[1774] = 105;
    memory_2[1775] = 116;
    memory_2[1776] = 108;
    memory_2[1777] = 101;
    memory_2[1778] = 62;
    memory_2[1779] = 60;
    memory_2[1780] = 47;
    memory_2[1781] = 104;
    memory_2[1782] = 101;
    memory_2[1783] = 97;
    memory_2[1784] = 100;
    memory_2[1785] = 62;
    memory_2[1786] = 60;
    memory_2[1787] = 98;
    memory_2[1788] = 111;
    memory_2[1789] = 100;
    memory_2[1790] = 121;
    memory_2[1791] = 62;
    memory_2[1792] = 60;
    memory_2[1793] = 104;
    memory_2[1794] = 49;
    memory_2[1795] = 62;
    memory_2[1796] = 101;
    memory_2[1797] = 116;
    memory_2[1798] = 104;
    memory_2[1799] = 101;
    memory_2[1800] = 114;
    memory_2[1801] = 110;
    memory_2[1802] = 101;
    memory_2[1803] = 116;
    memory_2[1804] = 95;
    memory_2[1805] = 109;
    memory_2[1806] = 97;
    memory_2[1807] = 99;
    memory_2[1808] = 32;
    memory_2[1809] = 67;
    memory_2[1810] = 104;
    memory_2[1811] = 105;
    memory_2[1812] = 112;
    memory_2[1813] = 115;
    memory_2[1814] = 45;
    memory_2[1815] = 50;
    memory_2[1816] = 46;
    memory_2[1817] = 48;
    memory_2[1818] = 32;
    memory_2[1819] = 71;
    memory_2[1820] = 105;
    memory_2[1821] = 103;
    memory_2[1822] = 97;
    memory_2[1823] = 66;
    memory_2[1824] = 101;
    memory_2[1825] = 101;
    memory_2[1826] = 32;
    memory_2[1827] = 68;
    memory_2[1828] = 101;
    memory_2[1829] = 109;
    memory_2[1830] = 111;
    memory_2[1831] = 60;
    memory_2[1832] = 47;
    memory_2[1833] = 104;
    memory_2[1834] = 49;
    memory_2[1835] = 62;
    memory_2[1836] = 60;
    memory_2[1837] = 112;
    memory_2[1838] = 62;
    memory_2[1839] = 87;
    memory_2[1840] = 101;
    memory_2[1841] = 108;
    memory_2[1842] = 99;
    memory_2[1843] = 111;
    memory_2[1844] = 109;
    memory_2[1845] = 101;
    memory_2[1846] = 32;
    memory_2[1847] = 116;
    memory_2[1848] = 111;
    memory_2[1849] = 32;
    memory_2[1850] = 116;
    memory_2[1851] = 104;
    memory_2[1852] = 101;
    memory_2[1853] = 32;
    memory_2[1854] = 101;
    memory_2[1855] = 116;
    memory_2[1856] = 104;
    memory_2[1857] = 101;
    memory_2[1858] = 114;
    memory_2[1859] = 110;
    memory_2[1860] = 101;
    memory_2[1861] = 116;
    memory_2[1862] = 95;
    memory_2[1863] = 109;
    memory_2[1864] = 97;
    memory_2[1865] = 99;
    memory_2[1866] = 32;
    memory_2[1867] = 67;
    memory_2[1868] = 104;
    memory_2[1869] = 105;
    memory_2[1870] = 112;
    memory_2[1871] = 115;
    memory_2[1872] = 45;
    memory_2[1873] = 50;
    memory_2[1874] = 46;
    memory_2[1875] = 48;
    memory_2[1876] = 32;
    memory_2[1877] = 71;
    memory_2[1878] = 105;
    memory_2[1879] = 103;
    memory_2[1880] = 97;
    memory_2[1881] = 66;
    memory_2[1882] = 101;
    memory_2[1883] = 101;
    memory_2[1884] = 32;
    memory_2[1885] = 68;
    memory_2[1886] = 101;
    memory_2[1887] = 109;
    memory_2[1888] = 111;
    memory_2[1889] = 33;
    memory_2[1890] = 60;
    memory_2[1891] = 47;
    memory_2[1892] = 112;
    memory_2[1893] = 62;
    memory_2[1894] = 60;
    memory_2[1895] = 112;
    memory_2[1896] = 62;
    memory_2[1897] = 76;
    memory_2[1898] = 105;
    memory_2[1899] = 110;
    memory_2[1900] = 107;
    memory_2[1901] = 32;
    memory_2[1902] = 115;
    memory_2[1903] = 112;
    memory_2[1904] = 101;
    memory_2[1905] = 101;
    memory_2[1906] = 100;
    memory_2[1907] = 58;
    memory_2[1908] = 32;
    memory_2[1909] = 49;
    memory_2[1910] = 48;
    memory_2[1911] = 48;
    memory_2[1912] = 48;
    memory_2[1913] = 32;
    memory_2[1914] = 77;
    memory_2[1915] = 98;
    memory_2[1916] = 47;
    memory_2[1917] = 115;
    memory_2[1918] = 60;
    memory_2[1919] = 47;
    memory_2[1920] = 112;
    memory_2[1921] = 62;
    memory_2[1922] = 60;
    memory_2[1923] = 102;
    memory_2[1924] = 111;
    memory_2[1925] = 114;
    memory_2[1926] = 109;
    memory_2[1927] = 62;
    memory_2[1928] = 9;
    memory_2[1929] = 60;
    memory_2[1930] = 105;
    memory_2[1931] = 110;
    memory_2[1932] = 112;
    memory_2[1933] = 117;
    memory_2[1934] = 116;
    memory_2[1935] = 32;
    memory_2[1936] = 116;
    memory_2[1937] = 121;
    memory_2[1938] = 112;
    memory_2[1939] = 101;
    memory_2[1940] = 61;
    memory_2[1941] = 34;
    memory_2[1942] = 99;
    memory_2[1943] = 104;
    memory_2[1944] = 101;
    memory_2[1945] = 99;
    memory_2[1946] = 107;
    memory_2[1947] = 98;
    memory_2[1948] = 111;
    memory_2[1949] = 120;
    memory_2[1950] = 34;
    memory_2[1951] = 32;
    memory_2[1952] = 110;
    memory_2[1953] = 97;
    memory_2[1954] = 109;
    memory_2[1955] = 101;
    memory_2[1956] = 61;
    memory_2[1957] = 34;
    memory_2[1958] = 108;
    memory_2[1959] = 101;
    memory_2[1960] = 100;
    memory_2[1961] = 49;
    memory_2[1962] = 34;
    memory_2[1963] = 32;
    memory_2[1964] = 118;
    memory_2[1965] = 97;
    memory_2[1966] = 108;
    memory_2[1967] = 117;
    memory_2[1968] = 101;
    memory_2[1969] = 61;
    memory_2[1970] = 34;
    memory_2[1971] = 65;
    memory_2[1972] = 34;
    memory_2[1973] = 62;
    memory_2[1974] = 108;
    memory_2[1975] = 101;
    memory_2[1976] = 100;
    memory_2[1977] = 32;
    memory_2[1978] = 48;
    memory_2[1979] = 60;
    memory_2[1980] = 47;
    memory_2[1981] = 105;
    memory_2[1982] = 110;
    memory_2[1983] = 112;
    memory_2[1984] = 117;
    memory_2[1985] = 116;
    memory_2[1986] = 62;
    memory_2[1987] = 9;
    memory_2[1988] = 60;
    memory_2[1989] = 105;
    memory_2[1990] = 110;
    memory_2[1991] = 112;
    memory_2[1992] = 117;
    memory_2[1993] = 116;
    memory_2[1994] = 32;
    memory_2[1995] = 116;
    memory_2[1996] = 121;
    memory_2[1997] = 112;
    memory_2[1998] = 101;
    memory_2[1999] = 61;
    memory_2[2000] = 34;
    memory_2[2001] = 99;
    memory_2[2002] = 104;
    memory_2[2003] = 101;
    memory_2[2004] = 99;
    memory_2[2005] = 107;
    memory_2[2006] = 98;
    memory_2[2007] = 111;
    memory_2[2008] = 120;
    memory_2[2009] = 34;
    memory_2[2010] = 32;
    memory_2[2011] = 110;
    memory_2[2012] = 97;
    memory_2[2013] = 109;
    memory_2[2014] = 101;
    memory_2[2015] = 61;
    memory_2[2016] = 34;
    memory_2[2017] = 108;
    memory_2[2018] = 101;
    memory_2[2019] = 100;
    memory_2[2020] = 50;
    memory_2[2021] = 34;
    memory_2[2022] = 32;
    memory_2[2023] = 118;
    memory_2[2024] = 97;
    memory_2[2025] = 108;
    memory_2[2026] = 117;
    memory_2[2027] = 101;
    memory_2[2028] = 61;
    memory_2[2029] = 34;
    memory_2[2030] = 66;
    memory_2[2031] = 34;
    memory_2[2032] = 62;
    memory_2[2033] = 108;
    memory_2[2034] = 101;
    memory_2[2035] = 100;
    memory_2[2036] = 32;
    memory_2[2037] = 49;
    memory_2[2038] = 60;
    memory_2[2039] = 47;
    memory_2[2040] = 105;
    memory_2[2041] = 110;
    memory_2[2042] = 112;
    memory_2[2043] = 117;
    memory_2[2044] = 116;
    memory_2[2045] = 62;
    memory_2[2046] = 9;
    memory_2[2047] = 60;
  end


  //////////////////////////////////////////////////////////////////////////////
  // INSTRUCTION INITIALIZATION                                                 
  //                                                                            
  // Initialise the contents of the instruction memory                          
  //
  // Intruction Set
  // ==============
  // 0 {'float': False, 'literal': True, 'right': False, 'unsigned': False, 'op': 'literal'}
  // 1 {'float': False, 'literal': True, 'right': False, 'unsigned': False, 'op': 'jmp_and_link'}
  // 2 {'float': False, 'literal': False, 'right': False, 'unsigned': False, 'op': 'stop'}
  // 3 {'float': False, 'literal': False, 'right': False, 'unsigned': False, 'op': 'move'}
  // 4 {'float': False, 'literal': False, 'right': False, 'unsigned': False, 'op': 'nop'}
  // 5 {'right': False, 'float': False, 'unsigned': False, 'literal': False, 'output': 'socket', 'op': 'write'}
  // 6 {'float': False, 'literal': False, 'right': False, 'unsigned': False, 'op': 'jmp_to_reg'}
  // 7 {'right': False, 'float': False, 'unsigned': False, 'literal': False, 'output': 'rs232_tx', 'op': 'write'}
  // 8 {'float': False, 'literal': False, 'right': False, 'unsigned': True, 'op': '+'}
  // 9 {'right': False, 'element_size': 2, 'float': False, 'unsigned': False, 'literal': False, 'op': 'memory_read_request'}
  // 10 {'right': False, 'element_size': 2, 'float': False, 'unsigned': False, 'literal': False, 'op': 'memory_read_wait'}
  // 11 {'right': False, 'element_size': 2, 'float': False, 'unsigned': False, 'literal': False, 'op': 'memory_read'}
  // 12 {'float': False, 'literal': True, 'right': False, 'unsigned': False, 'op': 'jmp_if_false'}
  // 13 {'float': False, 'literal': True, 'right': True, 'unsigned': True, 'op': '+'}
  // 14 {'float': False, 'literal': True, 'right': False, 'unsigned': False, 'op': 'goto'}
  // 15 {'float': False, 'literal': True, 'right': True, 'unsigned': True, 'op': '>='}
  // 16 {'float': False, 'literal': True, 'right': True, 'unsigned': True, 'op': '-'}
  // 17 {'float': False, 'literal': False, 'right': False, 'unsigned': True, 'op': '|'}
  // 18 {'float': False, 'literal': True, 'right': True, 'unsigned': True, 'op': '|'}
  // 19 {'float': False, 'literal': True, 'right': True, 'unsigned': False, 'op': '>='}
  // 20 {'float': False, 'literal': True, 'right': False, 'unsigned': False, 'op': '-'}
  // 21 {'float': False, 'literal': True, 'right': True, 'unsigned': False, 'op': '<<'}
  // 22 {'float': False, 'literal': True, 'right': True, 'unsigned': False, 'op': '&'}
  // 23 {'float': False, 'literal': True, 'right': True, 'unsigned': True, 'op': '=='}
  // 24 {'float': False, 'literal': True, 'right': False, 'unsigned': True, 'op': '|'}
  // 25 {'float': False, 'literal': True, 'right': True, 'unsigned': True, 'op': '>'}
  // 26 {'float': False, 'literal': True, 'right': True, 'unsigned': True, 'op': '<'}
  // 27 {'float': False, 'literal': False, 'right': False, 'unsigned': True, 'op': '<'}
  // 28 {'float': False, 'literal': False, 'right': False, 'unsigned': True, 'op': '=='}
  // 29 {'float': False, 'literal': True, 'right': True, 'unsigned': False, 'op': '+'}
  // 30 {'right': False, 'float': False, 'unsigned': False, 'literal': False, 'input': 'socket', 'op': 'read'}
  // 31 {'float': False, 'literal': True, 'right': True, 'unsigned': True, 'op': '>>'}
  // 32 {'float': False, 'literal': True, 'right': True, 'unsigned': True, 'op': '&'}
  // 33 {'right': False, 'element_size': 2, 'float': False, 'unsigned': False, 'literal': False, 'op': 'memory_write'}
  // 34 {'float': False, 'literal': True, 'right': False, 'unsigned': False, 'op': 'jmp_if_true'}
  // 35 {'float': False, 'literal': True, 'right': True, 'unsigned': False, 'op': '!='}
  // 36 {'right': False, 'float': False, 'unsigned': False, 'literal': False, 'output': 'leds', 'op': 'write'}
  // 37 {'right': False, 'float': False, 'unsigned': False, 'literal': False, 'input': 'speed', 'op': 'read'}
  // 38 {'float': False, 'literal': False, 'right': False, 'unsigned': False, 'op': '+'}
  // 39 {'right': False, 'float': False, 'unsigned': False, 'literal': False, 'input': 'rs232_rx', 'op': 'read'}
  // Intructions
  // ===========
  
  initial
  begin
    instructions[0] = {6'd0, 7'd57, 7'd0, 32'd1};//{'dest': 57, 'literal': 1, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[1] = {6'd0, 7'd58, 7'd0, 32'd0};//{'dest': 58, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[2] = {6'd1, 7'd18, 7'd0, 32'd930};//{'dest': 18, 'label': 930, 'op': 'jmp_and_link'}
    instructions[3] = {6'd2, 7'd0, 7'd0, 32'd0};//{'op': 'stop'}
    instructions[4] = {6'd3, 7'd31, 7'd45, 32'd0};//{'dest': 31, 'src': 45, 'op': 'move'}
    instructions[5] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[6] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[7] = {6'd5, 7'd0, 7'd31, 32'd0};//{'src': 31, 'output': 'socket', 'op': 'write'}
    instructions[8] = {6'd6, 7'd0, 7'd44, 32'd0};//{'src': 44, 'op': 'jmp_to_reg'}
    instructions[9] = {6'd3, 7'd31, 7'd47, 32'd0};//{'dest': 31, 'src': 47, 'op': 'move'}
    instructions[10] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[11] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[12] = {6'd7, 7'd0, 7'd31, 32'd0};//{'src': 31, 'output': 'rs232_tx', 'op': 'write'}
    instructions[13] = {6'd6, 7'd0, 7'd46, 32'd0};//{'src': 46, 'op': 'jmp_to_reg'}
    instructions[14] = {6'd0, 7'd50, 7'd0, 32'd0};//{'dest': 50, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[15] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[16] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[17] = {6'd3, 7'd32, 7'd50, 32'd0};//{'dest': 32, 'src': 50, 'op': 'move'}
    instructions[18] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[19] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[20] = {6'd8, 7'd33, 7'd32, 32'd49};//{'dest': 33, 'src': 32, 'srcb': 49, 'signed': False, 'op': '+'}
    instructions[21] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[22] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[23] = {6'd9, 7'd0, 7'd33, 32'd0};//{'element_size': 2, 'src': 33, 'sequence': 139888842450488, 'op': 'memory_read_request'}
    instructions[24] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[25] = {6'd10, 7'd0, 7'd33, 32'd0};//{'element_size': 2, 'src': 33, 'sequence': 139888842450488, 'op': 'memory_read_wait'}
    instructions[26] = {6'd11, 7'd31, 7'd33, 32'd0};//{'dest': 31, 'src': 33, 'sequence': 139888842450488, 'element_size': 2, 'op': 'memory_read'}
    instructions[27] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[28] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[29] = {6'd12, 7'd0, 7'd31, 32'd47};//{'src': 31, 'label': 47, 'op': 'jmp_if_false'}
    instructions[30] = {6'd3, 7'd33, 7'd50, 32'd0};//{'dest': 33, 'src': 50, 'op': 'move'}
    instructions[31] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[32] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[33] = {6'd8, 7'd35, 7'd33, 32'd49};//{'dest': 35, 'src': 33, 'srcb': 49, 'signed': False, 'op': '+'}
    instructions[34] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[35] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[36] = {6'd9, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888842475640, 'op': 'memory_read_request'}
    instructions[37] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[38] = {6'd10, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888842475640, 'op': 'memory_read_wait'}
    instructions[39] = {6'd11, 7'd32, 7'd35, 32'd0};//{'dest': 32, 'src': 35, 'sequence': 139888842475640, 'element_size': 2, 'op': 'memory_read'}
    instructions[40] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[41] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[42] = {6'd3, 7'd47, 7'd32, 32'd0};//{'dest': 47, 'src': 32, 'op': 'move'}
    instructions[43] = {6'd1, 7'd46, 7'd0, 32'd9};//{'dest': 46, 'label': 9, 'op': 'jmp_and_link'}
    instructions[44] = {6'd3, 7'd31, 7'd50, 32'd0};//{'dest': 31, 'src': 50, 'op': 'move'}
    instructions[45] = {6'd13, 7'd50, 7'd50, 32'd1};//{'src': 50, 'right': 1, 'dest': 50, 'signed': False, 'op': '+', 'size': 2}
    instructions[46] = {6'd14, 7'd0, 7'd0, 32'd48};//{'label': 48, 'op': 'goto'}
    instructions[47] = {6'd14, 7'd0, 7'd0, 32'd49};//{'label': 49, 'op': 'goto'}
    instructions[48] = {6'd14, 7'd0, 7'd0, 32'd15};//{'label': 15, 'op': 'goto'}
    instructions[49] = {6'd6, 7'd0, 7'd48, 32'd0};//{'src': 48, 'op': 'jmp_to_reg'}
    instructions[50] = {6'd0, 7'd53, 7'd0, 32'd0};//{'dest': 53, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[51] = {6'd0, 7'd54, 7'd0, 32'd0};//{'dest': 54, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[52] = {6'd0, 7'd31, 7'd0, 32'd0};//{'dest': 31, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[53] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[54] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[55] = {6'd3, 7'd53, 7'd31, 32'd0};//{'dest': 53, 'src': 31, 'op': 'move'}
    instructions[56] = {6'd3, 7'd32, 7'd52, 32'd0};//{'dest': 32, 'src': 52, 'op': 'move'}
    instructions[57] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[58] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[59] = {6'd15, 7'd31, 7'd32, 32'd10000};//{'src': 32, 'right': 10000, 'dest': 31, 'signed': False, 'op': '>=', 'type': 'int', 'size': 2}
    instructions[60] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[61] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[62] = {6'd12, 7'd0, 7'd31, 32'd78};//{'src': 31, 'label': 78, 'op': 'jmp_if_false'}
    instructions[63] = {6'd3, 7'd32, 7'd52, 32'd0};//{'dest': 32, 'src': 52, 'op': 'move'}
    instructions[64] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[65] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[66] = {6'd16, 7'd31, 7'd32, 32'd10000};//{'src': 32, 'right': 10000, 'dest': 31, 'signed': False, 'op': '-', 'type': 'int', 'size': 2}
    instructions[67] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[68] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[69] = {6'd3, 7'd52, 7'd31, 32'd0};//{'dest': 52, 'src': 31, 'op': 'move'}
    instructions[70] = {6'd3, 7'd32, 7'd53, 32'd0};//{'dest': 32, 'src': 53, 'op': 'move'}
    instructions[71] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[72] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[73] = {6'd13, 7'd31, 7'd32, 32'd1};//{'src': 32, 'right': 1, 'dest': 31, 'signed': False, 'op': '+', 'type': 'int', 'size': 2}
    instructions[74] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[75] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[76] = {6'd3, 7'd53, 7'd31, 32'd0};//{'dest': 53, 'src': 31, 'op': 'move'}
    instructions[77] = {6'd14, 7'd0, 7'd0, 32'd79};//{'label': 79, 'op': 'goto'}
    instructions[78] = {6'd14, 7'd0, 7'd0, 32'd80};//{'label': 80, 'op': 'goto'}
    instructions[79] = {6'd14, 7'd0, 7'd0, 32'd56};//{'label': 56, 'op': 'goto'}
    instructions[80] = {6'd3, 7'd32, 7'd53, 32'd0};//{'dest': 32, 'src': 53, 'op': 'move'}
    instructions[81] = {6'd3, 7'd33, 7'd54, 32'd0};//{'dest': 33, 'src': 54, 'op': 'move'}
    instructions[82] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[83] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[84] = {6'd17, 7'd31, 7'd32, 32'd33};//{'srcb': 33, 'src': 32, 'dest': 31, 'signed': False, 'op': '|', 'type': 'int', 'size': 2}
    instructions[85] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[86] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[87] = {6'd12, 7'd0, 7'd31, 32'd101};//{'src': 31, 'label': 101, 'op': 'jmp_if_false'}
    instructions[88] = {6'd3, 7'd33, 7'd53, 32'd0};//{'dest': 33, 'src': 53, 'op': 'move'}
    instructions[89] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[90] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[91] = {6'd18, 7'd32, 7'd33, 32'd48};//{'src': 33, 'right': 48, 'dest': 32, 'signed': False, 'op': '|', 'type': 'int', 'size': 2}
    instructions[92] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[93] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[94] = {6'd3, 7'd47, 7'd32, 32'd0};//{'dest': 47, 'src': 32, 'op': 'move'}
    instructions[95] = {6'd1, 7'd46, 7'd0, 32'd9};//{'dest': 46, 'label': 9, 'op': 'jmp_and_link'}
    instructions[96] = {6'd0, 7'd31, 7'd0, 32'd1};//{'dest': 31, 'literal': 1, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[97] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[98] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[99] = {6'd3, 7'd54, 7'd31, 32'd0};//{'dest': 54, 'src': 31, 'op': 'move'}
    instructions[100] = {6'd14, 7'd0, 7'd0, 32'd101};//{'label': 101, 'op': 'goto'}
    instructions[101] = {6'd0, 7'd31, 7'd0, 32'd0};//{'dest': 31, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[102] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[103] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[104] = {6'd3, 7'd53, 7'd31, 32'd0};//{'dest': 53, 'src': 31, 'op': 'move'}
    instructions[105] = {6'd3, 7'd32, 7'd52, 32'd0};//{'dest': 32, 'src': 52, 'op': 'move'}
    instructions[106] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[107] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[108] = {6'd15, 7'd31, 7'd32, 32'd1000};//{'src': 32, 'right': 1000, 'dest': 31, 'signed': False, 'op': '>=', 'type': 'int', 'size': 2}
    instructions[109] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[110] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[111] = {6'd12, 7'd0, 7'd31, 32'd127};//{'src': 31, 'label': 127, 'op': 'jmp_if_false'}
    instructions[112] = {6'd3, 7'd32, 7'd52, 32'd0};//{'dest': 32, 'src': 52, 'op': 'move'}
    instructions[113] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[114] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[115] = {6'd16, 7'd31, 7'd32, 32'd1000};//{'src': 32, 'right': 1000, 'dest': 31, 'signed': False, 'op': '-', 'type': 'int', 'size': 2}
    instructions[116] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[117] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[118] = {6'd3, 7'd52, 7'd31, 32'd0};//{'dest': 52, 'src': 31, 'op': 'move'}
    instructions[119] = {6'd3, 7'd32, 7'd53, 32'd0};//{'dest': 32, 'src': 53, 'op': 'move'}
    instructions[120] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[121] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[122] = {6'd13, 7'd31, 7'd32, 32'd1};//{'src': 32, 'right': 1, 'dest': 31, 'signed': False, 'op': '+', 'type': 'int', 'size': 2}
    instructions[123] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[124] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[125] = {6'd3, 7'd53, 7'd31, 32'd0};//{'dest': 53, 'src': 31, 'op': 'move'}
    instructions[126] = {6'd14, 7'd0, 7'd0, 32'd128};//{'label': 128, 'op': 'goto'}
    instructions[127] = {6'd14, 7'd0, 7'd0, 32'd129};//{'label': 129, 'op': 'goto'}
    instructions[128] = {6'd14, 7'd0, 7'd0, 32'd105};//{'label': 105, 'op': 'goto'}
    instructions[129] = {6'd3, 7'd32, 7'd53, 32'd0};//{'dest': 32, 'src': 53, 'op': 'move'}
    instructions[130] = {6'd3, 7'd33, 7'd54, 32'd0};//{'dest': 33, 'src': 54, 'op': 'move'}
    instructions[131] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[132] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[133] = {6'd17, 7'd31, 7'd32, 32'd33};//{'srcb': 33, 'src': 32, 'dest': 31, 'signed': False, 'op': '|', 'type': 'int', 'size': 2}
    instructions[134] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[135] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[136] = {6'd12, 7'd0, 7'd31, 32'd150};//{'src': 31, 'label': 150, 'op': 'jmp_if_false'}
    instructions[137] = {6'd3, 7'd33, 7'd53, 32'd0};//{'dest': 33, 'src': 53, 'op': 'move'}
    instructions[138] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[139] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[140] = {6'd18, 7'd32, 7'd33, 32'd48};//{'src': 33, 'right': 48, 'dest': 32, 'signed': False, 'op': '|', 'type': 'int', 'size': 2}
    instructions[141] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[142] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[143] = {6'd3, 7'd47, 7'd32, 32'd0};//{'dest': 47, 'src': 32, 'op': 'move'}
    instructions[144] = {6'd1, 7'd46, 7'd0, 32'd9};//{'dest': 46, 'label': 9, 'op': 'jmp_and_link'}
    instructions[145] = {6'd0, 7'd31, 7'd0, 32'd1};//{'dest': 31, 'literal': 1, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[146] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[147] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[148] = {6'd3, 7'd54, 7'd31, 32'd0};//{'dest': 54, 'src': 31, 'op': 'move'}
    instructions[149] = {6'd14, 7'd0, 7'd0, 32'd150};//{'label': 150, 'op': 'goto'}
    instructions[150] = {6'd0, 7'd31, 7'd0, 32'd0};//{'dest': 31, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[151] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[152] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[153] = {6'd3, 7'd53, 7'd31, 32'd0};//{'dest': 53, 'src': 31, 'op': 'move'}
    instructions[154] = {6'd3, 7'd32, 7'd52, 32'd0};//{'dest': 32, 'src': 52, 'op': 'move'}
    instructions[155] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[156] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[157] = {6'd15, 7'd31, 7'd32, 32'd100};//{'src': 32, 'right': 100, 'dest': 31, 'signed': False, 'op': '>=', 'type': 'int', 'size': 2}
    instructions[158] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[159] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[160] = {6'd12, 7'd0, 7'd31, 32'd176};//{'src': 31, 'label': 176, 'op': 'jmp_if_false'}
    instructions[161] = {6'd3, 7'd32, 7'd52, 32'd0};//{'dest': 32, 'src': 52, 'op': 'move'}
    instructions[162] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[163] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[164] = {6'd16, 7'd31, 7'd32, 32'd100};//{'src': 32, 'right': 100, 'dest': 31, 'signed': False, 'op': '-', 'type': 'int', 'size': 2}
    instructions[165] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[166] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[167] = {6'd3, 7'd52, 7'd31, 32'd0};//{'dest': 52, 'src': 31, 'op': 'move'}
    instructions[168] = {6'd3, 7'd32, 7'd53, 32'd0};//{'dest': 32, 'src': 53, 'op': 'move'}
    instructions[169] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[170] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[171] = {6'd13, 7'd31, 7'd32, 32'd1};//{'src': 32, 'right': 1, 'dest': 31, 'signed': False, 'op': '+', 'type': 'int', 'size': 2}
    instructions[172] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[173] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[174] = {6'd3, 7'd53, 7'd31, 32'd0};//{'dest': 53, 'src': 31, 'op': 'move'}
    instructions[175] = {6'd14, 7'd0, 7'd0, 32'd177};//{'label': 177, 'op': 'goto'}
    instructions[176] = {6'd14, 7'd0, 7'd0, 32'd178};//{'label': 178, 'op': 'goto'}
    instructions[177] = {6'd14, 7'd0, 7'd0, 32'd154};//{'label': 154, 'op': 'goto'}
    instructions[178] = {6'd3, 7'd32, 7'd53, 32'd0};//{'dest': 32, 'src': 53, 'op': 'move'}
    instructions[179] = {6'd3, 7'd33, 7'd54, 32'd0};//{'dest': 33, 'src': 54, 'op': 'move'}
    instructions[180] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[181] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[182] = {6'd17, 7'd31, 7'd32, 32'd33};//{'srcb': 33, 'src': 32, 'dest': 31, 'signed': False, 'op': '|', 'type': 'int', 'size': 2}
    instructions[183] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[184] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[185] = {6'd12, 7'd0, 7'd31, 32'd199};//{'src': 31, 'label': 199, 'op': 'jmp_if_false'}
    instructions[186] = {6'd3, 7'd33, 7'd53, 32'd0};//{'dest': 33, 'src': 53, 'op': 'move'}
    instructions[187] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[188] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[189] = {6'd18, 7'd32, 7'd33, 32'd48};//{'src': 33, 'right': 48, 'dest': 32, 'signed': False, 'op': '|', 'type': 'int', 'size': 2}
    instructions[190] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[191] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[192] = {6'd3, 7'd47, 7'd32, 32'd0};//{'dest': 47, 'src': 32, 'op': 'move'}
    instructions[193] = {6'd1, 7'd46, 7'd0, 32'd9};//{'dest': 46, 'label': 9, 'op': 'jmp_and_link'}
    instructions[194] = {6'd0, 7'd31, 7'd0, 32'd1};//{'dest': 31, 'literal': 1, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[195] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[196] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[197] = {6'd3, 7'd54, 7'd31, 32'd0};//{'dest': 54, 'src': 31, 'op': 'move'}
    instructions[198] = {6'd14, 7'd0, 7'd0, 32'd199};//{'label': 199, 'op': 'goto'}
    instructions[199] = {6'd0, 7'd31, 7'd0, 32'd0};//{'dest': 31, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[200] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[201] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[202] = {6'd3, 7'd53, 7'd31, 32'd0};//{'dest': 53, 'src': 31, 'op': 'move'}
    instructions[203] = {6'd3, 7'd32, 7'd52, 32'd0};//{'dest': 32, 'src': 52, 'op': 'move'}
    instructions[204] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[205] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[206] = {6'd15, 7'd31, 7'd32, 32'd10};//{'src': 32, 'right': 10, 'dest': 31, 'signed': False, 'op': '>=', 'type': 'int', 'size': 2}
    instructions[207] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[208] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[209] = {6'd12, 7'd0, 7'd31, 32'd225};//{'src': 31, 'label': 225, 'op': 'jmp_if_false'}
    instructions[210] = {6'd3, 7'd32, 7'd52, 32'd0};//{'dest': 32, 'src': 52, 'op': 'move'}
    instructions[211] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[212] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[213] = {6'd16, 7'd31, 7'd32, 32'd10};//{'src': 32, 'right': 10, 'dest': 31, 'signed': False, 'op': '-', 'type': 'int', 'size': 2}
    instructions[214] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[215] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[216] = {6'd3, 7'd52, 7'd31, 32'd0};//{'dest': 52, 'src': 31, 'op': 'move'}
    instructions[217] = {6'd3, 7'd32, 7'd53, 32'd0};//{'dest': 32, 'src': 53, 'op': 'move'}
    instructions[218] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[219] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[220] = {6'd13, 7'd31, 7'd32, 32'd1};//{'src': 32, 'right': 1, 'dest': 31, 'signed': False, 'op': '+', 'type': 'int', 'size': 2}
    instructions[221] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[222] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[223] = {6'd3, 7'd53, 7'd31, 32'd0};//{'dest': 53, 'src': 31, 'op': 'move'}
    instructions[224] = {6'd14, 7'd0, 7'd0, 32'd226};//{'label': 226, 'op': 'goto'}
    instructions[225] = {6'd14, 7'd0, 7'd0, 32'd227};//{'label': 227, 'op': 'goto'}
    instructions[226] = {6'd14, 7'd0, 7'd0, 32'd203};//{'label': 203, 'op': 'goto'}
    instructions[227] = {6'd3, 7'd32, 7'd53, 32'd0};//{'dest': 32, 'src': 53, 'op': 'move'}
    instructions[228] = {6'd3, 7'd33, 7'd54, 32'd0};//{'dest': 33, 'src': 54, 'op': 'move'}
    instructions[229] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[230] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[231] = {6'd17, 7'd31, 7'd32, 32'd33};//{'srcb': 33, 'src': 32, 'dest': 31, 'signed': False, 'op': '|', 'type': 'int', 'size': 2}
    instructions[232] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[233] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[234] = {6'd12, 7'd0, 7'd31, 32'd248};//{'src': 31, 'label': 248, 'op': 'jmp_if_false'}
    instructions[235] = {6'd3, 7'd33, 7'd53, 32'd0};//{'dest': 33, 'src': 53, 'op': 'move'}
    instructions[236] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[237] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[238] = {6'd18, 7'd32, 7'd33, 32'd48};//{'src': 33, 'right': 48, 'dest': 32, 'signed': False, 'op': '|', 'type': 'int', 'size': 2}
    instructions[239] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[240] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[241] = {6'd3, 7'd47, 7'd32, 32'd0};//{'dest': 47, 'src': 32, 'op': 'move'}
    instructions[242] = {6'd1, 7'd46, 7'd0, 32'd9};//{'dest': 46, 'label': 9, 'op': 'jmp_and_link'}
    instructions[243] = {6'd0, 7'd31, 7'd0, 32'd1};//{'dest': 31, 'literal': 1, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[244] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[245] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[246] = {6'd3, 7'd54, 7'd31, 32'd0};//{'dest': 54, 'src': 31, 'op': 'move'}
    instructions[247] = {6'd14, 7'd0, 7'd0, 32'd248};//{'label': 248, 'op': 'goto'}
    instructions[248] = {6'd3, 7'd33, 7'd52, 32'd0};//{'dest': 33, 'src': 52, 'op': 'move'}
    instructions[249] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[250] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[251] = {6'd18, 7'd32, 7'd33, 32'd48};//{'src': 33, 'right': 48, 'dest': 32, 'signed': False, 'op': '|', 'type': 'int', 'size': 2}
    instructions[252] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[253] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[254] = {6'd3, 7'd47, 7'd32, 32'd0};//{'dest': 47, 'src': 32, 'op': 'move'}
    instructions[255] = {6'd1, 7'd46, 7'd0, 32'd9};//{'dest': 46, 'label': 9, 'op': 'jmp_and_link'}
    instructions[256] = {6'd6, 7'd0, 7'd51, 32'd0};//{'src': 51, 'op': 'jmp_to_reg'}
    instructions[257] = {6'd3, 7'd32, 7'd56, 32'd0};//{'dest': 32, 'src': 56, 'op': 'move'}
    instructions[258] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[259] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[260] = {6'd19, 7'd31, 7'd32, 32'd0};//{'src': 32, 'right': 0, 'dest': 31, 'signed': True, 'op': '>=', 'type': 'int', 'size': 2}
    instructions[261] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[262] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[263] = {6'd12, 7'd0, 7'd31, 32'd270};//{'src': 31, 'label': 270, 'op': 'jmp_if_false'}
    instructions[264] = {6'd3, 7'd32, 7'd56, 32'd0};//{'dest': 32, 'src': 56, 'op': 'move'}
    instructions[265] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[266] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[267] = {6'd3, 7'd52, 7'd32, 32'd0};//{'dest': 52, 'src': 32, 'op': 'move'}
    instructions[268] = {6'd1, 7'd51, 7'd0, 32'd50};//{'dest': 51, 'label': 50, 'op': 'jmp_and_link'}
    instructions[269] = {6'd14, 7'd0, 7'd0, 32'd283};//{'label': 283, 'op': 'goto'}
    instructions[270] = {6'd0, 7'd32, 7'd0, 32'd45};//{'dest': 32, 'literal': 45, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[271] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[272] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[273] = {6'd3, 7'd47, 7'd32, 32'd0};//{'dest': 47, 'src': 32, 'op': 'move'}
    instructions[274] = {6'd1, 7'd46, 7'd0, 32'd9};//{'dest': 46, 'label': 9, 'op': 'jmp_and_link'}
    instructions[275] = {6'd3, 7'd33, 7'd56, 32'd0};//{'dest': 33, 'src': 56, 'op': 'move'}
    instructions[276] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[277] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[278] = {6'd20, 7'd32, 7'd33, 32'd0};//{'src': 33, 'dest': 32, 'signed': True, 'op': '-', 'size': 2, 'type': 'int', 'left': 0}
    instructions[279] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[280] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[281] = {6'd3, 7'd52, 7'd32, 32'd0};//{'dest': 52, 'src': 32, 'op': 'move'}
    instructions[282] = {6'd1, 7'd51, 7'd0, 32'd50};//{'dest': 51, 'label': 50, 'op': 'jmp_and_link'}
    instructions[283] = {6'd6, 7'd0, 7'd55, 32'd0};//{'src': 55, 'op': 'jmp_to_reg'}
    instructions[284] = {6'd3, 7'd31, 7'd57, 32'd0};//{'dest': 31, 'src': 57, 'op': 'move'}
    instructions[285] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[286] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[287] = {6'd12, 7'd0, 7'd31, 32'd300};//{'src': 31, 'label': 300, 'op': 'jmp_if_false'}
    instructions[288] = {6'd0, 7'd31, 7'd0, 32'd0};//{'dest': 31, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[289] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[290] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[291] = {6'd3, 7'd57, 7'd31, 32'd0};//{'dest': 57, 'src': 31, 'op': 'move'}
    instructions[292] = {6'd3, 7'd32, 7'd60, 32'd0};//{'dest': 32, 'src': 60, 'op': 'move'}
    instructions[293] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[294] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[295] = {6'd21, 7'd31, 7'd32, 32'd8};//{'src': 32, 'right': 8, 'dest': 31, 'signed': True, 'op': '<<', 'type': 'int', 'size': 2}
    instructions[296] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[297] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[298] = {6'd3, 7'd58, 7'd31, 32'd0};//{'dest': 58, 'src': 31, 'op': 'move'}
    instructions[299] = {6'd14, 7'd0, 7'd0, 32'd322};//{'label': 322, 'op': 'goto'}
    instructions[300] = {6'd0, 7'd31, 7'd0, 32'd1};//{'dest': 31, 'literal': 1, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[301] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[302] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[303] = {6'd3, 7'd57, 7'd31, 32'd0};//{'dest': 57, 'src': 31, 'op': 'move'}
    instructions[304] = {6'd3, 7'd32, 7'd58, 32'd0};//{'dest': 32, 'src': 58, 'op': 'move'}
    instructions[305] = {6'd3, 7'd35, 7'd60, 32'd0};//{'dest': 35, 'src': 60, 'op': 'move'}
    instructions[306] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[307] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[308] = {6'd22, 7'd33, 7'd35, 32'd255};//{'src': 35, 'right': 255, 'dest': 33, 'signed': True, 'op': '&', 'type': 'int', 'size': 2}
    instructions[309] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[310] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[311] = {6'd17, 7'd31, 7'd32, 32'd33};//{'srcb': 33, 'src': 32, 'dest': 31, 'signed': False, 'op': '|', 'type': 'int', 'size': 2}
    instructions[312] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[313] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[314] = {6'd3, 7'd58, 7'd31, 32'd0};//{'dest': 58, 'src': 31, 'op': 'move'}
    instructions[315] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[316] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[317] = {6'd3, 7'd32, 7'd58, 32'd0};//{'dest': 32, 'src': 58, 'op': 'move'}
    instructions[318] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[319] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[320] = {6'd3, 7'd45, 7'd32, 32'd0};//{'dest': 45, 'src': 32, 'op': 'move'}
    instructions[321] = {6'd1, 7'd44, 7'd0, 32'd4};//{'dest': 44, 'label': 4, 'op': 'jmp_and_link'}
    instructions[322] = {6'd6, 7'd0, 7'd59, 32'd0};//{'src': 59, 'op': 'jmp_to_reg'}
    instructions[323] = {6'd3, 7'd32, 7'd57, 32'd0};//{'dest': 32, 'src': 57, 'op': 'move'}
    instructions[324] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[325] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[326] = {6'd23, 7'd31, 7'd32, 32'd0};//{'src': 32, 'right': 0, 'dest': 31, 'signed': False, 'op': '==', 'type': 'int', 'size': 2}
    instructions[327] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[328] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[329] = {6'd12, 7'd0, 7'd31, 32'd336};//{'src': 31, 'label': 336, 'op': 'jmp_if_false'}
    instructions[330] = {6'd3, 7'd32, 7'd58, 32'd0};//{'dest': 32, 'src': 58, 'op': 'move'}
    instructions[331] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[332] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[333] = {6'd3, 7'd45, 7'd32, 32'd0};//{'dest': 45, 'src': 32, 'op': 'move'}
    instructions[334] = {6'd1, 7'd44, 7'd0, 32'd4};//{'dest': 44, 'label': 4, 'op': 'jmp_and_link'}
    instructions[335] = {6'd14, 7'd0, 7'd0, 32'd336};//{'label': 336, 'op': 'goto'}
    instructions[336] = {6'd0, 7'd31, 7'd0, 32'd1};//{'dest': 31, 'literal': 1, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[337] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[338] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[339] = {6'd3, 7'd57, 7'd31, 32'd0};//{'dest': 57, 'src': 31, 'op': 'move'}
    instructions[340] = {6'd6, 7'd0, 7'd61, 32'd0};//{'src': 61, 'op': 'jmp_to_reg'}
    instructions[341] = {6'd0, 7'd64, 7'd0, 32'd0};//{'dest': 64, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[342] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[343] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[344] = {6'd3, 7'd32, 7'd64, 32'd0};//{'dest': 32, 'src': 64, 'op': 'move'}
    instructions[345] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[346] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[347] = {6'd8, 7'd33, 7'd32, 32'd63};//{'dest': 33, 'src': 32, 'srcb': 63, 'signed': False, 'op': '+'}
    instructions[348] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[349] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[350] = {6'd9, 7'd0, 7'd33, 32'd0};//{'element_size': 2, 'src': 33, 'sequence': 139888842595720, 'op': 'memory_read_request'}
    instructions[351] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[352] = {6'd10, 7'd0, 7'd33, 32'd0};//{'element_size': 2, 'src': 33, 'sequence': 139888842595720, 'op': 'memory_read_wait'}
    instructions[353] = {6'd11, 7'd31, 7'd33, 32'd0};//{'dest': 31, 'src': 33, 'sequence': 139888842595720, 'element_size': 2, 'op': 'memory_read'}
    instructions[354] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[355] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[356] = {6'd12, 7'd0, 7'd31, 32'd374};//{'src': 31, 'label': 374, 'op': 'jmp_if_false'}
    instructions[357] = {6'd3, 7'd33, 7'd64, 32'd0};//{'dest': 33, 'src': 64, 'op': 'move'}
    instructions[358] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[359] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[360] = {6'd8, 7'd35, 7'd33, 32'd63};//{'dest': 35, 'src': 33, 'srcb': 63, 'signed': False, 'op': '+'}
    instructions[361] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[362] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[363] = {6'd9, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888842608584, 'op': 'memory_read_request'}
    instructions[364] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[365] = {6'd10, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888842608584, 'op': 'memory_read_wait'}
    instructions[366] = {6'd11, 7'd32, 7'd35, 32'd0};//{'dest': 32, 'src': 35, 'sequence': 139888842608584, 'element_size': 2, 'op': 'memory_read'}
    instructions[367] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[368] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[369] = {6'd3, 7'd60, 7'd32, 32'd0};//{'dest': 60, 'src': 32, 'op': 'move'}
    instructions[370] = {6'd1, 7'd59, 7'd0, 32'd284};//{'dest': 59, 'label': 284, 'op': 'jmp_and_link'}
    instructions[371] = {6'd3, 7'd31, 7'd64, 32'd0};//{'dest': 31, 'src': 64, 'op': 'move'}
    instructions[372] = {6'd13, 7'd64, 7'd64, 32'd1};//{'src': 64, 'right': 1, 'dest': 64, 'signed': False, 'op': '+', 'size': 2}
    instructions[373] = {6'd14, 7'd0, 7'd0, 32'd375};//{'label': 375, 'op': 'goto'}
    instructions[374] = {6'd14, 7'd0, 7'd0, 32'd376};//{'label': 376, 'op': 'goto'}
    instructions[375] = {6'd14, 7'd0, 7'd0, 32'd342};//{'label': 342, 'op': 'goto'}
    instructions[376] = {6'd6, 7'd0, 7'd62, 32'd0};//{'src': 62, 'op': 'jmp_to_reg'}
    instructions[377] = {6'd0, 7'd67, 7'd0, 32'd0};//{'dest': 67, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[378] = {6'd0, 7'd68, 7'd0, 32'd0};//{'dest': 68, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[379] = {6'd0, 7'd69, 7'd0, 32'd0};//{'dest': 69, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[380] = {6'd0, 7'd70, 7'd0, 32'd0};//{'dest': 70, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[381] = {6'd0, 7'd71, 7'd0, 32'd0};//{'dest': 71, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[382] = {6'd0, 7'd72, 7'd0, 32'd0};//{'dest': 72, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[383] = {6'd3, 7'd32, 7'd66, 32'd0};//{'dest': 32, 'src': 66, 'op': 'move'}
    instructions[384] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[385] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[386] = {6'd15, 7'd31, 7'd32, 32'd10000};//{'src': 32, 'right': 10000, 'dest': 31, 'signed': False, 'op': '>=', 'type': 'int', 'size': 2}
    instructions[387] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[388] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[389] = {6'd12, 7'd0, 7'd31, 32'd400};//{'src': 31, 'label': 400, 'op': 'jmp_if_false'}
    instructions[390] = {6'd3, 7'd31, 7'd71, 32'd0};//{'dest': 31, 'src': 71, 'op': 'move'}
    instructions[391] = {6'd13, 7'd71, 7'd71, 32'd1};//{'src': 71, 'right': 1, 'dest': 71, 'signed': False, 'op': '+', 'size': 2}
    instructions[392] = {6'd3, 7'd32, 7'd66, 32'd0};//{'dest': 32, 'src': 66, 'op': 'move'}
    instructions[393] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[394] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[395] = {6'd16, 7'd31, 7'd32, 32'd10000};//{'src': 32, 'right': 10000, 'dest': 31, 'signed': False, 'op': '-', 'type': 'int', 'size': 2}
    instructions[396] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[397] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[398] = {6'd3, 7'd66, 7'd31, 32'd0};//{'dest': 66, 'src': 31, 'op': 'move'}
    instructions[399] = {6'd14, 7'd0, 7'd0, 32'd401};//{'label': 401, 'op': 'goto'}
    instructions[400] = {6'd14, 7'd0, 7'd0, 32'd402};//{'label': 402, 'op': 'goto'}
    instructions[401] = {6'd14, 7'd0, 7'd0, 32'd383};//{'label': 383, 'op': 'goto'}
    instructions[402] = {6'd3, 7'd32, 7'd71, 32'd0};//{'dest': 32, 'src': 71, 'op': 'move'}
    instructions[403] = {6'd3, 7'd33, 7'd72, 32'd0};//{'dest': 33, 'src': 72, 'op': 'move'}
    instructions[404] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[405] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[406] = {6'd17, 7'd31, 7'd32, 32'd33};//{'srcb': 33, 'src': 32, 'dest': 31, 'signed': False, 'op': '|', 'type': 'int', 'size': 2}
    instructions[407] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[408] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[409] = {6'd12, 7'd0, 7'd31, 32'd423};//{'src': 31, 'label': 423, 'op': 'jmp_if_false'}
    instructions[410] = {6'd3, 7'd33, 7'd71, 32'd0};//{'dest': 33, 'src': 71, 'op': 'move'}
    instructions[411] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[412] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[413] = {6'd24, 7'd32, 7'd33, 32'd48};//{'src': 33, 'dest': 32, 'signed': False, 'op': '|', 'size': 2, 'type': 'int', 'left': 48}
    instructions[414] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[415] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[416] = {6'd3, 7'd60, 7'd32, 32'd0};//{'dest': 60, 'src': 32, 'op': 'move'}
    instructions[417] = {6'd1, 7'd59, 7'd0, 32'd284};//{'dest': 59, 'label': 284, 'op': 'jmp_and_link'}
    instructions[418] = {6'd0, 7'd31, 7'd0, 32'd1};//{'dest': 31, 'literal': 1, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[419] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[420] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[421] = {6'd3, 7'd72, 7'd31, 32'd0};//{'dest': 72, 'src': 31, 'op': 'move'}
    instructions[422] = {6'd14, 7'd0, 7'd0, 32'd423};//{'label': 423, 'op': 'goto'}
    instructions[423] = {6'd3, 7'd32, 7'd66, 32'd0};//{'dest': 32, 'src': 66, 'op': 'move'}
    instructions[424] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[425] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[426] = {6'd15, 7'd31, 7'd32, 32'd1000};//{'src': 32, 'right': 1000, 'dest': 31, 'signed': False, 'op': '>=', 'type': 'int', 'size': 2}
    instructions[427] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[428] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[429] = {6'd12, 7'd0, 7'd31, 32'd440};//{'src': 31, 'label': 440, 'op': 'jmp_if_false'}
    instructions[430] = {6'd3, 7'd31, 7'd70, 32'd0};//{'dest': 31, 'src': 70, 'op': 'move'}
    instructions[431] = {6'd13, 7'd70, 7'd70, 32'd1};//{'src': 70, 'right': 1, 'dest': 70, 'signed': False, 'op': '+', 'size': 2}
    instructions[432] = {6'd3, 7'd32, 7'd66, 32'd0};//{'dest': 32, 'src': 66, 'op': 'move'}
    instructions[433] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[434] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[435] = {6'd16, 7'd31, 7'd32, 32'd1000};//{'src': 32, 'right': 1000, 'dest': 31, 'signed': False, 'op': '-', 'type': 'int', 'size': 2}
    instructions[436] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[437] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[438] = {6'd3, 7'd66, 7'd31, 32'd0};//{'dest': 66, 'src': 31, 'op': 'move'}
    instructions[439] = {6'd14, 7'd0, 7'd0, 32'd441};//{'label': 441, 'op': 'goto'}
    instructions[440] = {6'd14, 7'd0, 7'd0, 32'd442};//{'label': 442, 'op': 'goto'}
    instructions[441] = {6'd14, 7'd0, 7'd0, 32'd423};//{'label': 423, 'op': 'goto'}
    instructions[442] = {6'd3, 7'd32, 7'd70, 32'd0};//{'dest': 32, 'src': 70, 'op': 'move'}
    instructions[443] = {6'd3, 7'd33, 7'd72, 32'd0};//{'dest': 33, 'src': 72, 'op': 'move'}
    instructions[444] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[445] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[446] = {6'd17, 7'd31, 7'd32, 32'd33};//{'srcb': 33, 'src': 32, 'dest': 31, 'signed': False, 'op': '|', 'type': 'int', 'size': 2}
    instructions[447] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[448] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[449] = {6'd12, 7'd0, 7'd31, 32'd463};//{'src': 31, 'label': 463, 'op': 'jmp_if_false'}
    instructions[450] = {6'd3, 7'd33, 7'd70, 32'd0};//{'dest': 33, 'src': 70, 'op': 'move'}
    instructions[451] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[452] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[453] = {6'd24, 7'd32, 7'd33, 32'd48};//{'src': 33, 'dest': 32, 'signed': False, 'op': '|', 'size': 2, 'type': 'int', 'left': 48}
    instructions[454] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[455] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[456] = {6'd3, 7'd60, 7'd32, 32'd0};//{'dest': 60, 'src': 32, 'op': 'move'}
    instructions[457] = {6'd1, 7'd59, 7'd0, 32'd284};//{'dest': 59, 'label': 284, 'op': 'jmp_and_link'}
    instructions[458] = {6'd0, 7'd31, 7'd0, 32'd1};//{'dest': 31, 'literal': 1, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[459] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[460] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[461] = {6'd3, 7'd72, 7'd31, 32'd0};//{'dest': 72, 'src': 31, 'op': 'move'}
    instructions[462] = {6'd14, 7'd0, 7'd0, 32'd463};//{'label': 463, 'op': 'goto'}
    instructions[463] = {6'd3, 7'd32, 7'd66, 32'd0};//{'dest': 32, 'src': 66, 'op': 'move'}
    instructions[464] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[465] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[466] = {6'd15, 7'd31, 7'd32, 32'd100};//{'src': 32, 'right': 100, 'dest': 31, 'signed': False, 'op': '>=', 'type': 'int', 'size': 2}
    instructions[467] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[468] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[469] = {6'd12, 7'd0, 7'd31, 32'd480};//{'src': 31, 'label': 480, 'op': 'jmp_if_false'}
    instructions[470] = {6'd3, 7'd31, 7'd69, 32'd0};//{'dest': 31, 'src': 69, 'op': 'move'}
    instructions[471] = {6'd13, 7'd69, 7'd69, 32'd1};//{'src': 69, 'right': 1, 'dest': 69, 'signed': False, 'op': '+', 'size': 2}
    instructions[472] = {6'd3, 7'd32, 7'd66, 32'd0};//{'dest': 32, 'src': 66, 'op': 'move'}
    instructions[473] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[474] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[475] = {6'd16, 7'd31, 7'd32, 32'd100};//{'src': 32, 'right': 100, 'dest': 31, 'signed': False, 'op': '-', 'type': 'int', 'size': 2}
    instructions[476] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[477] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[478] = {6'd3, 7'd66, 7'd31, 32'd0};//{'dest': 66, 'src': 31, 'op': 'move'}
    instructions[479] = {6'd14, 7'd0, 7'd0, 32'd481};//{'label': 481, 'op': 'goto'}
    instructions[480] = {6'd14, 7'd0, 7'd0, 32'd482};//{'label': 482, 'op': 'goto'}
    instructions[481] = {6'd14, 7'd0, 7'd0, 32'd463};//{'label': 463, 'op': 'goto'}
    instructions[482] = {6'd3, 7'd32, 7'd69, 32'd0};//{'dest': 32, 'src': 69, 'op': 'move'}
    instructions[483] = {6'd3, 7'd33, 7'd72, 32'd0};//{'dest': 33, 'src': 72, 'op': 'move'}
    instructions[484] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[485] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[486] = {6'd17, 7'd31, 7'd32, 32'd33};//{'srcb': 33, 'src': 32, 'dest': 31, 'signed': False, 'op': '|', 'type': 'int', 'size': 2}
    instructions[487] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[488] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[489] = {6'd12, 7'd0, 7'd31, 32'd503};//{'src': 31, 'label': 503, 'op': 'jmp_if_false'}
    instructions[490] = {6'd3, 7'd33, 7'd69, 32'd0};//{'dest': 33, 'src': 69, 'op': 'move'}
    instructions[491] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[492] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[493] = {6'd24, 7'd32, 7'd33, 32'd48};//{'src': 33, 'dest': 32, 'signed': False, 'op': '|', 'size': 2, 'type': 'int', 'left': 48}
    instructions[494] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[495] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[496] = {6'd3, 7'd60, 7'd32, 32'd0};//{'dest': 60, 'src': 32, 'op': 'move'}
    instructions[497] = {6'd1, 7'd59, 7'd0, 32'd284};//{'dest': 59, 'label': 284, 'op': 'jmp_and_link'}
    instructions[498] = {6'd0, 7'd31, 7'd0, 32'd1};//{'dest': 31, 'literal': 1, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[499] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[500] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[501] = {6'd3, 7'd72, 7'd31, 32'd0};//{'dest': 72, 'src': 31, 'op': 'move'}
    instructions[502] = {6'd14, 7'd0, 7'd0, 32'd503};//{'label': 503, 'op': 'goto'}
    instructions[503] = {6'd3, 7'd32, 7'd66, 32'd0};//{'dest': 32, 'src': 66, 'op': 'move'}
    instructions[504] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[505] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[506] = {6'd15, 7'd31, 7'd32, 32'd10};//{'src': 32, 'right': 10, 'dest': 31, 'signed': False, 'op': '>=', 'type': 'int', 'size': 2}
    instructions[507] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[508] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[509] = {6'd12, 7'd0, 7'd31, 32'd520};//{'src': 31, 'label': 520, 'op': 'jmp_if_false'}
    instructions[510] = {6'd3, 7'd31, 7'd68, 32'd0};//{'dest': 31, 'src': 68, 'op': 'move'}
    instructions[511] = {6'd13, 7'd68, 7'd68, 32'd1};//{'src': 68, 'right': 1, 'dest': 68, 'signed': False, 'op': '+', 'size': 2}
    instructions[512] = {6'd3, 7'd32, 7'd66, 32'd0};//{'dest': 32, 'src': 66, 'op': 'move'}
    instructions[513] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[514] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[515] = {6'd16, 7'd31, 7'd32, 32'd10};//{'src': 32, 'right': 10, 'dest': 31, 'signed': False, 'op': '-', 'type': 'int', 'size': 2}
    instructions[516] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[517] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[518] = {6'd3, 7'd66, 7'd31, 32'd0};//{'dest': 66, 'src': 31, 'op': 'move'}
    instructions[519] = {6'd14, 7'd0, 7'd0, 32'd521};//{'label': 521, 'op': 'goto'}
    instructions[520] = {6'd14, 7'd0, 7'd0, 32'd522};//{'label': 522, 'op': 'goto'}
    instructions[521] = {6'd14, 7'd0, 7'd0, 32'd503};//{'label': 503, 'op': 'goto'}
    instructions[522] = {6'd3, 7'd32, 7'd68, 32'd0};//{'dest': 32, 'src': 68, 'op': 'move'}
    instructions[523] = {6'd3, 7'd33, 7'd72, 32'd0};//{'dest': 33, 'src': 72, 'op': 'move'}
    instructions[524] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[525] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[526] = {6'd17, 7'd31, 7'd32, 32'd33};//{'srcb': 33, 'src': 32, 'dest': 31, 'signed': False, 'op': '|', 'type': 'int', 'size': 2}
    instructions[527] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[528] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[529] = {6'd12, 7'd0, 7'd31, 32'd543};//{'src': 31, 'label': 543, 'op': 'jmp_if_false'}
    instructions[530] = {6'd3, 7'd33, 7'd68, 32'd0};//{'dest': 33, 'src': 68, 'op': 'move'}
    instructions[531] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[532] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[533] = {6'd24, 7'd32, 7'd33, 32'd48};//{'src': 33, 'dest': 32, 'signed': False, 'op': '|', 'size': 2, 'type': 'int', 'left': 48}
    instructions[534] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[535] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[536] = {6'd3, 7'd60, 7'd32, 32'd0};//{'dest': 60, 'src': 32, 'op': 'move'}
    instructions[537] = {6'd1, 7'd59, 7'd0, 32'd284};//{'dest': 59, 'label': 284, 'op': 'jmp_and_link'}
    instructions[538] = {6'd0, 7'd31, 7'd0, 32'd1};//{'dest': 31, 'literal': 1, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[539] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[540] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[541] = {6'd3, 7'd72, 7'd31, 32'd0};//{'dest': 72, 'src': 31, 'op': 'move'}
    instructions[542] = {6'd14, 7'd0, 7'd0, 32'd543};//{'label': 543, 'op': 'goto'}
    instructions[543] = {6'd3, 7'd32, 7'd66, 32'd0};//{'dest': 32, 'src': 66, 'op': 'move'}
    instructions[544] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[545] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[546] = {6'd15, 7'd31, 7'd32, 32'd1};//{'src': 32, 'right': 1, 'dest': 31, 'signed': False, 'op': '>=', 'type': 'int', 'size': 2}
    instructions[547] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[548] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[549] = {6'd12, 7'd0, 7'd31, 32'd560};//{'src': 31, 'label': 560, 'op': 'jmp_if_false'}
    instructions[550] = {6'd3, 7'd31, 7'd67, 32'd0};//{'dest': 31, 'src': 67, 'op': 'move'}
    instructions[551] = {6'd13, 7'd67, 7'd67, 32'd1};//{'src': 67, 'right': 1, 'dest': 67, 'signed': False, 'op': '+', 'size': 2}
    instructions[552] = {6'd3, 7'd32, 7'd66, 32'd0};//{'dest': 32, 'src': 66, 'op': 'move'}
    instructions[553] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[554] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[555] = {6'd16, 7'd31, 7'd32, 32'd1};//{'src': 32, 'right': 1, 'dest': 31, 'signed': False, 'op': '-', 'type': 'int', 'size': 2}
    instructions[556] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[557] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[558] = {6'd3, 7'd66, 7'd31, 32'd0};//{'dest': 66, 'src': 31, 'op': 'move'}
    instructions[559] = {6'd14, 7'd0, 7'd0, 32'd561};//{'label': 561, 'op': 'goto'}
    instructions[560] = {6'd14, 7'd0, 7'd0, 32'd562};//{'label': 562, 'op': 'goto'}
    instructions[561] = {6'd14, 7'd0, 7'd0, 32'd543};//{'label': 543, 'op': 'goto'}
    instructions[562] = {6'd3, 7'd33, 7'd67, 32'd0};//{'dest': 33, 'src': 67, 'op': 'move'}
    instructions[563] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[564] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[565] = {6'd24, 7'd32, 7'd33, 32'd48};//{'src': 33, 'dest': 32, 'signed': False, 'op': '|', 'size': 2, 'type': 'int', 'left': 48}
    instructions[566] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[567] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[568] = {6'd3, 7'd60, 7'd32, 32'd0};//{'dest': 60, 'src': 32, 'op': 'move'}
    instructions[569] = {6'd1, 7'd59, 7'd0, 32'd284};//{'dest': 59, 'label': 284, 'op': 'jmp_and_link'}
    instructions[570] = {6'd6, 7'd0, 7'd65, 32'd0};//{'src': 65, 'op': 'jmp_to_reg'}
    instructions[571] = {6'd0, 7'd74, 7'd0, 32'd0};//{'dest': 74, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[572] = {6'd0, 7'd75, 7'd0, 32'd4};//{'dest': 75, 'literal': 4, 'op': 'literal'}
    instructions[573] = {6'd0, 7'd31, 7'd0, 32'd0};//{'dest': 31, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[574] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[575] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[576] = {6'd3, 7'd74, 7'd31, 32'd0};//{'dest': 74, 'src': 31, 'op': 'move'}
    instructions[577] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[578] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[579] = {6'd3, 7'd32, 7'd74, 32'd0};//{'dest': 32, 'src': 74, 'op': 'move'}
    instructions[580] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[581] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[582] = {6'd8, 7'd33, 7'd32, 32'd75};//{'dest': 33, 'src': 32, 'srcb': 75, 'signed': False, 'op': '+'}
    instructions[583] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[584] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[585] = {6'd9, 7'd0, 7'd33, 32'd0};//{'element_size': 2, 'src': 33, 'sequence': 139888842668656, 'op': 'memory_read_request'}
    instructions[586] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[587] = {6'd10, 7'd0, 7'd33, 32'd0};//{'element_size': 2, 'src': 33, 'sequence': 139888842668656, 'op': 'memory_read_wait'}
    instructions[588] = {6'd11, 7'd31, 7'd33, 32'd0};//{'dest': 31, 'src': 33, 'sequence': 139888842668656, 'element_size': 2, 'op': 'memory_read'}
    instructions[589] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[590] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[591] = {6'd12, 7'd0, 7'd31, 32'd595};//{'src': 31, 'label': 595, 'op': 'jmp_if_false'}
    instructions[592] = {6'd3, 7'd31, 7'd74, 32'd0};//{'dest': 31, 'src': 74, 'op': 'move'}
    instructions[593] = {6'd13, 7'd74, 7'd74, 32'd1};//{'src': 74, 'right': 1, 'dest': 74, 'signed': False, 'op': '+', 'size': 2}
    instructions[594] = {6'd14, 7'd0, 7'd0, 32'd596};//{'label': 596, 'op': 'goto'}
    instructions[595] = {6'd14, 7'd0, 7'd0, 32'd597};//{'label': 597, 'op': 'goto'}
    instructions[596] = {6'd14, 7'd0, 7'd0, 32'd577};//{'label': 577, 'op': 'goto'}
    instructions[597] = {6'd3, 7'd32, 7'd74, 32'd0};//{'dest': 32, 'src': 74, 'op': 'move'}
    instructions[598] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[599] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[600] = {6'd3, 7'd45, 7'd32, 32'd0};//{'dest': 45, 'src': 32, 'op': 'move'}
    instructions[601] = {6'd1, 7'd44, 7'd0, 32'd4};//{'dest': 44, 'label': 4, 'op': 'jmp_and_link'}
    instructions[602] = {6'd3, 7'd36, 7'd75, 32'd0};//{'dest': 36, 'src': 75, 'op': 'move'}
    instructions[603] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[604] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[605] = {6'd3, 7'd63, 7'd36, 32'd0};//{'dest': 63, 'src': 36, 'op': 'move'}
    instructions[606] = {6'd1, 7'd62, 7'd0, 32'd341};//{'dest': 62, 'label': 341, 'op': 'jmp_and_link'}
    instructions[607] = {6'd1, 7'd61, 7'd0, 32'd323};//{'dest': 61, 'label': 323, 'op': 'jmp_and_link'}
    instructions[608] = {6'd6, 7'd0, 7'd73, 32'd0};//{'src': 73, 'op': 'jmp_to_reg'}
    instructions[609] = {6'd0, 7'd2, 7'd0, 32'd0};//{'dest': 2, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[610] = {6'd0, 7'd3, 7'd0, 32'd0};//{'dest': 3, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[611] = {6'd0, 7'd4, 7'd0, 32'd0};//{'dest': 4, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[612] = {6'd0, 7'd5, 7'd0, 32'd0};//{'dest': 5, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[613] = {6'd0, 7'd6, 7'd0, 32'd0};//{'dest': 6, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[614] = {6'd0, 7'd7, 7'd0, 32'd132};//{'dest': 7, 'literal': 132, 'op': 'literal'}
    instructions[615] = {6'd0, 7'd31, 7'd0, 32'd0};//{'dest': 31, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[616] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[617] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[618] = {6'd3, 7'd3, 7'd31, 32'd0};//{'dest': 3, 'src': 31, 'op': 'move'}
    instructions[619] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[620] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[621] = {6'd3, 7'd32, 7'd3, 32'd0};//{'dest': 32, 'src': 3, 'op': 'move'}
    instructions[622] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[623] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[624] = {6'd8, 7'd33, 7'd32, 32'd1};//{'dest': 33, 'src': 32, 'srcb': 1, 'signed': False, 'op': '+'}
    instructions[625] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[626] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[627] = {6'd9, 7'd0, 7'd33, 32'd0};//{'element_size': 2, 'src': 33, 'sequence': 139888842168440, 'op': 'memory_read_request'}
    instructions[628] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[629] = {6'd10, 7'd0, 7'd33, 32'd0};//{'element_size': 2, 'src': 33, 'sequence': 139888842168440, 'op': 'memory_read_wait'}
    instructions[630] = {6'd11, 7'd31, 7'd33, 32'd0};//{'dest': 31, 'src': 33, 'sequence': 139888842168440, 'element_size': 2, 'op': 'memory_read'}
    instructions[631] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[632] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[633] = {6'd12, 7'd0, 7'd31, 32'd637};//{'src': 31, 'label': 637, 'op': 'jmp_if_false'}
    instructions[634] = {6'd3, 7'd31, 7'd3, 32'd0};//{'dest': 31, 'src': 3, 'op': 'move'}
    instructions[635] = {6'd13, 7'd3, 7'd3, 32'd1};//{'src': 3, 'right': 1, 'dest': 3, 'signed': False, 'op': '+', 'size': 2}
    instructions[636] = {6'd14, 7'd0, 7'd0, 32'd638};//{'label': 638, 'op': 'goto'}
    instructions[637] = {6'd14, 7'd0, 7'd0, 32'd639};//{'label': 639, 'op': 'goto'}
    instructions[638] = {6'd14, 7'd0, 7'd0, 32'd619};//{'label': 619, 'op': 'goto'}
    instructions[639] = {6'd0, 7'd31, 7'd0, 32'd0};//{'dest': 31, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[640] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[641] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[642] = {6'd3, 7'd2, 7'd31, 32'd0};//{'dest': 2, 'src': 31, 'op': 'move'}
    instructions[643] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[644] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[645] = {6'd3, 7'd32, 7'd2, 32'd0};//{'dest': 32, 'src': 2, 'op': 'move'}
    instructions[646] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[647] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[648] = {6'd8, 7'd33, 7'd32, 32'd7};//{'dest': 33, 'src': 32, 'srcb': 7, 'signed': False, 'op': '+'}
    instructions[649] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[650] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[651] = {6'd9, 7'd0, 7'd33, 32'd0};//{'element_size': 2, 'src': 33, 'sequence': 139888842169304, 'op': 'memory_read_request'}
    instructions[652] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[653] = {6'd10, 7'd0, 7'd33, 32'd0};//{'element_size': 2, 'src': 33, 'sequence': 139888842169304, 'op': 'memory_read_wait'}
    instructions[654] = {6'd11, 7'd31, 7'd33, 32'd0};//{'dest': 31, 'src': 33, 'sequence': 139888842169304, 'element_size': 2, 'op': 'memory_read'}
    instructions[655] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[656] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[657] = {6'd12, 7'd0, 7'd31, 32'd661};//{'src': 31, 'label': 661, 'op': 'jmp_if_false'}
    instructions[658] = {6'd3, 7'd31, 7'd2, 32'd0};//{'dest': 31, 'src': 2, 'op': 'move'}
    instructions[659] = {6'd13, 7'd2, 7'd2, 32'd1};//{'src': 2, 'right': 1, 'dest': 2, 'signed': False, 'op': '+', 'size': 2}
    instructions[660] = {6'd14, 7'd0, 7'd0, 32'd662};//{'label': 662, 'op': 'goto'}
    instructions[661] = {6'd14, 7'd0, 7'd0, 32'd663};//{'label': 663, 'op': 'goto'}
    instructions[662] = {6'd14, 7'd0, 7'd0, 32'd643};//{'label': 643, 'op': 'goto'}
    instructions[663] = {6'd3, 7'd32, 7'd2, 32'd0};//{'dest': 32, 'src': 2, 'op': 'move'}
    instructions[664] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[665] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[666] = {6'd13, 7'd31, 7'd32, 32'd5};//{'src': 32, 'right': 5, 'dest': 31, 'signed': False, 'op': '+', 'type': 'int', 'size': 2}
    instructions[667] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[668] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[669] = {6'd3, 7'd4, 7'd31, 32'd0};//{'dest': 4, 'src': 31, 'op': 'move'}
    instructions[670] = {6'd3, 7'd32, 7'd3, 32'd0};//{'dest': 32, 'src': 3, 'op': 'move'}
    instructions[671] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[672] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[673] = {6'd25, 7'd31, 7'd32, 32'd9};//{'src': 32, 'right': 9, 'dest': 31, 'signed': False, 'op': '>', 'type': 'int', 'size': 2}
    instructions[674] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[675] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[676] = {6'd12, 7'd0, 7'd31, 32'd680};//{'src': 31, 'label': 680, 'op': 'jmp_if_false'}
    instructions[677] = {6'd3, 7'd31, 7'd4, 32'd0};//{'dest': 31, 'src': 4, 'op': 'move'}
    instructions[678] = {6'd13, 7'd4, 7'd4, 32'd1};//{'src': 4, 'right': 1, 'dest': 4, 'signed': False, 'op': '+', 'size': 2}
    instructions[679] = {6'd14, 7'd0, 7'd0, 32'd680};//{'label': 680, 'op': 'goto'}
    instructions[680] = {6'd3, 7'd32, 7'd3, 32'd0};//{'dest': 32, 'src': 3, 'op': 'move'}
    instructions[681] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[682] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[683] = {6'd25, 7'd31, 7'd32, 32'd99};//{'src': 32, 'right': 99, 'dest': 31, 'signed': False, 'op': '>', 'type': 'int', 'size': 2}
    instructions[684] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[685] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[686] = {6'd12, 7'd0, 7'd31, 32'd690};//{'src': 31, 'label': 690, 'op': 'jmp_if_false'}
    instructions[687] = {6'd3, 7'd31, 7'd4, 32'd0};//{'dest': 31, 'src': 4, 'op': 'move'}
    instructions[688] = {6'd13, 7'd4, 7'd4, 32'd1};//{'src': 4, 'right': 1, 'dest': 4, 'signed': False, 'op': '+', 'size': 2}
    instructions[689] = {6'd14, 7'd0, 7'd0, 32'd690};//{'label': 690, 'op': 'goto'}
    instructions[690] = {6'd3, 7'd32, 7'd3, 32'd0};//{'dest': 32, 'src': 3, 'op': 'move'}
    instructions[691] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[692] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[693] = {6'd25, 7'd31, 7'd32, 32'd999};//{'src': 32, 'right': 999, 'dest': 31, 'signed': False, 'op': '>', 'type': 'int', 'size': 2}
    instructions[694] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[695] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[696] = {6'd12, 7'd0, 7'd31, 32'd700};//{'src': 31, 'label': 700, 'op': 'jmp_if_false'}
    instructions[697] = {6'd3, 7'd31, 7'd4, 32'd0};//{'dest': 31, 'src': 4, 'op': 'move'}
    instructions[698] = {6'd13, 7'd4, 7'd4, 32'd1};//{'src': 4, 'right': 1, 'dest': 4, 'signed': False, 'op': '+', 'size': 2}
    instructions[699] = {6'd14, 7'd0, 7'd0, 32'd700};//{'label': 700, 'op': 'goto'}
    instructions[700] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[701] = {6'd3, 7'd32, 7'd4, 32'd0};//{'dest': 32, 'src': 4, 'op': 'move'}
    instructions[702] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[703] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[704] = {6'd3, 7'd45, 7'd32, 32'd0};//{'dest': 45, 'src': 32, 'op': 'move'}
    instructions[705] = {6'd1, 7'd44, 7'd0, 32'd4};//{'dest': 44, 'label': 4, 'op': 'jmp_and_link'}
    instructions[706] = {6'd3, 7'd37, 7'd7, 32'd0};//{'dest': 37, 'src': 7, 'op': 'move'}
    instructions[707] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[708] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[709] = {6'd3, 7'd63, 7'd37, 32'd0};//{'dest': 63, 'src': 37, 'op': 'move'}
    instructions[710] = {6'd1, 7'd62, 7'd0, 32'd341};//{'dest': 62, 'label': 341, 'op': 'jmp_and_link'}
    instructions[711] = {6'd3, 7'd32, 7'd3, 32'd0};//{'dest': 32, 'src': 3, 'op': 'move'}
    instructions[712] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[713] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[714] = {6'd3, 7'd66, 7'd32, 32'd0};//{'dest': 66, 'src': 32, 'op': 'move'}
    instructions[715] = {6'd1, 7'd65, 7'd0, 32'd377};//{'dest': 65, 'label': 377, 'op': 'jmp_and_link'}
    instructions[716] = {6'd0, 7'd8, 7'd0, 32'd246};//{'dest': 8, 'literal': 246, 'op': 'literal'}
    instructions[717] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[718] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[719] = {6'd3, 7'd38, 7'd8, 32'd0};//{'dest': 38, 'src': 8, 'op': 'move'}
    instructions[720] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[721] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[722] = {6'd3, 7'd63, 7'd38, 32'd0};//{'dest': 63, 'src': 38, 'op': 'move'}
    instructions[723] = {6'd1, 7'd62, 7'd0, 32'd341};//{'dest': 62, 'label': 341, 'op': 'jmp_and_link'}
    instructions[724] = {6'd1, 7'd61, 7'd0, 32'd323};//{'dest': 61, 'label': 323, 'op': 'jmp_and_link'}
    instructions[725] = {6'd3, 7'd31, 7'd3, 32'd0};//{'dest': 31, 'src': 3, 'op': 'move'}
    instructions[726] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[727] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[728] = {6'd3, 7'd4, 7'd31, 32'd0};//{'dest': 4, 'src': 31, 'op': 'move'}
    instructions[729] = {6'd0, 7'd31, 7'd0, 32'd0};//{'dest': 31, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[730] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[731] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[732] = {6'd3, 7'd5, 7'd31, 32'd0};//{'dest': 5, 'src': 31, 'op': 'move'}
    instructions[733] = {6'd0, 7'd31, 7'd0, 32'd0};//{'dest': 31, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[734] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[735] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[736] = {6'd3, 7'd6, 7'd31, 32'd0};//{'dest': 6, 'src': 31, 'op': 'move'}
    instructions[737] = {6'd3, 7'd32, 7'd4, 32'd0};//{'dest': 32, 'src': 4, 'op': 'move'}
    instructions[738] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[739] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[740] = {6'd15, 7'd31, 7'd32, 32'd1046};//{'src': 32, 'right': 1046, 'dest': 31, 'signed': False, 'op': '>=', 'type': 'int', 'size': 2}
    instructions[741] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[742] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[743] = {6'd12, 7'd0, 7'd31, 32'd790};//{'src': 31, 'label': 790, 'op': 'jmp_if_false'}
    instructions[744] = {6'd3, 7'd32, 7'd4, 32'd0};//{'dest': 32, 'src': 4, 'op': 'move'}
    instructions[745] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[746] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[747] = {6'd16, 7'd31, 7'd32, 32'd1046};//{'src': 32, 'right': 1046, 'dest': 31, 'signed': False, 'op': '-', 'type': 'int', 'size': 2}
    instructions[748] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[749] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[750] = {6'd3, 7'd4, 7'd31, 32'd0};//{'dest': 4, 'src': 31, 'op': 'move'}
    instructions[751] = {6'd0, 7'd32, 7'd0, 32'd1046};//{'dest': 32, 'literal': 1046, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[752] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[753] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[754] = {6'd3, 7'd45, 7'd32, 32'd0};//{'dest': 45, 'src': 32, 'op': 'move'}
    instructions[755] = {6'd1, 7'd44, 7'd0, 32'd4};//{'dest': 44, 'label': 4, 'op': 'jmp_and_link'}
    instructions[756] = {6'd0, 7'd31, 7'd0, 32'd0};//{'dest': 31, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[757] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[758] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[759] = {6'd3, 7'd6, 7'd31, 32'd0};//{'dest': 6, 'src': 31, 'op': 'move'}
    instructions[760] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[761] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[762] = {6'd3, 7'd32, 7'd6, 32'd0};//{'dest': 32, 'src': 6, 'op': 'move'}
    instructions[763] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[764] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[765] = {6'd26, 7'd31, 7'd32, 32'd1046};//{'src': 32, 'right': 1046, 'dest': 31, 'signed': False, 'op': '<', 'type': 'int', 'size': 2}
    instructions[766] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[767] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[768] = {6'd12, 7'd0, 7'd31, 32'd788};//{'src': 31, 'label': 788, 'op': 'jmp_if_false'}
    instructions[769] = {6'd3, 7'd33, 7'd5, 32'd0};//{'dest': 33, 'src': 5, 'op': 'move'}
    instructions[770] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[771] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[772] = {6'd8, 7'd35, 7'd33, 32'd1};//{'dest': 35, 'src': 33, 'srcb': 1, 'signed': False, 'op': '+'}
    instructions[773] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[774] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[775] = {6'd9, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888842209400, 'op': 'memory_read_request'}
    instructions[776] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[777] = {6'd10, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888842209400, 'op': 'memory_read_wait'}
    instructions[778] = {6'd11, 7'd32, 7'd35, 32'd0};//{'dest': 32, 'src': 35, 'sequence': 139888842209400, 'element_size': 2, 'op': 'memory_read'}
    instructions[779] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[780] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[781] = {6'd3, 7'd60, 7'd32, 32'd0};//{'dest': 60, 'src': 32, 'op': 'move'}
    instructions[782] = {6'd1, 7'd59, 7'd0, 32'd284};//{'dest': 59, 'label': 284, 'op': 'jmp_and_link'}
    instructions[783] = {6'd3, 7'd31, 7'd5, 32'd0};//{'dest': 31, 'src': 5, 'op': 'move'}
    instructions[784] = {6'd13, 7'd5, 7'd5, 32'd1};//{'src': 5, 'right': 1, 'dest': 5, 'signed': False, 'op': '+', 'size': 2}
    instructions[785] = {6'd3, 7'd31, 7'd6, 32'd0};//{'dest': 31, 'src': 6, 'op': 'move'}
    instructions[786] = {6'd13, 7'd6, 7'd6, 32'd1};//{'src': 6, 'right': 1, 'dest': 6, 'signed': False, 'op': '+', 'size': 2}
    instructions[787] = {6'd14, 7'd0, 7'd0, 32'd760};//{'label': 760, 'op': 'goto'}
    instructions[788] = {6'd1, 7'd61, 7'd0, 32'd323};//{'dest': 61, 'label': 323, 'op': 'jmp_and_link'}
    instructions[789] = {6'd14, 7'd0, 7'd0, 32'd791};//{'label': 791, 'op': 'goto'}
    instructions[790] = {6'd14, 7'd0, 7'd0, 32'd792};//{'label': 792, 'op': 'goto'}
    instructions[791] = {6'd14, 7'd0, 7'd0, 32'd737};//{'label': 737, 'op': 'goto'}
    instructions[792] = {6'd3, 7'd32, 7'd4, 32'd0};//{'dest': 32, 'src': 4, 'op': 'move'}
    instructions[793] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[794] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[795] = {6'd3, 7'd45, 7'd32, 32'd0};//{'dest': 45, 'src': 32, 'op': 'move'}
    instructions[796] = {6'd1, 7'd44, 7'd0, 32'd4};//{'dest': 44, 'label': 4, 'op': 'jmp_and_link'}
    instructions[797] = {6'd0, 7'd31, 7'd0, 32'd0};//{'dest': 31, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[798] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[799] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[800] = {6'd3, 7'd6, 7'd31, 32'd0};//{'dest': 6, 'src': 31, 'op': 'move'}
    instructions[801] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[802] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[803] = {6'd3, 7'd32, 7'd6, 32'd0};//{'dest': 32, 'src': 6, 'op': 'move'}
    instructions[804] = {6'd3, 7'd33, 7'd4, 32'd0};//{'dest': 33, 'src': 4, 'op': 'move'}
    instructions[805] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[806] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[807] = {6'd27, 7'd31, 7'd32, 32'd33};//{'srcb': 33, 'src': 32, 'dest': 31, 'signed': False, 'op': '<', 'type': 'int', 'size': 2}
    instructions[808] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[809] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[810] = {6'd12, 7'd0, 7'd31, 32'd830};//{'src': 31, 'label': 830, 'op': 'jmp_if_false'}
    instructions[811] = {6'd3, 7'd33, 7'd5, 32'd0};//{'dest': 33, 'src': 5, 'op': 'move'}
    instructions[812] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[813] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[814] = {6'd8, 7'd35, 7'd33, 32'd1};//{'dest': 35, 'src': 33, 'srcb': 1, 'signed': False, 'op': '+'}
    instructions[815] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[816] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[817] = {6'd9, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888842232104, 'op': 'memory_read_request'}
    instructions[818] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[819] = {6'd10, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888842232104, 'op': 'memory_read_wait'}
    instructions[820] = {6'd11, 7'd32, 7'd35, 32'd0};//{'dest': 32, 'src': 35, 'sequence': 139888842232104, 'element_size': 2, 'op': 'memory_read'}
    instructions[821] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[822] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[823] = {6'd3, 7'd60, 7'd32, 32'd0};//{'dest': 60, 'src': 32, 'op': 'move'}
    instructions[824] = {6'd1, 7'd59, 7'd0, 32'd284};//{'dest': 59, 'label': 284, 'op': 'jmp_and_link'}
    instructions[825] = {6'd3, 7'd31, 7'd5, 32'd0};//{'dest': 31, 'src': 5, 'op': 'move'}
    instructions[826] = {6'd13, 7'd5, 7'd5, 32'd1};//{'src': 5, 'right': 1, 'dest': 5, 'signed': False, 'op': '+', 'size': 2}
    instructions[827] = {6'd3, 7'd31, 7'd6, 32'd0};//{'dest': 31, 'src': 6, 'op': 'move'}
    instructions[828] = {6'd13, 7'd6, 7'd6, 32'd1};//{'src': 6, 'right': 1, 'dest': 6, 'signed': False, 'op': '+', 'size': 2}
    instructions[829] = {6'd14, 7'd0, 7'd0, 32'd801};//{'label': 801, 'op': 'goto'}
    instructions[830] = {6'd1, 7'd61, 7'd0, 32'd323};//{'dest': 61, 'label': 323, 'op': 'jmp_and_link'}
    instructions[831] = {6'd6, 7'd0, 7'd0, 32'd0};//{'src': 0, 'op': 'jmp_to_reg'}
    instructions[832] = {6'd3, 7'd15, 7'd13, 32'd0};//{'dest': 15, 'src': 13, 'op': 'move'}
    instructions[833] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[834] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[835] = {6'd3, 7'd32, 7'd15, 32'd0};//{'dest': 32, 'src': 15, 'op': 'move'}
    instructions[836] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[837] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[838] = {6'd8, 7'd33, 7'd32, 32'd11};//{'dest': 33, 'src': 32, 'srcb': 11, 'signed': False, 'op': '+'}
    instructions[839] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[840] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[841] = {6'd9, 7'd0, 7'd33, 32'd0};//{'element_size': 2, 'src': 33, 'sequence': 139888842198048, 'op': 'memory_read_request'}
    instructions[842] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[843] = {6'd10, 7'd0, 7'd33, 32'd0};//{'element_size': 2, 'src': 33, 'sequence': 139888842198048, 'op': 'memory_read_wait'}
    instructions[844] = {6'd11, 7'd31, 7'd33, 32'd0};//{'dest': 31, 'src': 33, 'sequence': 139888842198048, 'element_size': 2, 'op': 'memory_read'}
    instructions[845] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[846] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[847] = {6'd12, 7'd0, 7'd31, 32'd923};//{'src': 31, 'label': 923, 'op': 'jmp_if_false'}
    instructions[848] = {6'd3, 7'd33, 7'd15, 32'd0};//{'dest': 33, 'src': 15, 'op': 'move'}
    instructions[849] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[850] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[851] = {6'd8, 7'd35, 7'd33, 32'd11};//{'dest': 35, 'src': 33, 'srcb': 11, 'signed': False, 'op': '+'}
    instructions[852] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[853] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[854] = {6'd9, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888842234624, 'op': 'memory_read_request'}
    instructions[855] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[856] = {6'd10, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888842234624, 'op': 'memory_read_wait'}
    instructions[857] = {6'd11, 7'd32, 7'd35, 32'd0};//{'dest': 32, 'src': 35, 'sequence': 139888842234624, 'element_size': 2, 'op': 'memory_read'}
    instructions[858] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[859] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[860] = {6'd3, 7'd56, 7'd32, 32'd0};//{'dest': 56, 'src': 32, 'op': 'move'}
    instructions[861] = {6'd1, 7'd55, 7'd0, 32'd257};//{'dest': 55, 'label': 257, 'op': 'jmp_and_link'}
    instructions[862] = {6'd0, 7'd16, 7'd0, 32'd253};//{'dest': 16, 'literal': 253, 'op': 'literal'}
    instructions[863] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[864] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[865] = {6'd3, 7'd34, 7'd16, 32'd0};//{'dest': 34, 'src': 16, 'op': 'move'}
    instructions[866] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[867] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[868] = {6'd3, 7'd49, 7'd34, 32'd0};//{'dest': 49, 'src': 34, 'op': 'move'}
    instructions[869] = {6'd1, 7'd48, 7'd0, 32'd14};//{'dest': 48, 'label': 14, 'op': 'jmp_and_link'}
    instructions[870] = {6'd3, 7'd32, 7'd15, 32'd0};//{'dest': 32, 'src': 15, 'op': 'move'}
    instructions[871] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[872] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[873] = {6'd3, 7'd56, 7'd32, 32'd0};//{'dest': 56, 'src': 32, 'op': 'move'}
    instructions[874] = {6'd1, 7'd55, 7'd0, 32'd257};//{'dest': 55, 'label': 257, 'op': 'jmp_and_link'}
    instructions[875] = {6'd0, 7'd17, 7'd0, 32'd255};//{'dest': 17, 'literal': 255, 'op': 'literal'}
    instructions[876] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[877] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[878] = {6'd3, 7'd34, 7'd17, 32'd0};//{'dest': 34, 'src': 17, 'op': 'move'}
    instructions[879] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[880] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[881] = {6'd3, 7'd49, 7'd34, 32'd0};//{'dest': 49, 'src': 34, 'op': 'move'}
    instructions[882] = {6'd1, 7'd48, 7'd0, 32'd14};//{'dest': 48, 'label': 14, 'op': 'jmp_and_link'}
    instructions[883] = {6'd3, 7'd32, 7'd15, 32'd0};//{'dest': 32, 'src': 15, 'op': 'move'}
    instructions[884] = {6'd3, 7'd33, 7'd14, 32'd0};//{'dest': 33, 'src': 14, 'op': 'move'}
    instructions[885] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[886] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[887] = {6'd28, 7'd31, 7'd32, 32'd33};//{'srcb': 33, 'src': 32, 'dest': 31, 'signed': False, 'op': '==', 'type': 'int', 'size': 2}
    instructions[888] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[889] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[890] = {6'd12, 7'd0, 7'd31, 32'd897};//{'src': 31, 'label': 897, 'op': 'jmp_if_false'}
    instructions[891] = {6'd0, 7'd31, 7'd0, -32'd1};//{'dest': 31, 'literal': -1, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[892] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[893] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[894] = {6'd3, 7'd10, 7'd31, 32'd0};//{'dest': 10, 'src': 31, 'op': 'move'}
    instructions[895] = {6'd6, 7'd0, 7'd9, 32'd0};//{'src': 9, 'op': 'jmp_to_reg'}
    instructions[896] = {6'd14, 7'd0, 7'd0, 32'd897};//{'label': 897, 'op': 'goto'}
    instructions[897] = {6'd3, 7'd33, 7'd15, 32'd0};//{'dest': 33, 'src': 15, 'op': 'move'}
    instructions[898] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[899] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[900] = {6'd8, 7'd35, 7'd33, 32'd11};//{'dest': 35, 'src': 33, 'srcb': 11, 'signed': False, 'op': '+'}
    instructions[901] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[902] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[903] = {6'd9, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888842233616, 'op': 'memory_read_request'}
    instructions[904] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[905] = {6'd10, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888842233616, 'op': 'memory_read_wait'}
    instructions[906] = {6'd11, 7'd32, 7'd35, 32'd0};//{'dest': 32, 'src': 35, 'sequence': 139888842233616, 'element_size': 2, 'op': 'memory_read'}
    instructions[907] = {6'd3, 7'd33, 7'd12, 32'd0};//{'dest': 33, 'src': 12, 'op': 'move'}
    instructions[908] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[909] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[910] = {6'd28, 7'd31, 7'd32, 32'd33};//{'srcb': 33, 'src': 32, 'dest': 31, 'signed': False, 'op': '==', 'type': 'int', 'size': 2}
    instructions[911] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[912] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[913] = {6'd12, 7'd0, 7'd31, 32'd920};//{'src': 31, 'label': 920, 'op': 'jmp_if_false'}
    instructions[914] = {6'd3, 7'd31, 7'd15, 32'd0};//{'dest': 31, 'src': 15, 'op': 'move'}
    instructions[915] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[916] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[917] = {6'd3, 7'd10, 7'd31, 32'd0};//{'dest': 10, 'src': 31, 'op': 'move'}
    instructions[918] = {6'd6, 7'd0, 7'd9, 32'd0};//{'src': 9, 'op': 'jmp_to_reg'}
    instructions[919] = {6'd14, 7'd0, 7'd0, 32'd920};//{'label': 920, 'op': 'goto'}
    instructions[920] = {6'd3, 7'd31, 7'd15, 32'd0};//{'dest': 31, 'src': 15, 'op': 'move'}
    instructions[921] = {6'd29, 7'd15, 7'd15, 32'd1};//{'src': 15, 'right': 1, 'dest': 15, 'signed': True, 'op': '+', 'size': 2}
    instructions[922] = {6'd14, 7'd0, 7'd0, 32'd924};//{'label': 924, 'op': 'goto'}
    instructions[923] = {6'd14, 7'd0, 7'd0, 32'd925};//{'label': 925, 'op': 'goto'}
    instructions[924] = {6'd14, 7'd0, 7'd0, 32'd833};//{'label': 833, 'op': 'goto'}
    instructions[925] = {6'd0, 7'd31, 7'd0, -32'd1};//{'dest': 31, 'literal': -1, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[926] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[927] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[928] = {6'd3, 7'd10, 7'd31, 32'd0};//{'dest': 10, 'src': 31, 'op': 'move'}
    instructions[929] = {6'd6, 7'd0, 7'd9, 32'd0};//{'src': 9, 'op': 'jmp_to_reg'}
    instructions[930] = {6'd0, 7'd19, 7'd0, 32'd0};//{'dest': 19, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[931] = {6'd0, 7'd20, 7'd0, 32'd0};//{'dest': 20, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[932] = {6'd0, 7'd21, 7'd0, 32'd0};//{'dest': 21, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[933] = {6'd0, 7'd22, 7'd0, 32'd257};//{'dest': 22, 'literal': 257, 'op': 'literal'}
    instructions[934] = {6'd0, 7'd23, 7'd0, 32'd0};//{'dest': 23, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[935] = {6'd0, 7'd24, 7'd0, 32'd0};//{'dest': 24, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[936] = {6'd0, 7'd25, 7'd0, 32'd0};//{'dest': 25, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[937] = {6'd0, 7'd26, 7'd0, 32'd0};//{'dest': 26, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[938] = {6'd0, 7'd27, 7'd0, 32'd0};//{'dest': 27, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[939] = {6'd0, 7'd28, 7'd0, 32'd1717};//{'dest': 28, 'literal': 1717, 'op': 'literal'}
    instructions[940] = {6'd0, 7'd29, 7'd0, 32'd2449};//{'dest': 29, 'literal': 2449, 'op': 'literal'}
    instructions[941] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[942] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[943] = {6'd3, 7'd39, 7'd29, 32'd0};//{'dest': 39, 'src': 29, 'op': 'move'}
    instructions[944] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[945] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[946] = {6'd3, 7'd49, 7'd39, 32'd0};//{'dest': 49, 'src': 39, 'op': 'move'}
    instructions[947] = {6'd1, 7'd48, 7'd0, 32'd14};//{'dest': 48, 'label': 14, 'op': 'jmp_and_link'}
    instructions[948] = {6'd0, 7'd30, 7'd0, 32'd2489};//{'dest': 30, 'literal': 2489, 'op': 'literal'}
    instructions[949] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[950] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[951] = {6'd3, 7'd40, 7'd30, 32'd0};//{'dest': 40, 'src': 30, 'op': 'move'}
    instructions[952] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[953] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[954] = {6'd3, 7'd49, 7'd40, 32'd0};//{'dest': 49, 'src': 40, 'op': 'move'}
    instructions[955] = {6'd1, 7'd48, 7'd0, 32'd14};//{'dest': 48, 'label': 14, 'op': 'jmp_and_link'}
    instructions[956] = {6'd30, 7'd31, 7'd0, 32'd0};//{'dest': 31, 'input': 'socket', 'op': 'read'}
    instructions[957] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[958] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[959] = {6'd3, 7'd19, 7'd31, 32'd0};//{'dest': 19, 'src': 31, 'op': 'move'}
    instructions[960] = {6'd0, 7'd31, 7'd0, 32'd0};//{'dest': 31, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[961] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[962] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[963] = {6'd3, 7'd21, 7'd31, 32'd0};//{'dest': 21, 'src': 31, 'op': 'move'}
    instructions[964] = {6'd0, 7'd31, 7'd0, 32'd0};//{'dest': 31, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[965] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[966] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[967] = {6'd3, 7'd20, 7'd31, 32'd0};//{'dest': 20, 'src': 31, 'op': 'move'}
    instructions[968] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[969] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[970] = {6'd3, 7'd32, 7'd20, 32'd0};//{'dest': 32, 'src': 20, 'op': 'move'}
    instructions[971] = {6'd3, 7'd33, 7'd19, 32'd0};//{'dest': 33, 'src': 19, 'op': 'move'}
    instructions[972] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[973] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[974] = {6'd27, 7'd31, 7'd32, 32'd33};//{'srcb': 33, 'src': 32, 'dest': 31, 'signed': False, 'op': '<', 'type': 'int', 'size': 2}
    instructions[975] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[976] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[977] = {6'd12, 7'd0, 7'd31, 32'd1021};//{'src': 31, 'label': 1021, 'op': 'jmp_if_false'}
    instructions[978] = {6'd30, 7'd31, 7'd0, 32'd0};//{'dest': 31, 'input': 'socket', 'op': 'read'}
    instructions[979] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[980] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[981] = {6'd3, 7'd23, 7'd31, 32'd0};//{'dest': 23, 'src': 31, 'op': 'move'}
    instructions[982] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[983] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[984] = {6'd3, 7'd41, 7'd23, 32'd0};//{'dest': 41, 'src': 23, 'op': 'move'}
    instructions[985] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[986] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[987] = {6'd31, 7'd35, 7'd41, 32'd8};//{'src': 41, 'right': 8, 'dest': 35, 'signed': False, 'op': '>>', 'type': 'int', 'size': 2}
    instructions[988] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[989] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[990] = {6'd32, 7'd31, 7'd35, 32'd255};//{'src': 35, 'right': 255, 'dest': 31, 'signed': False, 'op': '&', 'type': 'int', 'size': 2}
    instructions[991] = {6'd3, 7'd32, 7'd21, 32'd0};//{'dest': 32, 'src': 21, 'op': 'move'}
    instructions[992] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[993] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[994] = {6'd8, 7'd33, 7'd32, 32'd22};//{'dest': 33, 'src': 32, 'srcb': 22, 'signed': False, 'op': '+'}
    instructions[995] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[996] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[997] = {6'd33, 7'd0, 7'd33, 32'd31};//{'srcb': 31, 'src': 33, 'element_size': 2, 'op': 'memory_write'}
    instructions[998] = {6'd3, 7'd31, 7'd21, 32'd0};//{'dest': 31, 'src': 21, 'op': 'move'}
    instructions[999] = {6'd13, 7'd21, 7'd21, 32'd1};//{'src': 21, 'right': 1, 'dest': 21, 'signed': False, 'op': '+', 'size': 2}
    instructions[1000] = {6'd3, 7'd35, 7'd23, 32'd0};//{'dest': 35, 'src': 23, 'op': 'move'}
    instructions[1001] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1002] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1003] = {6'd32, 7'd31, 7'd35, 32'd255};//{'src': 35, 'right': 255, 'dest': 31, 'signed': False, 'op': '&', 'type': 'int', 'size': 2}
    instructions[1004] = {6'd3, 7'd32, 7'd21, 32'd0};//{'dest': 32, 'src': 21, 'op': 'move'}
    instructions[1005] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1006] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1007] = {6'd8, 7'd33, 7'd32, 32'd22};//{'dest': 33, 'src': 32, 'srcb': 22, 'signed': False, 'op': '+'}
    instructions[1008] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1009] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1010] = {6'd33, 7'd0, 7'd33, 32'd31};//{'srcb': 31, 'src': 33, 'element_size': 2, 'op': 'memory_write'}
    instructions[1011] = {6'd3, 7'd31, 7'd21, 32'd0};//{'dest': 31, 'src': 21, 'op': 'move'}
    instructions[1012] = {6'd13, 7'd21, 7'd21, 32'd1};//{'src': 21, 'right': 1, 'dest': 21, 'signed': False, 'op': '+', 'size': 2}
    instructions[1013] = {6'd3, 7'd32, 7'd20, 32'd0};//{'dest': 32, 'src': 20, 'op': 'move'}
    instructions[1014] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1015] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1016] = {6'd13, 7'd31, 7'd32, 32'd2};//{'src': 32, 'right': 2, 'dest': 31, 'signed': False, 'op': '+', 'type': 'int', 'size': 2}
    instructions[1017] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1018] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1019] = {6'd3, 7'd20, 7'd31, 32'd0};//{'dest': 20, 'src': 31, 'op': 'move'}
    instructions[1020] = {6'd14, 7'd0, 7'd0, 32'd968};//{'label': 968, 'op': 'goto'}
    instructions[1021] = {6'd0, 7'd33, 7'd0, 32'd0};//{'dest': 33, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[1022] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1023] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1024] = {6'd8, 7'd35, 7'd33, 32'd22};//{'dest': 35, 'src': 33, 'srcb': 22, 'signed': False, 'op': '+'}
    instructions[1025] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1026] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1027] = {6'd9, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888842278024, 'op': 'memory_read_request'}
    instructions[1028] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1029] = {6'd10, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888842278024, 'op': 'memory_read_wait'}
    instructions[1030] = {6'd11, 7'd32, 7'd35, 32'd0};//{'dest': 32, 'src': 35, 'sequence': 139888842278024, 'element_size': 2, 'op': 'memory_read'}
    instructions[1031] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1032] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1033] = {6'd23, 7'd31, 7'd32, 32'd71};//{'src': 32, 'right': 71, 'dest': 31, 'signed': False, 'op': '==', 'type': 'int', 'size': 2}
    instructions[1034] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1035] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1036] = {6'd12, 7'd0, 7'd31, 32'd1050};//{'src': 31, 'label': 1050, 'op': 'jmp_if_false'}
    instructions[1037] = {6'd0, 7'd33, 7'd0, 32'd1};//{'dest': 33, 'literal': 1, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[1038] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1039] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1040] = {6'd8, 7'd35, 7'd33, 32'd22};//{'dest': 35, 'src': 33, 'srcb': 22, 'signed': False, 'op': '+'}
    instructions[1041] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1042] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1043] = {6'd9, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888842278312, 'op': 'memory_read_request'}
    instructions[1044] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1045] = {6'd10, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888842278312, 'op': 'memory_read_wait'}
    instructions[1046] = {6'd11, 7'd32, 7'd35, 32'd0};//{'dest': 32, 'src': 35, 'sequence': 139888842278312, 'element_size': 2, 'op': 'memory_read'}
    instructions[1047] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1048] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1049] = {6'd23, 7'd31, 7'd32, 32'd69};//{'src': 32, 'right': 69, 'dest': 31, 'signed': False, 'op': '==', 'type': 'int', 'size': 2}
    instructions[1050] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1051] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1052] = {6'd12, 7'd0, 7'd31, 32'd1066};//{'src': 31, 'label': 1066, 'op': 'jmp_if_false'}
    instructions[1053] = {6'd0, 7'd33, 7'd0, 32'd2};//{'dest': 33, 'literal': 2, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[1054] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1055] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1056] = {6'd8, 7'd35, 7'd33, 32'd22};//{'dest': 35, 'src': 33, 'srcb': 22, 'signed': False, 'op': '+'}
    instructions[1057] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1058] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1059] = {6'd9, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888842278672, 'op': 'memory_read_request'}
    instructions[1060] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1061] = {6'd10, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888842278672, 'op': 'memory_read_wait'}
    instructions[1062] = {6'd11, 7'd32, 7'd35, 32'd0};//{'dest': 32, 'src': 35, 'sequence': 139888842278672, 'element_size': 2, 'op': 'memory_read'}
    instructions[1063] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1064] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1065] = {6'd23, 7'd31, 7'd32, 32'd84};//{'src': 32, 'right': 84, 'dest': 31, 'signed': False, 'op': '==', 'type': 'int', 'size': 2}
    instructions[1066] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1067] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1068] = {6'd12, 7'd0, 7'd31, 32'd1082};//{'src': 31, 'label': 1082, 'op': 'jmp_if_false'}
    instructions[1069] = {6'd0, 7'd33, 7'd0, 32'd3};//{'dest': 33, 'literal': 3, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[1070] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1071] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1072] = {6'd8, 7'd35, 7'd33, 32'd22};//{'dest': 35, 'src': 33, 'srcb': 22, 'signed': False, 'op': '+'}
    instructions[1073] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1074] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1075] = {6'd9, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888842279032, 'op': 'memory_read_request'}
    instructions[1076] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1077] = {6'd10, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888842279032, 'op': 'memory_read_wait'}
    instructions[1078] = {6'd11, 7'd32, 7'd35, 32'd0};//{'dest': 32, 'src': 35, 'sequence': 139888842279032, 'element_size': 2, 'op': 'memory_read'}
    instructions[1079] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1080] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1081] = {6'd23, 7'd31, 7'd32, 32'd32};//{'src': 32, 'right': 32, 'dest': 31, 'signed': False, 'op': '==', 'type': 'int', 'size': 2}
    instructions[1082] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1083] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1084] = {6'd12, 7'd0, 7'd31, 32'd1098};//{'src': 31, 'label': 1098, 'op': 'jmp_if_false'}
    instructions[1085] = {6'd0, 7'd33, 7'd0, 32'd4};//{'dest': 33, 'literal': 4, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[1086] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1087] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1088] = {6'd8, 7'd35, 7'd33, 32'd22};//{'dest': 35, 'src': 33, 'srcb': 22, 'signed': False, 'op': '+'}
    instructions[1089] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1090] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1091] = {6'd9, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888842279392, 'op': 'memory_read_request'}
    instructions[1092] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1093] = {6'd10, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888842279392, 'op': 'memory_read_wait'}
    instructions[1094] = {6'd11, 7'd32, 7'd35, 32'd0};//{'dest': 32, 'src': 35, 'sequence': 139888842279392, 'element_size': 2, 'op': 'memory_read'}
    instructions[1095] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1096] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1097] = {6'd23, 7'd31, 7'd32, 32'd47};//{'src': 32, 'right': 47, 'dest': 31, 'signed': False, 'op': '==', 'type': 'int', 'size': 2}
    instructions[1098] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1099] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1100] = {6'd12, 7'd0, 7'd31, 32'd1130};//{'src': 31, 'label': 1130, 'op': 'jmp_if_false'}
    instructions[1101] = {6'd0, 7'd33, 7'd0, 32'd5};//{'dest': 33, 'literal': 5, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[1102] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1103] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1104] = {6'd8, 7'd35, 7'd33, 32'd22};//{'dest': 35, 'src': 33, 'srcb': 22, 'signed': False, 'op': '+'}
    instructions[1105] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1106] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1107] = {6'd9, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888884214744, 'op': 'memory_read_request'}
    instructions[1108] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1109] = {6'd10, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888884214744, 'op': 'memory_read_wait'}
    instructions[1110] = {6'd11, 7'd32, 7'd35, 32'd0};//{'dest': 32, 'src': 35, 'sequence': 139888884214744, 'element_size': 2, 'op': 'memory_read'}
    instructions[1111] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1112] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1113] = {6'd23, 7'd31, 7'd32, 32'd63};//{'src': 32, 'right': 63, 'dest': 31, 'signed': False, 'op': '==', 'type': 'int', 'size': 2}
    instructions[1114] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1115] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1116] = {6'd34, 7'd0, 7'd31, 32'd1130};//{'src': 31, 'label': 1130, 'op': 'jmp_if_true'}
    instructions[1117] = {6'd0, 7'd33, 7'd0, 32'd5};//{'dest': 33, 'literal': 5, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[1118] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1119] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1120] = {6'd8, 7'd35, 7'd33, 32'd22};//{'dest': 35, 'src': 33, 'srcb': 22, 'signed': False, 'op': '+'}
    instructions[1121] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1122] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1123] = {6'd9, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888884215032, 'op': 'memory_read_request'}
    instructions[1124] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1125] = {6'd10, 7'd0, 7'd35, 32'd0};//{'element_size': 2, 'src': 35, 'sequence': 139888884215032, 'op': 'memory_read_wait'}
    instructions[1126] = {6'd11, 7'd32, 7'd35, 32'd0};//{'dest': 32, 'src': 35, 'sequence': 139888884215032, 'element_size': 2, 'op': 'memory_read'}
    instructions[1127] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1128] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1129] = {6'd23, 7'd31, 7'd32, 32'd32};//{'src': 32, 'right': 32, 'dest': 31, 'signed': False, 'op': '==', 'type': 'int', 'size': 2}
    instructions[1130] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1131] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1132] = {6'd12, 7'd0, 7'd31, 32'd1416};//{'src': 31, 'label': 1416, 'op': 'jmp_if_false'}
    instructions[1133] = {6'd0, 7'd31, 7'd0, 32'd5};//{'dest': 31, 'literal': 5, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[1134] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1135] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1136] = {6'd3, 7'd26, 7'd31, 32'd0};//{'dest': 26, 'src': 31, 'op': 'move'}
    instructions[1137] = {6'd3, 7'd42, 7'd22, 32'd0};//{'dest': 42, 'src': 22, 'op': 'move'}
    instructions[1138] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1139] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1140] = {6'd3, 7'd11, 7'd42, 32'd0};//{'dest': 11, 'src': 42, 'op': 'move'}
    instructions[1141] = {6'd0, 7'd32, 7'd0, 32'd32};//{'dest': 32, 'literal': 32, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[1142] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1143] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1144] = {6'd3, 7'd12, 7'd32, 32'd0};//{'dest': 12, 'src': 32, 'op': 'move'}
    instructions[1145] = {6'd3, 7'd32, 7'd26, 32'd0};//{'dest': 32, 'src': 26, 'op': 'move'}
    instructions[1146] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1147] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1148] = {6'd3, 7'd13, 7'd32, 32'd0};//{'dest': 13, 'src': 32, 'op': 'move'}
    instructions[1149] = {6'd3, 7'd32, 7'd21, 32'd0};//{'dest': 32, 'src': 21, 'op': 'move'}
    instructions[1150] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1151] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1152] = {6'd3, 7'd14, 7'd32, 32'd0};//{'dest': 14, 'src': 32, 'op': 'move'}
    instructions[1153] = {6'd1, 7'd9, 7'd0, 32'd832};//{'dest': 9, 'label': 832, 'op': 'jmp_and_link'}
    instructions[1154] = {6'd3, 7'd31, 7'd10, 32'd0};//{'dest': 31, 'src': 10, 'op': 'move'}
    instructions[1155] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1156] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1157] = {6'd3, 7'd27, 7'd31, 32'd0};//{'dest': 27, 'src': 31, 'op': 'move'}
    instructions[1158] = {6'd0, 7'd31, 7'd0, 32'd0};//{'dest': 31, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[1159] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1160] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1161] = {6'd3, 7'd25, 7'd31, 32'd0};//{'dest': 25, 'src': 31, 'op': 'move'}
    instructions[1162] = {6'd3, 7'd42, 7'd22, 32'd0};//{'dest': 42, 'src': 22, 'op': 'move'}
    instructions[1163] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1164] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1165] = {6'd3, 7'd11, 7'd42, 32'd0};//{'dest': 11, 'src': 42, 'op': 'move'}
    instructions[1166] = {6'd0, 7'd33, 7'd0, 32'd65};//{'dest': 33, 'literal': 65, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[1167] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1168] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1169] = {6'd3, 7'd12, 7'd33, 32'd0};//{'dest': 12, 'src': 33, 'op': 'move'}
    instructions[1170] = {6'd3, 7'd33, 7'd26, 32'd0};//{'dest': 33, 'src': 26, 'op': 'move'}
    instructions[1171] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1172] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1173] = {6'd3, 7'd13, 7'd33, 32'd0};//{'dest': 13, 'src': 33, 'op': 'move'}
    instructions[1174] = {6'd3, 7'd33, 7'd27, 32'd0};//{'dest': 33, 'src': 27, 'op': 'move'}
    instructions[1175] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1176] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1177] = {6'd3, 7'd14, 7'd33, 32'd0};//{'dest': 14, 'src': 33, 'op': 'move'}
    instructions[1178] = {6'd1, 7'd9, 7'd0, 32'd832};//{'dest': 9, 'label': 832, 'op': 'jmp_and_link'}
    instructions[1179] = {6'd3, 7'd32, 7'd10, 32'd0};//{'dest': 32, 'src': 10, 'op': 'move'}
    instructions[1180] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1181] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1182] = {6'd35, 7'd31, 7'd32, -32'd1};//{'src': 32, 'right': -1, 'dest': 31, 'signed': True, 'op': '!=', 'type': 'int', 'size': 2}
    instructions[1183] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1184] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1185] = {6'd12, 7'd0, 7'd31, 32'd1194};//{'src': 31, 'label': 1194, 'op': 'jmp_if_false'}
    instructions[1186] = {6'd3, 7'd32, 7'd25, 32'd0};//{'dest': 32, 'src': 25, 'op': 'move'}
    instructions[1187] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1188] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1189] = {6'd18, 7'd31, 7'd32, 32'd1};//{'src': 32, 'right': 1, 'dest': 31, 'signed': False, 'op': '|', 'type': 'int', 'size': 2}
    instructions[1190] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1191] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1192] = {6'd3, 7'd25, 7'd31, 32'd0};//{'dest': 25, 'src': 31, 'op': 'move'}
    instructions[1193] = {6'd14, 7'd0, 7'd0, 32'd1194};//{'label': 1194, 'op': 'goto'}
    instructions[1194] = {6'd3, 7'd42, 7'd22, 32'd0};//{'dest': 42, 'src': 22, 'op': 'move'}
    instructions[1195] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1196] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1197] = {6'd3, 7'd11, 7'd42, 32'd0};//{'dest': 11, 'src': 42, 'op': 'move'}
    instructions[1198] = {6'd0, 7'd33, 7'd0, 32'd66};//{'dest': 33, 'literal': 66, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[1199] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1200] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1201] = {6'd3, 7'd12, 7'd33, 32'd0};//{'dest': 12, 'src': 33, 'op': 'move'}
    instructions[1202] = {6'd3, 7'd33, 7'd26, 32'd0};//{'dest': 33, 'src': 26, 'op': 'move'}
    instructions[1203] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1204] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1205] = {6'd3, 7'd13, 7'd33, 32'd0};//{'dest': 13, 'src': 33, 'op': 'move'}
    instructions[1206] = {6'd3, 7'd33, 7'd27, 32'd0};//{'dest': 33, 'src': 27, 'op': 'move'}
    instructions[1207] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1208] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1209] = {6'd3, 7'd14, 7'd33, 32'd0};//{'dest': 14, 'src': 33, 'op': 'move'}
    instructions[1210] = {6'd1, 7'd9, 7'd0, 32'd832};//{'dest': 9, 'label': 832, 'op': 'jmp_and_link'}
    instructions[1211] = {6'd3, 7'd32, 7'd10, 32'd0};//{'dest': 32, 'src': 10, 'op': 'move'}
    instructions[1212] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1213] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1214] = {6'd35, 7'd31, 7'd32, -32'd1};//{'src': 32, 'right': -1, 'dest': 31, 'signed': True, 'op': '!=', 'type': 'int', 'size': 2}
    instructions[1215] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1216] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1217] = {6'd12, 7'd0, 7'd31, 32'd1226};//{'src': 31, 'label': 1226, 'op': 'jmp_if_false'}
    instructions[1218] = {6'd3, 7'd32, 7'd25, 32'd0};//{'dest': 32, 'src': 25, 'op': 'move'}
    instructions[1219] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1220] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1221] = {6'd18, 7'd31, 7'd32, 32'd2};//{'src': 32, 'right': 2, 'dest': 31, 'signed': False, 'op': '|', 'type': 'int', 'size': 2}
    instructions[1222] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1223] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1224] = {6'd3, 7'd25, 7'd31, 32'd0};//{'dest': 25, 'src': 31, 'op': 'move'}
    instructions[1225] = {6'd14, 7'd0, 7'd0, 32'd1226};//{'label': 1226, 'op': 'goto'}
    instructions[1226] = {6'd3, 7'd42, 7'd22, 32'd0};//{'dest': 42, 'src': 22, 'op': 'move'}
    instructions[1227] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1228] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1229] = {6'd3, 7'd11, 7'd42, 32'd0};//{'dest': 11, 'src': 42, 'op': 'move'}
    instructions[1230] = {6'd0, 7'd33, 7'd0, 32'd67};//{'dest': 33, 'literal': 67, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[1231] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1232] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1233] = {6'd3, 7'd12, 7'd33, 32'd0};//{'dest': 12, 'src': 33, 'op': 'move'}
    instructions[1234] = {6'd3, 7'd33, 7'd26, 32'd0};//{'dest': 33, 'src': 26, 'op': 'move'}
    instructions[1235] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1236] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1237] = {6'd3, 7'd13, 7'd33, 32'd0};//{'dest': 13, 'src': 33, 'op': 'move'}
    instructions[1238] = {6'd3, 7'd33, 7'd27, 32'd0};//{'dest': 33, 'src': 27, 'op': 'move'}
    instructions[1239] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1240] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1241] = {6'd3, 7'd14, 7'd33, 32'd0};//{'dest': 14, 'src': 33, 'op': 'move'}
    instructions[1242] = {6'd1, 7'd9, 7'd0, 32'd832};//{'dest': 9, 'label': 832, 'op': 'jmp_and_link'}
    instructions[1243] = {6'd3, 7'd32, 7'd10, 32'd0};//{'dest': 32, 'src': 10, 'op': 'move'}
    instructions[1244] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1245] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1246] = {6'd35, 7'd31, 7'd32, -32'd1};//{'src': 32, 'right': -1, 'dest': 31, 'signed': True, 'op': '!=', 'type': 'int', 'size': 2}
    instructions[1247] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1248] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1249] = {6'd12, 7'd0, 7'd31, 32'd1258};//{'src': 31, 'label': 1258, 'op': 'jmp_if_false'}
    instructions[1250] = {6'd3, 7'd32, 7'd25, 32'd0};//{'dest': 32, 'src': 25, 'op': 'move'}
    instructions[1251] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1252] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1253] = {6'd18, 7'd31, 7'd32, 32'd4};//{'src': 32, 'right': 4, 'dest': 31, 'signed': False, 'op': '|', 'type': 'int', 'size': 2}
    instructions[1254] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1255] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1256] = {6'd3, 7'd25, 7'd31, 32'd0};//{'dest': 25, 'src': 31, 'op': 'move'}
    instructions[1257] = {6'd14, 7'd0, 7'd0, 32'd1258};//{'label': 1258, 'op': 'goto'}
    instructions[1258] = {6'd3, 7'd42, 7'd22, 32'd0};//{'dest': 42, 'src': 22, 'op': 'move'}
    instructions[1259] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1260] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1261] = {6'd3, 7'd11, 7'd42, 32'd0};//{'dest': 11, 'src': 42, 'op': 'move'}
    instructions[1262] = {6'd0, 7'd33, 7'd0, 32'd68};//{'dest': 33, 'literal': 68, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[1263] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1264] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1265] = {6'd3, 7'd12, 7'd33, 32'd0};//{'dest': 12, 'src': 33, 'op': 'move'}
    instructions[1266] = {6'd3, 7'd33, 7'd26, 32'd0};//{'dest': 33, 'src': 26, 'op': 'move'}
    instructions[1267] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1268] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1269] = {6'd3, 7'd13, 7'd33, 32'd0};//{'dest': 13, 'src': 33, 'op': 'move'}
    instructions[1270] = {6'd3, 7'd33, 7'd27, 32'd0};//{'dest': 33, 'src': 27, 'op': 'move'}
    instructions[1271] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1272] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1273] = {6'd3, 7'd14, 7'd33, 32'd0};//{'dest': 14, 'src': 33, 'op': 'move'}
    instructions[1274] = {6'd1, 7'd9, 7'd0, 32'd832};//{'dest': 9, 'label': 832, 'op': 'jmp_and_link'}
    instructions[1275] = {6'd3, 7'd32, 7'd10, 32'd0};//{'dest': 32, 'src': 10, 'op': 'move'}
    instructions[1276] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1277] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1278] = {6'd35, 7'd31, 7'd32, -32'd1};//{'src': 32, 'right': -1, 'dest': 31, 'signed': True, 'op': '!=', 'type': 'int', 'size': 2}
    instructions[1279] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1280] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1281] = {6'd12, 7'd0, 7'd31, 32'd1290};//{'src': 31, 'label': 1290, 'op': 'jmp_if_false'}
    instructions[1282] = {6'd3, 7'd32, 7'd25, 32'd0};//{'dest': 32, 'src': 25, 'op': 'move'}
    instructions[1283] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1284] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1285] = {6'd18, 7'd31, 7'd32, 32'd8};//{'src': 32, 'right': 8, 'dest': 31, 'signed': False, 'op': '|', 'type': 'int', 'size': 2}
    instructions[1286] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1287] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1288] = {6'd3, 7'd25, 7'd31, 32'd0};//{'dest': 25, 'src': 31, 'op': 'move'}
    instructions[1289] = {6'd14, 7'd0, 7'd0, 32'd1290};//{'label': 1290, 'op': 'goto'}
    instructions[1290] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1291] = {6'd3, 7'd31, 7'd25, 32'd0};//{'dest': 31, 'src': 25, 'op': 'move'}
    instructions[1292] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1293] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1294] = {6'd36, 7'd0, 7'd31, 32'd0};//{'src': 31, 'output': 'leds', 'op': 'write'}
    instructions[1295] = {6'd37, 7'd31, 7'd0, 32'd0};//{'dest': 31, 'input': 'speed', 'op': 'read'}
    instructions[1296] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1297] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1298] = {6'd3, 7'd24, 7'd31, 32'd0};//{'dest': 24, 'src': 31, 'op': 'move'}
    instructions[1299] = {6'd3, 7'd43, 7'd28, 32'd0};//{'dest': 43, 'src': 28, 'op': 'move'}
    instructions[1300] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1301] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1302] = {6'd3, 7'd11, 7'd43, 32'd0};//{'dest': 11, 'src': 43, 'op': 'move'}
    instructions[1303] = {6'd0, 7'd32, 7'd0, 32'd58};//{'dest': 32, 'literal': 58, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[1304] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1305] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1306] = {6'd3, 7'd12, 7'd32, 32'd0};//{'dest': 12, 'src': 32, 'op': 'move'}
    instructions[1307] = {6'd0, 7'd32, 7'd0, 32'd0};//{'dest': 32, 'literal': 0, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[1308] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1309] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1310] = {6'd3, 7'd13, 7'd32, 32'd0};//{'dest': 13, 'src': 32, 'op': 'move'}
    instructions[1311] = {6'd0, 7'd32, 7'd0, 32'd1460};//{'dest': 32, 'literal': 1460, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[1312] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1313] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1314] = {6'd3, 7'd14, 7'd32, 32'd0};//{'dest': 14, 'src': 32, 'op': 'move'}
    instructions[1315] = {6'd1, 7'd9, 7'd0, 32'd832};//{'dest': 9, 'label': 832, 'op': 'jmp_and_link'}
    instructions[1316] = {6'd3, 7'd31, 7'd10, 32'd0};//{'dest': 31, 'src': 10, 'op': 'move'}
    instructions[1317] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1318] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1319] = {6'd3, 7'd21, 7'd31, 32'd0};//{'dest': 21, 'src': 31, 'op': 'move'}
    instructions[1320] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1321] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1322] = {6'd3, 7'd32, 7'd21, 32'd0};//{'dest': 32, 'src': 21, 'op': 'move'}
    instructions[1323] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1324] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1325] = {6'd13, 7'd31, 7'd32, 32'd4};//{'src': 32, 'right': 4, 'dest': 31, 'signed': False, 'op': '+', 'type': 'int', 'size': 2}
    instructions[1326] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1327] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1328] = {6'd3, 7'd21, 7'd31, 32'd0};//{'dest': 21, 'src': 31, 'op': 'move'}
    instructions[1329] = {6'd3, 7'd32, 7'd24, 32'd0};//{'dest': 32, 'src': 24, 'op': 'move'}
    instructions[1330] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1331] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1332] = {6'd23, 7'd31, 7'd32, 32'd0};//{'src': 32, 'right': 0, 'dest': 31, 'signed': False, 'op': '==', 'type': 'int', 'size': 2}
    instructions[1333] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1334] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1335] = {6'd12, 7'd0, 7'd31, 32'd1356};//{'src': 31, 'label': 1356, 'op': 'jmp_if_false'}
    instructions[1336] = {6'd0, 7'd31, 7'd0, 32'd32};//{'dest': 31, 'literal': 32, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[1337] = {6'd3, 7'd32, 7'd21, 32'd0};//{'dest': 32, 'src': 21, 'op': 'move'}
    instructions[1338] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1339] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1340] = {6'd38, 7'd33, 7'd32, 32'd28};//{'dest': 33, 'src': 32, 'srcb': 28, 'signed': True, 'op': '+'}
    instructions[1341] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1342] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1343] = {6'd33, 7'd0, 7'd33, 32'd31};//{'srcb': 31, 'src': 33, 'element_size': 2, 'op': 'memory_write'}
    instructions[1344] = {6'd3, 7'd31, 7'd21, 32'd0};//{'dest': 31, 'src': 21, 'op': 'move'}
    instructions[1345] = {6'd13, 7'd21, 7'd21, 32'd1};//{'src': 21, 'right': 1, 'dest': 21, 'signed': False, 'op': '+', 'size': 2}
    instructions[1346] = {6'd0, 7'd31, 7'd0, 32'd32};//{'dest': 31, 'literal': 32, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[1347] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1348] = {6'd3, 7'd32, 7'd21, 32'd0};//{'dest': 32, 'src': 21, 'op': 'move'}
    instructions[1349] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1350] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1351] = {6'd38, 7'd33, 7'd32, 32'd28};//{'dest': 33, 'src': 32, 'srcb': 28, 'signed': True, 'op': '+'}
    instructions[1352] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1353] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1354] = {6'd33, 7'd0, 7'd33, 32'd31};//{'srcb': 31, 'src': 33, 'element_size': 2, 'op': 'memory_write'}
    instructions[1355] = {6'd14, 7'd0, 7'd0, 32'd1356};//{'label': 1356, 'op': 'goto'}
    instructions[1356] = {6'd3, 7'd32, 7'd24, 32'd0};//{'dest': 32, 'src': 24, 'op': 'move'}
    instructions[1357] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1358] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1359] = {6'd23, 7'd31, 7'd32, 32'd1};//{'src': 32, 'right': 1, 'dest': 31, 'signed': False, 'op': '==', 'type': 'int', 'size': 2}
    instructions[1360] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1361] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1362] = {6'd12, 7'd0, 7'd31, 32'd1383};//{'src': 31, 'label': 1383, 'op': 'jmp_if_false'}
    instructions[1363] = {6'd0, 7'd31, 7'd0, 32'd48};//{'dest': 31, 'literal': 48, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[1364] = {6'd3, 7'd32, 7'd21, 32'd0};//{'dest': 32, 'src': 21, 'op': 'move'}
    instructions[1365] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1366] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1367] = {6'd38, 7'd33, 7'd32, 32'd28};//{'dest': 33, 'src': 32, 'srcb': 28, 'signed': True, 'op': '+'}
    instructions[1368] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1369] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1370] = {6'd33, 7'd0, 7'd33, 32'd31};//{'srcb': 31, 'src': 33, 'element_size': 2, 'op': 'memory_write'}
    instructions[1371] = {6'd3, 7'd31, 7'd21, 32'd0};//{'dest': 31, 'src': 21, 'op': 'move'}
    instructions[1372] = {6'd13, 7'd21, 7'd21, 32'd1};//{'src': 21, 'right': 1, 'dest': 21, 'signed': False, 'op': '+', 'size': 2}
    instructions[1373] = {6'd0, 7'd31, 7'd0, 32'd32};//{'dest': 31, 'literal': 32, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[1374] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1375] = {6'd3, 7'd32, 7'd21, 32'd0};//{'dest': 32, 'src': 21, 'op': 'move'}
    instructions[1376] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1377] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1378] = {6'd38, 7'd33, 7'd32, 32'd28};//{'dest': 33, 'src': 32, 'srcb': 28, 'signed': True, 'op': '+'}
    instructions[1379] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1380] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1381] = {6'd33, 7'd0, 7'd33, 32'd31};//{'srcb': 31, 'src': 33, 'element_size': 2, 'op': 'memory_write'}
    instructions[1382] = {6'd14, 7'd0, 7'd0, 32'd1383};//{'label': 1383, 'op': 'goto'}
    instructions[1383] = {6'd3, 7'd32, 7'd24, 32'd0};//{'dest': 32, 'src': 24, 'op': 'move'}
    instructions[1384] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1385] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1386] = {6'd23, 7'd31, 7'd32, 32'd2};//{'src': 32, 'right': 2, 'dest': 31, 'signed': False, 'op': '==', 'type': 'int', 'size': 2}
    instructions[1387] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1388] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1389] = {6'd12, 7'd0, 7'd31, 32'd1410};//{'src': 31, 'label': 1410, 'op': 'jmp_if_false'}
    instructions[1390] = {6'd0, 7'd31, 7'd0, 32'd48};//{'dest': 31, 'literal': 48, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[1391] = {6'd3, 7'd32, 7'd21, 32'd0};//{'dest': 32, 'src': 21, 'op': 'move'}
    instructions[1392] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1393] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1394] = {6'd38, 7'd33, 7'd32, 32'd28};//{'dest': 33, 'src': 32, 'srcb': 28, 'signed': True, 'op': '+'}
    instructions[1395] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1396] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1397] = {6'd33, 7'd0, 7'd33, 32'd31};//{'srcb': 31, 'src': 33, 'element_size': 2, 'op': 'memory_write'}
    instructions[1398] = {6'd3, 7'd31, 7'd21, 32'd0};//{'dest': 31, 'src': 21, 'op': 'move'}
    instructions[1399] = {6'd13, 7'd21, 7'd21, 32'd1};//{'src': 21, 'right': 1, 'dest': 21, 'signed': False, 'op': '+', 'size': 2}
    instructions[1400] = {6'd0, 7'd31, 7'd0, 32'd48};//{'dest': 31, 'literal': 48, 'size': 2, 'signed': 2, 'op': 'literal'}
    instructions[1401] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1402] = {6'd3, 7'd32, 7'd21, 32'd0};//{'dest': 32, 'src': 21, 'op': 'move'}
    instructions[1403] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1404] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1405] = {6'd38, 7'd33, 7'd32, 32'd28};//{'dest': 33, 'src': 32, 'srcb': 28, 'signed': True, 'op': '+'}
    instructions[1406] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1407] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1408] = {6'd33, 7'd0, 7'd33, 32'd31};//{'srcb': 31, 'src': 33, 'element_size': 2, 'op': 'memory_write'}
    instructions[1409] = {6'd14, 7'd0, 7'd0, 32'd1410};//{'label': 1410, 'op': 'goto'}
    instructions[1410] = {6'd3, 7'd43, 7'd28, 32'd0};//{'dest': 43, 'src': 28, 'op': 'move'}
    instructions[1411] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1412] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1413] = {6'd3, 7'd1, 7'd43, 32'd0};//{'dest': 1, 'src': 43, 'op': 'move'}
    instructions[1414] = {6'd1, 7'd0, 7'd0, 32'd609};//{'dest': 0, 'label': 609, 'op': 'jmp_and_link'}
    instructions[1415] = {6'd14, 7'd0, 7'd0, 32'd1417};//{'label': 1417, 'op': 'goto'}
    instructions[1416] = {6'd1, 7'd73, 7'd0, 32'd571};//{'dest': 73, 'label': 571, 'op': 'jmp_and_link'}
    instructions[1417] = {6'd14, 7'd0, 7'd0, 32'd956};//{'label': 956, 'op': 'goto'}
    instructions[1418] = {6'd39, 7'd31, 7'd0, 32'd0};//{'dest': 31, 'input': 'rs232_rx', 'op': 'read'}
    instructions[1419] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1420] = {6'd4, 7'd0, 7'd0, 32'd0};//{'op': 'nop'}
    instructions[1421] = {6'd3, 7'd21, 7'd31, 32'd0};//{'dest': 21, 'src': 31, 'op': 'move'}
    instructions[1422] = {6'd6, 7'd0, 7'd18, 32'd0};//{'src': 18, 'op': 'jmp_to_reg'}
  end


  //////////////////////////////////////////////////////////////////////////////
  // CPU IMPLEMENTAION OF C PROCESS                                             
  //                                                                            
  // This section of the file contains a CPU implementing the C process.        
  
  always @(posedge clk)
  begin

    //implement memory for 2 byte x n arrays
    if (memory_enable_2 == 1'b1) begin
      memory_2[address_2] <= data_in_2;
    end
    data_out_2 <= memory_2[address_2];
    memory_enable_2 <= 1'b0;

    write_enable_2 <= 0;
    //stage 0 instruction fetch
    if (stage_0_enable) begin
      stage_1_enable <= 1;
      instruction_0 <= instructions[program_counter];
      opcode_0 = instruction_0[51:46];
      dest_0 = instruction_0[45:39];
      src_0 = instruction_0[38:32];
      srcb_0 = instruction_0[6:0];
      literal_0 = instruction_0[31:0];
      if(write_enable_2) begin
        registers[dest_2] <= result_2;
      end
      program_counter_0 <= program_counter;
      program_counter <= program_counter + 1;
    end

    //stage 1 opcode fetch
    if (stage_1_enable) begin
      stage_2_enable <= 1;
      register_1 <= registers[src_0];
      registerb_1 <= registers[srcb_0];
      dest_1 <= dest_0;
      literal_1 <= literal_0;
      opcode_1 <= opcode_0;
      program_counter_1 <= program_counter_0;
    end

    //stage 2 opcode fetch
    if (stage_2_enable) begin
      dest_2 <= dest_1;
      case(opcode_1)

        16'd0:
        begin
          result_2 <= literal_1;
          write_enable_2 <= 1;
        end

        16'd1:
        begin
          program_counter <= literal_1;
          result_2 <= program_counter_1 + 1;
          write_enable_2 <= 1;
          stage_0_enable <= 1;
          stage_1_enable <= 0;
          stage_2_enable <= 0;
        end

        16'd2:
        begin
          stage_0_enable <= 0;
          stage_1_enable <= 0;
          stage_2_enable <= 0;
        end

        16'd3:
        begin
          result_2 <= register_1;
          write_enable_2 <= 1;
        end

        16'd5:
        begin
          stage_0_enable <= 0;
          stage_1_enable <= 0;
          stage_2_enable <= 0;
          s_output_socket_stb <= 1'b1;
          s_output_socket <= register_1;
        end

        16'd6:
        begin
          program_counter <= register_1;
          stage_0_enable <= 1;
          stage_1_enable <= 0;
          stage_2_enable <= 0;
        end

        16'd7:
        begin
          stage_0_enable <= 0;
          stage_1_enable <= 0;
          stage_2_enable <= 0;
          s_output_rs232_tx_stb <= 1'b1;
          s_output_rs232_tx <= register_1;
        end

        16'd8:
        begin
          result_2 <= $unsigned(register_1) + $unsigned(registerb_1);
          write_enable_2 <= 1;
        end

        16'd9:
        begin
          address_2 <= register_1;
        end

        16'd11:
        begin
          result_2 <= data_out_2;
          write_enable_2 <= 1;
        end

        16'd12:
        begin
          if (register_1 == 0) begin
            program_counter <= literal_1;
            stage_0_enable <= 1;
            stage_1_enable <= 0;
            stage_2_enable <= 0;
          end
        end

        16'd13:
        begin
          result_2 <= $unsigned(register_1) + $unsigned(literal_1);
          write_enable_2 <= 1;
        end

        16'd14:
        begin
          program_counter <= literal_1;
          stage_0_enable <= 1;
          stage_1_enable <= 0;
          stage_2_enable <= 0;
        end

        16'd15:
        begin
          result_2 <= $unsigned(register_1) >= $unsigned(literal_1);
          write_enable_2 <= 1;
        end

        16'd16:
        begin
          result_2 <= $unsigned(register_1) - $unsigned(literal_1);
          write_enable_2 <= 1;
        end

        16'd17:
        begin
          result_2 <= $unsigned(register_1) | $unsigned(registerb_1);
          write_enable_2 <= 1;
        end

        16'd18:
        begin
          result_2 <= $unsigned(register_1) | $unsigned(literal_1);
          write_enable_2 <= 1;
        end

        16'd19:
        begin
          result_2 <= $signed(register_1) >= $signed(literal_1);
          write_enable_2 <= 1;
        end

        16'd20:
        begin
          result_2 <= $signed(literal_1) - $signed(register_1);
          write_enable_2 <= 1;
        end

        16'd21:
        begin
          result_2 <= $signed(register_1) << $signed(literal_1);
          write_enable_2 <= 1;
        end

        16'd22:
        begin
          result_2 <= $signed(register_1) & $signed(literal_1);
          write_enable_2 <= 1;
        end

        16'd23:
        begin
          result_2 <= $unsigned(register_1) == $unsigned(literal_1);
          write_enable_2 <= 1;
        end

        16'd24:
        begin
          result_2 <= $unsigned(literal_1) | $unsigned(register_1);
          write_enable_2 <= 1;
        end

        16'd25:
        begin
          result_2 <= $unsigned(register_1) > $unsigned(literal_1);
          write_enable_2 <= 1;
        end

        16'd26:
        begin
          result_2 <= $unsigned(register_1) < $unsigned(literal_1);
          write_enable_2 <= 1;
        end

        16'd27:
        begin
          result_2 <= $unsigned(register_1) < $unsigned(registerb_1);
          write_enable_2 <= 1;
        end

        16'd28:
        begin
          result_2 <= $unsigned(register_1) == $unsigned(registerb_1);
          write_enable_2 <= 1;
        end

        16'd29:
        begin
          result_2 <= $signed(register_1) + $signed(literal_1);
          write_enable_2 <= 1;
        end

        16'd30:
        begin
          stage_0_enable <= 0;
          stage_1_enable <= 0;
          stage_2_enable <= 0;
          s_input_socket_ack <= 1'b1;
        end

        16'd31:
        begin
          result_2 <= $unsigned(register_1) >> $unsigned(literal_1);
          write_enable_2 <= 1;
        end

        16'd32:
        begin
          result_2 <= $unsigned(register_1) & $unsigned(literal_1);
          write_enable_2 <= 1;
        end

        16'd33:
        begin
          address_2 <= register_1;
          data_in_2 <= registerb_1;
          memory_enable_2 <= 1'b1;
        end

        16'd34:
        begin
          if (register_1 != 0) begin
            program_counter <= literal_1;
            stage_0_enable <= 1;
            stage_1_enable <= 0;
            stage_2_enable <= 0;
          end
        end

        16'd35:
        begin
          result_2 <= $signed(register_1) != $signed(literal_1);
          write_enable_2 <= 1;
        end

        16'd36:
        begin
          stage_0_enable <= 0;
          stage_1_enable <= 0;
          stage_2_enable <= 0;
          s_output_leds_stb <= 1'b1;
          s_output_leds <= register_1;
        end

        16'd37:
        begin
          stage_0_enable <= 0;
          stage_1_enable <= 0;
          stage_2_enable <= 0;
          s_input_speed_ack <= 1'b1;
        end

        16'd38:
        begin
          result_2 <= $signed(register_1) + $signed(registerb_1);
          write_enable_2 <= 1;
        end

        16'd39:
        begin
          stage_0_enable <= 0;
          stage_1_enable <= 0;
          stage_2_enable <= 0;
          s_input_rs232_rx_ack <= 1'b1;
        end

       endcase
    end
     if (s_output_socket_stb == 1'b1 && output_socket_ack == 1'b1) begin
       s_output_socket_stb <= 1'b0;
       stage_0_enable <= 1;
       stage_1_enable <= 1;
       stage_2_enable <= 1;
     end

     if (s_output_rs232_tx_stb == 1'b1 && output_rs232_tx_ack == 1'b1) begin
       s_output_rs232_tx_stb <= 1'b0;
       stage_0_enable <= 1;
       stage_1_enable <= 1;
       stage_2_enable <= 1;
     end

    if (s_input_socket_ack == 1'b1 && input_socket_stb == 1'b1) begin
       result_2 <= input_socket;
       write_enable_2 <= 1;
       s_input_socket_ack <= 1'b0;
       stage_0_enable <= 1;
       stage_1_enable <= 1;
       stage_2_enable <= 1;
     end

     if (s_output_leds_stb == 1'b1 && output_leds_ack == 1'b1) begin
       s_output_leds_stb <= 1'b0;
       stage_0_enable <= 1;
       stage_1_enable <= 1;
       stage_2_enable <= 1;
     end

    if (s_input_speed_ack == 1'b1 && input_speed_stb == 1'b1) begin
       result_2 <= input_speed;
       write_enable_2 <= 1;
       s_input_speed_ack <= 1'b0;
       stage_0_enable <= 1;
       stage_1_enable <= 1;
       stage_2_enable <= 1;
     end

    if (s_input_rs232_rx_ack == 1'b1 && input_rs232_rx_stb == 1'b1) begin
       result_2 <= input_rs232_rx;
       write_enable_2 <= 1;
       s_input_rs232_rx_ack <= 1'b0;
       stage_0_enable <= 1;
       stage_1_enable <= 1;
       stage_2_enable <= 1;
     end

    if (timer == 0) begin
      if (timer_enable) begin
         stage_0_enable <= 1;
         stage_1_enable <= 1;
         stage_2_enable <= 1;
         timer_enable <= 0;
      end
    end else begin
      timer <= timer - 1;
    end

    if (rst == 1'b1) begin
      stage_0_enable <= 1;
      stage_1_enable <= 0;
      stage_2_enable <= 0;
      timer <= 0;
      timer_enable <= 0;
      program_counter <= 0;
      s_input_speed_ack <= 0;
      s_input_socket_ack <= 0;
      s_input_rs232_rx_ack <= 0;
      s_output_rs232_tx_stb <= 0;
      s_output_leds_stb <= 0;
      s_output_socket_stb <= 0;
    end
  end
  assign input_speed_ack = s_input_speed_ack;
  assign input_socket_ack = s_input_socket_ack;
  assign input_rs232_rx_ack = s_input_rs232_rx_ack;
  assign output_rs232_tx_stb = s_output_rs232_tx_stb;
  assign output_rs232_tx = s_output_rs232_tx;
  assign output_leds_stb = s_output_leds_stb;
  assign output_leds = s_output_leds;
  assign output_socket_stb = s_output_socket_stb;
  assign output_socket = s_output_socket;

endmodule
