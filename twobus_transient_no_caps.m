function mpc = twobus_transient_no_caps
%CASE14    Power flow data for IEEE 14 bus test case.
%   Please see CASEFORMAT for details on the case file format.
%   This data was converted from IEEE Common Data Format
%   (ieee14cdf.txt) on 15-Oct-2014 by cdf2matp, rev. 2393
%   See end of file for warnings generated during conversion.
%
%   Converted from IEEE CDF file from:
%       http://www.ee.washington.edu/research/pstca/
% 
%  08/19/93 UW ARCHIVE           100.0  1962 W IEEE 14 Bus Test Case

%   MATPOWER

% MATPOWER Case Format : Version 2
mpc.version = '2';

%-----  Power Flow Data  -----%
% system MVA base
mpc.baseMVA = 100;

% bus data
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
mpc.bus = [
	1   3	0	0	0	0	1	1.06	0	0	1	1.3	0.8;
	2	2	21.7	12.7	0	0	1	1.045	-4.98	0	1	1.3	0.8;
];

%load data
% bus Type Configuration Pl Qind Qcap 
mpc.load = [
    2   2   1   26.04e10    15.24e10    0;
];
% generator data
%	bus	Type Configuration Active_Power Reactive_Power Max_Q Min_Q
%	Source_resistance Source_Inductance Base_V
mpc.gen = [
    1   3    3    163e6   0   inf   -inf   0.8929  16.58e-3    146.28e3;
];

%synchronous condenser data
%	bus	Type Configuration Active_Power Reactive_Power Max_Q Min_Q
%	Source_resistance Source_Inductance Base_V
mpc.sync_cond = [];

% branch data
%	fbus	tbus	r1 r0 l1 l0 c1 c0rateA	rateB	rateC	ratio	angle	status	angmin	angmax
mpc.branch = [
	1	2	 1.273 1.273  0.41264 0.41264 0.0    0.0	0	0	0	0	0	1	-360	360;];

%-----  OPF Data  -----%
% generator cost data
%	1	startup	shutdown	n	x1	y1	...	xn	yn
%	2	startup	shutdown	n	c(n-1)	...	c0
mpc.gencost = [
	2	0	0	2	0.001	0;
	2	0	0	2	0.002	0;
	2	0	0	2	0.003	0;
	2	0	0	2	0.004	0;
	2	0	0	2	0.005	0;
];

% bus names
mpc.bus_name = {
	'Bus 1     HV';
	'Bus 2     HV';
	'Bus 3     HV';
	'Bus 4     HV';
	'Bus 5     HV';
	'Bus 6     LV';
	'Bus 7     ZV';
	'Bus 8     TV';
	'Bus 9     LV';
	'Bus 10    LV';
	'Bus 11    LV';
	'Bus 12    LV';
	'Bus 13    LV';
	'Bus 14    LV';
};

% Warnings from cdf2matp conversion:
%
% ***** check the title format in the first line of the cdf file.
% ***** Qmax = Qmin at generator at bus    1 (Qmax set to Qmin + 10)
% ***** MVA limit of branch 1 - 2 not given, set to 0
% ***** MVA limit of branch 1 - 5 not given, set to 0
% ***** MVA limit of branch 2 - 3 not given, set to 0
% ***** MVA limit of branch 2 - 4 not given, set to 0
% ***** MVA limit of branch 2 - 5 not given, set to 0
% ***** MVA limit of branch 3 - 4 not given, set to 0
% ***** MVA limit of branch 4 - 5 not given, set to 0
% ***** MVA limit of branch 4 - 7 not given, set to 0
% ***** MVA limit of branch 4 - 9 not given, set to 0
% ***** MVA limit of branch 5 - 6 not given, set to 0
% ***** MVA limit of branch 6 - 11 not given, set to 0
% ***** MVA limit of branch 6 - 12 not given, set to 0
% ***** MVA limit of branch 6 - 13 not given, set to 0
% ***** MVA limit of branch 7 - 8 not given, set to 0
% ***** MVA limit of branch 7 - 9 not given, set to 0
% ***** MVA limit of branch 9 - 10 not given, set to 0
% ***** MVA limit of branch 9 - 14 not given, set to 0
% ***** MVA limit of branch 10 - 11 not given, set to 0
% ***** MVA limit of branch 12 - 13 not given, set to 0
% ***** MVA limit of branch 13 - 14 not given, set to 0
