function [su,id] = makesudoku

% Make a puzzle ID
id = randi([1 100000],1);
id = sprintf('%06d',id);

% Resources
map = 1:9;

jad = [1 1 1 2 2 2 3 3 3;
    1 1 1 2 2 2 3 3 3;
    1 1 1 2 2 2 3 3 3;
    4 4 4 5 5 5 6 6 6;
    4 4 4 5 5 5 6 6 6;
    4 4 4 5 5 5 6 6 6;
    7 7 7 8 8 8 9 9 9;
    7 7 7 8 8 8 9 9 9;
    7 7 7 8 8 8 9 9 9;];

% Start grid generation.
restart=0;
while restart==0
    
    % Diagonal grids are independent. Make them completely random.
    ul = randperm(9,9);
    ul = [ul(1:3); ul(4:6); ul(7:9)];   % Make a 3x3 matrix.
    mm = randperm(9,9);
    mm = [mm(1:3); mm(4:6); mm(7:9)];   % Make a 3x3 matrix.
    lr = randperm(9,9);
    lr = [lr(1:3); lr(4:6); lr(7:9)];   % Make a 3x3 matrix.
    
    % Fit into a 9x9 matrix.
    su = zeros(9,9);
    su(1:3,1:3) = ul;
    su(4:6,4:6) = mm;
    su(7:9,7:9) = lr;
    
    % Make UR. Dependent on UL and LR.
    valid=0;
    while valid==0
        ur = zeros(3,3);
        for ii = 1:3
            for jj = 1:3
                % What it can't be
                row = [ul(ii,:) ur(ii,:)];
                col = [ur(:,jj)' lr(:,jj)'];
                sec = ur(:)';
                not = unique([row col sec]);
                
                % Make possible values
                pos = [];
                cnt = 1;
                for kk = 1:9
                    lop = map(kk)==not;
                    if sum(lop)==0
                        pos(cnt) = kk;
                        cnt = cnt + 1;
                    end
                end
                
                if ~isempty(pos)
                    % Randomly select one possible value and insert it
                    idx = randi([1 length(pos)],1);
                    ur(ii,jj) = pos(idx);
                    if ii==3 && jj==3 && sum(sum(isnan(ur)))==0
                        valid = 1;
                    end
                end
            end
        end
    end
    
    su(1:3,7:9) = ur;
    
    % Make LL. Dependent on UL and LR.
    valid=0;
    while valid==0
        ll = zeros(3,3);
        for ii = 1:3
            for jj = 1:3
                % What it can't be
                row = [ll(ii,:) lr(ii,:)];
                col = [ul(:,jj)' ll(:,jj)'];
                sec = ll(:)';
                not = unique([row col sec]);
                
                % Make possible values
                pos = [];
                cnt = 1;
                for kk = 1:9
                    lop = map(kk)==not;
                    if sum(lop)==0
                        pos(cnt) = kk;
                        cnt = cnt + 1;
                    end
                end
                
                if ~isempty(pos)
                    % Randomly select one possible value and insert it
                    idx = randi([1 length(pos)],1);
                    ll(ii,jj) = pos(idx);
                    if ii==3 && jj==3 && sum(sum(isnan(ll)))==0
                        valid = 1;
                    end
                end
            end
        end
    end
    
    su(7:9,1:3) = ll;
    
    % Use trimed sudoku solver code to fill the remaining sections.
    gurow = [];
    gucol = [];
    
    % While loop stuff starts here
    solved = 0;
    guess=0;
    timeout = 0;
    step = 1;
    while solved==0
        % Loop through sudoku matrix
        for ii = 1:9
            for jj = 1:9
                aa = su(ii,jj);
                % Enter solve mode
                if aa==0
                    row = su(ii,(find(su(ii,:)~=0)))';
                    col = su((find(su(:,jj)~=0)),jj);
                    zon = jad(ii,jj);
                    sec = su(jad==zon);
                    sec(sec==0) = [];
                    % This is a list of values that conflict with the current
                    % cell.
                    val = unique([row',col',sec']);
                    
                    % Get possible values. Store values in matrix.
                    sto = [];
                    cnt = 1;
                    for kk = 1:9
                        lop = map(kk)==val;
                        if sum(lop)==0
                            sto(cnt) = kk;
                            cnt = cnt + 1;
                        end
                    end
                    
                    % If every value presents a conflict, skip cell on this
                    % iteration.
                    if isempty(sto)
                        continue
                    end
                    
                    % If there is only one possible value for the iterated
                    % cell, insert value into the matrix.
                    if length(sto)==1
                        su(ii,jj) = sto;
                    end
                    
                    % If in guess mode (below), insert first value in the sto
                    % vector. This needs improving.
                    if guess==1
                        su(ii,jj) = sto(1);
                        guess=0;
                    end
                end
            end
        end
        
        % Check/store number of rows and columns that are solved.
        ckrow = [];
        chcol = [];
        for ii = 1:9
            for jj = 1:9
                ckrow(ii) = sum(su(ii,:))==45;
                ckcol(jj) = sum(su(:,jj))==45;
            end
        end
        gurow(step) = sum(ckrow);
        gucol(step) = sum(ckcol);
        
        % Enter guess mode if no progress is made for an entire step. This
        % usually does well, but occasially guesses wrong and gets stuck.
        % This could be improved if we give the solver "memory" and let it
        % backtrack.
        if step>=5
            if gurow(step-1)-gurow(step-2)==0 && gucol(step-1)-gucol(step-2)==0
                guess=1;
            end
        end
        
        % If check sum is satisfied, exit both while loops.
        if sum(ckrow)==9 && sum(ckcol)==9
            solved = 1;
            restart = 1;
        end
        
        % If the solver fails to fill the remaining grids in 25 steps, we
        % restart the entire routine. Exit nested while loop and re-enter 
        % main while loop. This works well for now. We can improve the 
        % solver to limit this occurance later.
        if step==25
            solved = 1;
            restart = 0;
        end
        
        step = step + 1;
    end
end

% Remove a random amount of values. This should be improved. It gives no
% scaling for difficulty. Also might allow for non-unique solutions to the
% sudoku if too many values are removed. What determines this?
for ii = 1:9
    kill = logical(randi([0 1],1,9));
    su(ii,kill) = 0;
end

printsudoku(su,['sudoku_' id '.txt'])

