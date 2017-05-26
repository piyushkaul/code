function show_mnist(digit, index, m, n)
load mnist_all.mat
trainstruct = eval(['train' num2str(digit)]);
figure;
minix = min(index);
for ix=index
    im=reshape(trainstruct(ix,:),28,28);
    subplot(m,n,ix-minix+1); subimage(im');
    axis off;
end 
