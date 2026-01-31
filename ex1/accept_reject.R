set.seed(1)

N <- 1000
x <- runif(N, -1, 1)
y <- runif(N, -1, 1)

inside <- (x^2 + y^2 <= 1)

# media distantei pentru punctele acceptate
r_inside <- sqrt(x[inside]^2 + y[inside]^2)
mean_r <- mean(r_inside)

cat("Numar acceptate:", sum(inside), "din", N, "\n")
cat("Media empirica a distantei (doar puncte din disc):", mean_r, "\n")
cat("Media teoretica E[R] = 2/3 =", 2/3, "\n")

# figura
png("ex1/img/accept_reject.png", width = 800, height = 800)
plot(x[!inside], y[!inside],
     xlim = c(-1, 1), ylim = c(-1, 1),
     pch = 16, cex = 0.7, col = "red",
     xlab = "X", ylab = "Y",
     main = "Acceptare-respingere: in disc (albastru) vs in afara (rosu)")
points(x[inside], y[inside], pch = 16, cex = 0.7, col = "blue")
t <- seq(0, 2*pi, length.out = 400)
lines(cos(t), sin(t), lwd = 2)
dev.off()
