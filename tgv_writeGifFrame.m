function tgv_writeGifFrame(fig, delayTime, isFirstFrame, options)
    % Capture the plot as an image and write it to the GIF
    frame = getframe(fig);
    img = frame2im(frame);
    [img_ind, cm] = rgb2ind(img, 256);
    if isFirstFrame
        imwrite(img_ind, cm, options.filename, 'gif', 'LoopCount', Inf, 'DelayTime', delayTime);
    else
        imwrite(img_ind, cm, options.filename, 'gif', 'WriteMode', 'append', 'DelayTime', delayTime);
    end
end