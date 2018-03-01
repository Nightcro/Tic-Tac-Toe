function [x y] = AI(board, player, computer)

  best = -1000;
  x = -1;
  y = -1;

  % evalueaza fiecare mutare posibila si o returneaza pe cea mai buna
  % folosindu-se de functia minimax alfa-beta
  for i = 1:3
      for j = 1:3
          % verifica daca cell-ul e gol
          if(board(i, j) == -1)
              % face miscarea
              board(i, j) = computer;

              % se apeleaza alfabeta pentru a determina cea mai buna mutare
              move = alfabeta(board, 0, -1000, 1000, false , player, computer);
              % stergem mutarea
              board(i, j) = -1;

              % daca valoarea curenta e mai buna decat best atunci se retine
              % valoarea noua cu tot cu indicii respectivi ai mutarii
              if(move > best)
                  x = i;
                  y = j;
                  best = move;
              endif
          endif
      endfor
  endfor
  
endfunction

function score =  alfabeta(board, depth, alfa, beta, isMax, player, computer)

  score = evaluate(board, player);
  
  if(score == 10)
    score = 10 - depth;
    return;
  endif
  
  if(score == -10)
    score = -10 + depth; % returnam scorul evaluat si in functie de situatie
    return;              % scad sau adaug depth-ul la care s-a ajuns
  endif
  
  if(isMovesLeft(board) == false)
    score = 0;
    return;
  endif

  
  if(isMax) % daca e randul lui maximizer
  
    best = -1000;
    
    for i = 1:3
      for j = 1:3
        if(board(i, j) == -1)
          board(i, j) = computer;

          % apeleaza alfabeta recursiv pentru a alege cea mai buna mutare
          best = max(best, alfabeta(board, depth + 1, alfa, beta, 
                                    !isMax, player, computer));
          alfa = max(alfa, best);
          % sterge miscarea
          board(i, j) = -1;
          
          if (beta <= alfa)
            break;
          end
          
        endif
      endfor
    endfor
    
    score = best;
    return;
    
  else % daca e randul lui minimizer
  
    best = 1000;
    
    for i = 1:3
      for j = 1:3
        if(board(i, j) == -1)
          board(i, j) = player;

          % apeleaza alfabeta recursiv pentru a afla minimul
          best = min(best, alfabeta(board, depth + 1, alfa, beta, 
                                      !isMax, player, computer));
          beta = min(beta, best);
          % sterge miscarea
          board(i, j) = -1;
          
          if (beta <= alfa)
            break;
          endif
          
        endif
      endfor
    endfor
    
    score = best;
    return;
    
  endif
endfunction

function ans = isMovesLeft(board)

  ans = false;

  for i = 1:3
    for j = 1:3
    % verific daca mai sunt celule libere pe tabla
      if(board(i, j) == -1)
        ans = true;
        return;
      endif
      
    endfor
  endfor
    
endfunction

function value = evaluate(board, player)
  
  value = 0;
  over = check(board, player, false);

    if(over == -1) % in functie de valoarea functie isOver returnata
      value = 10; % intoarcem scorul respectiv
    elseif(over == 1)
      value = -10;
    endif
  
endfunction