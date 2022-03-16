%clear
%

hello  = 1;
function table = generate_lookup_iirgen_init(out_file_name, f_lower, f_upper, sampling_rate, fnd_amp, init_phase, use_plot)
% ##############################################################################
% This function generates iirgen_init for C lang
%
% Usage:
%  table = generate_lookup_iirgen_init(out_file_name, f_lower, f_upper, nSamples, fnd_amp, init_phase, use_plot)
%
% Parameters:
%  - out_file_name : directory of output C lang header file
%  - lower : start frequency
%  - upper : end frequency
%  - sampling_rate : sampling rate
%  - fnd_amp  : amplitude of signal(sine wave) ; defualt = 1
%  - init_phase : initial phase ; defualt = 0
%  - use_plot : plot create sine table at generate time ; defualt = 'True'
% ##############################################################################
  
  % set defualt parameters
  if nargin < 6,
    use_plot = 'True'
  end
  if nargin < 5,
    init_phase = 0;
  end
  if nargin < 4,
    fnd_amp = 1; init_phase = 0;
  end

  for i = f_lower : f_upper,
      % init
    a1(i-f_lower + 1) = fnd_amp * cos(2 * pi * i * (1/sampling_rate));
    b0(i-f_lower + 1) = fnd_amp * sin(2 * pi * i * (1/sampling_rate));
  end
  
  table = [a1; b0];
  
  if use_plot == 'True',
    plot(table);
  end
  
  fid = fopen(strcat(out_file_name, '.h'),'w');
  fprintf(fid, 'float sin_iir_f%dto%d[%d] = {', f_lower, f_upper, f_upper - f_lower + 1);
  fprintf(fid, '%f, ', b0(1:f_upper - f_lower));
  fprintf(fid, '%f', b0(f_upper - f_lower));
  fprintf(fid, '};\n');
  
  fprintf(fid, 'float cos_iir_f%dto%d[%d] = {', f_lower, f_upper, f_upper - f_lower + 1);
  fprintf(fid, '%f, ', a1(1:f_upper - f_lower));
  fprintf(fid, '%f', a1(f_upper - f_lower));
  fprintf(fid, '};\n');
  fclose(fid);
end

aa = generate_lookup_iirgen_init('iirgen_weights', 20, 120, 4000, 1);
