set.seed(123)

#Parametri
d1 <- 1.0   #distanta intre liniile verticale
d2 <- 1.5   #distanta intre liniile orizontale
L  <- 0.7   #lungimea acului (trebuie L < min(d1, d2))

#numar de simulari
N <- 1e6    

#Generam distanta de la centru la cea mai apropiata linie verticala/orizontala
#X este distanta fata de verticala, Y fata de orizontala
X <- runif(N, 0, d1/2)   
Y <- runif(N, 0, d2/2)  

#Unghiul acului fata de axa Ox 
theta <- runif(N, 0, pi/2)

#Proiectiile jumatatii din ac pe orizontala si verticala
hx <- (L / 2) * cos(theta)   
hy <- (L / 2) * sin(theta)   

#Conditia: acul intersecteaza cel putin o linie
hit <- (X <= hx) | (Y <= hy)

#Probabilitate estimata (simulare)
prob_est <- mean(hit)

#Probabilitate teoretica data in enunt:
prob_theo <- L * (2*d1 + 2*d2 - L) / (pi * d1 * d2)

sprintf("d1 = %.3f, d2 = %.3f, L = %.3f", d1, d2, L)
sprintf("Probabilitate estimata   = %.6f", prob_est)
sprintf("Probabilitate teoretica  = %.6f", prob_theo)
sprintf("Eroare absoluta          = %.6f", abs(prob_est - prob_theo))
