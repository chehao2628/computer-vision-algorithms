clc;clearvars;close all;
addpath('./pybsds');
GT_DIR = './contour-data/groundTruth';
IMAGE_DIR = './contour-data/images';
N_THRESHOLDS = 99;

imset = 'val';
imlist = get_imlist(imset);
output_dir = './contour-output/demo/';
fn = @(x)compute_edges_dxdy(x); %% function for computing edges 
if ~exist(output_dir)
       mkdir(output_dir);
end

fprintf('Running detector:\n');
detect_edges(imlist, fn, output_dir) % comment this once you implemented
%your own edge detector

% please implement your better edge detection function, and call it
% fn-yours = @(x)your-function(x)
% detect_edges(imlist, fn-yours, output_dir)
% 


%%% for evaluation of the results %%%%
load_pred_x = @(x)load_pred(output_dir, x);
load_gt_boundaries_x = @(x)load_gt_boundaries(x);
fprintf('Evaluating:\n');
[sample_results, threshold_results, overall_result] = pr_evaluation(int32(N_THRESHOLDS), imlist, load_gt_boundaries_x, load_pred_x);
file_name = sprintf('%s_out.txt',output_dir(1:end-1));
f = figure('visible','off');
display_results(file_name, sample_results, threshold_results, overall_result);
saveas(f,sprintf('%s_pr.pdf',output_dir(1:end-1)));

function imlist = get_imlist(name)
    fileID = fopen(sprintf('contour-data/%s.imlist',name),'r');
    imlist = fscanf(fileID,'%d');
end

function [mag, angle] = compute_edges_dxdy(I)
    % """Returns the norm of dx and dy as the edge response function."""
    I = double(I)/255;
    sigma = 2;
    padding = 3;
    kernel_size = 2*padding + 1;
    % Gaussian filter
    G = fspecial('gauss',kernel_size, sigma);
    % Filtering
    I = imfilter(I,G,'symmetric');
    Ix = padarray(I,[0 1],'symmetric'); % Horizontal Padding 
    Iy = padarray(I,[1 0],'symmetric'); % Vertical Padding 
    dx = conv2(Ix, [-1, 0, 1],'valid');
    dy = conv2(Iy, [-1; 0; 1], 'valid');
    mag = (dx .^ 2 + dy .^ 2).^(1/2);
    mag = mag / max(mag,[],'all');
    mag = mag * 255;
    mag(mag<0) = 0;
    mag(mag>255) = 255;
    mag = uint8(mag);
    % Get the theta and angle of gradient direction.
    theta = atan2(dy, dx);
    angle = rad2deg(theta);
end

function detect_edges(imlist, fn, out_dir)
    IMAGE_DIR = './contour-data/images/';
    lis_len = length(imlist);
    for i = 1:lis_len
        imname = imlist(i);
        I = imread(sprintf('%s%s.jpg',IMAGE_DIR, string(imname)));
        % Step1. Define two list of thresholds: low and high.
        low_threshold = [60,50,50];
        high_threshold = [78,75,70];
        % Build a new array with the same size of input colour image. 
        double_t_mag = zeros(size(I));
        % Step2.Apply Non-maximum Suppression and Hysteresis thresholding to each
        % channel of input image.
        for n = 1:3
            gray = I(:,:,n);    
            [mag,angle] = fn(gray);       
            nms_mag = nms(mag, angle);
            double_t_mag(:,:,n) = double_threshold(nms_mag,low_threshold(n),high_threshold(n));
        end
        % Step3. Convert the processed colour image to grayscale image.
        output = rgb2gray(double_t_mag);
        out_file_name = sprintf('%s%s.png',out_dir, string(imname));
        imwrite(output,out_file_name);
    end
end

function boundary = load_gt_boundaries(imname)
    GT_DIR = './contour-data/groundTruth/';
    gt_path = sprintf('%s%s.mat',GT_DIR, string(imname));
    bd = bsds_dataset;
    boundary = bd.load_boundaries(gt_path);
end


function img = load_pred(output_dir, imname)
    pred_path = sprintf('%s%s.png',output_dir,string(imname));
    img = double(imread(pred_path))/255.0;
end

function display_results(f, im_results, threshold_results, overall_result)
    % out_keys = ["threshold", "f1", "best_f1", "area_pr"];
    % out_name = ["threshold", "overall max F1 score", "average max F1 score", "area_pr"];
    
    overall_result
    fileID = fopen(f,'w');
    fprintf(fileID,'%s %10.6f\n','threshold',overall_result.threshold);
    fprintf(fileID,'%s %10.6f\n','overall max F1 score',overall_result.f1);
    fprintf(fileID,'%s %10.6f\n','average max F1 score',overall_result.best_f1);
    fprintf(fileID,'%s %10.6f\n','area_pr',overall_result.area_pr);
    fclose(fileID);
    
    res = reshape(struct2array(threshold_results),[],length(threshold_results))';
    recall = res(:, 2);
    precision = res(recall > 0.01, 3);
    recall = recall(recall > 0.01);
    label_str = sprintf('%0.2f, %0.2f, %0.2f', overall_result.f1, overall_result.best_f1, overall_result.area_pr);
    % # Sometimes the PR plot may look funny, such as the plot curving back, i.e,
    % # getting a lower recall value as you lower the threshold. This is because of
    % # the lack on non-maximum suppression. The benchmarking code does some
    % # contour thinning by itself. Unfortunately this contour thinning is not very
    % # good. Without having done non-maximum suppression, as you lower the
    % # threshold, the contours become thicker and thicker and we lose the
    % # information about the precise location of the contour. Thus, a thined
    % # contour that corresponded to a ground truth boundary at a higher threshold
    % # can end up far away from the ground truth boundary at a lower threshold.
    % # This leads to a drop in recall as we decrease the threshold.
    p = plot(recall, precision, 'Color','r');
    p.LineWidth = 2;
    grid on;
    xlim([0, 1]);
    ylim([0, 1]);
    legend([label_str]);
    xlabel('Recall');
    ylabel('Precision');
end
    