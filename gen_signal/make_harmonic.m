function [harmonic, t] = make_harmonic(fnd_freq_table, nth, nSamples, fnd_amp, use_plot, t)
% ##############################################################################
% This function generates harmonics of fundamental wave sine table
%
% Usage:
%  make_harmonic(fnd_wave_table, nSamples, fnd_amp, init_phase, use_plot)
%
% Parameters:
%  - fnd_freq_table : fundamental frequency sine table
%  - nth : The nth harmonic that we want to make (ex, nth = 4, fundamental freqency = 220 Hz -> output harmonic = 880 Hz)
%  - fnd_amp  : amplitude of signal(sine wave) ; defualt = 1
%  - use_plot : plot create sine table at generate time ; defualt = 'True'
%  - t : time index using use_plot
% ##############################################################################

  % set defualt parameters
  if nargin < 6,
    use_plot = 'False';
    t = [0];
  end
  if nargin < 4,
    fnd_amp = 1;
  end
  
  loop = 0;
  
  for i = 1 : length(fnd_freq_table),  
    harmonic(i) = fnd_amp * fnd_freq_table(mod(loop, nSamples) + 1);
    loop += nth;
  end
  
  if strcmp(use_plot, "True"),
    plot(t, harmonic);
  end
end