classdef muscle_manager_class
    
    % This class contains properties and methods related to managing muscle objects.
    
    % Define the class properties.
    properties
        muscles
        num_muscles
        conversion_manager
    end
    
    % Define the class methods.
    methods
        
        % Implement the class constructor.
        function self = muscle_manager_class( IDs, names, activations, activation_domains, desired_total_tensions, desired_active_tensions, desired_passive_tensions, measured_total_tensions, measured_active_tensions, measured_passive_tensions, tension_domains, desired_pressures, measured_pressures, pressure_domains, lengths, resting_lengths, strains, max_strains, velocities, yanks, typeIa_feedbacks, typeIb_feedbacks, typeII_feedbacks, kses, kpes, bs, c0s, c1s, c2s, c3s, c4s, c5s, c6s, network_dt, num_int_steps )
            
            % Define the default class properties.
            if nargin < 35, num_int_steps = 10; end
            if nargin < 34, network_dt = 1e-3; end
            if nargin < 33, c6s = 1; end
            if nargin < 32, c5s = 1; end
            if nargin < 31, c4s = 1; end
            if nargin < 30, c3s = 1; end
            if nargin < 29, c2s = 1; end
            if nargin < 28, c1s = 1; end
            if nargin < 27, c0s = 1; end
            if nargin < 26, bs = 1; end
            if nargin < 25, kpes = 30; end
            if nargin < 24, kses = 30; end
            if nargin < 23, typeII_feedbacks = 0; end
            if nargin < 22, typeIb_feedbacks = 0; end
            if nargin < 21, typeIa_feedbacks = 0; end
            if nargin < 20, yanks = 0; end
            if nargin < 19, velocities = 0; end
            if nargin < 18, max_strains = 0; end
            if nargin < 17, strains = 0; end
            if nargin < 16, resting_lengths = 0; end
            if nargin < 15, lengths = 0; end
            if nargin < 14, pressure_domains = {[0, 90]}; end
            if nargin < 13, measured_pressures = 0; end
            if nargin < 12, desired_pressures = 0; end
            if nargin < 11, tension_domains = {[0, 450]}; end
            if nargin < 10, measured_passive_tensions = 0; end
            if nargin < 9, measured_active_tensions = 0; end
            if nargin < 8, measured_total_tensions = 0; end
            if nargin < 7, desired_passive_tensions = 0; end
            if nargin < 6, desired_active_tensions = 0; end
            if nargin < 5, desired_total_tensions = 0; end
            if nargin < 4, activation_domains = {[-0.050, -0.019]}; end
            if nargin < 3, activations = 0; end
            if nargin < 2, names = {''}; end
            if nargin < 1, IDs = 0; end
            
            % Determine the number of muscles that we want to create.
            self.num_muscles = length(IDs);
            
            % Ensure that we have the correct number of properties for each muscle.
            num_int_steps = self.validate_property( num_int_steps, 'num_int_steps' );
            network_dt = self.validate_property( network_dt, 'network_dt' );
            c6s = self.validate_property( c6s, 'c6s' );
            c5s = self.validate_property( c5s, 'c5s' );
            c4s = self.validate_property( c4s, 'c4s' );
            c3s = self.validate_property( c3s, 'c3s' );
            c2s = self.validate_property( c2s, 'c2s' );
            c1s = self.validate_property( c1s, 'c1s' );
            c0s = self.validate_property( c0s, 'c0s' );
            bs = self.validate_property( bs, 'bs' );
            kpes = self.validate_property( kpes, 'kpes' );
            kses = self.validate_property( kses, 'kses' );
            typeII_feedbacks = self.validate_property( typeII_feedbacks, 'typeII_feedbacks' );
            typeIb_feedbacks = self.validate_property( typeIb_feedbacks, 'typeIb_feedbacks' );
            typeIa_feedbacks = self.validate_property( typeIa_feedbacks, 'typeIa_feedbacks' );
            yanks = self.validate_property( yanks, 'yanks' );
            velocities = self.validate_property( velocities, 'velocities' );
            max_strains = self.validate_property( max_strains, 'max_strains' );
            strains = self.validate_property( strains, 'strains' );
            resting_lengths = self.validate_property( resting_lengths, 'resting_lengths' );
            lengths = self.validate_property( lengths, 'lengths' );
            pressure_domains = self.validate_property( pressure_domains, 'pressure_domains' );
            measured_pressures = self.validate_property( measured_pressures, 'measured_pressures' );
            desired_pressures = self.validate_property( desired_pressures, 'desired_pressures' );
            tension_domains = self.validate_property( tension_domains, 'tension_domains' );
            measured_passive_tensions = self.validate_property( measured_passive_tensions, 'measured_passive_tensions' );
            measured_active_tensions = self.validate_property( measured_active_tensions, 'measured_active_tensions' );
            measured_total_tensions = self.validate_property( measured_total_tensions, 'measured_total_tensions' );
            desired_passive_tensions = self.validate_property( desired_passive_tensions, 'desired_passive_tensions' );
            desired_active_tensions = self.validate_property( desired_active_tensions, 'desired_active_tensions' );
            desired_total_tensions = self.validate_property( desired_total_tensions, 'desired_total_tensions' );
            activation_domains = self.validate_property( activation_domains, 'activation_domains' );
            activations = self.validate_property( activations, 'activations' );
            names = self.validate_property( names, 'names' );
            IDs = self.validate_property( IDs, 'IDs' );
            
            % Preallocate an array of muscles.
            self.muscles = repmat( muscle_class(), 1, self.num_muscles );
            
            % Create each muscle object.
            for k = 1:self.num_muscles              % Iterate through each muscle...
                
                % Create this muscle.
                self.muscles(k) = muscle_class( IDs(k), names{k}, activations(k), activation_domains{k}, desired_total_tensions(k), desired_active_tensions(k), desired_passive_tensions(k), measured_total_tensions(k), measured_active_tensions(k), measured_passive_tensions(k), tension_domains{k}, desired_pressures(k), measured_pressures(k), pressure_domains{k}, lengths(k), resting_lengths(k), strains(k), max_strains(k), velocities(k), yanks(k), typeIa_feedbacks(k), typeIb_feedbacks(k), typeII_feedbacks(k), kses(k), kpes(k), bs(k), c0s(k), c1s(k), c2s(k), c3s(k), c4s(k), c5s(k), c6s(k), network_dt(k), num_int_steps(k) );
                
            end
            
            % Create an instance of the conversion manager class.
            self.conversion_manager = conversion_manager_class();
            
        end
        
        
        % Implement a function to validate the input properties.
        function x = validate_property( self, x, var_name )
            
            % Set the default variable name.
            if nargin < 3, var_name = 'properties'; end
            
            % Determine whether we need to repeat this property for each muscle.
            if length(x) ~= self.num_muscles                % If the number of instances of this property do not agree with the number of muscles...
                
                % Determine whether to repeat this property for each muscle.
                if length(x) == 1                               % If only one muscle property was provided...
                    
                    % Repeat the muscle property.
                    x = repmat( x, 1, self.num_muscles );
                    
                else                                            % Otherwise...
                    
                    % Throw an error.
                    error( 'The number of provided %s must match the number of muscles being created.', var_name )
                    
                end
                
            end
            
        end
        
        
        % Implement a function to retrieve the index associated with a given muscle ID.
        function muscle_index = get_muscle_index( self, muscle_ID )
            
            % Set a flag variable to indicate whether a matching muscle index has been found.
            bMatchFound = false;
            
            % Initialize the muscle index.
            muscle_index = 0;
            
            while (muscle_index < self.num_muscles) && (~bMatchFound)
                
                % Advance the muscle index.
                muscle_index = muscle_index + 1;
                
                % Check whether this muscle index is a match.
                if self.muscles(muscle_index).ID == muscle_ID                       % If this muscle has the correct muscle ID...
                    
                    % Set the match found flag to true.
                    bMatchFound = true;
                    
                end
                
            end
            
            % Determine whether a match was found.
            if ~bMatchFound                     % If a match was not found...
                
                % Throw an error.
                error('No muscle with ID %0.0f.', muscle_ID)
                
            end
            
        end
        
        
        % Implement a function to store given muscle activations into the muscle manager.
        function self = set_muscle_activations( self, muscle_IDs, muscle_activations )
            
            % Ensure that the number of muscle IDs matches the number of provided muscle activations.
            if length(muscle_IDs) ~= length(muscle_activations)                     % If the number of muscle IDs does not match the number of muscle activations...
                
                % Throw an error.
                error('The number of provided muscle IDs must match the number of provided muscle activations.')
                
            end
            
            % Retrieve the number of muscle activations.
            num_activations = length(muscle_activations);
            
            % Store each muscle activation in the appropriate muscle of the muscle manager.
            for k = 1:num_activations                   % Iterate through each muscle activation...
                
                % Determine the muscle index associated with this muscle ID.
                muscle_index = self.get_muscle_index( muscle_IDs(k) );
                
                % Saturate this motor neuron activation.
                self.muscles(muscle_index).activation = self.muscles(muscle_index).saturate_value( muscle_activations(k), self.muscles(muscle_index).activation_domain );
                
            end
            
        end
        
        
        % Implement a function to retrieve the properties of specific muscles.
        function xs = get_muscle_property( self, muscle_IDs, muscle_property )
            
            % Determine whether we want get the desired muscle property from all of the muscles.
            if isa(muscle_IDs, 'char')                                                      % If the muscle IDs variable is a character array instead of an integer srray...
                
                % Determine whether this is a valid character array.
                if  strcmp(muscle_IDs, 'all') || strcmp(muscle_IDs, 'All')                  % If the character array is either 'all' or 'All'...
                    
                    % Preallocate an array to store the muscle IDs.
                    muscle_IDs = zeros(1, self.num_muscles);
                    
                    % Retrieve the muscle ID associated with each muscle.
                    for k = 1:self.num_muscles                   % Iterate through each muscle...
                        
                        % Store the muscle ID associated with the current muscle ID.
                        muscle_IDs(k) = self.muscles(k).muscle_ID;
                        
                    end
                    
                else                                                                        % Otherwise...
                    
                    % Throw an error.
                    error('Muscle_IDs must be either an array of valid muscle IDs or one of the strings: ''all'' or ''All''.')
                    
                end
                
            end
            
            % Determine how many muscles to which we are going to apply the given method.
            num_properties_to_get = length(muscle_IDs);
            
            % Preallocate a variable to store the muscle properties.
            xs = zeros(1, num_properties_to_get);
            
            % Retrieve the given muscle property for each muscle.
            for k = 1:num_properties_to_get
                
                % Retrieve the index associated with this muscle ID.
                muscle_index = self.get_muscle_index( muscle_IDs(k) );
                
                % Define the eval string.
                eval_str = sprintf( 'xs(k) = self.muscles(%0.0f).%s;', muscle_index, muscle_property );
                
                % Evaluate the given muscle property.
                eval(eval_str);
                
            end
            
        end
        
        
        % Implement a function to that calls a specified muscle method for each of the specified muscles.
        function self = call_muscle_method( self, muscle_IDs, muscle_method )
            
            % Determine whether we want get the desired muscle property from all of the muscles.
            if isa(muscle_IDs, 'char')                                                      % If the muscle IDs variable is a character array instead of an integer srray...
                
                % Determine whether this is a valid character array.
                if  strcmp(muscle_IDs, 'all') || strcmp(muscle_IDs, 'All')                  % If the character array is either 'all' or 'All'...
                    
                    % Preallocate an array to store the muscle IDs.
                    muscle_IDs = zeros(1, self.num_muscles);
                    
                    % Retrieve the muscle ID associated with each muscle.
                    for k = 1:self.num_muscles                   % Iterate through each muscle...
                        
                        % Store the muscle ID associated with the current muscle ID.
                        muscle_IDs(k) = self.muscles(k).muscle_ID;
                        
                    end
                    
                else                                                                        % Otherwise...
                    
                    % Throw an error.
                    error('Muscle_IDs must be either an array of valid muscle IDs or one of the strings: ''all'' or ''All''.')
                    
                end
                
            end
            
            % Determine how many muscles to which we are going to apply the given method.
            num_muscles_to_evaluate = length(muscle_IDs);
            
            % Evaluate the given muscle method for each muscle.
            for k = 1:num_muscles_to_evaluate               % Iterate through each of the muscles of interest...
                
                % Retrieve the index associated with this muscle ID.
                muscle_index = self.get_muscle_index( muscle_IDs(k) );
                
                % Define the eval string.
                eval_str = sprintf( 'self.muscles(%0.0f) = self.muscles(%0.0f).%s();', muscle_index, muscle_index, muscle_method );
                
                % Evaluate the given muscle method.
                eval(eval_str);
                
            end
            
            
        end
        
        
        % Implement a function to set the measured pressures of the muscles.
        function self = set_measured_pressures( self, slave_manager )
            
            % Retrieve the IDs of each pressure sensor.
            pressure_IDs1 = slave_manager.get_slave_property( 'all', 'pressure_sensor_ID1' );
            pressure_IDs2 = slave_manager.get_slave_property( 'all', 'pressure_sensor_ID2' );

            % Retrieve only the unique pressure sensor IDs.
            pressure_IDs = unique( [ pressure_IDs1, pressure_IDs2 ] );
            
            % Determine the number of pressure sensors.
            num_pressure_sensors = length( pressure_IDs );
            
            % Preallocate an array to store the pressures.
            pressures = zeros(1, num_pressure_sensors);
            
            % Compute the pressure associated with each pressure sensor.
            for k = 1:num_pressure_sensors                              % Iterate through each pressure sensor.
                
                % Retrieve the indexes of the slaves that read this pressure sensor.
                slave_index1 = find( pressure_IDs1 == pressure_IDs(k) );
                slave_index2 = find( pressure_IDs2 == pressure_IDs(k) );

                % Retrieve the muscle ID associated with each of the slaves that read this pressure sensor.
                muscle_ID = slave_manager.slaves(slave_index1).muscle_ID;

                % Retrieve the muscle index associated with each of the muscle IDs associated with this pressure sensor.
                muscle_index = self.get_muscle_index( muscle_ID );
                
                % Retrieve the measured pressure values for this pressure sensor.
                pressure_value1_uint16 = slave_manager.slaves(slave_index1).measured_pressure_value1;
                pressure_value2_uint16 = slave_manager.slaves(slave_index2).measured_pressure_value2;

                % Convert the measured pressure values from uint16s to doubles.
                pressure_value1 = self.conversion_manager.uint162double( pressure_value1_uint16, self.muscles(muscle_index).pressure_domain );
                pressure_value2 = self.conversion_manager.uint162double( pressure_value2_uint16, self.muscles(muscle_index).pressure_domain );

                % Take the average pressure sensor reading from all of the pressure readings across possibly many slaves.
                pressures(k) = mean( [ pressure_value1, pressure_value2 ] );
                
                % Store the measured muscle pressure.
                self.muscles(muscle_index).measured_pressure = pressures(k);
                
            end
            
        end
        
        
        
%         % Implement a function to set the measured pressures of the muscles.
%         function self = set_measured_pressures( self, slave_manager )
%             
%             % Preallocate an array to store the pressures.
%             pressures = zeros(1, slave_manager.num_slaves);
%             
%             % Set the measured pressures for each slave / muscle pair.
%             for k = 1:slave_manager.num_slaves                  % Iterate through each slave...
%                 
%                 % Determine how to compute the muscle pressures.
%                 if mod(k, 2) == 1                   % If this slave is index is odd...
%                     
%                     % Get the muscle index for the muscles associated with this slave and the next slave.
%                     muscle_index1 = self.get_muscle_index( slave_manager.slaves(k).muscle_ID );
%                     muscle_index2 = self.get_muscle_index( slave_manager.slaves(k + 1).muscle_ID );
%                     
%                     % Store the muscle pressures associated with this slave.
%                     pressures(k) = self.conversion_manager.uint162double( slave_manager.slaves(k).measured_pressure_value1, self.muscles(muscle_index1).pressure_domain );
%                     pressures(k + 1) = self.conversion_manager.uint162double( slave_manager.slaves(k).measured_pressure_value2, self.muscles(muscle_index2).pressure_domain );
%                     
%                     
%                 else                                % Otherwise...
%                     
%                     % Get the muscle index for the muscles associated with this slave and the previous slave.
%                     muscle_index1 = self.get_muscle_index( slave_manager.slaves(k).muscle_ID );
%                     muscle_index2 = self.get_muscle_index( slave_manager.slaves(k - 1).muscle_ID );
%                     
%                     % Store the average of the pressures associated with this slave.
%                     pressures(k) = mean( [ pressures(k), self.conversion_manager.uint162double( slave_manager.slaves(k).measured_pressure_value1, self.muscles(muscle_index1).pressure_domain ) ] );
%                     pressures(k - 1) = mean( [ pressures(k - 1), self.conversion_manager.uint162double( slave_manager.slaves(k).measured_pressure_value2, self.muscles(muscle_index2).pressure_domain ) ] );
%                     
%                     % Store the muscle pressures.
%                     self.muscles(muscle_index1).measured_pressure = pressures(k);
%                     self.muscles(muscle_index2).measured_pressure = pressures(k - 1);
%                     
%                 end
%                 
%             end
%             
%             
%         end
        
        
        
        
        
        
        
        
        
        
        
        %         % Implement a function to compute the desired total muscle tensions associated with the activations of the constituent muscles.
        %         function self = activations2desired_total_tensions( self )
        %
        %             % Compute the desired total muscle tension associated with the current muscle activation for each muscle.
        %             for k = 1:self.num_muscles              % Iterate through each muscle...
        %
        %                 % Compute the desired total muscle tension associated with ths current muscle activation for this muscle.
        %                 self.muscles(k) = self.muscles(k).activation2desired_total_tension();
        %
        %             end
        %
        %         end
        %
        %
        %         % Implement a function to compute the desired active and desired passive muscle tension associated with the desired total muscle tension of the constituent muscles.
        %         function self = desired_total_tensions2desired_active_passive_tensions( self )
        %
        %             % Compute the desired active and desired passive muscle tension associated with the desired total muscle tension of the constituent muscles.
        %             for k = 1:self.num_muscles              % Iterate through each muscle...
        %
        %                 % Compute the desired total muscle tension associated with ths current muscle activation for this muscle.
        %                 self.muscles(k) = self.muscles(k).desired_total_tension2desired_active_passive_tension();
        %
        %             end
        %
        %         end
        
        
        
    end
end

