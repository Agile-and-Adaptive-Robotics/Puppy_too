%% BPA Force & Length Requirements (Version 2)

% Clear everything.
clear, close('all'), clc

%% Define the Limb Properties.

% Define the limb mass.
m = 1;                  % [kg] Mass of the Limb.

% Define the gravitational constant.
g = 9.81;               % [m/s^2] Gravitational Constant.

% Define the Joint Geometry.
L_limb = 0.0254*8.25;        % [m] Limb Length.

% x20 = 0.0254*0.4309;    % [m] x Distance to Tendon Attachment Point in Home Position.  Decreasing x20 decreases T.
% y20 = 0.0254*0.361568;  % [m] y Distance to Tendon Attachment Point in Home Position.  Should be between 0.4 and 0.5.  Too low of a value causes a infinite spike within the operating domain.  Too high of a value increases the maximum required pressure to start.
% 
% x30 = 0.0254*0.604432;  % [m] x Distance to the Pulley Point.  Decreasing x30 decreases T.
% y30 = 0.0254*0.680268;  % [m] y Distance to the Pulley Point.  Increasing y30 decreases T.

x20 = 0.0254*0.40;    % [m] x Distance to Tendon Attachment Point in Home Position.  Decreasing x20 decreases T.
y20 = 0.0254*0.40;  % [m] y Distance to Tendon Attachment Point in Home Position.  Should be between 0.4 and 0.5.  Too low of a value causes a infinite spike within the operating domain.  Too high of a value increases the maximum required pressure to start.

x30 = 0.0254*0.65;  % [m] x Distance to the Pulley Point.  Decreasing x30 decreases T.
y30 = 0.0254*0.70;  % [m] y Distance to the Pulley Point.  Increasing y30 decreases T.

% Compute the Distance to the Center of Mass of the Limb.
x40 = L_limb/2;              % [m] x Distance to the Center of Mass of the Limb in the Home Position.

% Define the muscle properties.
L_muscle = 0.0254*7.28125;      % [m] Resting muscle length.
% L_muscle = 0.0254*4.0;      % [m] Resting muscle length.
L_min = (1 - 0.16)*L_muscle;    % [m] Muscle length at maximum contraction.

% a0 = 254.3;                     % [kPa]
% a1 = 192.0;                     % [kPa]
% a2 = 2.0265;                    % [-]
% a3 = -0.461;                    % [-]
% a4 = -0.331;                    % [1/mN]
% a5 = 1.230;                     % [kPa/mN]
% a6 = 15.6;                      % [kPa]

a0 = 254.3e2;                     % [Pa]
a1 = 192.0e2;                     % [Pa]
a2 = 2.0265;                    % [-]
a3 = -0.461;                    % [-]
a4 = -0.331e-3;                    % [1/N]
a5 = 6.5e3/53;                     % [Pa/N]
a6 = 1.5e3;                      % [Pa]

S = 0;                          % [-]

% Compute the maximum muscle strain.
epsilon_max = (L_muscle - L_min)/L_muscle;


%% Compute the Positions of Important Points on the Joint in the Home Position.

% Compute the positions.
P10 = [0; 0; 0];                % [m] Position of the joint center of rotation in the home position.
P20 = P10 + [-x20; y20; 0];     % [m] Position of the tendon attachment point in the home position.
P30 = P10 + [x30; y30; 0];      % [m] Position of the pulley point in the home position.
P40 = P10 + [-x40; 0; 0];       % [m] Position of the center of mass in the home position.
P50 = P10 + [x30; 0; 0];        % [m] Position of point under the pulley in the home position.
P60 = P10 + [-x20; 0; 0];       % [m] Position of point under the tendon attachment point in the home position.
P70 = P10 + [-L_limb; 0; 0];         % [m] Position of the end of the limb in the home position.


%% Compute the Positions of Important Points Throughout the Joint Range of Motion.

% Define an anonymous function that generates a rotation matrix.
fR = @(x) [cos(x) -sin(x) 0; sin(x) cos(x) 0; 0 0 1];

% Define the number of angles of interest.
num_thetas = 1000;

% Define the angles of interest.
thetas = linspace(0, pi/2, num_thetas);
% thetas = linspace(0, 3*pi/4, num_thetas);

% Define arrays to store the points of interest.
[P1s, P2s, P3s, P4s, P5s, P6s, P7s] = deal( zeros(3, num_thetas) );

% Create an array to store the angle between the tendon and limb.
[phis, Ts, Ls] = deal( zeros(1, num_thetas) );

% Create a flag variable to determine whether to switch the phi sign.
bSwitched = false; 

% Create a flag variable to set the sign of the phi angle.
sign = 1;
% sign = -1;

% Compute the positions of the important points.
for k = 1:num_thetas
    
    % Compute the rotation matrix associated with this iteration.
    R = fR(thetas(k));
    
    % Compute the location of each of the important points for this iteration.
    P1s(:, k) = P10; P2s(:, k) = R*P20; P3s(:, k) = P30; P4s(:, k) = R*P40; P5s(:, k) = P50; P6s(:, k) = R*P60; P7s(:, k) = R*P70;
    
    % Compute the the vectors between some of the points of interest.
    P21 = P2s(:, k) - P1s(:, k); P41 = P4s(:, k) - P1s(:, k);
    P32 = P3s(:, k) - P2s(:, k); P14 = P1s(:, k) - P4s(:, k);
    
    % Compute the length of the tendon.
    Ls(k) = norm(P32);
    
    % Compute the angle of the tendon relative to the limb.
    phis(k) = sign*acos(dot(P32, P14)/(norm(P32)*norm(P14)));
    
    % Determine whether to switch the sign of the phi angle.
    if ~bSwitched && (k > 1) && (phis(k) - phis(k - 1) > 0)             % Based on the geometry, we know that the phi angle should start positive and then become negative.
       
        % Switch the sign of this angle.
        phis(k) = - phis(k);
        
        % Switch the sign of future phi angles to be negative.
        sign = -1;
        
    end
    
    % Compute the force required to lift the limb throughout the range of motion.
    Ts(k) = m*g*x40*cos(thetas(k))/(y20*cos(phis(k)) + x20*sin(phis(k)));
    
end

% Compute the required contraction length throughout the range of motion.
deltaLs = max(Ls) - Ls;         % [m] Required contraction length of the muscle throughout the range of motion.

% Compute the muscle strain with respect to the resting muscle length throughout the range of motion.
epsilons = deltaLs/L_muscle;

% Compute the BPA pressure required to lift the limb throughout the range of motion.
Ps = a0 + a1*tan( a2*(epsilons./(a4*Ts + epsilon_max)) + a3 ) + a5*Ts + a6*S;



%% Plot Variables of Interest Over the Range of Motion.

% Plot the tendon to limb angle over the range of motion.
fig = figure('color', 'w'); hold on, grid on
xlabel('Joint Angle, $\theta$ [deg]', 'Interpreter', 'Latex'), ylabel('Tendon-Limb Angle, $\phi$ [deg]', 'Interpreter', 'Latex'), title('Tendon-Limb Angle vs Joint Angle')
plot((180/pi)*thetas, (180/pi)*phis, '-', 'Linewidth', 3)

% Plot the tendon length over the range of motion.
fig = figure('color', 'w'); hold on, grid on
xlabel('Joint Angle, $\theta$ [deg]', 'Interpreter', 'Latex'), ylabel('Tendon Length, $L$ [in]', 'Interpreter', 'Latex'), title('Tendon Length vs Joint Angle')
plot((180/pi)*thetas, 39.3701*Ls, '-', 'Linewidth', 3)

% Plot the change in muscle length over the range of motion.
fig = figure('color', 'w'); hold on, grid on
xlabel('Joint Angle, $\theta$ [deg]', 'Interpreter', 'Latex'), ylabel('Change in Muscle Length, $\Delta L$ [in]', 'Interpreter', 'Latex'), title('Change in Muscle Length vs Joint Angle')
plot((180/pi)*thetas, 39.3701*deltaLs, '-', 'Linewidth', 3)

% Plot the muscle strain over the range of motion.
fig = figure('color', 'w'); hold on, grid on
xlabel('Joint Angle, $\theta$ [deg]', 'Interpreter', 'Latex'), ylabel('Muscle Strain, $\epsilon$ [-]', 'Interpreter', 'Latex'), title('Muscle Strain vs Joint Angle')
plot((180/pi)*thetas, epsilons, '-', 'Linewidth', 3)

% Plot the force required to lift the limb over the range of motion.
fig = figure('color', 'w'); hold on, grid on
xlabel('Joint Angle, $\theta$ [deg]', 'Interpreter', 'Latex'), ylabel('Required Force, $T$ [lbs]', 'Interpreter', 'Latex'), title('Tension vs Joint Angle')
plot((180/pi)*thetas, Ts/4.4482216282509, '-', 'Linewidth', 3)

% Plot the required BPA pressure over the range of motion.
fig = figure('color', 'w'); hold on, grid on
xlabel('Joint Angle, $\theta$ [deg]', 'Interpreter', 'Latex'), ylabel('Muscle Pressure, $P$ [psi]', 'Interpreter', 'Latex'), title('Muscle Pressure vs Joint Angle')
plot((180/pi)*thetas, 0.000145038*Ps, '-', 'Linewidth', 3)



%% Animate the Joint Through the Specified Range of Motion.

% Define the number of times to play the animation.
N = 1;

% Create a figure to store the animation.
fig = figure('color', 'w'); hold on
axis([-0.21, 0.05, -0.21, 0.05])
% axis([-0.21, 0.21, -0.21, 0.21])

ts = linspace(pi, 3*pi/2, 100);
xs_circle = L_limb*cos(ts); ys_circle = L_limb*sin(ts);
plot(xs_circle, ys_circle, '--', 'Linewidth', 3)

% Define the structure in the home position.
P0s = [P30 P50 P10 P60 P20 P60 P40 P70];

% Initialize the data source variables.
xs_limb = P0s(1, :); ys_limb = P0s(2, :);

% Plot the initial structure.
h_limb = plot(xs_limb, ys_limb, '-', 'Linewidth', 3, 'XDataSource', 'xs_limb', 'YDataSource', 'ys_limb');

for j = 1:N
    
    % Animate the structure through the range of motion.
    for k = 1:num_thetas        % Iterate through each of the frames...
        
        % Retrieve the points of the structure associated with the current animation frame.
        Ps = [P3s(:, k) P5s(:, k) P1s(:, k) P6s(:, k) P2s(:, k) P6s(:, k) P4s(:, k) P7s(:, k)];
        
        % Update the data source variables.
        xs_limb = Ps(1, :); ys_limb = Ps(2, :);
        
        % Update the plot with the new frame.
        refreshdata(h_limb, 'caller'), drawnow()
                
    end
    
end


