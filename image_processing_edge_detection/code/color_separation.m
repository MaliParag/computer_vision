function color_separation(fn)
    
    % Answer 4
    % This function is written just to visualize given image
    % in 10 different channels, namely Gray, R, G, B, Y, Cb, Cr, H, S, and
    % V
    
    FS = 20;        % Font Size
    
    im = im2double( imread( fn ) );
    im = rgb2gray(im);
    
    % Plot grayscale
    figure('Position', [1 1 1024 768] );
    subplot(2,2,1);
    imagesc( im );
    title('Full Color Image -- Grayscale', 'FontSize', FS );
    colorbar;
    
    % read image
    im = im2double( imread( fn ) );
    
    % Plot RGB channels
    figure('Position', [1 1 1024 768] );
    subplot(2,2,1);
    imagesc( im );
    title('Full Color Image -- RGB', 'FontSize', FS );
    colorbar;

    subplot(2,2,2);
    imagesc( im(:,:,1) );
    title('Channel 1 -- Red', 'FontSize', FS );
    colormap( gray(256) );
    colorbar;

    subplot(2,2,3);
    imagesc( im(:,:,2) );
    title('Channel 2 -- Green', 'FontSize', FS );
    colorbar;

    subplot(2,2,4);
    imagesc( im(:,:,3) );
    title('Channel 3 -- Blue', 'FontSize', FS );
    colorbar;
    
    % keep current figures
    hold on;
    
    % Convert image to YCbCr
    im = rgb2ycbcr(im);
    
    % Plot Y, Cb, Cr channels
    figure('Position', [1 1 1024 768] );
    subplot(2,2,1);
    imagesc( im );
    title('Full Color Image -- YCbCr', 'FontSize', FS );
    colorbar;

    subplot(2,2,2);
    imagesc( im(:,:,1) );
    title('Channel 1 -- Y', 'FontSize', FS );
    colormap( gray(256) );
    colorbar;

    subplot(2,2,3);
    imagesc( im(:,:,2) );
    title('Channel 2 -- Cb', 'FontSize', FS );
    colorbar;

    subplot(2,2,4);
    imagesc( im(:,:,3) );
    title('Channel 3 -- Cr', 'FontSize', FS );
    colorbar;
    
    % Read image and convert to HSV
    im = im2double( imread( fn ) );
    im = rgb2hsv(im);

    hold on;
    
    % Plot H, S and V channels
    figure('Position', [1 1 1024 768] );
    subplot(2,2,1);
    imagesc( im );
    title('Full Color Image -- HSV', 'FontSize', FS );
    colorbar

    subplot(2,2,2);
    imagesc( im(:,:,1) );
    title('Channel 1 -- H', 'FontSize', FS );
    colormap( gray(256) );
    colorbar;

    subplot(2,2,3);
    imagesc( im(:,:,2) );
    title('Channel 2 -- S', 'FontSize', FS );
    colorbar;

    subplot(2,2,4);
    imagesc( im(:,:,3) );
    title('Channel 3 -- V', 'FontSize', FS );
    colorbar;
end

