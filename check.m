function over = check(board, player, verbose)

  over = -2;
  
  for turn = 0:1
    if(win(board, turn))
    
      if(turn == player)
      
        if(verbose == true)
          printf("Player won!\n");
        endif
        
        over = 1;
        return;
        
      else
      
        if(verbose == true) % daca sa se afiseze mesajele sau nu
          printf("Computer won!\n");
        endif
        
        over = -1;
        return;
        
      endif
      
    endif
  endfor
  
  if(sum(board(:) == -1) == 0)
    if(verbose == true)
      printf("It's a tie!\n\n");
    endif
    over = 0;
  endif
  
endfunction

function value = win(board, turn) % se verifica daca pe col, row, diag

  col = 0;
  row = 0;
  value = 1;
  
  for i = 1:3 % se verifica toate coloanele si liniile daca exista
    % 3 elemente de acelasi fel
    row = sum(board(i, 1:3) == turn) == 3;
    
    if(row == 1)
      return;
    endif
    
    col = sum(board(1:3, i) == turn) == 3;
    
    if(col == 1)
      return;
    endif
    
  endfor
  
  if((board(1, 1) == board(2, 2)) && (board(2, 2) == board(3, 3)) 
      && (board(3, 3) == turn))
    return; % se verifica diagonala principala
  endif
    
  if((board(1, 3) == board(2, 2)) && (board(2, 2) == board(3, 1)) 
      && (board(3, 1) == turn))
    return; % se verifica diagonala secundara
  endif
  
  value = 0;
  
end