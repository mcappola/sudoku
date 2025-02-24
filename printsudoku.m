function printsudoku(sudoku,filename)

% Make the matrix into a char array. Add borders for sectors.
cc = 1;
for jj = 1:9
    line = [];
    if jj == 1
        out(cc,:) = '|-----------------------------------|';
        cc = cc + 1;
    end
    for ii = 1:9
        if ii == 1
            line = [line '| ' num2str(sudoku(jj,ii)) ' '];
        elseif ii == 4 || ii == 7
            line = [line '| ' num2str(sudoku(jj,ii)) ' '];
        elseif ii == 9
            line = [line ': ' num2str(sudoku(jj,ii)) ' |'];
        else
            line = [line ': ' num2str(sudoku(jj,ii)) ' '];
        end        
    end
    line(line=='0') = ' ';
    out(cc,:) = line;    
    if jj == 3 || jj == 6 || jj == 9
        cc = cc + 1;
        out(cc,:) = '|-----------------------------------|';
    end
    cc = cc + 1;
    if jj==1 || jj==2 || jj==4 || jj==5 || jj==7 || jj==8
        out(cc,:) = '| - - - - - | - - - - - | - - - - - |';
        cc = cc + 1;
    end    
end

% Output
writematrix(out,filename)
    
