clear
clc

T = .02;
dt = 1e-5;
f0_init = 60;

parse_devices('case4gs', T, dt, f0_init)


% define parameters, inputs
stopTime = sprintf('%.6f',time_stop);

load_type = {'constant Z', 'constant PQ', 'constant I'};
load_config = {'Y (grounded)', 'Y (floating)', 'Y (neutral)', 'Delta'};
rlc_load_timestep = '5e-5';

gen_type = {'swing', 'PV', 'PQ'};
gen_config = {'Y', 'Yn', 'Yg'};
gen_timestep = '5e-5';

sync_cond_type = {'swing', 'PV', 'PQ'};
sync_cond_config = {'Y', 'Yn', 'Yg'};
sync_timestep = '5e-5';
% define case/mpx
mpc = loadcase('case14_transient');
% initial V waveform
% run function to get PF solution and turn that into a guess waveform?
V_init = get_init_waveform(mpc);
% generate Ymatrix

converged = false;

while ~converged
   for ele = nlin_dev
       % extract voltages
       
       % run simulation
       
       % add currents to bus
   end
   % calculate Jlin
   
   % solve system
   
   % check convergence
   
end

