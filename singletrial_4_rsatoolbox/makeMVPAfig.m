function [] = makeMVPAfig
%% makeMVPAfig
% Make pretty cubes for MVPA/RSA visualizations
% 
% Marika C. Inhoff 05/10/13

figure
m = 3; 

cmap = colormap();
c{1} = randi(length(colormap),[1 m^3]);
c{2} = randi(length(colormap),[1 m^3]);
c{3} = randi(length(colormap),[1 m^3]);
c{4} = randi(length(colormap),[1 m^3]);
c{5} = randi(length(colormap),[1 m^3]);

% c{2} = c{1}+7*randn([1 m^3]);
% c{2} = c{2}-min(c{2})+1;
% c{2} = round(c{2}./max(c{2})*length(colormap));
% 
% c{3} = length(colormap)-c{1};
% c{3} = c{3}-min(c{3})+1;
% c{3} = round(c{3}./max(c{3})*length(colormap));
% 
% c{4} = length(colormap)-c{1};
% c{4} = c{4}-min(c{4})+1;
% c{4} = round(c{4}./max(c{4})*length(colormap));
% 
% c{5} = length(colormap)-c{1};
% c{5} = c{5}-min(c{5})+1;
% c{5} = round(c{5}./max(c{5})*length(colormap));

seedHeight = 12;
for f = 1:5
    subplot(1,5,f)
    count = 1;
    for j = 1:m
        for i = 1:m %loop through x
            for l = 1:3 % loop through z
                colidx = c{f}(count);
                fill3([0 1 1 0]+i, [0 0 1 1]+j, [1 1 1 1]+l, cmap(colidx,:),'LineWidth',1.1) %top
                hold on;
                fill3([0 1 1 0]+i, [0 0 1 1]+j, [1 1 1 1]+l, cmap(colidx,:),'LineWidth',1.1) %bottom
                fill3([0 1 1 0]+i, [0 0 0 0]+j, [0 0 1 1]+l, cmap(colidx,:),'LineWidth',1.1) %front
                fill3([0 1 1 0]+i, [1 1 1 1]+j, [0 0 1 1]+l, cmap(colidx,:),'LineWidth',1.1) %back
                fill3([0 0 0 0]+i, [0 1 1 0]+j, [0 0 1 1]+l, cmap(colidx,:),'LineWidth',1.1) %left
                fill3([1 1 1 1]+i, [0 1 1 0]+j, [0 0 1 1]+l, cmap(colidx,:),'LineWidth',1.1) %right

                count = count+1;
            end
        end
    end

    axis([0 m 0 m 0 3])
    axis equal
    set(gca, 'XTick',[], 'YTick',[],'ZTick',[])

end
