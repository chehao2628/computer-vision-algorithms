function double_t_mag = double_threshold(mag, lowThreshold, highThreshold)

[r,c] = size(mag);
double_t_mag = zeros(size(mag));
weak = 0.5;
strong = 1;
% Step2 If a pixel value is larger than high threshold, set the pixel value
% to strong value 1. If a pixel value is smaller than low threshold, 
% set the pixel value to 0. If a pixel value is larger than low threshold 
% and smaller than high threshold, set the pixel value to weak value 0.5 temporarily.
for i=1:r %vertical
    for j=1:c %horizontal
        if mag(i,j) < lowThreshold
            double_t_mag(i,j) = 0;
        elseif mag(i,j) > highThreshold
            double_t_mag(i,j) = strong;
        else
            double_t_mag(i,j) = weak;
        end
    end
end

% Step3. Check all weak value pixels. If the one of neighbor pixel value of
% weak value pixel is a strong value pixel, set the weak value pixel to strong value pixel.
for i=3:r-2 %vertical
    for j=3:c-2 %horizontal
        if double_t_mag(i,j) == weak
            if double_t_mag(i+1,j) == strong||double_t_mag(i,j+1) == strong||double_t_mag(i+1,j+1)...
                    == strong||double_t_mag(i-1,j) == strong||double_t_mag(i,j-1) == strong||...
                    double_t_mag(i-1,j-1) == strong||double_t_mag(i+1,j-1) == strong||...
                    double_t_mag(i-1,j+1) == strong
                double_t_mag(i,j) = strong;
            else 
                double_t_mag(i,j) = 0;
            end
        end
    end
end

end
    