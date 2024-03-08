f_samp = 425e3;

%Band Edge speifications
fp1 = 59e3;
fs1 = 64e3;
fs2 = 104e3;
fp2 = 109e3;

Wc1 = (fs1+fp1)*pi/f_samp;
Wc2  = (fs2+fp2)*pi/f_samp;

delta = 0.15;
deltaWt = (5e3/f_samp)*2*pi;

%Kaiser paramters
A = -20*log10(delta);
if(A < 21)
    beta = 0;
elseif(A <51)
    beta = 0.5842*(A-21)^0.4 + 0.07886*(A-21);
else
    beta = 0.1102*(A-8.7);
end
N_min = ceil((A-8) / (2.285*deltaWt));     %empirical formula for N_min

%Window length for Kaiser Window
n=N_min + 15;

%Ideal bandstop impulse response of length "n"

bs_ideal =  ideal_lp(pi,n) - ideal_lp(Wc2,n) + ideal_lp(Wc1,n);

%Kaiser Window of length "n" with shape paramter beta calculated above
kaiser_win = (kaiser(n,beta))';

FIR_BandStop = bs_ideal .* kaiser_win;
%fvtool(FIR_BandStop);         %frequency response

%magnitude response
%[H,f] = freqz(FIR_BandStop,1,1024, f_samp);
%figure(1)
%hold on
%grid on
%plot(f,abs(H))
%title('FIR Band Stop Filter')
%xlabel('Frequency')
%ylabel('Magnitude')
%hold off

% If you want a plot of frequency response then uncomment the above code



figure(2)
hold on
grid on
stem(-(n-1)/2:(n-1)/2,bs_ideal, 'filled')
title('Time domain representation of BSF')
xlabel('n')
ylabel('x[n]')
hold off 