function F = wvform_init_14_bus()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    load('Vwaveform_init.mat')
    
    V1 = out.V1;
    V2 = out.V2;
    V3 = out.V3;
    V4 = out.V4;
    V5 = out.V5;
    V6 = out.V6;
    V7 = out.V7;
    V8 = out.V8;
    V9 = out.V9;
    V10 = out.V10;
    V11 = out.V11;
    V12 = out.V12;
    V13 = out.V13;
    V14 = out.V14;
    
    F = [V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14]; 
    
end

