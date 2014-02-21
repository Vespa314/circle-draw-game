function dianyuanquan()
IMG = double(imread('IMG_0016.JPG'));
[M N] = size(IMG(:,:,1));
result_image = Click_Image(IMG,floor(M/2),floor(N/2),zeros(M,N,3));
imwrite(uint8(result_image),'result.bmp');

function  result_image = Click_Image(img,x,y,result_image)
rate_thred_hold = 0.75;%提高可以增加分裂的数目
[m n] = size(img(:,:,1));
r = floor(m/2);
rgb = GetMainColorRGB(img);
circle_idx = GetCircle_Idx(m);
color_idx = find_similar_color(img,rgb);

%限制圆的最小尺寸和最大尺寸
if (sum(color_idx(:))/m/n < rate_thred_hold && m>20) || m > size(result_image,1)/10
    sub_img = img(1:floor(m/2),1:floor(m/2),:);
    result_image = Click_Image(sub_img,x-r/2,y-r/2,result_image);
    
    sub_img = img(1:floor(m/2),floor(m/2)+1:floor(m/2)*2,:);
    result_image = Click_Image(sub_img,x+r/2,y-r/2,result_image);
    
    sub_img = img(floor(m/2)+1:floor(m/2)*2,1:floor(m/2),:);
    result_image = Click_Image(sub_img,x-r/2,y+r/2,result_image);
    
    sub_img = img(floor(m/2)+1:floor(m/2)*2,floor(m/2)+1:floor(m/2)*2,:);
    result_image = Click_Image(sub_img,x+r/2,y+r/2,result_image);
else
    for i = 1 : m
        for j = 1 : m
            if(circle_idx(i,j))
                result_image(floor(y-r+i),floor(x-r+j),:) = rgb;
            end
        end
    end
    figure(1);
    imshow(uint8(result_image));drawnow;
end

function idx = find_similar_color(sub_image,rgb)
thred = 20;
[m n] = size(sub_image(:,:,1));
diff_img = abs(sub_image - repmat(rgb,m,n));
idx = (diff_img(:,:,1)<thred) & (diff_img(:,:,1)<thred) & (diff_img(:,:,1)<thred);

function rgb = GetMainColorRGB(img)
rgb = zeros(1,3);
for i = 1 : 3
	rgb(i) = mean(mean(img(:,:,i)));
end
rgb = reshape(rgb,1,1,3);

function z = GetCircle_Idx(m)
[x y] = meshgrid(linspace(-1,1,m),linspace(-1,1,m));
z = (x.^2+y.^2)<=1;