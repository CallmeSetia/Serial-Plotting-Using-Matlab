% Hasil Riset
% print di matlab pakai fungsi disp()
% Note : array di matlab start dari 1 bukan 0, dan basisnya matriks
%         example : data[5] = [0,2,3,4,5];
%                   cara akses => data(1,1)


clear
clc
delete(instrfind)

s = serial('COM7','BaudRate', 9600); %start serial port to arduino
s.ReadAsyncMode = 'continuous';
s.InputBufferSize = 256;
s.DataBits = 8;
s.Parity = 'none'
s.StopBit = 1
s.FlowControl = 'hardware';  %jangan pake none agar tidak lambat
s.Timeout = 10


%======= PRINT INFO SERIAL ARDUINO ========%
disp(get(s, 'Name')) %tampilan untuk konfigurasi serial
prop(1)=(get(s, 'BaudRate'));
prop(2)=(get(s, 'DataBits'));
prop(3)=(get(s, 'StopBit'));
prop(4)=(get(s, 'InputBufferSize'));
disp(['Port Setup Done ', num2str(prop)])
%========================================%

fopen(s); %open port/baca serial
disp('start') %menampilkan tulisan “start”

%==== Setting PARAMETER PLOT ===== %
plotTitle = 'Arduino Data Log';  % plot title
xLabel = 'Elapsed Time (s)';     % x-axis label
yLabel = 'Data Sensor)';      % y-axis label

%Plot item, misal data ada 3. Sensor 1, 2,3. Cakupan tak hingga
legend1 = 'Motor 1 (RPM)';   
legend2 = 'Motor 2 (RPM)'; 
legend3 = 'Motor 3 (RPM)'; 
legend4 = 'Motor 4 (RPM)';

yMax  = 500                      %y Maximum Value
yMin  = 0                       %y minimum Value
plotGrid = 'on';                 % 'off' untuk hilang grid
min = 0;                         % set y-min
max = 500;                        % set y-max
delay = .50;                     % make sure sample faster than resolution 
%==========[END SETTING PLOT]===========%

%Define Function Variables
time = 0;

data = 0;
data1 = 0;
data2 = 0;
data3 = 0;

count = 0;


%Set up Plot
plotGraph = plot(time,data,'-r' )  % Plot Data0 - red
hold on                            % hold on => plot agar tetap akif
plotGraph1 = plot(time,data1,'-b') %plot data1 - blue
hold on  
plotGraph2 = plot(time, data2,'-g' ) %plot data2 -green
hold on  
plotGraph3 = plot(time, data3,'-g' ) %plot data2 -green
hold on  

title(plotTitle,'FontSize',15);

xlabel(xLabel,'FontSize',15);
ylabel(yLabel,'FontSize',15);

%legend(legend1,legend2,legend3)
legend(legend1)

axis([yMin yMax min max]);
grid(plotGrid);

tic

while ishandle(plotGraph) %Loop when Plot is Active will run until plot is closed
    while (s.Status == 'open')
        C=fscanf(s);
        c_str = regexp(C, '#', 'split') % Parsing #
        
        count = count + 1;    
        time(count) = toc;

        data(count) = str2double(c_str(1,1));    % Ambil Data Dari Arduino     
        data1(count) = str2double(c_str(1,2));
        data2(count) = str2double(c_str(1,3));  
        data3(count) = str2double(c_str(1,4));  


        
        set(plotGraph,'XData',time,'YData',data);
        set(plotGraph1,'XData',time,'YData',data1);
        set(plotGraph2,'XData',time,'YData',data2);
        set(plotGraph3,'XData',time,'YData',data3);
        
        axis([0 time(count) min max]);
        %Update the graph
        pause(delay);

        if(s.Status ~= 'open')
           break;
        end

    end
end
 
delete(a);

disp('Plot Closed and arduino object has been deleted');
  