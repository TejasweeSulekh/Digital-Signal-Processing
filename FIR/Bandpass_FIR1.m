clear all;
f_samp = 600e3;

%Filter number is 84
%Therefore,\\
%m = 4\\
%q(m) = 0.1*4 = 0\\
%r(m) = m - 10*q(m) = 4\\
%BL(m) = 10 + 5*q(m) + 13*r(m) = 10 + 52 = 62 $Khz$\\
%BH(m) = 75 + 62 = 137 $kHz$\\


%Band Edge speifications
fs1 = 57e3;
fp1 = 62e3;
fp2 = 137e3;
fs2 = 142e3;

Wc1 = (fs1+fp1)*pi/f_samp;
Wc2  = (fs2+fp2)*pi/f_samp;

%Kaiser paramters
A = -20*log10(0.15);
if(A < 21)
    beta = 0;
elseif(A <51)
    beta = 0.5842*(A-21)^0.4 + 0.07886*(A-21);
else
    beta = 0.1102*(A-8.7);
end

N_min = ceil((A-8) / (2.285*5000*2*pi/f_samp));           %empirical formula for N_min

%Window length for Kaiser Window
n=N_min + 25;

%Ideal bandpass impulse response of length "n"
bp_ideal = ideal_lp(Wc2,n) - ideal_lp(Wc1,n);

%Kaiser Window of length "n" with shape paramter beta calculated above
kaiser_win = (kaiser(n,beta))';

FIR_BandPass = bp_ideal .* kaiser_win;
fvtool(FIR_BandPass);         %frequency response

%magnitude response
[H,f] = freqz(FIR_BandPass,1,1024, f_samp);
%figure(1)
%hold on
%grid on
%yline(0.15); yline(0.85); yline(1.15);
%xline(fs1); xline(fs2); xline(fp1); xline(fp2);
%title('Frequency Response for Bandpass FIR filter')
%plot(f,abs(H))
%hold off

% If you want a plot of frequency response then uncomment the code above

figure(2)
hold on
grid on
stem(-(n-1)/2:(n-1)/2,bp_ideal, 'filled')
title('Time domain representation of BPF')
xlabel('n')
ylabel('x[n]')
hold off 