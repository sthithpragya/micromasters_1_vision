function nn=ReinforcementLearning
    % A full neural network based reinforcement learning pipeline
    %
    % Output:
    % - nn: a variable storing a neural network with the updated weights after full training.  

    %% Initial Parameters
    epsilon=0.5;  
    
    rows=7; cols=7;
    walls=[2 4; 3 4; 4 4; 5 4];
    cur_row=2; cur_col=1; rot_idx=1;

    %% Create A Start state
    start_S=MakeState(rows,cols,walls,cur_row,cur_col,rot_idx);
    
    %% Network Initialization
    load('RL_nn_500.mat');

    N=100;
    %% loop N times
    
    nn = InitializeNetwork([rows*cols 8]);

    for i=1:N

        %% Resetting to a start state
        S=start_S;
        cur_row=2; cur_col=1; rot_idx=1;
        
        while isGoal(S) ~= 1

            %% Picking action
            action= pickAction(S,cur_row,cur_col,rot_idx,nn,epsilon);

            %% Getting a reward
            reward= GetReward(S,cur_row,cur_col,rot_idx,action);

            %% Transitioning to a New State
            % - action: a scalar indicating a selected action
    %        (1-going down, 2-going right, 3-going up, 4-going left
    %        5-rotating to rotation position 1, 6-rotating to rotation position 2
    %        7-rotating to rotation position 3, 8-rotating to rotation position 4).
            %{
            if action >= 5
                new_rot_idx = action-4;
                new_row = cur_row;
                new_col = cur_col;
            else
                new_rot_idx = rot_idx;
                if action == 1
                    new_row = cur_row+1;
                    new_col = cur_col;
                elseif action == 2
                    new_row = cur_row;
                    new_col = cur_col + 1;
                elseif action == 3
                    new_row = cur_row - 1;
                    new_col = cur_col;
                else
                    new_row = cur_row;
                    new_col = cur_col - 1;
                end
            end
    %}
%             new_S = MakeState(rows,cols,walls,new_row,new_col,new_rot_idx);
            [new_S,new_rot_idx,new_row,new_col] = MakeNextState(S,cur_row,cur_col,rot_idx,action);

            %% Deep Q-Learning
            nn = DeepQLearning(action,reward,S,new_S,nn);
            
            %% Updating state and other variables

            S = new_S;
            cur_row= new_row;
            cur_col= new_col;
            rot_idx= new_rot_idx;
        end

    end
        
end
