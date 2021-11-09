clear
clc

t = 0:1e-5:1;
amp = 230e3;
d2 = .01*amp;
th2 = 5*pi/180;

% Vg1_a_ts = timeseries(Va1, t);
% Vg1_b_ts = timeseries(Vb1, t);
% Vg1_c_ts = timeseries(Vc1, t);
% 
% Vg1_a_ts = timeseries(Va1, t);
% Vg1_b_ts = timeseries(Vb1, t);
% Vg1_c_ts = timeseries(Vc1, t);

params = Params('case4gs', 100, 1, 1e-5, 60, 'linear');

%           Bus Type Vset      P      Qinit Qmax Qmin 
gen_data1 = [1, 3,   amp,      160e3, 0,    inf, -inf];
gen_data2 = [1, 1,   (amp+d2), 155e3, 0,    inf, -inf];

gen1 = Generator(gen_data1, params, 'generator_sim2');
gen2 = Generator(gen_data2, params, 'generator_sim2');

gen1 = gen1.init_sim();

gen2 = gen2.init_sim();

Va1 = amp*cos(2*pi*60*t);
Vb1 = amp*cos(2*pi*60*(t-2*pi/3));
Vc1 = amp*cos(2*pi*60*(t+2*pi/3));
Vg1 = [Va1; Vb1; Vc1];

Va2 = (amp+d2)*cos(2*pi*60*(t-th2));
Vb2 = (amp+d2)*cos(2*pi*60*(t-2*pi/3-th2));
Vc2 = (amp+d2)*cos(2*pi*60*(t+2*pi/3-th2));
Vg2 = [Va2; Vb2; Vc2];


Iwave1 = gen1.run_model(Vg1, t);
Iwave2 = gen2.run_model(Vg2, t);

