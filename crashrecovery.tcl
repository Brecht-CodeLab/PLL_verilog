# SimVision Command Script (Sat Feb 13 05:47:25 PM CET 2021)
#
# Version 19.03.s013
#
# You can restore this configuration with:
#
#     simvision -input crashrecovery.tcl
#  or simvision -input crashrecovery.tcl database1 database2 ...
#


#
# Preferences
#
preferences set toolbar-Standard-WatchWindow {
  usual
  shown 0
}
preferences set plugin-enable-svdatabrowser-new 1
preferences set toolbar-Windows-WatchWindow {
  usual
  shown 0
}
preferences set toolbar-Standard-Console {
  usual
  position -pos 1
}
preferences set toolbar-Search-Console {
  usual
  position -pos 2
}
preferences set toolbar-Standard-WaveWindow {
  usual
  position -pos 1
}
preferences set plugin-enable-groupscope 0
preferences set plugin-enable-interleaveandcompare 0
preferences set plugin-enable-waveformfrequencyplot 0
preferences set toolbar-SimControl-WatchWindow {
  usual
  shown 0
}
preferences set toolbar-TimeSearch-WatchWindow {
  usual
  shown 0
}

#
# Mnemonic Maps
#
mmap new  -reuse -name {Boolean as Logic} -radix %b -contents {{%c=FALSE -edgepriority 1 -shape low}
{%c=TRUE -edgepriority 1 -shape high}}
mmap new  -reuse -name {Example Map} -radix %x -contents {{%b=11???? -bgcolor orange -label REG:%x -linecolor yellow -shape bus}
{%x=1F -bgcolor red -label ERROR -linecolor white -shape EVENT}
{%x=2C -bgcolor red -label ERROR -linecolor white -shape EVENT}
{%x=* -label %x -linecolor gray -shape bus}}

#
# Design Browser windows
#
if {[catch {window new WatchList -name "Design Browser 1" -geometry 942x500+39+25}] != ""} {
    window geometry "Design Browser 1" 942x500+39+25
}
window target "Design Browser 1" on
browser using {Design Browser 1}
browser set -scope [subst  {simulator::[format {toplevel.inst_optimization}]} ]
browser set \
    -signalsort name
browser yview see [subst  {simulator::[format {toplevel.inst_optimization}]} ]
browser timecontrol set -lock 0

#
# Waveform windows
#
if {[catch {window new WaveWindow -name "Waveform 1" -geometry 1024x665+-10+20}] != ""} {
    window geometry "Waveform 1" 1024x665+-10+20
}
window target "Waveform 1" on
waveform using {Waveform 1}
waveform sidebar visibility partial
waveform set \
    -primarycursor TimeA \
    -signalnames name \
    -signalwidth 175 \
    -units ms \
    -valuewidth 75
waveform baseline set -time 0

set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.clk}]}
	} ]]
set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.nrst}]}
	} ]]
set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.swiptAlive}]}
	} ]]
set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.SWIPT_OUT0}]}
	} ]]
waveform format $id -trace analogLinear
waveform axis range $id -for V -min 1.0017328707580244e-09 -max 4.9986670211349349 -scale linear
set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.SWIPT_OUT1}]}
	} ]]
waveform format $id -trace analogLinear
waveform axis range $id -for V -min 1.0017328707580244e-09 -max 4.9986670211349349 -scale linear
set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.SWIPT_OUT2}]}
	} ]]
waveform format $id -trace analogLinear
waveform axis range $id -for V -min 9.9539059633668714e-10 -max 4.9986670211401831 -scale linear
set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.SWIPT_OUT3}]}
	} ]]
waveform format $id -trace analogLinear
waveform axis range $id -for V -min 1.0017325759582689e-09 -max 4.998667021140295 -scale linear
set id [waveform add -signals [subst  {
	{[format {(simulator::toplevel.inst_ANALOG_NETWORK.ADCp - simulator::toplevel.inst_ANALOG_NETWORK.ADCn)} ]}
	} ]]
waveform format $id -trace analogSampleAndHold
waveform axis range $id -for V -min -0.42500824855388419 -max 0.42387084542463144 -scale linear
set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.ADC_in[11:0]}]}
	} ]]
set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.freq[19:0]}]}
	} ]]
set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.inst_optimization.freq_new_reg[19:0]}]}
	} ]]
set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.freq_new[19:0]}]}
	} ]]
set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.freq_new[19:0]}]}
	} ]]
set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.inst_optimization.freq_new[19:0]}]}
	} ]]
set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.inst_freq.new_highest[11:0]}]}
	} ]]
set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.best_freq[19:0]}]}
	} ]]
set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.inst_freq.highest_so_far[11:0]}]}
	} ]]
set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.inst_freq.lowest_so_far[11:0]}]}
	} ]]
set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.freq_rdy}]}
	} ]]
set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.freq_set_up_down}]}
	} ]]
set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.freq_optimum}]}
	} ]]
set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.data_go}]}
	} ]]
set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.data_start}]}
	} ]]
set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.l[11:0]}]}
	} ]]
set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.d}]}
	} ]]
set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.power_optimum}]}
	} ]]
set id [waveform add -signals [subst  {
	{simulator::[format {toplevel.inst_optimization.freq_new[19:0]}]}
	} ]]

waveform xview limits 4.70672826ms 4.70672827ms

#
# Waveform Window Links
#

#
# Layout selection
#

