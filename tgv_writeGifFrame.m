function tgv_writeGifFrame(fig, delayTime, t, options)
    % Funktion zum Schreiben eines Frames in eine GIF-Datei
    frame = getframe(fig);
    img = frame2im(frame);
    [img_ind, cm] = rgb2ind(img, 256); % Gibt das indizierte Bild img_ind und die Farbkarte cm zurück
    if t == 0
        imwrite(img_ind, cm, options.filename, 'gif', 'LoopCount', Inf, 'DelayTime', delayTime);
    else
        imwrite(img_ind, cm, options.filename, 'gif', 'WriteMode', 'append', 'DelayTime', delayTime);
    end
end