function [timeseries, time] = TimeseriesFromPSD(Sxx, fs, T, plot_on)
% Create one realization of a timeseries from a given double-sided PSD, Sxx
%
% NOTE: Since we don't have pThase information, the original timeseries is
% not recoverable. We can, however, create a random timeseries that has the
% same statistical characteristics as the original timeseries.
%
% Steps:
% Create perfect white noise by generating random phase in the frequency
% domain, and then multiply it by your PSD. Then transfer it to the time
% domain...Take note that MATLAB expects the conjugate symmetric part of
% the spectrum to be the second half of the array.
%
% INPUTS
%       Sxx - Double-sided power spectral density in the expected MATLAB
%             order e.g. [wavePSD_positiveFreq wavePSD_negativeFreq]
%
%       fs -  Sample rate of the output timeseries [samples/sec]
%
%       T -   Desired length of the output timeseries [seconds]
%
% OUTPUTS
%       timeseries - Generated timeseries
%
%       time   - Time vector corresponding to timeseries generated
%
% EXAMPLE
%   T = 100; % Length of timeseries
%   fs = 25; % Sample rate of timeseries
%   f0 = 2;  % For this example, just do a tone
%
%   % Build PSD of a single tone in this example
%   rmsLevel = 1; % RMS level of tone
%   df = 1/T;
%   GxxMag = ((rmsLevel^2)/df); % Single-Sided Power spectrum magnitude
%   SxxMag = GxxMag/2;          % Double-sided Power spectrum magnitude
%   PSD_DoubleSided = zeros(T*fs, 1);
%   PSD_DoubleSided(f0*T+1) = SxxMag;
%   PSD_DoubleSided(end-f0*T+1) = SxxMag;
%
%   [timeseries, time] = TimeseriesFromPSD(PSD_DoubleSided, fs, T); % Run!
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright Mike Rudolph, 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 2: June 27, 2015 - resample Sxx based on input T
% Version 1: July 29, 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if exist('Sxx', 'var') && (~exist('T', 'var') || isempty(T))
    T = length(Sxx)/fs; % Length of your timeseries [seconds]
else
    N_orig = length(Sxx);
    Sxx = resample(Sxx, T, N_orig/fs);
end

if ~exist('fs', 'var')
    fs = 4;                % Sample rate [samples/sec]
end

if ~exist('plot_on', 'var')
    plot_on = 0;                % Sample rate [samples/sec]
end

dt = 1/fs;                  % Delta time [sec]
df = 1/T;                   % Delta frequency [Hz]
N = round(fs*T);            % Total number of samples

frequency_DoubleSided = (0:(N-1))*df; % Double-Sided Frequency vector
time = (0:N-1)*dt;                    % Time vector

%% Create your double-sided PSD
% Here I'm using an ocean wave PSD called JONSWAP
% Taken from https://code.google.com/p/wafo/downloads/list
if nargin == 0 || ~exist('Sxx', 'var')
    Hm0 = 2.2;          % Significant Wave Height
    Tp = 4.3*sqrt(Hm0); % Peak wave period (middle of acceptable range)
    
    frequency_SingleSided = (0:(N/2))*df; % Single-Sided Frequency vector
    wave = jonswap(2*pi.*frequency_SingleSided,[Hm0 Tp], 0);
    
    % Scale Gxx to proper value (yours should already be in [m^2/Hz])
    Gxx = abs(wave.S*(2*pi)); % Single-sided spectrum [m^2/Hz]
    
    % Make it double-sided (Sxx shoud be your input)
    Sxx_positiveFreq = Gxx/2;
    Sxx_negativeFreq = flip(conj(Sxx_positiveFreq(2:end-1)));
    Sxx = [Sxx_positiveFreq; Sxx_negativeFreq]; % [m^2/Hz]
end

if N ~= length(Sxx)
    error('Invalid sample rate or time series length.')
    return
end

Xm_mag = sqrt(Sxx.*T); % Magnitude of Linear Spectrum [meters*sec]

%% Generate 'Perfect' white noise in the frequency domain
even = true;
Nhalf = N/2-1;
if rem(N,2) ~= 0; even = false; Nhalf = (N-1)/2; end

rms_level = 1;
randnums = rand(Nhalf, 1).*2*pi;  % Random phase between 0 and 2pi
randvalues = rms_level.*exp(1i*randnums);   % This is your white noise

% Create linear spectrum for white noise
if even
    linspecPositiveFreq = [rms_level; randvalues; rms_level]; % + Freqs
else
    linspecPositiveFreq = [rms_level; randvalues];   % + Freqs
end
linspecNegativeFreq = flip(conj(randvalues));        % - Freqs

% Need this order for IFFT in MATLAB:
noiseLinSpec = [linspecPositiveFreq; linspecNegativeFreq];


%% Multiply noise * signal linear spectra (double-sided) in frequency-domain
totalWaveLinSpec = Xm_mag.*noiseLinSpec; % [meters]

% Convert double-sided PSD to units in time domain via IFFT and math
% Also, take the real part - should be all real anyway
timeseries = real(ifft(totalWaveLinSpec)*N*df);


%% Plot it up, yo.
if plot_on ==1
figure(2)
subplot(211)
plot(frequency_DoubleSided, abs(totalWaveLinSpec))
title('Double-Sided Linear Spectrum * White Noise')
xlabel('Frequency (Hz)')
ylabel('Spectrum Magnitude [m/Hz]')

subplot(212)
plot(frequency_DoubleSided, angle(totalWaveLinSpec))
title('Double-Sided Linear Spectrum * White Noise Phase')
xlabel('Frequency (Hz)')
ylabel('Phase [rad]')

figure(3)
plot(time, timeseries)
title('Generated Timeseries From PSD')
xlabel('Time (Sec)')
ylabel('Amplitude [m]')
end
end

