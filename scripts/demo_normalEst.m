%% This scripts used to show the results for multi-scale normal estimation

%% 1. relight the surface normals with lightings
addpath('../include')
%% load synthetic BRDF 
load('../data/syn_brdf/brdf');

%% load lighting directions
fid = fopen('../lighting/lights.txt','rb');
temp = textscan(fid, '%s %f %f %f');
lightMatrix = [temp{2} temp{3} temp{4}];
light = -lightMatrix';

%% load surface normals and masks
load('../data/surface normals/bunnyNormal.mat');
load('../data/surface normals/bunny_mask.mat');
test_normal = reshape(normalMap, [], 3);
test_normal = test_normal(mask == 1, :);
test_normal = test_normal';

% relighting the objects for the varying lightings
vog = relight(test_normal, light, brdf, 1);

tSampleR = zeros(length(vog), size(test_normal, 2));
tSampleG = zeros(length(vog), size(test_normal, 2));
tSampleB = zeros(length(vog), size(test_normal, 2));
for i = 1:length(vog)
    temp = vog{i};
    tSampleR(i, :) = reshape(temp(:, 1), 1, []);
    tSampleG(i, :) = reshape(temp(:, 2), 1, []);
    tSampleB(i, :) = reshape(temp(:, 3), 1, []);
end

%% 2. use the generate B matrix to do multi-sclae search
% you need to generate the B matrix by yourself since it is too large
% We have provided the code to guide how to get B matrix

[Bn, canNormal, mapSet] = initialize('F:/newCode/B_matrix/');
opt.lid = 1:253; % lighting distributions
opt.start = 2; % start scale for multi-sclae;
opt.mapSet = mapSet;

[idMat, errMat] = ms_normalEst(Bn, tSampleR, tSampleG, tSampleB, opt);