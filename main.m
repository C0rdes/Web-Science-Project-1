clear;

%load, trim and sort the data set
Moviedatat = 'Dataset\ml-100k\u.data';
Moviedatat = dlmread(Moviedatat, '\t');
Moviedatat = Moviedatat(:, 1:3);
[Y, I] = sort(Moviedatat(:, 1));
Moviedata = Moviedatat(I, :);

% Instantiate training and test set matrices

k = 10;

% split dataset
N = size(Moviedata, 1);
NumTest = 9430;
NumTrain = N - NumTest;
TrainingSet = zeros(NumTrain, 3);
TrainingMatrix = zeros(1, max(Moviedata(:,2)));
TestSet = zeros(NumTest, 3);
TestMatrix = zeros(1, max(Moviedata(:,2)));
i_test = 1;
i_train = 1;
userid = -1;
for n = 1 : N
    prevuserid = userid;
    userid = Moviedata(n, 1);
    if userid > prevuserid
        count = 0;
    end
    
    movieid = Moviedata(n, 2);
    rating = Moviedata(n, 3);
    
    if count >= k
        TrainingSet(i_train, 1) = userid;
        TrainingSet(i_train, 2) = movieid;
        TrainingSet(i_train, 3) = rating;
        TrainingMatrix(userid, movieid) = rating;
        i_train = i_train + 1;
    else
        TestSet(i_test, 1) = userid;
        TestSet(i_test, 2) = movieid;
        TestSet(i_test, 3) = rating;
        TestMatrix(userid, movieid) = rating;
        i_test = i_test + 1;
        count = count + 1;
    end
end

% Calculate the average rating of users
Rhat = zeros(userid, 1);
Counts = zeros(userid, 1);
for n = 1 : size(TrainingSet, 1)
    userid = TrainingSet(n, 1);
    Rhat(userid, 1) = Rhat(userid, 1) + TrainingSet(n, 3);
    Counts(userid, 1) = Counts(userid, 1) + 1;
end
for u = 1 : size(Rhat, 1)
   Rhat(u, 1) = Rhat(u, 1) / Counts(u, 1); 
end

% Fill movieid/username index matrix.
UserMovieRatingIndices = zeros(size(TrainingMatrix, 2), 1);
NextUMRIIndex = ones(size(TrainingMatrix, 2), 1);

for n = 1 : size(TrainingMatrix, 1)
   for m = 1 : size(TrainingMatrix, 2)
      rating = TrainingMatrix(n, m);
      NextIndex = NextUMRIIndex(m, 1);
      if rating > 0
         UserMovieRatingIndices(m, NextIndex) = n;
         NextUMRIIndex(m, 1) = NextUMRIIndex(m, 1) + 1;
      end
   end
    
end

Predictions = TrainingMatrix;

clearvars i_test i_train m movieid n N NextIndex u userid rating prevuserid count Moviedata Moviedatat I Y;










