clc;
clear;
close all;

cam = webcam;

figure;

while true
    frame = snapshot(cam);

    [id, loc] = readAprilTag(frame,"tag36h11");

    imshow(frame);
    title('Mobile AR Architecture View');
    hold on;

 if ~isempty(id)

    % Tag boundary
    plot([loc(:,1); loc(1,1)], ...
         [loc(:,2); loc(1,2)], ...
         'r-', 'LineWidth', 3);

    % Center
    cx = mean(loc(:,1));
    cy = mean(loc(:,2));

    % Tag width (scale)
    tagWidth = norm(loc(1,:) - loc(2,:));
    scale = tagWidth / 100;

    % ===== SOFA =====
    fill([cx-60*scale cx+60*scale cx+60*scale cx-60*scale], ...
         [cy+40*scale cy+40*scale cy+80*scale cy+80*scale], ...
         'blue','FaceAlpha',0.7);

    % ===== BED =====
    fill([cx-80*scale cx+80*scale cx+80*scale cx-80*scale], ...
         [cy-120*scale cy-120*scale cy-60*scale cy-60*scale], ...
         'green','FaceAlpha',0.6);

 end

    hold off;
    drawnow;
end