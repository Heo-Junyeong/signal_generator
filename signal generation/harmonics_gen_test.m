%% program to generate a lookup table for sine_wave data

% test

freq = 100;
nSamples = 64;
fnd_amp = 2

gen_sin = generate_lookup_sine('sin100', freq, nSamples, fnd_amp);

##loop = 0;
##
##for i = 1 : length(gen_sin),  
##  gen_sin_2fq(i) = gen_sin(mod(loop, nSamples) + 1);
##  loop += 2;
##end


function [harmonics_nth] = make_harmonics(signal, nth)
% ##############################################################################
% This function generates sinetone of fundamental wave sine table
%
% Usage:
%  [harmonics_nth] = make_harmonics(signal, nth)
%
% Parameters:
%  - fnd_freq : fundamental frequency
%  - nth : nth fundamental frequency
% ##############################################################################
  nSamples = length(signal);
  loop = 0;

  for i = 1 : nSamples,  
    harmonics_nth(i) = signal(mod(loop, nSamples) + 1);
    loop += nth;
  end

end




figure; hold on;
plot(make_harmonics(gen_sin, 1), 'r-');
plot(make_harmonics(gen_sin, 2), 'k-');
plot(make_harmonics(gen_sin, 3), 'b-');