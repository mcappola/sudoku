function printsudoku(sudoku,filename)

% Make the matrix into a char array. Add borders for sectors.
cc = 1;
for jj = 1:9
    line = [];
    for ii = 1:9
        if ii == 1
            line = [line num2str(sudoku(jj,ii))];
        elseif ii == 3 || ii == 6
            line = [line '   ' num2str(sudoku(jj,ii)) '   |'];
        else
            line = [line '   ' num2str(sudoku(jj,ii))];
        end
    end
    line(line=='0') = ' ';
    out(cc,:) = line;    
    if jj == 3 || jj == 6
        cc = cc + 1;
        out(cc,:) = '- - - - - - - - - - - - - - - - - - - - -';
    end
    cc = cc + 1;
end

% Output
writematrix(out,filename)
    