clc;
clear;
close all;

% Load camera parameters for AprilTag mode
load('cameraParams.mat');

% Camera list
camList = webcamlist;
disp(camList);

% Select mobile camera index
cam = webcam(2);   % change if needed

% Try setting resolution
try
    cam.Resolution = '640x480';
catch
end

choice = menu('Mobile AR Menu', ...
    'Live Feed', ...
    'Original View', ...
    'Grayscale View', ...
    'Edge Detection', ...
    'Wall Detection', ...
    'Static 3D View', ...
    'AprilTag AR View');

fig = figure;

while ishandle(fig)
    frame = snapshot(cam);

    if choice == 1
        imshow(frame);
        title('Live Camera Feed');
    elseif choice == 2
        imshow(frame);
        title('Original Mobile Camera View');
    elseif choice == 3
        gray = im2gray(frame);
        imshow(gray);
        title('Grayscale Mobile View');
    elseif choice == 4
        gray = im2gray(frame);
        edges = edge(gray,'canny');
        imshow(edges);
        title('Edge Detection View');
    elseif choice == 5
        gray = im2gray(frame);
        edges = edge(gray,'canny');

        [H,T,R] = hough(edges);
        P = houghpeaks(H,10);
        lines = houghlines(edges,T,R,P,'FillGap',30,'MinLength',80);

        imshow(frame);
        title('Wall Detection View');
        hold on;

        for k = 1:length(lines)
            xy = [lines(k).point1; lines(k).point2];
            plot(xy(:,1),xy(:,2),'g','LineWidth',3);
        end

        hold off;
    elseif choice == 6
        gray = im2gray(frame);
        edges = edge(gray,'canny');

        [H,T,R] = hough(edges);
        P = houghpeaks(H,10);
        lines = houghlines(edges,T,R,P,'FillGap',30,'MinLength',80);

        imshow(frame);
        title('Static 3D Wall View');
        hold on;

        for k = 1:length(lines)
            p1 = lines(k).point1;
            p2 = lines(k).point2;

            len = norm(p2-p1);

            if len > 120
                dx = p2(1)-p1(1);
                dy = p2(2)-p1(2);

                shiftX = round(dx*0.2);
                shiftY = round(dy*0.2);

                x = [p1(1), p2(1), p2(1)-shiftX, p1(1)-shiftX];
                y = [p1(2), p2(2), p2(2)-60-shiftY, p1(2)-60-shiftY];

                fill(x,y,'cyan','FaceAlpha',0.3,'EdgeColor','black');
            end
        end

        hold off;
    elseif choice == 7
        tagSize = 40;

        imshow(frame);
        title('AprilTag Based Mobile AR');
        hold on;

        try
            [id,loc,pose] = readAprilTag(frame,"tag36h11",cameraParams,tagSize);

            if ~isempty(id)
                plot([loc(:,1); loc(1,1)], ...
                     [loc(:,2); loc(1,2)], ...
                     'r-', 'LineWidth', 3);

                wall3D = [0 0 0;
                          40 0 0;
                          40 0 60;
                          0 0 60];

                wall2D = worldToImage(cameraParams, ...
                    pose(1).Rotation, ...
                    pose(1).Translation, ...
                    wall3D);

                fill(wall2D(:,1), wall2D(:,2), ...
                    'magenta', 'FaceAlpha',0.4);

                bed3D = [45 5 0;
                         65 5 0;
                         65 20 0;
                         45 20 0;
                         45 5 15;
                         65 5 15;
                         65 20 15;
                         45 20 15];

                bed2D = worldToImage(cameraParams, ...
                    pose(1).Rotation, ...
                    pose(1).Translation, ...
                    bed3D);

                fill(bed2D(5:8,1), bed2D(5:8,2), ...
                    'blue', 'FaceAlpha',0.8);
            end
        catch
        end

        hold off;
    end

    drawnow;

    % Press Q to exit
    if waitforbuttonpress
        key = get(fig,'CurrentCharacter');
        if lower(key) == 'q'
            break;
        end
    end
end

clear cam;