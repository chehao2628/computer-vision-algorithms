function [rec, prec, f1] = compute_rec_prec_f1(count_r, sum_r, count_p, sum_p)
    % """
    % Computer recall, precision and F1-score given `count_r`, `sum_r`,
    % `count_p` and `sum_p`; see `evaluate_boundaries`.
    % :param count_r:
    % :param sum_r:
    % :param count_p:
    % :param sum_p:
    % :return: tuple `(recall, precision, f1)`
    % """
    rec = count_r ./ (sum_r + (sum_r == 0));
    prec = count_p ./ (sum_p + (sum_p == 0));
    f1_denom = (prec + rec + ((prec + rec) == 0));
    f1 = 2.0 * prec .* rec ./ f1_denom;
end