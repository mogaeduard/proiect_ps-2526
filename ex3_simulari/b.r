
set.seed(123)

#nr de repetari
N <- 10000000

# X = distanta de la centru la cea mai apropiata linie
X <- runif(N, min = 0, max = 0.5)

# Theta = unghiul primului ac fata de orizontala 
Theta <- runif(N, min = 0, max = pi/2)

# Proiectia verticala a jumatatii fiecarui ac (lungime 1 -> jumatate = 1/2)
h1 <- 0.5 * sin(Theta)  # pentru primul ac
h2 <- 0.5 * cos(Theta)  # pentru al doilea, perpendicular

# Indicatori de intersectie
#Y1 este vectorul ce ne spune daca primul ac intersecteaza o linie
Y1 <- X <= h1   
#Y2 este vectorul ce ne spune daca al doilea ac intersecteaza o linie
Y2 <- X <= h2  

# Numarul total de intersectii Z ∈ {0,1,2}
Z <- Y1 + Y2    

# Estimari Monte Carlo
E_Z_over_2_est  <- mean(Z / 2)
Var_Z_over_2_est <- var(Z / 2)

# Valori teoretice
E_Z_over_2_theo   <- 2 / pi
Var_Z_over_2_theo <- (3 - sqrt(2)) / pi - 4 / (pi^2)

sprintf("E[Z/2] estimat      = %.6f", E_Z_over_2_est)
sprintf("E[Z/2] teoretic     = %.6f", E_Z_over_2_theo)

sprintf("Var(Z/2) estimata   = %.6f", Var_Z_over_2_est)
sprintf("Var(Z/2) teoretica  = %.6f", Var_Z_over_2_theo)
