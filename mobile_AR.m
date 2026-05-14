clc;
clear;
close all;

% Load camera parameters
load('cameraParams.mat');

% Camera list
camList = webcamlist;
disp(camList);

% Select mobile camera
cam = webcam(2);   % change index if needed

cam.Resolution = '640x480';

% Menu
choice = menu('📱 Mobile AR Menu', ...
    'Original View', ...
    'Grayscale View', ...
    'Edge Detection', ...
    'Wall Detection', ...
    'Static 3D View', ...
    'AprilTag AR View');

%% ================= ORIGINAL VIEW =================
if choice == 1

    figure;

    while true

        frame = snapshot(cam);

        imshow(frame);
        title('Original Mobile Camera View');

        drawnow;

        % Press Q to Exit
        if waitforbuttonpress
            key = get(gcf,'CurrentCharacter');

            if lower(key) == 'q'
                break;
            end
        end
    end

%% ================= GRAYSCALE =================
elseif choice == 2

    figure;

    while true

        frame = snapshot(cam);

        gray = im2gray(frame);

        imshow(gray);
        title('Grayscale Mobile View');

        drawnow;

        if waitforbuttonpress
            key = get(gcf,'CurrentCharacter');

            if lower(key) == 'q'
                break;
            end
        end
    end

%% ================= EDGE DETECTION =================
elseif choice == 3

    figure;

    while true

        frame = snapshot(cam);

        gray = im2gray(frame);

        edges = edge(gray,'canny');

        imshow(edges);
        title('Edge Detection View');

        drawnow;

        if waitforbuttonpress
            key = get(gcf,'CurrentCharacter');

            if lower(key) == 'q'
                break;
            end
        end
    end

%% ================= WALL DETECTION =================
elseif choice == 4

    figure;

    while true

        frame = snapshot(cam);

        gray = im2gray(frame);

        edges = edge(gray,'canny');

        [H,T,R] = hough(edges);

        P = houghpeaks(H,10);

        lines = houghlines(edges,T,R,P,...
            'FillGap',30,...
            'MinLength',80);

        imshow(frame);
        title('Wall Detection View');

        hold on;

        for k = 1:length(lines)

            xy = [lines(k).point1; lines(k).point2];

            plot(xy(:,1),xy(:,2),...
                'LineWidth',2,...
                'Color','green');
        end

        hold off;

        drawnow;

        if waitforbuttonpress
            key = get(gcf,'CurrentCharacter');

            if lower(key) == 'q'
                break;
            end
        end
    end

%% ================= STATIC 3D VIEW =================
elseif choice == 5

    figure;

    while true

        frame = snapshot(cam);

        gray = im2gray(frame);

        edges = edge(gray,'canny');

        [H,T,R] = hough(edges);

        P = houghpeaks(H,10);

        lines = houghlines(edges,T,R,P,...
            'FillGap',30,...
            'MinLength',80);

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

                x = [p1(1), p2(1), ...
                     p2(1)-shiftX, ...
                     p1(1)-shiftX];

                y = [p1(2), p2(2), ...
                     p2(2)-60-shiftY, ...
                     p1(2)-60-shiftY];

                fill(x,y,'cyan',...
                    'FaceAlpha',0.3,...
                    'EdgeColor','black');
            end
        end

        hold off;

        drawnow;

        if waitforbuttonpress
            key = get(gcf,'CurrentCharacter');

            if lower(key) == 'q'
                break;
            end
        end
    end

%% ================= APRILTAG AR =================
elseif choice == 6

    tagSize = 40;

    figure;

    while true

        frame = snapshot(cam);

        imshow(frame);

        title('AprilTag Based Mobile AR');

        hold on;

        try

            [id,loc,pose] = readAprilTag(frame,...
                "tag36h11",...
                cameraParams,...
                tagSize);

            if ~isempty(id)

                % Marker boundary
                plot([loc(:,1); loc(1,1)], ...
                     [loc(:,2); loc(1,2)], ...
                     'r-', 'LineWidth', 3);

                % 3D Wall
                wall3D = [0 0 0;
                          40 0 0;
                          40 0 60;
                          0 0 60];

                wall2D = worldToImage(cameraParams,...
                    pose(1).Rotation,...
                    pose(1).Translation,...
                    wall3D);

                fill(wall2D(:,1),...
                     wall2D(:,2),...
                     'magenta',...
                     'FaceAlpha',0.4);

                % Bed
                bed3D = [45 5 0;
                         65 5 0;
                         65 20 0;
                         45 20 0;
                         45 5 15;
                         65 5 15;
                         65 20 15;
                         45 20 15];

                bed2D = worldToImage(cameraParams,...
                    pose(1).Rotation,...
                    pose(1).Translation,...
                    bed3D);

                fill(bed2D(5:8,1),...
                     bed2D(5:8,2),...
                     'blue',...
                     'FaceAlpha',0.8);
            end

        catch
        end

        hold off;

        drawnow;

        if waitforbuttonpress
            key = get(gcf,'CurrentCharacter');

            if lower(key) == 'q'
                break;
            end
        end
    end

end

clear cam;