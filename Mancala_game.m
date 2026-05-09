% Alyssa Rodriguez
%% ------------------- Final Project ---------------------
clc;
load('Mancala_Graphics.mat')

%% ------------------- Creating the board ----------------

% pit count to index
% cahnges to a 1D array its much simpler
%1-6 is the bottom
%7-13 top
board = [4 4 4 4 4 4 0 4 4 4 4 4 4 0];
% 12 pits here
pit_imgs = cell(11,1);
pit_imgs{1} = pit_empty;
pit_imgs{2} = pit1;
pit_imgs{3} = pit2;
pit_imgs{4} = pit3;
pit_imgs{5} = pit4;
pit_imgs{6} = pit5;
pit_imgs{7} = pit6;
pit_imgs{8} = pit7;
pit_imgs{9} = pit8;
pit_imgs{10} = pit9;
pit_imgs{11} = pit10_plus;

% Mancala stored images to index     
mancala_imgs = cell(13,1);
mancala_imgs{1} = mancala_empty;
mancala_imgs{2} = mancala1;
mancala_imgs{3} = mancala2;
mancala_imgs{4} = mancala3;
mancala_imgs{5} = mancala4;
mancala_imgs{6} = mancala5;
mancala_imgs{7} = mancala6;
mancala_imgs{8} = mancala7;
mancala_imgs{9} = mancala8;
mancala_imgs{10} = mancala9;
mancala_imgs{11} = mancala10;
mancala_imgs{12} = mancala11;
mancala_imgs{13} = mancala12_plus;



% variables outside of the while loop so they can be affected
game = true;

ai = 0;
while ai == 0 || ai > 2
    ai = input('Do you want to play aginst a friend(1) or the AI(2) please type a number: ');
end
current_player =  1;

% layout 2 rows 8 columns
while game == true
    % this defeats all of the stuff in the previous figures so that way i can
    % repaint the new image
    clf;
    
    %loop so img will change kinda similar to the pits
    % Right mancala
    count_left = board(7);
    img_left = min(count_left + 1, 13);
    mancala_left = subplot(2,8,[1,9]);
    imshow(mancala_imgs{img_left},'Parent',mancala_left)
    title('Player 2 Mancala')

    % left mancala
    count_right = board(14);
    img_right = min(count_right + 1, 13);
    mancala_right = subplot(2,8,[8,16]);
    imshow(mancala_imgs{img_right},'Parent',mancala_right)
    title('Player 1 Mancala')

    % ---- How this code works if it makes sense i had to like map this out ---
    % counts and marbles math so that way the image will change
    % don't screw this up bro
    % center pits makes sure the pits are in the center and that they are in
    % those boxes each image takes up one box
    % Start counts indexes the board array to exclude the mancala pits which
    % are 0's on the array 
    % box is so i don't have to type mutiput iterations of the same code and it
    % will update depingd on the count number which changes with the array
    % I have an if statement that allows for the count to go over 11 but have
    % the same image so its not capped but still retains the value
    center_pits = [2:7, 10:15];
    start_counts_pits = [fliplr(board(1:6)), (board(8:13))];
    pit_labels = {'P2-6', 'P2-5', 'P2-4', 'P2-3', 'P2-2', 'P2-1',...
        'P1-1', 'P1-2', 'P1-3', 'P1-4', 'P1-5', 'P1-6' };
    for box = 1:12
        
        pits = subplot(2,8,center_pits(box));
        
        counts_pits = start_counts_pits(box);
        img_num_pits = min(counts_pits + 1, 11);
        
        imshow(pit_imgs{img_num_pits}, 'Parent', pits)
        title(pit_labels{box})
    end
    
    %% ------------------- Turn System ------------------------
    
    if current_player == 1
        pick = input('Player 2 pick a pit (1-6): ');
        num = pick;
    elseif current_player == 2 && ai == 1
        pick = input('Player 1 pick a pit (1-6): ');
        num = pick + 7;
    elseif current_player == 3 && ai == 2
    pick = randi(6);
    while board(pick + 7) == 0
        pick = randi(6);
    end
    disp(['AI picked: ' num2str(pick)])
    disp('');
    num = pick + 7;  % AI plays on pits 8-13 like Player 1

end
   
    
    %% prevent empty pit move
    if board(num) == 0
        disp('Invalid move');
        continue;
    end
    
    %% ------------------- Distribute Stones ------------------------
    
    balls = board(num); %num = pit
    board(num) = 0; % reset the pit to 0
    
    index = num; % store pit num so it can be indexed and changed without affecting original value
    
    while balls > 0
            index = index + 1;
        
            if index > 14
                index = 1;
            end
        
            % skip opponent mancala
            if current_player == 1 && index == 14
                continue;
            end
            if current_player == 2 && index == 7
                continue;
            end
            if current_player == 3 && index == 7
                continue;
            end
            board(index) = board(index) + 1;
            balls = balls - 1;
        %% ----------------- Capture Function ----------------------
            if balls == 0 && board(index) == 1
                 % player 2
                if current_player == 1 && index >= 1 && index <= 6
        
                    %index the opposing sides to be able to steal
                    if index == 1
                        cap = 13;
                    elseif index == 2
                        cap = 12;
                    elseif index == 3
                        cap = 11;
                    elseif index == 4
                        cap = 10;
                    elseif index == 5
                        cap = 9;
                    elseif index == 6
                        cap = 8;
                    end
                    disp('Capture!');
                    steal = board(cap);
                    board(cap) = 0;
                    board(index) = 0;
                    board(7) = board(7) + steal + 1;
                
        
                    
        %player 1
                elseif (current_player == 2 || current_player == 3) && index >= 8 && index <= 13
        
                    if index == 8
                        cap = 6;
                    elseif index == 9
                        cap = 5;
                    elseif index == 10
                        cap = 4;
                    elseif index == 11
                        cap = 3;
                    elseif index == 12
                        cap = 2;
                    elseif index == 13
                        cap = 1;
                    end
                    disp('Capture!');
                    steal = board(cap);
                    board(cap) = 0;
                    board(index) = 0;
                    board(14) = board(14) + steal + 1;

                    % end of the capture else if
                    % makes the players = 0
                    
                 end
                 
            end
        end
        
        %% ------------------- Switch Player ------------------------
        
        if (current_player == 1 && index == 7) || (current_player == 2 && index == 14) || (current_player == 3 && index == 14)
    % free turn, don't switch
        else
             if current_player == 1
                 if ai == 2
                            current_player = 3;  % switch to AI
                 else
                            current_player = 2;  % switch to Player 1
                 end
             elseif current_player == 2 || current_player == 3
                    current_player = 1;  % always go back to Player 2 (human)
             end
         end
        % Check for game over condition
        
        if all(board(1:6) == 0) || all(board(8:13) == 0)
            game = false; % End the game if one player has no stones left
            disp('Game Over');
        end
        disp(board)
end   