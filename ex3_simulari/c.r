# primim lungimea acului si distanta dintre linii ca si parametrii
args <- commandArgs(trailingOnly = TRUE);

distanta = as.numeric(args[1]);
lungime_ac = as.numeric(args[2]);

N <- 100000000

#generam variabilele aleatoare X si THETA

X <- runif(N, 0, distanta/2)
O <- runif(N, 0, pi/2)

#calculam limita
limit <- (lungime_ac/2) * sin(O)

#raspuns va fi un sir de bool, unde true reprezinta ca acul intersecteaza linia,
#false ca nu intersecteaza linia
raspuns <- X <= limit
#true este tratat ca 1, false ca 0, asa ca mean(raspuns) ne va da probabilitatea
prob_estimata <- mean(raspuns)

sprintf("Distanta intre linii este: %d", distanta)
sprintf("Lungimea acului este: %d", lungime_ac)
sprintf("Probabilitatea estimate este: %f", prob_estimata)
sprintf("Probabilitatea teoretica este: %f", (2*lungime_ac)/( distanta * pi ))
