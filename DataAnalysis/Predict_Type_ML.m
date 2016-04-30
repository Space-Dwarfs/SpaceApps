clear;clc;close all;

addpath('json/');

%% Load input data

myDataPath = 'Data/EAR_A_I0046_5_REDDYSPEC_V1_0/data/';
A1620 = dlmread(strcat(myDataPath,'1620_geographos.tab'));
A1980 = dlmread(strcat(myDataPath,'1980_tezcatlipoca.tab'));
A2004xp14 = dlmread(strcat(myDataPath,'2004xp14.tab'));

myDataPath = 'Data/EAR_A_3_RDR_SAWYER_ASTEROID_SPECTRA_V1_2/data/spectra/';
A65cybele = dlmread(strcat(myDataPath,'65cybele.tab'));

myDataPath = 'Data/EAR_A_I0039_4_IANNINISPEC_V1_0/data/';
A61207 = dlmread(strcat(myDataPath,'61207.tab'));

myDataPath = 'Data/EAR_A_I1092_2_MSPECTRA_V1_0/data/compspectra/';
A441bathilde = dlmread(strcat(myDataPath,'441bathilde.tab'));

% Training set
A16psyche = dlmread(strcat(myDataPath,'16psyche.tab'));
A97klotho = dlmread(strcat(myDataPath,'97klotho.tab'));
A516amherstia = dlmread(strcat(myDataPath,'516amherstia.tab'));


%% Data Analysis

% Define common x-axis
Xavg = 0.5:0.01:1;

% Find atlas (averaged signal)
Y1avg = interp1(A16psyche(:,1),A16psyche(:,2),Xavg);
Y2avg = interp1(A97klotho(:,1),A97klotho(:,2),Xavg);
Y3avg = interp1(A516amherstia(:,1),A516amherstia(:,2),Xavg);

Yavg = mean([Y1avg;Y2avg;Y3avg],1);

myatlas = [Xavg;Yavg]';

% Adjust the the mean 
A65cybele_adj = mean_adj(A65cybele,Xavg,Yavg);
A441bathilde_adj = mean_adj(A441bathilde,Xavg,Yavg);

%% Graphs

% Plot example (with error bars)
% myPlot = A1620;
% figure;
% errorbar(myPlot(:,1),myPlot(:,2),myPlot(:,3))
% xlabel('Wavelength (microns)')
% ylabel('Normalized Reflectance')

% Plot example (with no bars)
% myPlot = A1980;
% figure;
% plot(myPlot(:,1),myPlot(:,2),'r')
% xlabel('Wavelength (microns)')
% ylabel('Normalized Reflectance')

% Plot everything on the same graph
figure
hold on
plotMyGraph(A65cybele_adj,'r');
plotMyGraph(myatlas,'b');
plotMyGraph(A441bathilde_adj,'g');
plotMyGraph(A16psyche,'c');
plotMyGraph(A97klotho,'c');
plotMyGraph(A516amherstia,'c');
plotMyGraph(A65cybele_adj,'r');
plotMyGraph(myatlas,'b');
plotMyGraph(A441bathilde_adj,'g');
xlabel('Wavelength (microns)','FontSize',16)
ylabel('Normalized Reflectance','FontSize',16)
xlim([0.2 1.1])
ylim([0.8 1.2])
hold off
legend({'65 cybele (Type P)','Atlas of Type M', '441 Bathilde (Type M)',  ...
    'Asteroids of Type M'},...
    'FontSize',14, 'Location', 'northwest')

%% Similarity/Distance metrics
[pos,idx_pos] = excludeNaN(A441bathilde_adj(:,2));
[neg,idx_neg] = excludeNaN(A65cybele_adj(:,2));

disp('--- L1-norms ( <2) ---')

disp('positive example (441 Bathilde):')
disp(norm(pos - Yavg(idx_pos)',1))

disp('negative example (65 Cybele):')
disp(norm(neg - Yavg(idx_neg)',1))

disp('--- L2-norms ( <0.5) ---')

disp('positive example (441 Bathilde):')
disp(norm(pos - Yavg(idx_pos)',2))

disp('negative example (65 Cybele):')
disp(norm(neg - Yavg(idx_neg)',2))

disp('--- Corr. Coef. ( >90%) ---')

disp('positive example (441 Bathilde):')
coef_pos = corrcoef(pos,Yavg(idx_pos)');
disp(coef_pos(1,2)*100)

disp('negative example (65 Cybele):')
coef_neg = corrcoef(neg,Yavg(idx_neg)');
disp(coef_neg(1,2)*100)

%% Composition based on Type (using Asterank API)
AsterankAPI = urlread('http://www.asterank.com/api/compositions');
str = strrep(AsterankAPI,'C type','C_type');
str = strrep(str,'magnesium silicate','magnesium_silicate');
str = strrep(str,'iron silicate','iron_silicate');
str = strrep(str,'S(IV)','S_IV');
str = strrep(str,'?','NaN');
compositions = JSON.parse(str);

disp('--- Composition ---')

disp('Asteroid 441 Bathilde (Type M):')
disp(compositions.M)

disp(' ')

disp('Asteroid 65 Cybele (Type P):')
disp(compositions.Xc) % Tholen spectral type P = SMASSII spectral type Xc
