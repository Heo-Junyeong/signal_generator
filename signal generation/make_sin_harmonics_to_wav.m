%
pkg load signal;

function y = figure_debug()
%% wrapper function for create figure
  y = figure('position',[1980, 200, 800, 500]);
end

function [sin_signal, t] = make_sin_harmonics_to_wav(fnd_freq, len, sampling_rate, file_directory, fnd_amp, use_plot)
% ##############################################################################
% This function generates sinetone of fundamental wave sine table
%
% Usage:
%  [sin_signal, t] = make_sin_wav(fnd_freq, len, sampling_rate, file_directory, fnd_amp, use_plot)
%
% Parameters:
%  - fnd_freq : fundamental frequency
%  - sec : signal length (seconds)
%  - sampling_rate : sampling rate of signal
%  - file_directory : save file directory
%  - fnd_amp  : amplitude of signal(sine wave) ; defualt = 1
%  - use_plot : plot create sine table at generate time ; defualt = 'True'
% ##############################################################################

  % set defualt parameters
  if nargin < 6,
    use_plot = 'False';
  end
  
  if nargin < 5,
    fnd_amp = 1;
  end
  
  if nargin < 4,
    file_directory = './';
  endif
  
  
  fs = sampling_rate;

  f0 = fnd_freq; f1 = 2*f0; f2 = 3*f0;

  A = (1/3)*fnd_amp;
  
  t = linspace(0, len, sampling_rate * len);
  
  for n=1:length(t),
    x0(n) = A*cos(2*pi*(f0/fs)*n);
    y0(n) = A*sin(2*pi*(f0/fs)*n);
  end


  for n=1:length(t),
    x1(n) = A*cos(2*pi*(f1/fs)*n);
    y1(n) = A*sin(2*pi*(f1/fs)*n);
  end


  for n=1:length(t),
    x2(n) = A*cos(2*pi*(f2/fs)*n);
    y2(n) = A*sin(2*pi*(f2/fs)*n);
  end

  s = x0 + x1 + x2;

  file_name = strcat(file_directory, "cosine_", num2str(f0), "_", num2str(f1), "_", num2str(f2), "_fs_", num2str(fs), "_nd.wav");
  audiowrite(file_name, s, fs);
  aa = strcat(file_name, " save");
  disp(aa);
  sin_signal = s;
  
  if strcmp(use_plot, "True"),
    debug_figure();
    plot(sin_signal);
  end
  
end

%% test main
for i = 1:20,
  make_sin_harmonics_to_wav(i, 10, 4000);
end