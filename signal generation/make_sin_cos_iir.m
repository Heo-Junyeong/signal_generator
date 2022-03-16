%
clear all
close all

function [cos_signal, sin_signal, t] = make_sin_cos_iir(fnd_freq, len, sampling_rate, fnd_amp, use_plot)
% ##############################################################################
% This function generates sinetone and cosineton
%
% Usage:
%  [cos_signal, sin_signal, t] = make_sin_cos_iir(fnd_freq, len, sampling_rate, fnd_amp, use_plot)
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
  a1 = fnd_amp * cos(2 * pi * fnd_freq * (1/sampling_rate));
  b0 = fnd_amp * sin(2 * pi * fnd_freq * (1/sampling_rate));
  
  qn1 = 1; qn2 = 0;
  
  for n = 1 : length(t),
    cos_signal(n) = qn1-a1*qn2;  % data push
    sin_signal(n) = b0 * qn2;
    
    qn0 = 2 * a1 * qn1 - qn2; % q(n) = a1 * qn(n-1) - q(n-2)
    qn2 = qn1;
    qn1 = qn0;
  end
 
  if strcmp(use_plot, "True"),
    debug_figure(); hold on; grid on; grid minor;
    plot(sin_signal, 'k-');  
    plot(cos_signal, 'r-');
    title(strcat('signal generation, f0=', num2str(fnd_freq), ' sr=', num2str(sampling_rate)));
    xlabel('samples');
    legend('sin', 'cos');
    
    figure; hold on; grid on; grid minor;
    
  end
end

function y = debug_figure,
%% wrapper function for create figure
  figure('position',[1980, 200, 800, 500]);
end

[aa, bb, t] = make_sin_cos_iir(100, 2, 4000, 1, "True");
%% aa=cos, bb= sin
disp(aa*bb');
