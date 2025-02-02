clear; clc; clf;
%% Importing data
load("C:\Users\lphoo\MATLAB Drive\Train Smart\Sensor Logs\COM_MaxHRTest_4HZ_1354_till_1409.mat");

time = Allvariables.Timestamp;
accel = [Allvariables.Mat_Acc_X, Allvariables.Mat_Acc_Y, Allvariables.Mat_Acc_Z];
gyro = [Allvariables.Mat_AV_X Allvariables.Mat_AV_Y Allvariables.Mat_AV_Z];
orient = quaternion([Allvariables.Mat_Pitch Allvariables.Mat_Roll Allvariables.Mat_Azimuth], 'rotvec');

deltaTimes = seconds(diff(time));
sampleRate = 1/mean(deltaTimes);

Orientation estimation

loggedOrient = conj(orient);

filt = imufilter('SampleRate', sampleRate);
estOrient = filt(accel, gyro);

%% IMU + GPS

% refloc = [51.923340000000000 41.431000000000000 4.439660000000000];
% imuFs = 4;
% gpsFs = 4;
% 
% fusionfilt = insfilter;
% fusionfilt.IMUSampleRate = imuFs;
% fusionfilt.ReferenceLocation = refloc;
% 
% % Load the "ground truth" UAV trajectory.
% load LoggedQuadcopter.mat trajData;
% trajOrient = trajData.Orientation;
% trajVel = trajData.Velocity;
% trajPos = trajData.Position;
% trajAcc = trajData.Acceleration;
% trajAngVel = trajData.AngularVelocity;
% 
% gps = gpsSensor('UpdateRate', gpsFs);
% gps.ReferenceLocation = refloc;
% gps.DecayFactor = 0.5;              % Random walk noise parameter
% gps.HorizontalPositionAccuracy = 1.6;
% gps.VerticalPositionAccuracy =  1.6;
% gps.VelocityAccuracy = 0.1;
% 
% imu = imuSensor('accel-gyro-mag', 'SampleRate', imuFs);
% imu.MagneticField = [0 0 0];
% 
% % Accelerometer
% imu.Accelerometer.MeasurementRange =  19.6133;
% imu.Accelerometer.Resolution = 0.0023928;
% imu.Accelerometer.ConstantBias = 0.19;
% imu.Accelerometer.NoiseDensity = 0.0012356;
% 
% % Gyroscope
% imu.Gyroscope.MeasurementRange = deg2rad(250);
% imu.Gyroscope.Resolution = deg2rad(0.0625);
% imu.Gyroscope.ConstantBias = deg2rad(3.125);
% imu.Gyroscope.AxesMisalignment = 1.5;
% imu.Gyroscope.NoiseDensity = deg2rad(0.025);
% 
% % Magnetometer
% imu.Magnetometer.MeasurementRange = 1000;
% imu.Magnetometer.Resolution = 0.1;
% imu.Magnetometer.ConstantBias = 100;
% imu.Magnetometer.NoiseDensity = 0.3/ sqrt(50);
% 
% % Initialize the states of the filter
% initstate = zeros(22,1);
% initstate(1:4) = compact( meanrot(trajOrient(1:100)));
% initstate(5:7) = mean( trajPos(1:100,:), 1);
% initstate(8:10) = mean( trajVel(1:100,:), 1);
% initstate(11:13) =  imu.Gyroscope.ConstantBias./imuFs;
% initstate(14:16) =  imu.Accelerometer.ConstantBias./imuFs;
% initstate(17:19) =  imu.MagneticField;
% initstate(20:22) = imu.Magnetometer.ConstantBias;
% 
% % Measurement noises
% Rmag = 0.09; % Magnetometer measurement noise
% Rvel = 0.01; % GPS Velocity measurement noise
% Rpos = 2.56; % GPS Position measurement noise
% 
% % Process noises
% fusionfilt.AccelerometerBiasNoise =  2e-4;
% fusionfilt.AccelerometerNoise = 2;
% fusionfilt.GyroscopeBiasNoise = 1e-16;
% fusionfilt.GyroscopeNoise =  1e-5;
% fusionfilt.MagnetometerBiasNoise = 1e-10;
% fusionfilt.GeomagneticVectorNoise = 1e-12;
% 
% % Initial error covariance
% fusionfilt.StateCovariance = 1e-9*ones(22);
% 
% %% Scopes
% 
% useErrScope = false;  % Turn on the streaming error plot
% usePoseView = false;  % Turn on the 3-D pose viewer
% 
% if useErrScope
%     errscope = HelperScrollingPlotter(...
%         'NumInputs', 4, ...
%         'TimeSpan', 10, ...
%         'SampleRate', imuFs, ...
%         'YLabel', {'degrees', ...
%         'meters', ...
%         'meters', ...
%         'meters'}, ...
%         'Title', {'Quaternion Distance', ...
%         'Position X Error', ...
%         'Position Y Error', ...
%         'Position Z Error'}, ...
%         'YLimits', ...
%         [ -1, 1
%         -2, 2
%         -2 2
%         -2 2]);
% end
% 
% if usePoseView
%     posescope = HelperPoseViewer(...
%         'XPositionLimits', [-15 15], ...
%         'YPositionLimits', [-15, 15], ...
%         'ZPositionLimits', [-10 10]);
% 
% end
% 
% % Loop setup - |trajData| has about 142 seconds of recorded data.
% secondsToSimulate = 50; % simulate about 50 seconds
% numsamples = secondsToSimulate*imuFs;
% 
% loopBound = floor(numsamples);
% loopBound = floor(loopBound/imuFs)*imuFs; % ensure enough IMU Samples
% 
% % Log data for final metric computation.
% pqorient = quaternion.zeros(loopBound,1);
% pqpos = zeros(loopBound,3);
% 
% fcnt = 1;
% 
% while(fcnt <=loopBound)
%     % |predict| loop at IMU update frequency.
%     for ff=1:imuSamplesPerGPS
%         % Simulate the IMU data from the current pose.
%         [accel, gyro, mag] = imu(trajAcc(fcnt,:), trajAngVel(fcnt, :), ...
%             trajOrient(fcnt));
% 
%         % Use the |predict| method to estimate the filter state based
%         % on the simulated accelerometer and gyroscope signals.
%         predict(fusionfilt, accel, gyro);
% 
%         % Acquire the current estimate of the filter states.
%         [fusedPos, fusedOrient] = pose(fusionfilt);
% 
%         % Save the position and orientation for post processing.
%         pqorient(fcnt) = fusedOrient;
%         pqpos(fcnt,:) = fusedPos;
% 
%         % Compute the errors and plot.
%         if useErrScope
%             orientErr = rad2deg(dist(fusedOrient, ...
%                 trajOrient(fcnt) ));
%             posErr = fusedPos - trajPos(fcnt,:);
%             errscope(orientErr, posErr(1), posErr(2), posErr(3));
%         end
% 
%         % Update the pose viewer.
%         if usePoseView
%             posescope(pqpos(fcnt,:), pqorient(fcnt),  trajPos(fcnt,:), ...
%                 trajOrient(fcnt,:) );
%         end
%         fcnt = fcnt + 1;
%     end
% 
%     % This next step happens at the GPS sample rate.
%     % Simulate the GPS output based on the current pose.
%     [lla, gpsvel] = gps( trajPos(fcnt,:), trajVel(fcnt,:) );
% 
%     % Correct the filter states based on the GPS data and magnetic
%     % field measurements.
%     fusegps(fusionfilt, lla, Rpos, gpsvel, Rvel);
%     fusemag(fusionfilt, mag, Rmag);
% 
% end
% 
% posd = pqpos(1:loopBound,:) - trajPos( 1:loopBound, :);
% 
% % For orientation, quaternion distance is a much better alternative to
% % subtracting Euler angles, which have discontinuities. The quaternion
% % distance can be computed with the |dist| function, which gives the
% % angular difference in orientation in radians. Convert to degrees
% % for display in the command window.
% 
% quatd = rad2deg(dist(pqorient(1:loopBound), trajOrient(1:loopBound)) );
% 
% % Display RMS errors in the command window.
% fprintf('\n\nEnd-to-End Simulation Position RMS Error\n');
% msep = sqrt(mean(posd.^2));
% fprintf('\tX: %.2f , Y: %.2f, Z: %.2f   (meters)\n\n',msep(1), ...
%     msep(2), msep(3));
% 
% fprintf('End-to-End Quaternion Distance RMS Error (degrees) \n');
% fprintf('\t%.2f (degrees)\n\n', sqrt(mean(quatd.^2)));

%% Visual Representation
% figure
% subplot(2, 1, 1) 
% plot(time, eulerd(loggedOrient, 'ZYX', 'frame'), '--')
% title('Logged Euler Angles')
% ylabel('\circ') % Degrees symbol.
% legend('z-axis', 'y-axis', 'x-axis')
% subplot(2, 1, 2)
% plot(time, eulerd(estOrient, 'ZYX', 'frame'))
% title('|imufilter| Euler Angles')
% ylabel('\circ') % Degrees symbol.
% legend('z-axis', 'y-axis', 'x-axis')

