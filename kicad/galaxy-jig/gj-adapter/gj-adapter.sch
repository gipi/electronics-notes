EESchema Schematic File Version 4
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Analog_Switch:ADG723 U1
U 1 1 5CA05C02
P 5400 2250
F 0 "U1" H 5400 2592 50  0000 C CNN
F 1 "ADG723" H 5400 2501 50  0000 C CNN
F 2 "Package_SO:MSOP-8_3x3mm_P0.65mm" H 5400 2250 50  0001 C CNN
F 3 "" H 5400 2250 50  0001 C CNN
	1    5400 2250
	1    0    0    -1  
$EndComp
$Comp
L Analog_Switch:ADG723 U1
U 2 1 5CA05CA6
P 5400 3100
F 0 "U1" H 5400 3425 50  0000 C CNN
F 1 "ADG723" H 5400 3334 50  0000 C CNN
F 2 "Package_SO:MSOP-8_3x3mm_P0.65mm" H 5400 3100 50  0001 C CNN
F 3 "" H 5400 3100 50  0001 C CNN
	2    5400 3100
	1    0    0    -1  
$EndComp
$Comp
L Analog_Switch:ADG723 U1
U 3 1 5CA05FC0
P 5400 3800
F 0 "U1" H 5579 3834 50  0000 L CNN
F 1 "ADG723" H 5579 3743 50  0000 L CNN
F 2 "Package_SO:MSOP-8_3x3mm_P0.65mm" H 5400 3800 50  0001 C CNN
F 3 "" H 5400 3800 50  0001 C CNN
	3    5400 3800
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_01x05 J1
U 1 1 5CA0619C
P 1850 2450
F 0 "J1" H 1930 2492 50  0000 L CNN
F 1 "Conn_01x05" H 1930 2401 50  0000 L CNN
F 2 "Connector_PinHeader_1.00mm:PinHeader_1x05_P1.00mm_Vertical" H 1850 2450 50  0001 C CNN
F 3 "~" H 1850 2450 50  0001 C CNN
	1    1850 2450
	1    0    0    -1  
$EndComp
Text Notes 2600 1950 2    79   ~ 16
Samsung USB connector
Text GLabel 1550 2650 0    39   Input ~ 0
GND
Wire Wire Line
	1650 2650 1550 2650
Text GLabel 5000 3900 0    39   Input ~ 0
GND
Text GLabel 1550 2550 0    39   UnSpc ~ 0
VCC-device
Wire Wire Line
	1650 2550 1550 2550
Text GLabel 1550 2450 0    39   UnSpc ~ 0
ID-device
Text GLabel 1550 2250 0    39   BiDi ~ 0
D+
Text GLabel 1550 2350 0    39   Input ~ 0
D-
Wire Wire Line
	1550 2250 1650 2250
Wire Wire Line
	1550 2350 1650 2350
Wire Wire Line
	1550 2450 1650 2450
$Comp
L Connector_Generic:Conn_01x04 J2
U 1 1 5CA063DA
P 1300 3800
F 0 "J2" H 1380 3792 50  0000 L CNN
F 1 "Conn_01x04" H 1380 3701 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x04_P2.54mm_Horizontal" H 1300 3800 50  0001 C CNN
F 3 "~" H 1300 3800 50  0001 C CNN
	1    1300 3800
	1    0    0    -1  
$EndComp
Text Notes 1400 3550 2    79   ~ 16
UART
Text GLabel 1000 3700 0    39   Input ~ 0
TX
Text GLabel 1000 3800 0    39   Input ~ 0
RX
Text GLabel 1000 3900 0    39   Input ~ 0
GND
Text GLabel 1000 4000 0    39   Input ~ 0
Mode
Wire Wire Line
	1000 3700 1100 3700
Wire Wire Line
	1000 3800 1100 3800
Wire Wire Line
	1000 3900 1100 3900
Wire Wire Line
	1000 4000 1100 4000
Wire Wire Line
	5000 2250 4800 2250
Wire Wire Line
	4800 2250 4800 2650
Wire Wire Line
	4800 3100 5000 3100
Wire Wire Line
	4800 2650 4500 2650
Connection ~ 4800 2650
Wire Wire Line
	4800 2650 4800 3100
Text GLabel 4500 2650 0    39   BiDi ~ 0
D+
Text GLabel 5800 2150 2    39   Input ~ 0
RX
$Comp
L Connector:USB_B_Micro J3
U 1 1 5CA069E4
P 2400 3950
F 0 "J3" H 2455 4417 50  0000 C CNN
F 1 "USB_B_Micro" H 2455 4326 50  0000 C CNN
F 2 "Connector_USB:USB_Micro-B_Wuerth_629105150521" H 2550 3900 50  0001 C CNN
F 3 "~" H 2550 3900 50  0001 C CNN
	1    2400 3950
	1    0    0    -1  
$EndComp
Text GLabel 2850 3750 2    39   Input ~ 0
VCC
Text GLabel 2850 3950 2    39   BiDi ~ 0
D+-PC
Text GLabel 2850 4050 2    39   BiDi ~ 0
D--PC
Text GLabel 5000 3700 0    39   Input ~ 0
VCC
Wire Wire Line
	2700 3750 2850 3750
Wire Wire Line
	2850 3950 2700 3950
Wire Wire Line
	2850 4050 2700 4050
Wire Wire Line
	2300 4350 2350 4350
Text GLabel 5800 3000 2    39   BiDi ~ 0
D+-PC
Wire Wire Line
	5400 3500 6300 3500
Wire Wire Line
	6300 3500 6300 2650
Wire Wire Line
	6300 2650 5400 2650
Connection ~ 6300 3500
Wire Wire Line
	6300 3500 6700 3500
Text GLabel 6700 3500 2    39   Input ~ 0
Mode
$Comp
L Analog_Switch:ADG723 U3
U 1 1 5CA07C9D
P 8500 2250
F 0 "U3" H 8500 2592 50  0000 C CNN
F 1 "ADG723" H 8500 2501 50  0000 C CNN
F 2 "Package_SO:MSOP-8_3x3mm_P0.65mm" H 8500 2250 50  0001 C CNN
F 3 "" H 8500 2250 50  0001 C CNN
	1    8500 2250
	1    0    0    -1  
$EndComp
$Comp
L Analog_Switch:ADG723 U3
U 2 1 5CA07CA4
P 8500 3100
F 0 "U3" H 8500 3425 50  0000 C CNN
F 1 "ADG723" H 8500 3334 50  0000 C CNN
F 2 "Package_SO:MSOP-8_3x3mm_P0.65mm" H 8500 3100 50  0001 C CNN
F 3 "" H 8500 3100 50  0001 C CNN
	2    8500 3100
	1    0    0    -1  
$EndComp
$Comp
L Analog_Switch:ADG723 U3
U 3 1 5CA07CAB
P 8500 3800
F 0 "U3" H 8679 3834 50  0000 L CNN
F 1 "ADG723" H 8679 3743 50  0000 L CNN
F 2 "Package_SO:MSOP-8_3x3mm_P0.65mm" H 8500 3800 50  0001 C CNN
F 3 "" H 8500 3800 50  0001 C CNN
	3    8500 3800
	1    0    0    -1  
$EndComp
Text GLabel 8100 3900 0    39   Input ~ 0
GND
Wire Wire Line
	8100 2250 7900 2250
Wire Wire Line
	7900 2250 7900 2650
Wire Wire Line
	7900 3100 8100 3100
Wire Wire Line
	7900 2650 7600 2650
Connection ~ 7900 2650
Wire Wire Line
	7900 2650 7900 3100
Text GLabel 7600 2650 0    39   BiDi ~ 0
D-
Text GLabel 8900 2150 2    39   Input ~ 0
TX
Text GLabel 8150 3700 0    39   Input ~ 0
VCC
Text GLabel 8900 3000 2    39   BiDi ~ 0
D--PC
Wire Wire Line
	8500 3500 9400 3500
Wire Wire Line
	9400 3500 9400 2650
Wire Wire Line
	9400 2650 8500 2650
Connection ~ 9400 3500
Wire Wire Line
	9400 3500 9800 3500
Text GLabel 9800 3500 2    39   Input ~ 0
Mode
$Comp
L Analog_Switch:ADG723 U2
U 1 1 5CA08545
P 7050 4600
F 0 "U2" H 7050 4942 50  0000 C CNN
F 1 "ADG723" H 7050 4851 50  0000 C CNN
F 2 "Package_SO:MSOP-8_3x3mm_P0.65mm" H 7050 4600 50  0001 C CNN
F 3 "" H 7050 4600 50  0001 C CNN
	1    7050 4600
	1    0    0    -1  
$EndComp
$Comp
L Analog_Switch:ADG723 U2
U 2 1 5CA0854C
P 7050 5450
F 0 "U2" H 7050 5775 50  0000 C CNN
F 1 "ADG723" H 7050 5684 50  0000 C CNN
F 2 "Package_SO:MSOP-8_3x3mm_P0.65mm" H 7050 5450 50  0001 C CNN
F 3 "" H 7050 5450 50  0001 C CNN
	2    7050 5450
	1    0    0    -1  
$EndComp
$Comp
L Analog_Switch:ADG723 U2
U 3 1 5CA08553
P 7050 6150
F 0 "U2" H 7229 6184 50  0000 L CNN
F 1 "ADG723" H 7229 6093 50  0000 L CNN
F 2 "Package_SO:MSOP-8_3x3mm_P0.65mm" H 7050 6150 50  0001 C CNN
F 3 "" H 7050 6150 50  0001 C CNN
	3    7050 6150
	1    0    0    -1  
$EndComp
Text GLabel 6650 6250 0    39   Input ~ 0
GND
Wire Wire Line
	6650 4600 6450 4600
Wire Wire Line
	6450 4600 6450 5000
Wire Wire Line
	6450 5450 6650 5450
Wire Wire Line
	6450 5000 6150 5000
Connection ~ 6450 5000
Wire Wire Line
	6450 5000 6450 5450
Text GLabel 6150 5000 0    39   UnSpc ~ 0
ID-device
Text GLabel 6700 6050 0    39   Input ~ 0
VCC
Wire Wire Line
	7050 5850 7950 5850
Wire Wire Line
	7950 5850 7950 5000
Wire Wire Line
	7950 5000 7050 5000
Connection ~ 7950 5850
Wire Wire Line
	7950 5850 8350 5850
Text GLabel 8350 5850 2    39   Input ~ 0
Mode
$Comp
L Device:R R1
U 1 1 5CA08CFA
P 8400 4650
F 0 "R1" H 8470 4696 50  0000 L CNN
F 1 "619k" H 8470 4605 50  0000 L CNN
F 2 "Resistor_SMD:R_0402_1005Metric" V 8330 4650 50  0001 C CNN
F 3 "~" H 8400 4650 50  0001 C CNN
	1    8400 4650
	1    0    0    -1  
$EndComp
Wire Wire Line
	7450 4500 8400 4500
$Comp
L power:GND #PWR0101
U 1 1 5CA09522
P 8400 4950
F 0 "#PWR0101" H 8400 4700 50  0001 C CNN
F 1 "GND" H 8405 4777 50  0000 C CNN
F 2 "" H 8400 4950 50  0001 C CNN
F 3 "" H 8400 4950 50  0001 C CNN
	1    8400 4950
	1    0    0    -1  
$EndComp
Wire Wire Line
	8400 4800 8400 4950
Wire Wire Line
	5000 3900 5050 3900
Wire Wire Line
	8150 3900 8100 3900
Wire Wire Line
	6700 6250 6650 6250
Text GLabel 7600 5350 2    39   Input ~ 0
ID-PC
Wire Wire Line
	7600 5350 7450 5350
Text GLabel 2850 4150 2    39   Input ~ 0
ID-PC
Wire Wire Line
	2850 4150 2700 4150
$Comp
L power:GND #PWR0102
U 1 1 5CA0FAE1
P 2350 4450
F 0 "#PWR0102" H 2350 4200 50  0001 C CNN
F 1 "GND" H 2355 4277 50  0000 C CNN
F 2 "" H 2350 4450 50  0001 C CNN
F 3 "" H 2350 4450 50  0001 C CNN
	1    2350 4450
	1    0    0    -1  
$EndComp
Wire Wire Line
	2350 4450 2350 4350
Connection ~ 2350 4350
Wire Wire Line
	2350 4350 2400 4350
Wire Wire Line
	5050 3700 5000 3700
Text Notes 2100 3150 2    79   ~ 16
PC side
$EndSCHEMATC
