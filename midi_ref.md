---
layout: default
title: MIDI Ref
---

# MIDI Reference

## Table of Contents 

- [MIDI Reference](#midi-reference)
  - [Channel Messages](#channel-messages)
  - [Controller Numbers](#controller-numbers)
  - [System Messages](#system-messages)
	- [MIDI Manufacturer Codes](#manufacturers)
  - [Realtime Messages](#realtime-messages)
  - [General MIDI](#general-midi)
	- [Instrument Patch Map](#instrument-patch-map)
	- [Percussion Key Map](#percussion-key-map)

# MIDI Reference

This is not a MIDI tutorial. Rather, it is intended as a quick overview and
a reference guide. Unless otherwise stated, all numbers appear in
hexadecimal, either with or without the leading "0x". (You can find
descriptions of the MIDI file format in a number of places, such as
[here](http://www.borg.com/~jglatt/tech/midifile.htm).)

See also
[MIDI Message Table 1](http://www.midi.org/techspecs/midimessages.php) from
the MIDI Manufacturers Association.

All MIDI messages consist of a status byte followed by zero or more data
bytes. Status bytes have their high bit set, and data bytes have a high bit
of zero. Realtime status bytes may be inserted in the data stream at any
point, including the middle of a stream of data bytes.

Two methods are used to compress data. First, running status bytes allow
two or more consecutive messages with the same status byte to be combined
into one; the status byte only need be sent the first time. Second, note on
message with a velocity of zero are to be interpreted as note off messages.

## Channel Messages

In the following table, an "x" specifies any MIDI channel (0 - 15). Thus
"status byte 8x" means any value from 80 to 8F. (Thanks to Mike Morris for
pointing out that I had the hex values for program change and controller
backwards.)

<table border="1">
	<tr>
		<th>Status</th>
		<th>Data</th>
		<th>Comments</th>
	</tr>
	<tr>
		<td>8x</td>
		<td>note, velocity</td>
		<td>Note off</td>
	</tr>
	<tr>
		<td>9x</td>
		<td>note, velocity</td>
		<td>Note on (velocity 0 = note off)</td>
	</tr>
	<tr>
		<td>Ax</td>
		<td>note, value</td>
		<td>Polyphonic pressure</td>
	</tr>
	<tr>
		<td>Bx</td>
		<td>controller, value</td>
		<td>Controller change</td>
	</tr>
	<tr>
		<td>Cx</td>
		<td>program</td>
		<td>Program change</td>
	</tr>
	<tr>
		<td>Dx</td>
		<td>value</td>
		<td>Channel pressure</td>
	</tr>
	<tr>
		<td>Ex</td>
		<td>value (two bytes: LSB then MSB. I <i>think</i>
		many devices will accept only one byte which will
		be interpreted as the MSB.)</td>
		<td>Pitch bend</td>
	</tr>
</table>

### Controller Numbers

The following table shows some standardized controller numbers. Controller
numbers 0 - 31 are continuous, MSB (most significant byte), numbers 32 - 63
are continuous, LSB (least significant byte), and 64 - 97 are switches.
(Thanks to Jeff Mann for pointing out that I had MSB and LSB reversed.)

<table border="1">
	<tr>
		<th>Name</th>
		<th>Hex</th>
		<th>Dec</th>
		<th>Comments</th>
	</tr>
	<tr>
		<td colspan="4"><strong>Continuous Values</strong></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td> Controller numbers 00 - 1f [0 - 31 decimal] are continuous, MSB
			(most significant byte)</td>
	</tr>
	<tr>
		<td>Bank Select</td>
		<td>00</td>
		<td>0</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Mod Wheel</td>
		<td>01</td>
		<td>1</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Breath Controller</td>
		<td>02</td>
		<td>2</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Foot Controller</td>
		<td>04</td>
		<td>4</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Portamento Time</td>
		<td>05</td>
		<td>5</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Data Entry MSB</td>
		<td>06</td>
		<td>6</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Volume</td>
		<td>07</td>
		<td>7</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Balance</td>
		<td>08</td>
		<td>8</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Pan</td>
		<td>0A</td>
		<td>10</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Expression Controller</td>
		<td>0B</td>
		<td>11</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>General Purpose 1</td>
		<td>10</td>
		<td>16</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>General Purpose 2</td>
		<td>11</td>
		<td>17</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>General Purpose 3</td>
		<td>12</td>
		<td>18</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>General Purpose 4</td>
		<td>13</td>
		<td>19</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>20 - 3f [32 - 63 decimal] are LSB (least significant byte) for
			00 - 1f [0 - 31 decimal]</td>
	</tr>
	<tr>
		<td colspan="4"><strong>Momentary Switches</strong></td>
	</tr>
	<tr>
		<td>Sustain</td>
		<td>40</td>
		<td>64</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Portamento</td>
		<td>41</td>
		<td>65</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Sustenuto</td>
		<td>42</td>
		<td>66</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Soft Pedal</td>
		<td>43</td>
		<td>67</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Hold 2</td>
		<td>45</td>
		<td>69</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>General Purpose 5</td>
		<td>50</td>
		<td>80</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Temp Change (General Purpose 6)</td>
		<td>51</td>
		<td>81</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>General Purpose 6</td>
		<td>51</td>
		<td>81</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>General Purpose 7</td>
		<td>52</td>
		<td>82</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>General Purpose 8</td>
		<td>53</td>
		<td>83</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Ext Effects Depth</td>
		<td>5B</td>
		<td>91</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Tremelo Depth</td>
		<td>5C</td>
		<td>92</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Chorus Depth</td>
		<td>5D</td>
		<td>93</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Detune Depth (Celeste Depth)</td>
		<td>5E</td>
		<td>94</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Phaser Depth</td>
		<td>5F</td>
		<td>95</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Data Increment (Data Entry +1)</td>
		<td>60</td>
		<td>96</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Data Decrement (Data Entry -1)</td>
		<td>61</td>
		<td>97</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Non-Registered Param LSB</td>
		<td>62</td>
		<td>98</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Non-Registered Param MSB</td>
		<td>63</td>
		<td>99</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Registered Param LSB</td>
		<td>64</td>
		<td>100</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Registered Param MSB</td>
		<td>65</td>
		<td>101</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td colspan="4"><strong>Channel mode message values</strong></td>
	</tr>
	<tr>
		<td>Reset All Controllers</td>
		<td>79</td>
		<td>121</td>
		<td>Val ??</td>
	</tr>
	<tr>
		<td>Local Control</td>
		<td>7A</td>
		<td>122</td>
		<td>Val 0 = off, 7F (127) = on</td>
	</tr>
	<tr>
		<td>All Notes Off</td>
		<td>7B</td>
		<td>123</td>
		<td>Val must be 0</td>
	</tr>
	<tr>
		<td>Omni Mode Off</td>
		<td>7C</td>
		<td>124</td>
		<td>Val must be 0</td>
	</tr>
	<tr>
		<td>Omni Mode On</td>
		<td>7D</td>
		<td>125</td>
		<td>Val must be 0</td>
	</tr>
	<tr>
		<td>Mono Mode On</td>
		<td>7E</td>
		<td>126</td>
		<td>Val = # of channels, or 0 if # channels equals # voices in receiver</td>
	</tr>
	<tr>
		<td>Poly Mode On</td>
		<td>7F</td>
		<td>127</td>
		<td>Val must be 0</td>
	</tr>
</table>

## System Messages

System messages are those not associated with any particular MIDI channel.
They are intended for the whole MIDI system.

Note that any non-realtime status byte ends a System Exclusive message; F7
(EOX) is not required at the end of a SysEx message. Realtime status bytes
may appear any time in the MIDI data stream, including in the middle of a
SysEx message.

<table border="1">
	<tr>
		<th>Status</th>
		<th>Name</th>
		<th>Data</th>
	</tr>
	<tr>
		<td>F0</td>
		<td>System Exclusive</td>
		<td>data, then EOX or any status byte</td>
	</tr>
	<tr>
		<td>F1</td>
		<td>Time Code</td>
		<td>one byte</td>
	</tr>
	<tr>
		<td>F2</td>
		<td>Song Position Pointer</td>
		<td>two bytes: lsb msb</td>
	</tr>
	<tr>
		<td>F3</td>
		<td>Song Select</td>
		<td>one byte: song number 0 - 127</td>
	</tr>
	<tr>
		<td>F4</td>
		<td>(undefined)</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>F5</td>
		<td>(undefined)</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>F6</td>
		<td>Tune Request</td>
		<td>no data</td>
	</tr>
	<tr>
		<td>F7</td>
		<td>EOX (End of System Exclusive)</td>
		<td>&nbsp;</td>
	</tr>
</table>

### MIDI Manufacturer Codes

These codes are used in System Exclusive messages to identify particular
MIDI device manufacturers. The following tables came from
[Hunton Instrument's Guide to MIDI Protocol](http://www.hinton.demon.co.uk/midicode.html).
Thanks to Manfred Hanke for finding them for me.

<i><font size="-1">(* indicates that the manufacturer has ceased trading,
but products using their ID exist.) </font></i>

#### USA

<table border="1">
	<tr>
		<th width="80">Hex</th>
		<th width="80">Decimal</th>
		<th width="240">Manufacturer</th>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="center"><tt>01</tt></td>
		<td align="center"> 1</td>
		<td>Sequential Circuits*</td>
	</tr>
	<tr>
		<td align="center"><tt>02</tt></td>
		<td align="center"> 2</td>
		<td>IDP</td>
	</tr>
	<tr>
		<td align="center"><tt>03</tt></td>
		<td align="center"> 3</td>
		<td><a href="http://www.voyetra.com/">Voyetra/Octave Plateau</a></td>
	</tr>
	<tr>
		<td align="center"><tt>04</tt></td>
		<td align="center"> 4</td>
		<td><a href="http://www.moogmusic.com/">Moog Music</a></td>
	</tr>
	<tr>
		<td align="center"><tt>05</tt></td>
		<td align="center"> 5</td>
		<td><a href="http://www.passportdesigns.com/">Passport Designs</a></td>
	</tr>
	<tr>
		<td align="center"><tt>06</tt></td>
		<td align="center"> 6</td>
		<td><a href="http://www.lexicon.com/">Lexicon</a></td>
	</tr>
	<tr>
		<td align="center"><tt>07</tt></td>
		<td align="center"> 7</td>
		<td><a
		href="http://www.kurzweilmusicsystems.com/">Kurzweil</a></td>
	</tr>
	<tr>
		<td align="center"><tt>08</tt></td>
		<td align="center"> 8</td>
		<td>Fender</td>
	</tr>
	<tr>
		<td align="center"><tt>09</tt></td>
		<td align="center"> 9</td>
		<td>Gulbransen</td>
	</tr>
	<tr>
		<td align="center"><tt>0A</tt></td>
		<td align="center">10</td>
		<td>AKG Acoustics</td>
	</tr>
	<tr>
		<td align="center"><tt>0B</tt></td>
		<td align="center">11</td>
		<td>Voyce Music</td>
	</tr>
	<tr>
		<td align="center"><tt>0C</tt></td>
		<td align="center">12</td>
		<td>Waveframe *</td>
	</tr>
	<tr>
		<td align="center"><tt>0D</tt></td>
		<td align="center">13</td>
		<td>ADA</td>
	</tr>
	<tr>
		<td align="center"><tt>0E</tt></td>
		<td align="center">14</td>
		<td>Garfield Electronics *</td>
	</tr>
	<tr>
		<td align="center"><tt>0F</tt></td>
		<td align="center">15</td>
		<td><a href="http://www.ensoniq.com/">Ensoniq</a></td>
	</tr>
	<tr>
		<td align="center"><tt>10</tt></td>
		<td align="center">16</td>
		<td><a href="http://www.gibson.com/products/oberheim/oberheim.html">Oberheim</a></td>
	</tr>
	<tr>
		<td align="center"><tt>11</tt></td>
		<td align="center">17</td>
		<td><a href="http://www.apple.com/">Apple Computer</a></td>
	</tr>
	<tr>
		<td align="center"><tt>12</tt></td>
		<td align="center">18</td>
		<td>Grey Matter</td>
	</tr>
	<tr>
		<td align="center"><tt>13</tt></td>
		<td align="center">19</td>
		<td><a href="http://www.digidesign.com/">Digidesign</a></td>
	</tr>
	<tr>
		<td align="center"><tt>14</tt></td>
		<td align="center">20</td>
		<td>Palm Tree Instruments</td>
	</tr>
	<tr>
		<td align="center"><tt>15</tt></td>
		<td align="center">21</td>
		<td>J L Cooper</td>
	</tr>
	<tr>
		<td align="center"><tt>16</tt></td>
		<td align="center">22</td>
		<td>Lowrey</td>
	</tr>
	<tr>
		<td align="center"><tt>17</tt></td>
		<td align="center">23</td>
		<td>Adams-Smith</td>
	</tr>
	<tr>
		<td align="center"><tt>18</tt></td>
		<td align="center">24</td>
		<td><a href="http://www.emu.com/">E-mu Systems</a></td>
	</tr>
	<tr>
		<td align="center"><tt>19</tt></td>
		<td align="center">25</td>
		<td>Harmony Systems</td>
	</tr>
	<tr>
		<td align="center"><tt>1A</tt></td>
		<td align="center">26</td>
		<td><a href="http://www.artroch.com/">ART</a></td>
	</tr>
	<tr>
		<td align="center"><tt>1B</tt></td>
		<td align="center">27</td>
		<td>Baldwin</td>
	</tr>
	<tr>
		<td align="center"><tt>1C</tt></td>
		<td align="center">28</td>
		<td>Eventide</td>
	</tr>
	<tr>
		<td align="center"><tt>1D</tt></td>
		<td align="center">29</td>
		<td>Inventronics</td>
	</tr>
	<tr>
		<td align="center"><tt>1E</tt></td>
		<td align="center">30</td>
		<td>Key Concepts</td>
	</tr>
	<tr>
		<td align="center"><tt>1F</tt></td>
		<td align="center">31</td>
		<td>Clarity *</td>
	</tr>
</table>
<table border="1">
	<tr>
		<th width="166">Hex Extended</th>
		<th width="240">Manufacturer</th>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 01</tt></td>
		<td>Warner New Media</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 07</tt></td>
		<td>Digital Music Corporation</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 08</tt></td>
		<td>IOTA Systems</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 09</tt></td>
		<td>New England Digital *</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 0A</tt></td>
		<td>Artisyn</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 0B</tt></td>
		<td>IVL Technologies</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 0C</tt></td>
		<td>Southern Music Systems</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 0D</tt></td>
		<td>Lake Butler Sound Company</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 0E</tt></td>
		<td>Alesis</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 10</tt></td>
		<td><a href="http://www.dod.com/DigiTech/">DOD Electronics</a></td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 11</tt></td>
		<td>Studer-Editech</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 14</tt></td>
		<td>Perfect Fretworks</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 15</tt></td>
		<td>KAT</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 16</tt></td>
		<td><a href="http://www.opcode.com/">Opcode</a></td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 17</tt></td>
		<td><a href="http://www.rane.com/">Rane Corporation</a></td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 18</tt></td>
		<td>Spatial Sound/Anadi Inc</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 19</tt></td>
		<td>KMX</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 1A</tt></td>
		<td>Allen &amp; Heath Brenell</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 1B</tt></td>
		<td><a href="http://www.peavey.com/">Peavey Electronics</a></td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 1C</tt></td>
		<td>360 Systems</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 1D</tt></td>
		<td>Spectrum Design &amp; Development</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 1E</tt></td>
		<td>Marquis Musi</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 1F</tt></td>
		<td>Zeta Systems</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 20</tt></td>
		<td>Axxes</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 21</tt></td>
		<td>Orban</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 24</tt></td>
		<td>KTI</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 25</tt></td>
		<td>Breakaway Technologies</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 26</tt></td>
		<td>CAE</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 29</tt></td>
		<td>Rocktron Corp.</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 2A</tt></td>
		<td>PianoDisc</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 2B</tt></td>
		<td>Cannon Research Corporation</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 2D</tt></td>
		<td>Rogers Instrument Corp.</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 2E</tt></td>
		<td>Blue Sky Logic</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 2F</tt></td>
		<td>Encore Electronics</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 30</tt></td>
		<td>Uptown</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 31</tt></td>
		<td>Voce</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 32</tt></td>
		<td>CTI Audio</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 33</tt></td>
		<td>S&amp;S Research</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 34</tt></td>
		<td><a href="http://www.broderbund.com/">Broderbund Software</a></td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 35</tt></td>
		<td>Allen Organ Co.</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 37</tt></td>
		<td>Music Quest</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 38</tt></td>
		<td>Aphex</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 39</tt></td>
		<td>Gallien Krueger</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 3A</tt></td>
		<td>IBM</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 3C</tt></td>
		<td>Hotz Instruments Technologies</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 3D</tt></td>
		<td>ETA Lighting</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 3E</tt></td>
		<td>NSI Corporation</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 3F</tt></td>
		<td>Ad Lib</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 40</tt></td>
		<td><a href="http://www.richmondsounddesign.com/">Richmond
		Sound Design</a></td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 41</tt></td>
		<td><a href="http://www.microsoft.com/">Microsoft</a></td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 42</tt></td>
		<td>The Software Toolworks</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 43</tt></td>
		<td>RJMG/Niche</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 44</tt></td>
		<td>Intone</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 47</tt></td>
		<td>GT Electronics/Groove Tubes</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 48</tt></td>
		<td>InterMIDI</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 55</tt></td>
		<td>Lone Wolf</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 00, 64</tt></td>
		<td>Musonix</td>
	</tr>
</table>

#### Europe

<table border="1">
	<tr>
		<th width="80">Hex</th>
		<th width="80">Decimal</th>
		<th width="240">Manufacturer</th>
	</tr>
	<tr>
		<td align="center"><tt>20</tt></td>
		<td align="center">32</td>
		<td>Passac</td>
	</tr>
	<tr>
		<td align="center"><tt>21</tt></td>
		<td align="center">33</td>
		<td>SIEL</td>
	</tr>
	<tr>
		<td align="center"><tt>22</tt></td>
		<td align="center">34</td>
		<td>Synthaxe *</td>
	</tr>
	<tr>
		<td align="center"><tt>23</tt></td>
		<td align="center">35</td>
		<td>Stepp *</td>
	</tr>
	<tr>
		<td align="center"><tt>24</tt></td>
		<td align="center">36</td>
		<td>Hohner</td>
	</tr>
	<tr>
		<td align="center"><tt>25</tt></td>
		<td align="center">37</td>
		<td>Twister *</td>
	</tr>
	<tr>
		<td align="center"><tt>26</tt></td>
		<td align="center">38</td>
		<td>Solton</td>
	</tr>
	<tr>
		<td align="center"><tt>27</tt></td>
		<td align="center">39</td>
		<td>Jellinghaus *</td>
	</tr>
	<tr>
		<td align="center"><tt>28</tt></td>
		<td align="center">40</td>
		<td>Southworth</td>
	</tr>
	<tr>
		<td align="center"><tt>29</tt></td>
		<td align="center">41</td>
		<td>PPG *</td>
	</tr>
	<tr>
		<td align="center"><tt>2A</tt></td>
		<td align="center">42</td>
		<td>JEN</td>
	</tr>
	<tr>
		<td align="center"><tt>2B</tt></td>
		<td align="center">43</td>
		<td><a href="http://www.solid-state-logic.com/">Solid State Logic</a></td>
	</tr>
	<tr>
		<td align="center"><tt>2C</tt></td>
		<td align="center">44</td>
		<td>Audio Veritrieb</td>
	</tr>
	<tr>
		<td align="center"><tt>2D</tt></td>
		<td align="center">45</td>
		<td><a href="http://www.hinton.demon.co.uk/">Hinton Instruments</a></td>
	</tr>
	<tr>
		<td align="center"><tt>2E</tt></td>
		<td align="center">46</td>
		<td>Soundtracs</td>
	</tr>
	<tr>
		<td align="center"><tt>2F</tt></td>
		<td align="center">47</td>
		<td>Elka</td>
	</tr>
	<tr>
		<td align="center"><tt>30</tt></td>
		<td align="center">48</td>
		<td>Dynacord</td>
	</tr>
	<tr>
		<td align="center"><tt>33</tt></td>
		<td align="center">51</td>
		<td><a href="http://www.clavia.se/">Clavia Digital Instruments</a></td>
	</tr>
	<tr>
		<td align="center"><tt>34</tt></td>
		<td align="center">52</td>
		<td>Audio Architecture *</td>
	</tr>
	<tr>
		<td align="center"><tt>39</tt></td>
		<td align="center">57</td>
		<td><a href="http://www.soundcraft.com/">Soundcraft Electronics</a></td>
	</tr>
	<tr>
		<td align="center"><tt>3B</tt></td>
		<td align="center">59</td>
		<td>Wersi</td>
	</tr>
	<tr>
		<td align="center"><tt>3C</tt></td>
		<td align="center">60</td>
		<td>Avab Electronik</td>
	</tr>
	<tr>
		<td align="center"><tt>3D</tt></td>
		<td align="center">61</td>
		<td>Digigram</td>
	</tr>
	<tr>
		<td align="center"><tt>3E</tt></td>
		<td align="center">62</td>
		<td><a href="http://www.waldorf-gmbh.de/">Waldorf Electronics</a></td>
	</tr>
	<tr>
		<td align="center"><tt>3F</tt></td>
		<td align="center">63</td>
		<td><a href="http://www.quasimidi.com/">Quasimidi</a></td>
	</tr>
</table>

<table border="1">
	<tr>
		<th width="166">Hex Extended</th>
		<th width="240">Manufacturer</th>
	</tr>
	<tr>
		<td align="center"><tt>00, 20, 00</tt></td>
		<td>Dream</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 20, 01</tt></td>
		<td>Strand Lighting</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 20, 02</tt></td>
		<td><a href="http://www.amek.com/">AMEK Systems &amp; Controls</a></td>
	</tr>
	<tr>
		<td align="center"><tt>00, 20, 04</tt></td>
		<td>Dr.Bohm/Musician International</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 20, 06</tt></td>
		<td>Trident</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 20, 07</tt></td>
		<td><a href="http://realworld.on.net/">Real World Design</a></td>
	</tr>
	<tr>
		<td align="center"><tt>00, 20, 09</tt></td>
		<td>Yes Technology</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 20, 0A</tt></td>
		<td>Audiomatica</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 20, 0B</tt></td>
		<td>Bontempi/Farfisa</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 20, 0C</tt></td>
		<td>F.B.T. Electronica</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 20, 0E</tt></td>
		<td>Larking Audio</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 20, 0F</tt></td>
		<td>Zero 88 Lighting</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 20, 10</tt></td>
		<td>Micon Audio Electronics</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 20, 11</tt></td>
		<td>Forefront Technology</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 20, 13</tt></td>
		<td><a href="http://www.kenton.co.uk/">Kenton Electronics</a></td>
	</tr>
	<tr>
		<td align="center"><tt>00, 20, 15</tt></td>
		<td>ADB</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 20, 16</tt></td>
		<td>Jim Marshall Products</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 20, 17</tt></td>
		<td>DDA</td>
	</tr>
	<tr>
		<td align="center"><tt>00, 20, 1F</tt></td>
		<td><a href="http://www.tcelectronic.com/">TC Electronic</a></td>
	</tr>
</table>

#### Japan

<table border="1">
	<tr>
		<th width="80">Hex</th>
		<th width="80">Decimal</th>
		<th width="240">Manufacturer</th>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="center"><tt>40</tt></td>
		<td align="center">64</td>
		<td>Kawai</td>
	</tr>
	<tr>
		<td align="center"><tt>41</tt></td>
		<td align="center">65</td>
		<td><a href="http://ww.rolandus.com/">Roland</a></td>
	</tr>
	<tr>
		<td align="center"><tt>42</tt></td>
		<td align="center">66</td>
		<td>Korg</td>
	</tr>
	<tr>
		<td align="center"><tt>43</tt></td>
		<td align="center">67</td>
		<td><a href="http://www.yamaha.co.jp/english/">Yamaha</a></td>
	</tr>
	<tr>
		<td align="center"><tt>44</tt></td>
		<td align="center">68</td>
		<td>Casio</td>
	</tr>
	<tr>
		<td align="center"><tt>45</tt></td>
		<td align="center">69</td>
		<td>Moridaira</td>
	</tr>
	<tr>
		<td align="center"><tt>46</tt></td>
		<td align="center">70</td>
		<td>Kamiya</td>
	</tr>
	<tr>
		<td align="center"><tt>47</tt></td>
		<td align="center">71</td>
		<td><a href="http://www.akai.com/akaipro/">Akai</a></td>
	</tr>
	<tr>
		<td align="center"><tt>48</tt></td>
		<td align="center">72</td>
		<td>Japan Victor</td>
	</tr>
	<tr>
		<td align="center"><tt>49</tt></td>
		<td align="center">73</td>
		<td>Meisosha</td>
	</tr>
	<tr>
		<td align="center"><tt>4A</tt></td>
		<td align="center">74</td>
		<td>Hoshino Gakki</td>
	</tr>
	<tr>
		<td align="center"><tt>4B</tt></td>
		<td align="center">75</td>
		<td>Fujitsu Electric</td>
	</tr>
	<tr>
		<td align="center"><tt>4C</tt></td>
		<td align="center">76</td>
		<td>Sony</td>
	</tr>
	<tr>
		<td align="center"><tt>4D</tt></td>
		<td align="center">77</td>
		<td>Nishin Onpa</td>
	</tr>
	<tr>
		<td align="center"><tt>4E</tt></td>
		<td align="center">78</td>
		<td>TEAC</td>
	</tr>
	<tr>
		<td align="center"><tt>50</tt></td>
		<td align="center">80</td>
		<td>Matsushita Electric</td>
	</tr>
	<tr>
		<td align="center"><tt>51</tt></td>
		<td align="center">81</td>
		<td>Fostex</td>
	</tr>
	<tr>
		<td align="center"><tt>52</tt></td>
		<td align="center">82</td>
		<td>Zoom</td>
	</tr>
	<tr>
		<td align="center"><tt>53</tt></td>
		<td align="center">83</td>
		<td>Midori Electronics</td>
	</tr>
	<tr>
		<td align="center"><tt>54</tt></td>
		<td align="center">84</td>
		<td>Matsushita Communication Industrial</td>
	</tr>
	<tr>
		<td align="center"><tt>55</tt></td>
		<td align="center">85</td>
		<td>Suzuki Musical Instrument Mfg.</td>
	</tr>
</table>

#### Universal

<table border="1">
	<tr>
		<th width="80">Hex</th>
		<th width="80">Decimal</th>
		<th width="240">Use</th>
	</tr>
	<tr>
		<td align="center"><tt>7D</tt></td>
		<td align="center">125</td>
		<td>Non-Commercial</td>
	</tr>
	<tr>
		<td align="center"><tt>7E</tt></td>
		<td align="center">126</td>
		<td>Non Real Time</td>
	</tr>
	<tr>
		<td align="center"><tt>7F</tt></td>
		<td align="center">127</td>
		<td>Real Time</td>
	</tr>
</table>

## Realtime Messages

Realtime messages are not associated with any one MIDI channel. They can
appear in the MIDI data stream at any time.

These messages consist of a single status byte; they have no data bytes.

<table border="1">
	<tr>
		<th>Status</th>
		<th>Comment</th>
	</tr>
	<tr>
		<td>F8</td>
		<td>Clock</td>
	</tr>
	<tr>
		<td>F9</td>
		<td>(undefined)</td>
	</tr>
	<tr>
		<td>FA</td>
		<td>Start</td>
	</tr>
	<tr>
		<td>FB</td>
		<td>Continue</td>
	</tr>
	<tr>
		<td>FC</td>
		<td>Stop</td>
	</tr>
	<tr>
		<td>FD</td>
		<td>(undefined)</td>
	</tr>
	<tr>
		<td>FE</td>
		<td>Active Sensing</td>
	</tr>
	<tr>
		<td>FF</td>
		<td>System Reset</td>
	</tr>
</table>

## General MIDI

General MIDI is nothing more than an agreement to a standard set of 128
patch names and, on MIDI channel 10, a set of standard
[percussion key names](#GM Percussion). Manufacturers get to interpret these
names any way they see fit.

### Instrument Patch Map

The sounds are grouped into "families" of eight patch numbers each. Patch
numbers are in decimal, and start at 1. Note that MIDI patch numbers start
at 0; you will have to subtract 1 when sending a patch change command.

<table border="1">
	<tr>
		<th>Patch</th>
		<th>Family Name</th>
		<th>Patch</th>
		<th>Family Name</th>
	</tr>
	<tr>
		<td>1 - 8</td>
		<td>Piano</td>
		<td>65 - 72</td>
		<td>Reed</td>
	</tr>
	<tr>
		<td>9 - 16</td>
		<td>Chromatic Percussion</td>
		<td>73 - 80</td>
		<td>Pipe</td>
	</tr>
	<tr>
		<td>17 - 24</td>
		<td>Organ</td>
		<td>81 - 88</td>
		<td>Synth Lead</td>
	</tr>
	<tr>
		<td>25 - 32</td>
		<td>Guitar</td>
		<td>89- 96</td>
		<td>Synth Pad</td>
	</tr>
	<tr>
		<td>33 - 40</td>
		<td>Bass</td>
		<td>97 - 104</td>
		<td>Synth Effects</td>
	</tr>
	<tr>
		<td>41 - 48</td>
		<td>Strings</td>
		<td>105 - 112</td>
		<td>Ethnic</td>
	</tr>
	<tr>
		<td>49- 56</td>
		<td>Ensemble</td>
		<td>113 - 120</td>
		<td>Percussive</td>
	</tr>
	<tr>
		<td>57 - 64</td>
		<td>Brass</td>
		<td>121 - 128</td>
		<td>Sound Effects</td>
	</tr>
</table>

Here are the patch names. Again, these numbers are in decimal, and the list
starts with 1 instead of 0. You will have to subrtact 1 when sending patch
change commands.

<table border="1">
	<tr>
		<th>Patch</th>
		<th>Name</th>
		<th>Patch</th>
		<th>Name</th>
	</tr>
	<tr>
		<td>1</td>
		<td>Acoustic Grand Piano</td>
		<td>65</td>
		<td>Soprano Sax</td>
	</tr>
	<tr>
		<td>2</td>
		<td>Bright Acoustic Piano</td>
		<td>66</td>
		<td>Alto Sax</td>
	</tr>
	<tr>
		<td>3</td>
		<td>Electric Grand Piano</td>
		<td>67</td>
		<td>Tenor Sax</td>
	</tr>
	<tr>
		<td>4</td>
		<td>Honky-tonk Piano</td>
		<td>68</td>
		<td>Baritone Sax</td>
	</tr>
	<tr>
		<td>5</td>
		<td>Electric Piano 1</td>
		<td>69</td>
		<td>Oboe</td>
	</tr>
	<tr>
		<td>6</td>
		<td>Electric Piano 2</td>
		<td>70</td>
		<td>English Horn</td>
	</tr>
	<tr>
		<td>7</td>
		<td>Harpsichord</td>
		<td>71</td>
		<td>Bassoon</td>
	</tr>
	<tr>
		<td>8</td>
		<td>Clavi</td>
		<td>72</td>
		<td>Clarinet</td>
	</tr>
	<tr>
		<td>9</td>
		<td>Celesta</td>
		<td>73</td>
		<td>Piccolo</td>
	</tr>
	<tr>
		<td>10</td>
		<td>Glockenspiel</td>
		<td>74</td>
		<td>Flute</td>
	</tr>
	<tr>
		<td>11</td>
		<td>Music Box</td>
		<td>75</td>
		<td>Recorder</td>
	</tr>
	<tr>
		<td>12</td>
		<td>Vibraphone</td>
		<td>76</td>
		<td>Pan Flute</td>
	</tr>
	<tr>
		<td>13</td>
		<td>Marimba</td>
		<td>77</td>
		<td>Blown Bottle</td>
	</tr>
	<tr>
		<td>14</td>
		<td>Xylophone</td>
		<td>78</td>
		<td>Shakuhachi</td>
	</tr>
	<tr>
		<td>15</td>
		<td>Tubular Bells</td>
		<td>79</td>
		<td>Whistle</td>
	</tr>
	<tr>
		<td>16</td>
		<td>Dulcimer</td>
		<td>80</td>
		<td>Ocarina</td>
	</tr>
	<tr>
		<td>17</td>
		<td>Drawbar Organ</td>
		<td>81</td>
		<td>Lead 1 (square)</td>
	</tr>
	<tr>
		<td>18</td>
		<td>Percussive Organ</td>
		<td>82</td>
		<td>Lead 2 (sawtooth)</td>
	</tr>
	<tr>
		<td>19</td>
		<td>Rock Organ</td>
		<td>83</td>
		<td>Lead 3 (calliope)</td>
	</tr>
	<tr>
		<td>20</td>
		<td>Church Organ</td>
		<td>84</td>
		<td>Lead 4 (chiff)</td>
	</tr>
	<tr>
		<td>21</td>
		<td>Reed Organ</td>
		<td>85</td>
		<td>Lead 5 (charang)</td>
	</tr>
	<tr>
		<td>22</td>
		<td>Accordion</td>
		<td>86</td>
		<td>Lead 6 (voice)</td>
	</tr>
	<tr>
		<td>23</td>
		<td>Harmonica</td>
		<td>87</td>
		<td>Lead 7 (fifths)</td>
	</tr>
	<tr>
		<td>24</td>
		<td>Tango Accordion</td>
		<td>88</td>
		<td>Lead 8 (bass + lead)</td>
	</tr>
	<tr>
		<td>25</td>
		<td>Acoustic Guitar (nylon)</td>
		<td>89</td>
		<td>Pad 1 (new age)</td>
	</tr>
	<tr>
		<td>26</td>
		<td>Acoustic Guitar (steel)</td>
		<td>90</td>
		<td>Pad 2 (warm)</td>
	</tr>
	<tr>
		<td>27</td>
		<td>Electric Guitar (jazz)</td>
		<td>91</td>
		<td>Pad 3 (polysynth)</td>
	</tr>
	<tr>
		<td>28</td>
		<td>Electric Guitar (clean)</td>
		<td>92</td>
		<td>Pad 4 (choir)</td>
	</tr>
	<tr>
		<td>29</td>
		<td>Electric Guitar (muted)</td>
		<td>93</td>
		<td>Pad 5 (bowed)</td>
	</tr>
	<tr>
		<td>30</td>
		<td>Overdriven Guitar</td>
		<td>94</td>
		<td>Pad 6 (metallic)</td>
	</tr>
	<tr>
		<td>31</td>
		<td>Distortion Guitar</td>
		<td>95</td>
		<td>Pad 7 (halo)</td>
	</tr>
	<tr>
		<td>32</td>
		<td>Guitar harmonics</td>
		<td>96</td>
		<td>Pad 8 (sweep)</td>
	</tr>
	<tr>
		<td>33</td>
		<td>Acoustic Bass</td>
		<td>97</td>
		<td>FX 1 (rain)</td>
	</tr>
	<tr>
		<td>34</td>
		<td>Electric Bass (finger)</td>
		<td>98</td>
		<td>FX 2 (soundtrack)</td>
	</tr>
	<tr>
		<td>35</td>
		<td>Electric Bass (pick)</td>
		<td>99</td>
		<td>FX 3 (crystal)</td>
	</tr>
	<tr>
		<td>36</td>
		<td>Fretless Bass</td>
		<td>100</td>
		<td>FX 4 (atmosphere)</td>
	</tr>
	<tr>
		<td>37</td>
		<td>Slap Bass 1</td>
		<td>101</td>
		<td>FX 5 (brightness)</td>
	</tr>
	<tr>
		<td>38</td>
		<td>Slap Bass 2</td>
		<td>102</td>
		<td>FX 6 (goblins)</td>
	</tr>
	<tr>
		<td>39</td>
		<td>Synth Bass 1</td>
		<td>103</td>
		<td>FX 7 (echoes)</td>
	</tr>
	<tr>
		<td>40</td>
		<td>Synth Bass 2</td>
		<td>104</td>
		<td>FX 8 (sci-fi)</td>
	</tr>
	<tr>
		<td>41</td>
		<td>Violin</td>
		<td>105</td>
		<td>Sitar</td>
	</tr>
	<tr>
		<td>42</td>
		<td>Viola</td>
		<td>106</td>
		<td>Banjo</td>
	</tr>
	<tr>
		<td>43</td>
		<td>Cello</td>
		<td>107</td>
		<td>Shamisen</td>
	</tr>
	<tr>
		<td>44</td>
		<td>Contrabass</td>
		<td>108</td>
		<td>Koto</td>
	</tr>
	<tr>
		<td>45</td>
		<td>Tremolo Strings</td>
		<td>109</td>
		<td>Kalimba</td>
	</tr>
	<tr>
		<td>46</td>
		<td>Pizzicato Strings</td>
		<td>110</td>
		<td>Bag pipe</td>
	</tr>
	<tr>
		<td>47</td>
		<td>Orchestral Harp</td>
		<td>111</td>
		<td>Fiddle</td>
	</tr>
	<tr>
		<td>48</td>
		<td>Timpani</td>
		<td>112</td>
		<td>Shanai</td>
	</tr>
	<tr>
		<td>49</td>
		<td>String Ensemble 1</td>
		<td>113</td>
		<td>Tinkle Bell</td>
	</tr>
	<tr>
		<td>50</td>
		<td>String Ensemble 2</td>
		<td>114</td>
		<td>Agogo</td>
	</tr>
	<tr>
		<td>51</td>
		<td>SynthStrings 1</td>
		<td>115</td>
		<td>Steel Drums</td>
	</tr>
	<tr>
		<td>52</td>
		<td>SynthStrings 2</td>
		<td>116</td>
		<td>Woodblock</td>
	</tr>
	<tr>
		<td>53</td>
		<td>Choir Aahs</td>
		<td>117</td>
		<td>Taiko Drum</td>
	</tr>
	<tr>
		<td>54</td>
		<td>Voice Oohs</td>
		<td>118</td>
		<td>Melodic Tom</td>
	</tr>
	<tr>
		<td>55</td>
		<td>Synth Voice</td>
		<td>119</td>
		<td>Synth Drum</td>
	</tr>
	<tr>
		<td>56</td>
		<td>Orchestra Hit</td>
		<td>120</td>
		<td>Reverse Cymbal</td>
	</tr>
	<tr>
		<td>57</td>
		<td>Trumpet</td>
		<td>121</td>
		<td>Guitar Fret Noise</td>
	</tr>
	<tr>
		<td>58</td>
		<td>Trombone</td>
		<td>122</td>
		<td>Breath Noise</td>
	</tr>
	<tr>
		<td>59</td>
		<td>Tuba</td>
		<td>123</td>
		<td>Seashore</td>
	</tr>
	<tr>
		<td>60</td>
		<td>Muted Trumpet</td>
		<td>124</td>
		<td>Bird Tweet</td>
	</tr>
	<tr>
		<td>61</td>
		<td>French Horn</td>
		<td>125</td>
		<td>Telephone Ring</td>
	</tr>
	<tr>
		<td>62</td>
		<td>Brass Section</td>
		<td>126</td>
		<td>Helicopter</td>
	</tr>
	<tr>
		<td>63</td>
		<td>SynthBrass 1</td>
		<td>127</td>
		<td>Applause</td>
	</tr>
	<tr>
		<td>64</td>
		<td>SynthBrass 2</td>
		<td>128</td>
		<td>Gunshot</td>
	</tr>
</table>

### Percussion Key Map

MIDI channel 10 is reserved for percussion. Each key maps to a specific
percussive sound. Key numbers are in decimal. I _think_ they are
offset by one; you will have to subtract one when sending a MIDI note
message.

<table border="1">
	<tr>
		<th>Key</th>
		<th>Note</th>
		<th>Sound</th>
		<th>Key</th>
		<th>Note</th>
		<th>Sound</th>
	</tr>
	<tr>
		<td>35</td>
		<td>C</td>
		<td>Acoustic Bass Drum</td>
		<td>59</td>
		<td>C</td>
		<td>Ride Cymbal 2</td>
	</tr>
	<tr>
		<td>36</td>
		<td>C#</td>
		<td>Bass Drum 1</td>
		<td>60</td>
		<td>C#</td>
		<td>Hi Bongo</td>
	</tr>
	<tr>
		<td>37</td>
		<td>D</td>
		<td>Side Stick</td>
		<td>61</td>
		<td>D</td>
		<td>Low Bongo</td>
	</tr>
	<tr>
		<td>38</td>
		<td>D#</td>
		<td>Acoustic Snare</td>
		<td>62</td>
		<td>D#</td>
		<td>Mute Hi Conga</td>
	</tr>
	<tr>
		<td>39</td>
		<td>E</td>
		<td>Hand Clap</td>
		<td>63</td>
		<td>E</td>
		<td>Open Hi Conga</td>
	</tr>
	<tr>
		<td>40</td>
		<td>F</td>
		<td>Electric Snare</td>
		<td>64</td>
		<td>F</td>
		<td>Low Conga</td>
	</tr>
	<tr>
		<td>41</td>
		<td>F#</td>
		<td>Low Floor Tom</td>
		<td>65</td>
		<td>F#</td>
		<td>High Timbale</td>
	</tr>
	<tr>
		<td>42</td>
		<td>G</td>
		<td>Closed Hi Hat</td>
		<td>66</td>
		<td>G</td>
		<td>Low Timbale</td>
	</tr>
	<tr>
		<td>43</td>
		<td>G#</td>
		<td>High Floor Tom</td>
		<td>67</td>
		<td>G#</td>
		<td>High Agogo</td>
	</tr>
	<tr>
		<td>44</td>
		<td>A</td>
		<td>Pedal Hi-Hat</td>
		<td>68</td>
		<td>A</td>
		<td>Low Agogo</td>
	</tr>
	<tr>
		<td>45</td>
		<td>A#</td>
		<td>Low Tom</td>
		<td>69</td>
		<td>A#</td>
		<td>Cabasa</td>
	</tr>
	<tr>
		<td>46</td>
		<td>B</td>
		<td>Open Hi-Hat</td>
		<td>70</td>
		<td>B</td>
		<td>Maracas</td>
	</tr>
	<tr>
		<td>47</td>
		<td>C</td>
		<td>Low-Mid Tom</td>
		<td>71</td>
		<td>C</td>
		<td>Short Whistle</td>
	</tr>
	<tr>
		<td>48</td>
		<td>C#</td>
		<td>Hi Mid Tom</td>
		<td>72</td>
		<td>C#</td>
		<td>Long Whistle</td>
	</tr>
	<tr>
		<td>49</td>
		<td>D</td>
		<td>Crash Cymbal 1</td>
		<td>73</td>
		<td>D</td>
		<td>Short Guiro</td>
	</tr>
	<tr>
		<td>50</td>
		<td>D#</td>
		<td>High Tom</td>
		<td>74</td>
		<td>D#</td>
		<td>Long Guiro</td>
	</tr>
	<tr>
		<td>51</td>
		<td>E</td>
		<td>Ride Cymbal 1</td>
		<td>75</td>
		<td>E</td>
		<td>Claves</td>
	</tr>
	<tr>
		<td>52</td>
		<td>F</td>
		<td>Chinese Cymbal</td>
		<td>76</td>
		<td>F</td>
		<td>Hi Wood Block</td>
	</tr>
	<tr>
		<td>53</td>
		<td>F#</td>
		<td>Ride Bell</td>
		<td>77</td>
		<td>F#</td>
		<td>Low Wood Block</td>
	</tr>
	<tr>
		<td>54</td>
		<td>G</td>
		<td>Tambourine</td>
		<td>78</td>
		<td>G</td>
		<td>Mute Cuica</td>
	</tr>
	<tr>
		<td>55</td>
		<td>G#</td>
		<td>Splash Cymbal</td>
		<td>79</td>
		<td>G#</td>
		<td>Open Cuica</td>
	</tr>
	<tr>
		<td>56</td>
		<td>A</td>
		<td>Cowbell</td>
		<td>80</td>
		<td>A</td>
		<td>Mute Triangle</td>
	</tr>
	<tr>
		<td>57</td>
		<td>A#</td>
		<td>Crash Cymbal 2</td>
		<td>81</td>
		<td>A#</td>
		<td>Open Triangle</td>
	</tr>
	<tr>
		<td>58</td>
		<td>B</td>
		<td>Vibraslap</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
</table>
