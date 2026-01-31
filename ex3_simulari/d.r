set.seed(123)

# L = lungimea acului, d = diametrul cercului, N = numarul de simulari
L <- 0.7      
d <- 1.0      
N <- 1e6     

# Directia liniei
Theta <- runif(N, 0, 2*pi)

# Distanta liniei fata de centru
R <- runif(N, 0, d/2)

# Conditia de intersectie
limit <- (L / 2) * abs(sin(Theta))
intersectie <- R <= limit

# Probabilitate estimata
prob_estimata <- mean(intersectie)

# Probabilitate teoretica
prob_teoretica <- (2 * L) / (pi * d)

# Afisare rezultate
sprintf("Probabilitate estimata = %.6f", prob_estimata)
sprintf("Probabilitate teoretica = %.6f", prob_teoretica)
sprintf("Eroare absoluta = %.6f", abs(prob_estimata - prob_teoretica))
