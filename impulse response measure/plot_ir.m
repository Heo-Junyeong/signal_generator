close all;
clear all;
clc;
len = 2048;
pkg load signal;

function [impulse] = get_impulse_response(ir1, Fs, Length)
  disp('Hello Impulse!');
  
  ir = ir1(:, 1);
  irfft = fft(ir);
  
  f1 = 500;
  f2 = 4000;
  
  [B1 A1] = butter(5, f1/(Fs/2), 'high') % HP at f1
  [B2 A2] = butter(5, f2/(Fs/2), 'high') % LP at f2
  
  % get fft of measurement signal to verify its okay and to use for inverse
  
  irfft = fft(ir);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%             CREATE INVERSE SPECTRUM               %%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  
  % start with the true inverse of the measurement signal fft
  % this includes the band-pass filtering, whos inverse could go to
  % infinity!!!
  
  invirfft = 1./irfft;
  % so we need to re-apply the band pass here to get rid of that

  [H1 W1] = freqz(B1, A1, length(irfft), Fs);
  [H2 W2] = freqz(B2, A2, length(irfft), Fs);

  % apply band pass filter to inverse magnitude
  invirfftmag  = (abs(invirfft').*abs(H1)'.*abs(H2)')';

  % get inverse phase
  invirfftphase = angle(invirfft);

  % re-synthesis inverse fft in polar form
  invirfft = invirfftmag.*exp(sqrt(-1)*invirfftphase);


  % assign outputs
  invsweepfft = invirfft;
  sweep_response = ir1(:,2);



%%

% if(size(sweep_response,1) > 1)
%     sweep_response = sweep_response';
% end

  N = length(invsweepfft);
  sweepfft = fft(sweep_response,N);
  %%% convolve sweep with inverse sweep (freq domain multiply)
  ir_x = real(ifft(invsweepfft.*sweepfft));
  ir_x = circshift(ir_x,  ceil(length(ir_x)/2)); 
  irLin = ir_x(end/2+1:end);
  irNonLin = ir_x(1:end/2);
  %[irLin, irNonLin] = extractIR_1(sweep_response, invsweepfft)
  % figure,subplot(211); plot(irLin);
  % xlim([1 1024]);

  % [H,w]=freqz(irLin,2048);
  % subplot(212);plot(w/pi*(FS/2),20*log10(abs(H)));
  % xlim([1 10000]);
 
  % break
  % audiowrite('ir_con.wav',irLin(1:1024),FS);
  ##impulse = irLin(1:Length);
  impulse = irLin;
end

%% functions
function [P1, f] = plot_fft(time_domain_signal, signal_length, sampling_rate)
  Y = fft(time_domain_signal);
  P2 = abs(Y/signal_length);
  P1 = P2(1:signal_length/2+1);
  P1(2:end-1) = 2*P1(2:end-1);
  
  f = sampling_rate * (0:(signal_length/2))/signal_length;
  
  plot(f, P1, 'r');
  ylabel('Magnitude'), xlabel('frequency (Hz)');
end

function [P1, f] = plot_fft2(time_domain_signal, signal_length, sampling_rate)
  Y = fft(time_domain_signal);
  P2 = abs(Y/signal_length);
  P1 = P2(1:signal_length/2+1);
  P1(2:end-1) = 2*P1(2:end-1);
  
  f = sampling_rate * (0:(signal_length/2))/signal_length;
  
  plot(f, P1, 'b');
  ylabel('Magnitude'), xlabel('frequency (Hz)');
end
function [P1, f] = plot_fft_dB(time_domain_signal, signal_length, sampling_rate)
  Y = fft(time_domain_signal);
  P2 = abs(Y/signal_length);
  P1 = P2(1:signal_length/2+1);
  P1(2:end-1) = 2*P1(2:end-1);
  
  f = sampling_rate * (0:(signal_length/2))/signal_length;
  P1 = 10*log10(P1);
  plot(f, P1);
  ylabel('Magnitude(dB)'), xlabel('frequency (Hz)');
end

function plot_stft(time_domain_signal)%, signal_length, sampling_rate, window)
  specgram(time_domain_signal);
  colormap hot;
end

function plot_welch(time_domain_signal)%, signal_length, sampling_rate, windowing)
  pwelch(time_domain_signal);
  ylabel('PSD'), xlabel('frequency (Hz)');
end

function plot_welch_dB(time_domain_signal)%, signal_length, sampling_rate, windowing)
  [pxx, f] = pwelch(time_domain_signal);
  plot(f, 10*log10(pxx));
  ylabel('PSD(dB/Hz)'), xlabel('frequency (Hz)');
end

function save_fig2png(figure, filename, directory)
   if nargin < 3,
     directory = './';
   end
   filename = strcat(directory, filename);
   saveas(figure, filename, 'png');
end

##[signal, fs] = audioread('secondary_recorded.wav');
##[signal, fs] = audioread('primary_new_mic.wav');
[signal, fs] = audioread('primary_swtone_mesure_16000.wav');
ir = get_impulse_response(signal,fs,len);
##find(ir==max(ir))
ir = resample(ir,16000,44100);
audiowrite('p_ir.wav', ir, 16000);
##audiowrite('primary_ir.wav', ir, 16000);
figure, plot(ir, 'k-'); grid on; grid minor;
xlim([0 1000]);
title('primary path impulse response');
xlabel('samples');
##ylim([-12*1e-3 12*1e-3]);

##[signal, fs] = audioread('Impulse_Response_1.wav');
##figure, plot(signal);

[signal, fs] = audioread('secondary_swtone_mesure_16000.wav');
ir2 = get_impulse_response(signal,fs,len);
##find(ir==max(ir))
ir2 = resample(ir2,16000,44100);
audiowrite('s_ir.wav', ir2, 16000);
##audiowrite('primary_ir.wav', ir, 16000);
figure, plot(ir2, 'r-'); grid on; grid minor;
title('secondary path impulse response');
xlabel('samples');
xlim([0 1000]);
##ylim([-12*1e-3 12*1e-3]);

figure, plot(ir, 'k-');
hold on; grid on; grid minor;
plot(ir2, 'r-');
title('primary/secondary path impulse response');
xlabel('samples');
xlim([0 1000]);
legend('primary path ir', 'secondeary path ir');

f4 = figure; hold on; grid on; grid minor;
plot_welch_dB(ir(500:700));
plot_welch_dB(ir2(200:300));
title('PSD of primary/secondary path ir');
xlabel('Normalized frequency (Hz)');
ylabel('PSD(db/Hz)');
legend('primary path ir', 'secondeary path ir', 'Location','southwest');
save_fig2png(f4, 'psd_ir');