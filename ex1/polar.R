set.seed(1)

N <- 1000
theta <- runif(N, 0, 2*pi)
u <- runif(N, 0, 1)
r <- sqrt(u)

x <- r * cos(theta)
y <- r * sin(theta)

mean_r <- mean(r)
cat("Media empirica a distantei:", mean_r, "\n")
cat("Media teoretica E[R] = 2/3 =", 2/3, "\n")

png("ex1/img/polar.png", width = 800, height = 800)
plot(x, y,
     xlim = c(-1, 1), ylim = c(-1, 1),
     pch = 16, cex = 0.7,
     xlab = "X", ylab = "Y",
     main = "Metoda polara: puncte uniforme in discul unitate")
t <- seq(0, 2*pi, length.out = 400)
lines(cos(t), sin(t), lwd = 2)
dev.off()
