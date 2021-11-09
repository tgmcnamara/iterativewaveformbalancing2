case_name = 'case14_transient.m';
baseMVA = 100;
T = 1;
dt = 1e-5;
f0_init = 60;

[buses, branches, generators, sync_conds, loads, shunts] = parse_devices(case_name, baseMVA, T, dt, f0_init);

