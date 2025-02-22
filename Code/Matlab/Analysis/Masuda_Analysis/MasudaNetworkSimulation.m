%% Masuda Network Simulation

% This script simulates the Masuda network.

% Clear Everything.
clear, close('all'), clc


%% Define Neuron Properties.

% Define the number of neurons.
num_neurons = 6;

% Define Hip Extensor Motor Neuron Properties (Neuron 1).
Cm1 = 5e-9;                     % [C] Membrane Capacitance.
Gm1 = 1e-6;                     % [S] Membrane Conductance.
Er1 = -60e-3;                   % [V] Membrane Resting (Equilibrium) Potential.
R1 = 20e-3;                     % [V] Biphasic Equilibrium Voltage Range.

% Define Hip Flexor Motor Neuron Properties (Neuron 2).
Cm2 = 5e-9;                     % [C] Membrane Capacitance.
Gm2 = 1e-6;                     % [S] Membrane Conductance.
Er2 = -60e-3;                   % [V] Membrane Resting (Equilibrium) Potential.
R2 = 20e-3;                     % [V] Biphasic Equilibrium Voltage Range.

% Define Knee Extensor Motor Neuron Properties (Neuron 3).
Cm3 = 5e-9;                     % [C] Membrane Capacitance.
Gm3 = 1e-6;                     % [S] Membrane Conductance.
Er3 = -60e-3;                   % [V] Membrane Resting (Equilibrium) Potential.
R3 = 20e-3;                     % [V] Biphasic Equilibrium Voltage Range.

% Define Knee Flexor Motor Neuron Properties (Neuron 4).
Cm4 = 5e-9;                     % [C] Membrane Capacitance.
Gm4 = 1e-6;                     % [S] Membrane Conductance.
Er4 = -60e-3;                   % [V] Membrane Resting (Equilibrium) Potential.
R4 = 20e-3;                     % [V] Biphasic Equilibrium Voltage Range.

% Define Hip Feedback Neuron Properties (Neuron 5).
Cm5 = 5e-9;                     % [C] Membrane Capacitance.
Gm5 = 1e-6;                     % [S] Membrane Conductance.
Er5 = -60e-3;                   % [V] Membrane Resting (Equilibrium) Potential.
R5 = 20e-3;                     % [V] Biphasic Equilibrium Voltage Range.

% Define Knee Feedback Neuron Properties (Neuron 6).
Cm6 = 5e-9;                     % [C] Membrane Capacitance.
Gm6 = 1e-6;                     % [S] Membrane Conductance.
Er6 = -60e-3;                   % [V] Membrane Resting (Equilibrium) Potential.
R6 = 20e-3;                     % [V] Biphasic Equilibrium Voltage Range.

% Store the neuron properties into arrays.
Cms = [Cm1; Cm2; Cm3; Cm4; Cm5; Cm6];
% Cms = 5e-9*ones(num_neurons, 1);
Gms = [Gm1; Gm2; Gm3; Gm4; Gm5; Gm6];
Ers = [Er1; Er2; Er3; Er4; Er5; Er6];
Rs = [R1; R2; R3; R4; R5; R6]; Rs = repmat(Rs', [num_neurons, 1]);


%% Define Applied Current Magnitudes.

% Compute the necessary applied current magnitudes.
Iapp1 = 0;                      % [A] Applied Current.
Iapp2 = Gm2*R2;                % [A] Applied Current.
Iapp3 = 0;                      % [A] Applied Current.
Iapp4 = Gm4*R4;                % [A] Applied Current.
Iapp5 = Gm5*R5;                % [A] Applied Current.
Iapp6 = Gm6*R6;                % [A] Applied Current.


%% Define Synapse Properties.

% Define synapse reversal potentials.
dEsyn61 = 2*R1;              % [V] Synapse Reversal Potential.
dEsyn64 = -2*R4;             % [V] Synapse Reversal Potential.
dEsyn52 = -2*R2;             % [V] Synapse Reversal Potential.
dEsyn53 = 2*R3;              % [V] Synapse Reversal Potential.

% Compute the synapse conductances.
gsyn61_max = Gm1*R1/(dEsyn61 - R1);
gsyn64_max = -Iapp4/dEsyn64;
gsyn52_max = -Iapp2/dEsyn52;
gsyn53_max = Gm3*R3/(dEsyn53 - R3);

% Store the synapse properties into arrays.
dEsyns = zeros(num_neurons, num_neurons); dEsyns(1, 6) = dEsyn61; dEsyns(4, 6) = dEsyn64; dEsyns(2, 5) = dEsyn52; dEsyns(3, 5) = dEsyn53;
gsyn_maxs = zeros(num_neurons, num_neurons); gsyn_maxs(1, 6) = gsyn61_max; gsyn_maxs(4, 6) = gsyn64_max; gsyn_maxs(2, 5) = gsyn52_max; gsyn_maxs(3, 5) = gsyn53_max;


%% Define Simulation Properties.

% Set the simulation time.
tf = 1;         % [s] Simulation Duration.
dt = 1e-3;      % [s] Simulation Time Step.

% Compute the simulation time vector.
ts = 0:dt:tf;

% Compute the number of time steps.
num_timesteps = length(ts);

% Set the network initial conditions.
Us0 = zeros(num_neurons, 1);

% Define the number of cycles.
num_cycles = 5;

% Define the applied currents over time.
Iapp1s = Iapp1*ones(1, num_timesteps);
Iapp2s = Iapp2*ones(1, num_timesteps);
Iapp3s = Iapp3*ones(1, num_timesteps);
Iapp4s = Iapp4*ones(1, num_timesteps);
Iapp5s = zeros(1, num_timesteps);
Iapp6s = zeros(1, num_timesteps);
% Iapp5s = Iapp5*ones(1, num_timesteps);
% Iapp6s = Iapp6*ones(1, num_timesteps);
% Iapp5s = (Iapp5/2)*(1 + sin(2*pi*num_cycles*ts));
% Iapp6s = (Iapp6/2)*(1 + sin(2*pi*num_cycles*ts));

% Store the applied currents into arrays.
Iapps = [Iapp1s; Iapp2s; Iapp3s; Iapp4s; Iapp5s; Iapp6s];


%% Simulate the Network

% Simulate the network.
[ts, Us, dUs, Gs, Ileaks, Isyns, Itotals] = SimulateNetworkNoNa(Us0, Gms, Cms, Rs, gsyn_maxs, dEsyns, Iapps, tf, dt);


%% Plot the Network Membrane Voltages.

% Plot the network membranve voltage vs time.
fig_U = figure('Color', 'w', 'Name', 'Network Voltages vs Time');
subplot(2, 1, 1), hold on, grid on, xlabel('Time [s]'), ylabel('Membrane Voltage, $U$ [V]', 'Interpreter', 'Latex'), title('Membrane Voltage vs Time') , plot(ts, Us, '-', 'Linewidth', 3)
subplot(2, 1, 2), hold on, grid on, xlabel('Time [s]'), ylabel('Membrane Voltage Derivative, $\dot{U}$ [V/s]', 'Interpreter', 'Latex'), title('Membrane Voltage Derivative vs Time') , plot(ts(1:end-1), dUs(:, 1:end-1), '-', 'Linewidth', 3)
legend('Hip Ext MN', 'Hip Flx MN', 'Knee Ext MN', 'Knee Flx MN', 'Hip Ext Ib', 'Knee Ext Ib')


%% Plot the Network Currents

fig_I = figure('Color', 'w', 'Name', 'Network Currents vs Time');
subplot(4, 1, 1), hold on, grid on, xlabel('Time [s]'), ylabel('Leak Current, $I_{leak}$ [A]', 'Interpreter', 'Latex'), title('Leak Current vs Time'), plot(ts(1:end-1), Ileaks(:, 1:end-1), '-', 'Linewidth', 3)
subplot(4, 1, 2), hold on, grid on, xlabel('Time [s]'), ylabel('Synaptic Current, $I_{syn}$ [A]', 'Interpreter', 'Latex'), title('Synaptic Current vs Time'), plot(ts(1:end-1), Isyns(:, 1:end-1), '-', 'Linewidth', 3)
subplot(4, 1, 3), hold on, grid on, xlabel('Time [s]'), ylabel('Applied Current, $I_{app}$ [A]', 'Interpreter', 'Latex'), title('Applied Current vs Time'), plot(ts(1:end-1), Iapps(:, 1:end-1), '-', 'Linewidth', 3)
subplot(4, 1, 4), hold on, grid on, xlabel('Time [s]'), ylabel('Total Current, $I_{total}$ [A]', 'Interpreter', 'Latex'), title('Total Current vs Time'), plot(ts(1:end-1), Itotals(:, 1:end-1), '-', 'Linewidth', 3)
legend({'Hip Ext MN', 'Hip Flx MN', 'Knee Ext MN', 'Knee Flx MN', 'Hip Ext Ib', 'Knee Ext Ib'}, 'Location', 'Southoutside', 'Orientation', 'Horizontal')


