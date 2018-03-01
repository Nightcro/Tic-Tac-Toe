function [] = joc()
  
  printf("Buna! :)\n");
  printf("Acesta e un joc X si O.\n");
  printf("Mai intai vei alege daca vrei sa joci cu X sau O.\n");
  printf("Introdu coordonatele casutei alese de tine sub forma aceasta: X X\n");
  printf("Daca te-ai plictisit si vrei sa iesi din joc ");
  printf("introdu litera q cand e randul tau in joc sau la inceput\n");
  
  prefmoves = [1, 1; 1, 3; 3, 1; 3, 3; 2, 2];
  choice = 0; % variabila ce reprezinta alegerea celulei, mentine loop
  ch = '!'; % variabile pentru ce s-a ales
  new = 1; % variabila pentru a desemna un joc nou
  new_move = 1; % variabila pentru a desemna mutarea player-ului
  sc_comp = 0; % scor computer
  sc_pl = 0; % scor player
  round = 0; % variabila pentru a desemna runda  
  firsttime = 0; % variabila pentru a desemna anumite afisaje first time
  turn = NaN; % desemneaza al cui e randul pentru a pune pe tabla
  inp = 1; % pentru a mentine loop in caz de alegere invalida
  over = -2; % arata cine a castigat sau daca e egal
  quit = 0; % folosita pentru a inchide jocul cand trb sa alegi intre X si O
  
  while(1)
    if(new) % nou joc
    
      printf("\nScore Computer vs Player: %d - %d\n\n", sc_comp, sc_pl);
      board = (-1) * ones(3); 
      
      while(inp) % loop pentru alegerea dintre X si O, acopera invalid input
        printf("Cu ce vrei sa joci, X sau O sau q ?\n");
        ch = strtrim(input("Choice: ", 's'));
        printf("\n");
        if(strcmpi(ch, 'X'))
          player = 1;
          computer = 0;
          firsttime = 1;
          new = 0;
          turn = 1;
          inp = 0;
          new_move = 1;
        elseif(strcmpi(ch, 'O'))
          player = 0;
          computer = 1;
          firsttime = 1;
          new = 0;
          turn = 0;
          inp = 0;
          new_move = 1;
        elseif(strcmpi(ch, 'q'))
          quit = 1;
          break;
        else
          inp = 1;
          printf("Invalid Input!\n");
        endif
      endwhile
      
      if(quit == 0)
        inp = 1;
        printf("Round %d!\nFight!\n\n", round);
      endif
      
    endif
    
    if(strcmp(ch, 'q'))
        printf("\nFinal Score Computer vs Player: %d - %d\n", sc_comp, sc_pl);
        break;
      endif
    
    if(over == -1) % se verifica cine a castigat
      sc_comp++;
      new = 1;
      round++;
      over = -2;
    elseif(over == 1)
      sc_pl++;
      new = 1;
      round++;
      over = -2;
    elseif(over == 0)
      new = 1;
      round++;
      over = -2;
    else
    
      if(turn == 0) % desemneaza al cui e randul
      %Computer Moves
        printf("Computerul gandeste.\n");
        fflush(stdout);
        sleep(1);
        
        if(firsttime == 1) % anumite miscari pentru computer daca e primul
          index = randi(5);
          x = prefmoves(index, 1);
          y = prefmoves(index, 2);
          board(x, y) = computer;
          firsttime = 0;
        else
          fflush(stdout);
          [x y] = AI(board, player, computer);
          board(x, y) = computer;
        endif
        
        over = check(board, player, true);
        printBoard(board);
        
        if(over != -2)
          turn = -1;
          new_move = 0;
        else
          turn = 1;
        endif
         
      endif
      
      while(new_move) % input pentru player, acopera inalid input
      
        if(firsttime == 1)
          printBoard(board);
          firsttime = 0;
        endif
        
        move = strsplit(strtrim(input('Introdu linia, coloana:  ', 's')));
        
        if(strcmpi(move, 'q'))
          quit = 1;
          break;
        endif
        
        if (length(move) == 2) % se verifica pozitia introdusa de player
          x = str2num(move{1});
          y = str2num(move{2});
          if(isempty(x) || isempty(y) || ((x < 1) || (x > 3)) || ((y < 1) 
              || (y > 3)) || (board(x, y) != -1))
            printf("Invalid Input! Choose a valid position!\n");
            printBoard(board);
          else
            move{1} = x;
            move{2} = y;
            new_move = 0;
          endif
        else
          printf("Invalid Input! Choose a valid position!\n");
          printBoard(board);
        endif
        
      endwhile
      
      if(quit == 1)
        printf("\nFinal Score Computer vs Player: %d - %d\n", sc_comp, sc_pl);
        break;
      endif
      
      if(turn == 1)
        %Player Moves
        board(move{1}, move{2}) = player;
        new_move = 1;
        printBoard(board);
        over = check(board, player, true);
        
        if(over != -2)
          turn = -1;
        else
          turn = 0;
        endif
        
      endif
    endif
    
  endwhile
  
endfunction

function [] = printBoard(board) % printeaza board-ul
  for i = 1:3
    for j = 1:3   
      fprintf('|');      
      if(board(i,j) == 1)
        fprintf('X');
      elseif(board(i,j) == 0)
        fprintf('O');
      else
        fprintf(' ');
      endif          
      fprintf('|');      
    endfor 
    fprintf('\n');
  endfor
  fprintf('\n');
endfunction