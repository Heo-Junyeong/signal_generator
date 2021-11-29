function [sin_table, t] = generate_lookup_sine(out_file_name, fnd_freq, nSamples, fnd_amp, init_phase, use_plot)
% ##############################################################################
% This function generates sin_table for C lang
%
% Usage:
%  generate_lookup_sine(out_file_name, fnd_freq, nSamples, fnd_amp, init_phase, use_plot)
%
% Parameters:
%  - out_file_name : directory of output C lang header file
%  - fnd_freq : fundamental frequency
%  - nSamples : number of samples
%  - fnd_amp  : amplitude of signal(sine wave) ; defualt = 1
%  - init_phase : initial phase ; defualt = 0
%  - use_plot : plot create sine table at generate time ; defualt = 'True'
% ##############################################################################
  
  % set defualt parameters
  if nargin < 6,
    use_plot = 'True';
  end
  if nargin < 5,
    init_phase = 0;
  end
  if nargin < 4,
    fnd_amp = 1; init_phase = 0;
  end
  
  T = 1/fnd_freq;
  t = 0 : T/nSamples : T - T/nSamples;
  sin_table = round(1000*fnd_amp*sin(2*pi*fnd_freq*t + init_phase));
  
  if strcmp(use_plot, "True"),
    plot(t, sin_table);
  end
  
  fid = fopen(strcat(out_file_name, '.h'),'w');
  fprintf(fid, 'short sin%d[%d] = {', fnd_freq, nSamples);
  fprintf(fid, '%d, ', sin_table(1:nSamples - 1));
  fprintf(fid, '%d', sin_table(nSamples));
  fprintf(fid, '};\n');
  fclose(fid);
end
