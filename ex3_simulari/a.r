#prima oara alegem un numar mare de repetari
N <- 100000000

#generam variabilele aleatoare X si THETA

X <- runif(N, 0, 0.5)
O <- runif(N, 0, pi/2)
limit <- 0.5 * sin(O)
print("Am ajun aici!")
raspuns <- X <= limit
prob_estimata <- mean(raspuns)
prob_estimata
2/pi
