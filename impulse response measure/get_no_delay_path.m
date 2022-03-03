pkg load signal;
[signal1, fs] = audioread('primary_ir_new_mic.wav');
[signal2, fs] = audioread('secondary_ir_new_mic.wav');

signal1 = signal1(100:227);
signal2 = signal2(100:227);

audiowrite('primary_ir_no_deleay.wav', signal1, 16000);
audiowrite('seccondary_ir_no_deleay.wav', signal2, 16000);