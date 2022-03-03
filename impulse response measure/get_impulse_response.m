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