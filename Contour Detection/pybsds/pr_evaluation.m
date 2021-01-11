function [sample_results, threshold_results, overall_result] = pr_evaluation(thresholds, sample_names, load_gt_boundaries, load_pred)
    % """
    % Perform an evaluation of predictions against ground truths for an image
    % set over a given set of thresholds.
    % 
    % :param thresholds: either an integer specifying the number of thresholds
    % to use or a 1D array specifying the thresholds
    % :param sample_names: the names of the samples that are to be evaluated
    % :param load_gt_boundaries: a callable that loads the ground truth for a
    %     named sample; of the form `load_gt_boundaries(sample_name) -> gt`
    %     where `gt` is a 2D NumPy array
    % :param load_pred: a callable that loads the prediction for a
    %     named sample; of the form `load_gt_boundaries(sample_name) -> gt`
    %     where `gt` is a 2D NumPy array
    % :param fast: default=False, which boundary evaluation function to use
    % :param progress: default=None a callable -- such as `tqdm` -- that
    %     accepts an iterator over the sample names in order to track progress
    % :return: `(sample_results, threshold_results, overall_result)`
    % where `sample_results` is a list of `SampleResult` named tuples with one
    % for each sample, `threshold_results` is a list of `ThresholdResult`
    % named tuples, with one for each threshold and `overall_result`
    % is an `OverallResult` named tuple giving the over all results. The
    % attributes in these structures will now be described:
    % 
    % `SampleResult`:
    % - `sample_name`: the name identifying the sample to which this result
    %     applies
    % - `threshold`: the threshold at which the best F1-score was obtained for
    %     the given sample
    % - `recall`: the recall score obtained at the best threshold
    % - `precision`: the precision score obtained at the best threshold
    % - `f1`: the F1-score obtained at the best threshold\
    % 
    % `ThresholdResult`:
    % - `threshold`: the threshold value to which this result applies
    % - `recall`: the average recall score for all samples
    % - `precision`: the average precision score for all samples
    % - `f1`: the average F1-score for all samples
    % 
    % `OverallResult`:
    % - `threshold`: the threshold at which the best average F1-score over
    %     all samples is obtained
    % - `recall`: the average recall score for all samples at `threshold`
    % - `precision`: the average precision score for all samples at `threshold`
    % - `f1`: the average F1-score for all samples at `threshold`
    % - `best_recall`: the average recall score for all samples at the best
    %     threshold *for each individual sample*
    % - `best_precision`: the average precision score for all samples at the
    %     best threshold *for each individual sample*
    % - `best_f1`: the average F1-score for all samples at the best threshold
    %     *for each individual sample*
    % - `area_pr`: the area under the precision-recall curve at `threshold`
    % `
    % """
    
    if isinteger(thresholds)
        n_thresh = thresholds;
    else
        n_thresh = length(thresholds);
    end
    
    count_r_overall = zeros([1,n_thresh]);
    sum_r_overall = zeros([1,n_thresh]);
    count_p_overall = zeros([1,n_thresh]);
    sum_p_overall = zeros([1,n_thresh]);

    count_r_best = 0;
    sum_r_best = 0;
    count_p_best = 0;
    sum_p_best = 0;

    sample_results = [];
    sample_len = length(sample_names);
    for sample_index = 1:sample_len
        sample_name = sample_names(sample_index);
        % # Get the paths for the ground truth and predicted boundaries

        % # Load them
        pred = load_pred(sample_name);
        gt_b = load_gt_boundaries(sample_name);

        % # Evaluate predictions
        [count_r, sum_r, count_p, sum_p, used_thresholds] = evaluate_boundaries_fast(pred, gt_b, thresholds);
        count_r_overall = count_r_overall + count_r;
        sum_r_overall = sum_r_overall + sum_r;
        count_p_overall = count_p_overall + count_p;
        sum_p_overall = sum_p_overall + sum_p;

        % # Compute precision, recall and F1
        [rec, prec, f1] = compute_rec_prec_f1(count_r, sum_r, count_p, sum_p);

        % # Find best F1 score
        [best_value,best_ndx] = max(f1);

        count_r_best = count_r_best + count_r(best_ndx);
        sum_r_best = sum_r_best + sum_r(best_ndx);
        count_p_best = count_p_best + count_p(best_ndx);
        sum_p_best = sum_p_best + sum_p(best_ndx);
        
        samp = {};
        samp.sample_name = sample_name;
        samp.threshold = used_thresholds(best_ndx);
        samp.recall = rec(best_ndx);
        samp.precision = prec(best_ndx);
        samp.f1 = f1(best_ndx);
        samp.thresholds = used_thresholds;
        samp.count_r = int32(count_r);
        samp.sum_r = int32(sum_r);
        samp.count_p = int32(count_p);
        samp.sum_p = int32(sum_p);
        
        sample_results = [sample_results,samp];
    end
    % # Computer overall precision, recall and F1
    [rec_overall, prec_overall, f1_overall] = compute_rec_prec_f1(count_r_overall, sum_r_overall, count_p_overall, sum_p_overall);

    % # Find best F1 score
    [best_value, best_i_ovr] = max(f1_overall);

    threshold_results = [];
    for thresh_i = 1:n_thresh
        thresholdRet = {};
        thresholdRet.threshold = used_thresholds(thresh_i);
        thresholdRet.recall = rec_overall(thresh_i);
        thresholdRet.precision = prec_overall(thresh_i);
        thresholdRet.f1 = f1_overall(thresh_i);
        threshold_results = [threshold_results,thresholdRet];
    end
    [rec_unique, rec_unique_ndx, ic] = unique(rec_overall);
    prec_unique = prec_overall(rec_unique_ndx);
    if length(rec_unique) > 1
        prec_interp = interp1(rec_unique, prec_unique,0:0.01:0.999,'linear');
        prec_interp(isnan(prec_interp)) = 0;
        area_pr = sum(prec_interp) * 0.01;
    else
        area_pr = 0.0;
    end
    [rec_best, prec_best, f1_best] = compute_rec_prec_f1(double(count_r_best), double(sum_r_best), double(count_p_best),double(sum_p_best));

    
    overall_result = {};
    overall_result.threshold = used_thresholds(best_i_ovr);
    overall_result.recall = rec_overall(best_i_ovr);
    overall_result.precision = prec_overall(best_i_ovr);
    overall_result.f1 = f1_overall(best_i_ovr);
    overall_result.best_recall = rec_best;
    overall_result.best_precision = prec_best;
    overall_result.best_f1 = f1_best;
    overall_result.area_pr = area_pr;
end