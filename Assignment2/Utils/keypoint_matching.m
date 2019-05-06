function [fa_matches,fb_matches]=keypoint_matching(Ia,Ib,peak_thresh)
    if nargin == 2
        peak_thresh=8;
    end
    Ia=single(Ia);
    Ib=single(Ib);
    [fa, da] = vl_sift(Ia,'PeakThresh', peak_thresh) ;
    [fb, db] = vl_sift(Ib,'PeakThresh', peak_thresh) ;
    [matches, ~] = vl_ubcmatch(da, db) ;
    fa_matches = fa(:,matches(1,:));
    fb_matches = fb(:,matches(2,:));
end

    