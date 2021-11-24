%% program to generate a lookup table for sine_wave data

% test

freq = 100;
nSamples = 64;
fnd_amp = 2

gen_sin = generate_lookup_sine('sin100', freq, nSamples, fnd_amp);

loop = 0;

for i = 1 : length(gen_sin),  
  gen_sin_2fq(i) = gen_sin(mod(loop, nSamples) + 1);
  loop += 2;
end