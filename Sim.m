function [Similarity] = Sim(i, j, U, Rhat, R)
    Numerator = 0;
    
    SquaredSum1 = 0;
    SquaredSum2 = 0;
    
    for u = U
       R_u = Rhat(u, 1);
       
       Part1 = R(u, i) - R_u;
       Part2 = R(u, j) - R_u;
       
       Numerator = Numerator + Part1*Part2;
       
       SquaredSum1 = SquaredSum1 + Part1.^2;
       SquaredSum2 = SquaredSum2 + Part2.^2;
    end
   
    Denominator = sqrt(SquaredSum1) * sqrt(SquaredSum2);
    
    Similarity = Numerator / Denominator;
end