function smallTest
axes('NextPlot', 'add')
H(1) = plot(1:10, rand(1, 10), 'r');
H(2) = plot(1:10, rand(1, 10), 'b');
set(H, 'ButtonDownFcn', {@LineSelected, H})

function LineSelected(ObjectH, EventData, H)
set(ObjectH, 'LineWidth', 2.5);
set(H(H ~= ObjectH), 'LineWidth', 0.5);
