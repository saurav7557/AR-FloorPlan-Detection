clc;
clear;
close all;

%% Load Image
img = imread('data/floor_plan.jpg');

choice = menu('Select View', ...
    'Original Image', ...
    'Grayscale', ...
    'Edge Detection', ...
    'Wall Detection', ...
    'Static 3D View', ...
    'Live AR Webcam', ...
    'AprilTag AR');

%% ================= ORIGINAL IMAGE =================
if choice == 1

    figure;
    imshow(img);
    title('Original Floor Plan');

%% ================= GRAYSCALE =================
elseif choice == 2

    gray = im2gray(img);

    figure;
    imshow(gray);
    title('Grayscale Floor Plan');

%% ================= EDGE DETECTION =================
elseif choice == 3

    gray = im2gray(img);
    edges = edge(gray,'canny');

    figure;
    imshow(edges);
    title('Detected Wall Edges');

%% ================= WALL DETECTION =================
elseif choice == 4

    gray = im2gray(img);
    edges = edge(gray,'canny');

    [H,T,R] = hough(edges);
    P = houghpeaks(H,20);

    lines = houghlines(edges,T,R,P,...
        'FillGap',20,...
        'MinLength',50);

    figure;
    imshow(img);
    title('Detected Walls');
    hold on;

    for k = 1:length(lines)

        xy = [lines(k).point1; lines(k).point2];

        plot(xy(:,1),xy(:,2),...
            'LineWidth',2,...
            'Color','green');
    end

    hold off;

%% ================= STATIC 3D VIEW =================
elseif choice == 5

    gray = im2gray(img);
    edges = edge(gray,'canny');

    [H,T,R] = hough(edges);
    P = houghpeaks(H,20);

    lines = houghlines(edges,T,R,P,...
        'FillGap',20,...
        'MinLength',50);

    figure;
    imshow(img);
    title('Static 3D Room Structure');
    hold on;

    for k = 1:length(lines)

        p1 = lines(k).point1;
        p2 = lines(k).point2;

        x = [p1(1), p2(1), p2(1)-25, p1(1)-25];
        y = [p1(2), p2(2), p2(2)-50, p1(2)-50];

        fill(x,y,'blue',...
            'FaceAlpha',0.25,...
            'EdgeColor','black');
    end

    hold off;

%% ================= LIVE AR WEBCAM =================
elseif choice == 6

    cam = webcam;

    figure;

    while true

        frame = snapshot(cam);

        gray_live = im2gray(frame);
        edges_live = edge(gray_live,'canny');

        [H,T,R] = hough(edges_live);
        P = houghpeaks(H,10);

        lines_live = houghlines(edges_live,T,R,P,...
            'FillGap',30,...
            'MinLength',80);

        imshow(frame);
        title('Live AR Architecture View');

        hold on;

        for k = 1:length(lines_live)

            p1 = lines_live(k).point1;
            p2 = lines_live(k).point2;

            len = norm(p2 - p1);

            if len > 120

                dx = p2(1)-p1(1);
                dy = p2(2)-p1(2);

                angleShiftX = round(dx*0.2);
                angleShiftY = round(dy*0.2);

                x = [p1(1), p2(1), ...
                     p2(1)-angleShiftX, ...
                     p1(1)-angleShiftX];

                y = [p1(2), p2(2), ...
                     p2(2)-60-angleShiftY, ...
                     p1(2)-60-angleShiftY];

                fill(x,y,'cyan',...
                    'FaceAlpha',0.3,...
                    'EdgeColor','black');

            elseif len > 40

                plot([p1(1) p2(1)],...
                     [p1(2) p2(2)],...
                     'g',...
                     'LineWidth',3);
            end
        end

        hold off;
        drawnow;

        % Press Q to Exit
        if waitforbuttonpress
            key = get(gcf,'CurrentCharacter');
            if lower(key) == 'q'
                break;
            end
        end
    end

    clear cam;

%% ================= APRILTAG AR =================
elseif choice == 7

    cam = webcam;

    figure;

    while true

        frame = snapshot(cam);

        [id,loc] = readAprilTag(frame,"tag36h11");

        imshow(frame);
        title('AprilTag Based 3D AR');

        hold on;

        if ~isempty(loc)

            plot([loc(:,1); loc(1,1)],...
                 [loc(:,2); loc(1,2)],...
                 'r-',...
                 'LineWidth',3);

            p1 = loc(1,:);
            p2 = loc(2,:);

            x = [p1(1), p2(1), ...
                 p2(1)-30, p1(1)-30];

            y = [p1(2), p2(2), ...
                 p2(2)-80, p1(2)-80];

            fill(x,y,'magenta',...
                'FaceAlpha',0.35,...
                'EdgeColor','black');
        end

        hold off;
        drawnow;

        % Press Q to Exit
        if waitforbuttonpress
            key = get(gcf,'CurrentCharacter');
            if lower(key) == 'q'
                break;
            end
        end
    end

    clear cam;

end