function tgv_writeGifFrame(fig, t, options)
    % Funktion zum Schreiben eines Frames in eine GIF-Datei
    delayTime = options.dt; % Zeitschrittgröße
    try
        % Überprüfen, ob das Figure-Handle gültig ist
        if ~ishandle(fig)
            error('Ungültiges Figure-Handle.');
        end
        
        % Frame aus der Figur aufnehmen
        frame = getframe(fig);
        img = frame2im(frame);
        [img_ind, cm] = rgb2ind(img, 256); % Gibt das indizierte Bild img_ind und die Farbkarte cm zurück
        
        % GIF-Datei schreiben
        if t == 0
            imwrite(img_ind, cm, options.filename, 'gif', 'LoopCount', Inf, 'DelayTime', delayTime);
        else
            imwrite(img_ind, cm, options.filename, 'gif', 'WriteMode', 'append', 'DelayTime', delayTime);
        end
    catch ME
        % tüdeldüüü
    end
end
