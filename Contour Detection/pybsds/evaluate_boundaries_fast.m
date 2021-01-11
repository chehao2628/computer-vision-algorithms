function [count_r, sum_r, count_p, sum_p, thresholds] = evaluate_boundaries_fast(predicted_boundaries, gt_boundaries, thresholds, radius, apply_thinning)
    % """
    % Evaluate the accuracy of a predicted boundary and a range of thresholds
    % 
    % :param predicted_boundaries: the predicted boundaries as a (H,W)
    % floating point array where each pixel represents the strength of the
    % predicted boundary
    % :param gt_boundaries: a list of ground truth boundaries, as returned
    % by the `load_boundaries` or `boundaries` methods
    % :param thresholds: either an integer specifying the number of thresholds
    % to use or a 1D array specifying the thresholds
    % :param radius: (default=3) size of disk for dilation element that is used
    % to correspond predicted boundary to ground truth boundaries.
    % :param apply_thinning: (default=True) if True, apply morphologial
    % thinning to the predicted boundaries before evaluation
    % :param progress: a function that can be used to monitor progress;
    % use `tqdm.tqdm` or `tdqm.tqdm_notebook` from the `tqdm` package
    % to generate a progress bar.
    % :return: tuple `(count_r, sum_r, count_p, sum_p, thresholds)` where each
    % of the first four entries are arrays that can be used to compute
    % recall and precision at each threshold with:
    % ```
    % recall = count_r / (sum_r + (sum_r == 0))
    % precision = count_p / (sum_p + (sum_p == 0))
    % ```
    % The thresholds are also returned.
    % """
    % # Code adapted from Pablo Arbelaez
    
    switch nargin
        case 2
            thresholds=99; radius=3; apply_thinning=true;
        case 3
            radius=3; apply_thinning=true;
        case 4
            apply_thinning=true;
    end

    % Handle thresholds
    if isinteger(thresholds)
        thresholds = linspace(1.0 / (double(thresholds) + 1),1.0 - 1.0 / (double(thresholds) + 1), thresholds);
    elseif ismatrix(thresholds)
        siz = size(thresholds);
        if siz(0) ==1 && length(siz) == 2
            error(['thresholds array should have 1 dimension', length(size)]);
        end
    else
        error('thresholds should be an int or a 1-D array');
    end
    sum_p = zeros(size(thresholds));
    count_p = zeros(size(thresholds));
    sum_r = zeros(size(thresholds));
    count_r = zeros(size(thresholds));
    [sx,sy] = size(gt_boundaries{1,1});
    sz = length(gt_boundaries);
    human = squeeze(sum(reshape(cell2mat(gt_boundaries),[sx,sy,sz]),3));
    
    thresholds_len = length(thresholds);
    
    for i_t = 1:thresholds_len
        thresh = thresholds(i_t);
        predicted_boundaries_bin = predicted_boundaries >= thresh;

        if i_t == 1
            bmap_old = predicted_boundaries_bin;
            same_bmap = false;
        else
            if all(predicted_boundaries_bin == bmap_old)
                same_bmap = true;
            else
                bmap_old = predicted_boundaries_bin;
                same_bmap = false;
            end
        end
        
        acc_prec = false(size(predicted_boundaries_bin));
        
        if ~same_bmap
            if apply_thinning
                predicted_boundaries_bin = binary_thin(predicted_boundaries_bin);
            end
            [match1, match2] = correspond_curves(predicted_boundaries_bin, human, radius);
            count_r(i_t) = sum(match2,'all');
            sum_r(i_t) = sum(human,'all');
            count_p(i_t) = sum(match1,'all');
            sum_p(i_t) = sum(predicted_boundaries_bin,'all');
        else
            count_r(i_t) = count_r(i_t-1);
            sum_r(i_t) = sum_r(i_t-1);
            count_p(i_t) = count_p(i_t-1);
            sum_p(i_t) = sum_p(i_t-1);
        end
    end
end
 