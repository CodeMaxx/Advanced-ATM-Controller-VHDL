ethernet\_mac Demo with Chips-2.0 HTTP server on GigaBee
========================================================

This project is intended to demonstrate the capabilities of the ethernet\_mac tri-mode full-duplex Ethernet MAC. It is based on a demo for the [Chips-2.0] development environment by Jonathan P Dawson. The project targets the Xilinx Spartan 6 device, and more specifically, the [Trenz Electronic GigaBee platform]. The demo implements a TCP/IP socket interface, and a simple web application.

Dependencies
============

You will need:

-   Xilinx ISE 14.7 (webpack edition is free)
-   Python 2.7 or later (but not Python 3)
-   Chips-2.0 (optional, included)
-   ethernet\_mac (included)
-   A Trenz Electronic GigaBee FPGA module (TE0600) and baseboard (TE0603)
-   git

Install
=======

Clone the git repository with git:

    $ git clone https://github.com/pkerling/Chips-Demo.git
    $ cd Chips-Demo
    $ git submodule init
    $ git submodule update

Chips Compile
=============

To compile the C code in chips, issue the following command in the project folder:

    $ make

Alternatively, you can copy the contents of the `precompiled` folder into the `source` folder.

Build in ISE
============

-   Open the project file Chips-Demo.xise in the ISE project navigator
-   Select the root node “xc6slx45-2fgg484” in the hierarchy view
-   Run the “Regenerate All Cores” process under “Design Utilities”
-   Select the “GigaBee” top module in the hierarchy view
-   Run the “Generate Programming File” process
-   Download the generated file GigaBee.bit to the device using iMPACT or any other means

The default project settings are for an Spartan-6 XC6SLX45-2 FPGA. You need to modify them if you have a different device.

Setup and Test
==============

    +----------------+                 +----------------+
    | PC             |                 | TE0603         |
    |                |   POWER =======>o                |
    |                |                 |                |
    |          JTAG  o<===============>o JTAG           |
    |                |                 |                |
    |          ETH0  o<===============>o ETHERNET       |
    |                |                 |                |
    | 192.168.1.0    |                 | 192.168.1.1    |
    +----------------+                 +----------------+

Connect the Ethernet port to the GigaBee baseboard.

Using the script, configure Ethernet port with IP address 192.168.1.0 and subnet mask 255.255.255.0. Turn off TCP Window Scaling and TCP time stamps:

    $ ./configure_network

Verify connection using ping command:

    $ ping 192.168.1.1
    PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
    64 bytes from 192.168.1.1: icmp_req=1 ttl=255 time=0.253 ms
    64 bytes from 192.168.1.1: icmp_req=2 ttl=255 time=0.371 ms
    64 bytes from 192.168.1.1: icmp_req=3 ttl=255 time=0.382 ms
    64 bytes from 192.168.1.1: icmp_req=4 ttl=255 time=0.250 ms
    ^C
    --- 192.168.1.1 ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 3000ms
    rtt min/avg/max/mdev = 0.250/0.314/0.382/0.062 ms

Connect to 192.168.1.1 using your favourite browser.

![image]

  [Chips-2.0]: http://pyandchips.org
  [Trenz Electronic GigaBee platform]: http://www.trenz-electronic.de/products/fpga-boards/trenz-electronic/te0600.html
  [image]: https://raw.github.com/pkerling/Chips-Demo/master/images/screenshot.png
