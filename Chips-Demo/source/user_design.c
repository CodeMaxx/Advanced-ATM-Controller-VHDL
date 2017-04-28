////////////////////////////////////////////////////////////////////////////////
//
//  CHIPS-2.0 USER DESIGN
//
//  :Author: Jonathan P Dawson
//  :Date: 17/10/2013
//  :email: chips@jondawson.org.uk
//  :license: MIT
//  :Copyright: Copyright (C) Jonathan P Dawson 2013
//
//  Simple web app demo.
//
////////////////////////////////////////////////////////////////////////////////

void put_socket(unsigned i){
	output_socket(i);
}
void stdout_put_char(unsigned i){
	output_rs232_tx(i);
}

#include "print.h"
#include "HTTP.h"

int find(unsigned string[], unsigned search, unsigned start, unsigned end){
	int value = start;
	while(string[value]){
	       print_decimal(string[value]); print_string("\n");
	       print_decimal(value); print_string("\n");
	       if(value == end) return -1;
	       if(string[value] == search) return value;
	       value++;
	}
	return -1;
}

void user_design()
{
	//simple echo application
	unsigned length;
	unsigned i, index;
	unsigned data[1460];
	unsigned word;
	unsigned speed = 0;
	unsigned leds = 0;
	unsigned start, end;

	unsigned page[] = 
"<html>\
<head>\
<title>ethernet_mac Chips-2.0 GigaBee Demo</title>\
</head>\
<body>\
<h1>ethernet_mac Chips-2.0 GigaBee Demo</h1>\
<p>Welcome to the ethernet_mac Chips-2.0 GigaBee Demo!</p>\
<p>Link speed: 1000 Mb/s</p>\
<form>\
	<input type=\"checkbox\" name=\"led1\" value=\"A\">led 0</input>\
	<input type=\"checkbox\" name=\"led2\" value=\"B\">led 1</input>\
	<input type=\"checkbox\" name=\"led3\" value=\"C\">led 2</input>\
	<input type=\"checkbox\" name=\"led4\" value=\"D\">led 3</input>\
	<button type=\"submit\" value=\"Submit\">Update LEDs</button>\
</form>\
<p>This <a href=\"https://github.com/pkerling/Chips-Demo\">project</a>\
 is powered by <a href=\"http://pyandchips.org\">Chips-2.0</a> and\
 <a href=\"https://github.com/pkerling/ethernet_mac\">ethernet_mac</a>.</p>\
</body>\
</html>";

	print_string("Welcome to the GigaBee Chips-2.0 demo!\n");
	print_string("Connect your web browser to 192.168.1.1\n");
	while(1){

		length = input_socket();
		index = 0;
		for(i=0;i<length;i+=2){
			word = input_socket();
			data[index] = (word >> 8) & 0xff;
			index++;
			data[index] = (word) & 0xff;
			index++;
		}

		//Get LED values
		//==============

		if(   data[0] == 'G' 
		   && data[1] == 'E' 
		   && data[2] == 'T' 
		   && data[3] == ' ' 
		   && data[4] == '/'
		   && (data[5] == '?' || data[5] == ' ')){
			start=5;
			end=find(data, ' ', start, index);
			leds = 0;
			if(find(data, 'A', start, end) != -1) leds |= 1;
			if(find(data, 'B', start, end) != -1) leds |= 2;
			if(find(data, 'C', start, end) != -1) leds |= 4;
			if(find(data, 'D', start, end) != -1) leds |= 8;
			output_leds(leds);
			
			speed = input_speed();
			//find first ':'
			index = find(page, ':', 0, 1460);
			index+=4;
			//insert speed
			if(speed == 0) {
				// 10 Mb/s: delete two zeroes
				page[index] = ' ';
				index++;
				page[index] = ' ';
			}
			if(speed == 1) {
				// 100 Mb/s: delete one zero
				page[index] = '0';
				index++;
				page[index] = ' ';
			}
			if(speed == 2) {
				// 1000 Mb/s: two zeroes
				page[index] = '0';
				index++;
				page[index] = '0';
			}

			HTTP_OK(page);
		} else {
			HTTP_Not_Found();
		}

	}

        //dummy access to peripherals
	index = input_rs232_rx();
}
