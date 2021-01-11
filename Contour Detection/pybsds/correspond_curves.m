function [match1, match2] = correspond_curves(bmap1, bmap2, radius)
    % # Code adapted from Pablo Arbelaez
    % # strel = disk(radius)
    % generate a disk like matrix with
    imgSiz = (radius+1)*2 + 1;
    [columnsInImage rowsInImage] = meshgrid(1:imgSiz, 1:imgSiz);
    % Next create the circle in the image.
    centerX = (imgSiz+1)/2;
    se = (rowsInImage - centerX).^2 + (columnsInImage - centerX).^2 <= (radius+1).^2;
    se = se(2:end-1,2:end-1);
    stre = strel(se);
%     stre.Neighborhood = se;
    
    % # binarios
    BW1 = bmap1;
    BW2 = bmap2 > 0;

    % # dilatar humano y pb para compararlos
    % # version continua : con Fast Marching
    BW1d  = imdilate(BW1, stre);
    BW2d  = imdilate(BW2, stre);
    match1 = BW1 & BW2d;
    % # ojo : ya no es binario
    match2 = bmap2 .* (BW1d & BW2);
end
