clc;
clear;
close all;

cam = webcam(2);

figure;

while true
    frame = snapshot(cam);

    % ===== Resize (speed + stability) =====
    frame = imresize(frame,0.7);

    % ===== Convert grayscale =====
    gray = im2gray(frame);

    % ===== Edge =====
    edges = edge(gray,'canny',[0.15 0.4]);

    % ===== Clean noise =====
    edges = bwareaopen(edges,150);
    edges = imclose(edges, strel('line',5,0));

    % ===== Hough =====
    [H,T,R] = hough(edges);
    P = houghpeaks(H,10);

    lines = houghlines(edges,T,R,P,...
        'FillGap',50,'MinLength',120);

    % ===== Display =====
    imshow(frame);
    title('📱 FINAL Floor Plan 3D Detection');
    hold on;

    for k = 1:length(lines)

        p1 = lines(k).point1;
        p2 = lines(k).point2;

        dx = p2(1) - p1(1);
        dy = p2(2) - p1(2);

        angle = abs(atan2d(dy,dx));
        len = norm(p2 - p1);

        % ===== Smart angle filter (rotation tolerant) =====
        if len > 120 && ...
           (abs(angle) < 15 || abs(angle-90) < 15 || abs(angle-180) < 15)

            % ===== Stable extrusion =====
            offset = 40;

            x = [p1(1), p2(1), p2(1), p1(1)];
            y = [p1(2), p2(2), p2(2)-offset, p1(2)-offset];

            fill(x,y,'cyan',...
                'FaceAlpha',0.3,...
                'EdgeColor','none');

            % wall line
            plot([p1(1) p2(1)],...
                 [p1(2) p2(2)],...
                 'b','LineWidth',2);
        end
    end

    hold off;
    drawnow;
end