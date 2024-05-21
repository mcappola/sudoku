function out = solvesudoku(su,id,print)

% Resources
kbd = 1:9;

jad = [1 1 1 2 2 2 3 3 3;
    1 1 1 2 2 2 3 3 3;
    1 1 1 2 2 2 3 3 3;
    4 4 4 5 5 5 6 6 6;
    4 4 4 5 5 5 6 6 6;
    4 4 4 5 5 5 6 6 6;
    7 7 7 8 8 8 9 9 9;
    7 7 7 8 8 8 9 9 9;
    7 7 7 8 8 8 9 9 9;];

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
                    lop = kbd(kk)==val;
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
    
    % Enter guess mode if no progress is made for an entire step
    if step>=5
        if gurow(step-1)-gurow(step-2)==0 && gucol(step-1)-gucol(step-2)==0
            guess=1;
        end
    end
    
    disp([num2str(step) ' ' num2str(sum(ckrow)) ' ' num2str(sum(ckrow))])
    
    if sum(ckrow)==9 && sum(ckcol)==9
        solved = 1;
        disp('SUDOKU SOLVED!')
    end
        
    if step==25
        solved = 1;
        timeout = 1;
        disp('TIME OUT!');
    end
    
    step = step + 1;
end

out = su;

if print==1
    if timeout~=1
        printsudoku(su,['sudoku_' id '_solved.txt'])
    else
        printsudoku(su,['sudoku_' id '_failed.txt'])
    end
end


            