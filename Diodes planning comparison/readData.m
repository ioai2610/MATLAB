% analysis of a planning treatment with two different matrix
% measDose is the measured dose read by the SRS MapCheck dosimeter
% calcDose is the calculated dose computed by the SNC Patient software

% load measDose (previouslly imported)
load('measDose.mat');

% reduce the matrix and getting just the values (not the axis)
measDose_reduced = measDose(2:end,2:end);  

% making a comparation variable
measDose_cleaned = measDose_reduced;
 
% getting array length (l)
[l,y] = size(measDose_cleaned(:,1)); 

% changing NaN values to 0
for i=1:l
    for j=1:l
        if isnan(measDose_cleaned{i,j}) == 1
            measDose_cleaned{i,j} = 0;
        end
    end
end

clear y i j

%% Treatment for calcDose

% load calcDose
load('calcDose.mat');

% reduce the matrix and getting just the values (not the axis)
calcDose_reduced = calcDose(2:end,2:end);  

%% Transforming data to plot

% change from table to array structure
calcDose_reduced = table2array(calcDose_reduced);
measDose_cleaned = table2array(measDose_cleaned);

%% 2D Visual data checking (pre-analysis)

figure; % plot naming
subplot(1,2,1);
contour(calcDose_reduced);
colorbar('southoutside');
title('Calculated Dose');
subplot(1,2,2);
contour(measDose_cleaned);
colorbar('southoutside');
title('Measured Dose');
figure.Position = [100 100 550 400];
set(gcf,'Name', '2D Comparison - Irving Orlando Ayala Iturbe', ...
    'NumberTitle','off', ...
    'Position',  [100, 100, 1000, 400]); % graph size

%% 3D Visual data checking (pre-analysis)

figure; % plot naming
subplot(1,2,1);
surf(calcDose_reduced);
colorbar('southoutside');
title('Calculated Dose');
subplot(1,2,2);
surf(measDose_cleaned);
colorbar('southoutside');
title('Measured Dose');
figure.Position = [100 100 550 400];
set(gcf,'Name', '3D Comparison - Irving Orlando Ayala Iturbe', ...
    'NumberTitle','off', ...
    'Position',  [100, 100, 1000, 400]); % graph size

%% First Comparing

% Checking out our matrices, we advise there's a 5 time spatial resolution 
% in calcDose compared to measDose, so as a first approach, we're going to
% compute the mean for the 5x5 data block from calcDose and then we'll 
% compare it to measDose  cell-to-cell 

% cleaning unuseful variables
clear i j calcDose measDose  measDose_reduced

% getting array length (m)
[m,c] = size(calcDose_reduced(:,1)); 
clear c
%% Analysis

% computting the arithmetic mean for calcDose in 5x5 cell blocks

% usage
% https://la.mathworks.com/help/images/ref/blockproc.html
avgCalcDose = blockproc(calcDose_reduced, [5 5], ...
    @(block_struct) mean(block_struct.data(:)));

%% Readapting 

% since our original matrix (measDose_cleaned) has 0 values and the
% previous analysis computed the average for every single cell, we need to
% make 0 all the values from our avgCalcDose matrix in the same position of
% this one

avgCalcDose_cleaned = avgCalcDose;

% cleaning rows

for i=1:2:l
    for j=1:l
        if mod(j,2) == 0
            avgCalcDose_cleaned(i,j) = 0;
        end
    end
end

% cleaning columns

for i=2:2:l
    for j=1:2:l
        if mod(i,2) == 0
            avgCalcDose_cleaned(i,j) = 0;
        end
    end
end

%% Final Comparing 2D plot - (average function)

figure; % plot naming
subplot(1,2,1);
contour(avgCalcDose_cleaned);
colorbar('southoutside');
title('Calculated Dose (using average function)');
subplot(1,2,2);
contour(measDose_cleaned);
colorbar('southoutside');
title('Measured Dose');
figure.Position = [100 100 550 400];
set(gcf,'Name', '2D Comparison - Irving Orlando Ayala Iturbe', ...
    'NumberTitle','off', ...
    'Position',  [100, 100, 1000, 400]); % graph size

%% Final Comparing 3D plot - (average function)

figure; % plot naming
subplot(1,2,1);
surf(avgCalcDose_cleaned);
colorbar('southoutside');
title('Calculated Dose (using average function)');
subplot(1,2,2);
surf(measDose_cleaned);
colorbar('southoutside');
title('Measured Dose');
figure.Position = [100 100 550 400];
set(gcf,'Name', '3D Comparison - Irving Orlando Ayala Iturbe', ...
    'NumberTitle','off', ...
    'Position',  [100, 100, 1000, 400]); % graph size

%% Final Comparing - Analitical (average function)

for i=1:l
    for j=1:l
        if avgCalcDose_cleaned(i,j) == 0
            avgErrorMatrix(i,j) = 0;
        else
            avgErrorMatrix(i,j) = abs(avgCalcDose_cleaned(i, ...
                j)-measDose_cleaned(i,j))/measDose_cleaned(i,j);
        end
    end
end

%% Error plot - (average function)

figure;
heatmap(avgErrorMatrix);
colorbar;
title('Error (using average function)');
figure.Position = [100 100 550 400];
set(gcf,'Name', 'Error AVG - Irving Orlando Ayala Iturbe', ...
    'NumberTitle','off', ...
    'Position',  [200, 0, 900, 750]); % graph size

%% Comparison using median function

medianCalcDose = blockproc(calcDose_reduced, [5 5], ...
    @(block_struct) median(block_struct.data(:)));

medianCalcDose_cleaned = medianCalcDose;

% cleaning rows

for i=1:2:l
    for j=1:l
        if mod(j,2) == 0
            medianCalcDose_cleaned(i,j) = 0;
        end
    end
end

% cleaning columns

for i=2:2:l
    for j=1:2:l
        if mod(i,2) == 0
            medianCalcDose_cleaned(i,j) = 0;
        end
    end
end

%% Final Comparing - Analitical (median function)

for i=1:l
    for j=1:l
        if medianCalcDose_cleaned(i,j) == 0
            medianErrorMatrix(i,j) = 0;
        else
            medianErrorMatrix(i,j) = abs(medianCalcDose_cleaned(i, ...
                j)-measDose_cleaned(i,j))/measDose_cleaned(i,j);
        end
    end
end

%% Error plot - (median function)

figure;
heatmap(medianErrorMatrix);
colorbar;
title('Error (using median function)');
figure.Position = [100 100 550 400];
set(gcf,'Name', 'Error median - Irving Orlando Ayala Iturbe', ...
    'NumberTitle','off', ...
    'Position',  [200, 0, 900, 750]); % graph size
