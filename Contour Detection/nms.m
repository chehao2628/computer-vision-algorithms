function nms_mag = nms(mag, angle)
% Perform Non-maximum Suppression for edge detection
nms_mag = mag;
[r,c] = size(mag);
for i=2:r-1 % vertical
    for j=2:c-1 % horizontal
        if angle(i,j) < 0
            angle(i,j) = angle(i,j)+180; % Convert negative angle value to positive.
        end
        current_angle = angle(i,j);
        theta = deg2rad(current_angle); % convert for computation
        % The logic of following parts are refer to https://www.cnblogs.com/nowgood/p/cannyedge.html
        if current_angle >=0 && current_angle < 45
            dtheta = theta; % Compute angle with cloest axis for further compuation
            E = mag(i, j+1); % Get the pixel value in east of P
            NE = mag(i-1, j+1); % Get the pixel value in northeast of P
            W = mag(i, j-1); % Get the pixel value in west of P
            SW = mag(i+1, j-1); % Get the pixel value in southwest of P
            p1 = (1- tan(dtheta))*E + tan(dtheta)*NE; % compute P1
            p2 = (1- tan(dtheta))*W + tan(dtheta)*SW; % compute P2
        elseif current_angle >= 45 && current_angle < 90
            dtheta = pi/2 - theta; % Compute angle with cloest axis for further compuation
            N = mag(i-1, j); % Get the pixel value in north of P
            NE = mag(i-1, j+1); % Get the pixel value in northeast of P
            S = mag(i+1, j); % Get the pixel value in south of P
            SW = mag(i+1, j-1); % Get the pixel value in southwest of P
            p1 = (1- tan(dtheta))*N + tan(dtheta)*NE; % compute P1
            p2 = (1- tan(dtheta))*S + tan(dtheta)*SW; % compute P2
        elseif current_angle >= 90 && current_angle < 135
            dtheta = theta - pi/2;
            N = mag(i-1, j);
            NW = mag(i-1, j-1);
            S = mag(i+1, j);
            SE = mag(i+1, j+1);
            p1 = (1- tan(dtheta))*N + tan(dtheta)*NW;
            p2 = (1- tan(dtheta))*S + tan(dtheta)*SE;
        elseif current_angle >= 135 && current_angle <= 180
            dtheta = pi - theta;
            W = mag(i, j-1);
            NW = mag(i-1, j-1);
            E = mag(i, j+1);
            SE = mag(i+1, j+1);
            p1 = (1- tan(dtheta))*W + tan(dtheta)*NW;
            p2 = (1- tan(dtheta))*E + tan(dtheta)*SE;
        end
        if mag(i,j) >= p1 && mag(i,j) >= p2
            nms_mag(i,j) = mag(i,j);
        else
            nms_mag(i,j) = 0;
        end
    end
end

end