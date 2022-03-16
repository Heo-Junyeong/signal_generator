%
clear all
close all

a = 1;
b = 2;

function [sin_signal, t] = make_sine_iir(fnd_freq, len, sampling_rate, fnd_amp, use_plot)
% ##############################################################################
% This function generates sinetone of fundamental wave sine table
%
% Usage:
%  [sin_signal, t] = make_sine(fnd_freq, sampling_rate, fnd_amp, _use_plot)
%
% Parameters:
%  - fnd_freq : fundamental frequency
%  - sec : signal length (seconds)
%  - sampling_rate : sampling rate of signal
%  - fnd_amp  : amplitude of signal(sine wave) ; defualt = 1
%  - use_plot : plot create sine table at generate time ; defualt = 'True'
% ##############################################################################

  % set defualt parameters
  if nargin < 5,
    use_plot = 'False';
  end
  
  if nargin < 4,
    fnd_amp = 1;
  end
  
  t = linspace(0, len, sampling_rate * len);
  
  % init
  a1 = 2 * cos(2 * pi * fnd_freq * (1/sampling_rate));
  b0 = sin(2 * pi * fnd_freq * (1/sampling_rate));
  
  yn1 = b0, yn2 = 0;
  
  for n = 1 : length(t),
    yn0 = a1 * yn1 - yn2; % y(n) = a1 * yn(n-1) - y(n-2)
    
    yn2 = yn1;
    yn1 = yn0;
    
    sin_signal(n) = yn1; % push
  end
 
  if strcmp(use_plot, "True"),
    debug_figure();
    plot(sin_signal);
  end
end

function y = debug_figure,
%% wrapper function for create figure
  figure('position',[1980, 200, 800, 500]);
end

[aa, t] = make_sine_iir(100, 2, 4000, 1, "True");