% Parametreler
Fs = 1000; % Örnekleme frekansı (Hz)
t = 0:1/Fs:1-1/Fs; % Zaman vektörü
f1 = 10; % İlk sinyalin frekansı (Hz)
f2 = 50; % İkinci sinyalin frekansı (Hz)
noiseAmplitude = 0.1; % Gürültü genliği

% Sinyalleri oluştur
sinyal1 = sin(2*pi*f1*t);
sinyal2 = sin(2*pi*f2*t);

% Sinyalleri topla ve gürültü ekle
toplamSinyal = sinyal1 + sinyal2 + noiseAmplitude*randn(size(t));

% Bandpass filtre tasarımı
lowFc = 0.2; % Düşük kesme frekansı (Hz)
highFc = 15; % Yüksek kesme frekansı (Hz)
Filtre = designfilt('bandpassiir', 'FilterOrder', 4, 'HalfPowerFrequency1', lowFc, 'HalfPowerFrequency2', highFc, 'SampleRate', Fs);

% Gerçek zamanlı grafik için hazırlık
hfig = figure;
hline = plot(nan, nan);
xlabel('Zaman (s)');
ylabel('Amplitude');
grid on;

% Sinyali filtrele ve grafikle
for i = 1:length(t)
    % Her iterasyonda bir değer al
    currentSample = toplamSinyal(i);
    
    % Filtrele
    filteredSample = filter(Filtre, currentSample);
    
    % Grafikte göster
    set(hline, 'XData', t(1:i), 'YData', toplamSinyal(1:i));
    hold on;
    plot(t(i), filteredSample, 'ro');
    hold off;
    drawnow;
    
    % Gerçek zamanlı simülasyon için kısa bir duraklama
    pause(0.01);
end
