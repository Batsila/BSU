dat <- read.table(file = "data.txt", sep = ",")
d <- as.numeric(dat)
mean(d)
var(d)
sd(d)
which.max(table(d))
median(d)
a <- table(d)
a
zn <- sort(unique(d))
sr_znach <- mean(d)
n <- length(d)
disp <- var(d)
koeff_asimm <- sum((zn - sr_znach) ^ 3 * a) / (n * disp ^ (3 / 2))
koeff_asimm
koeff_ex <- (sum(( zn - sr_znach) ^ 4 * a) / (n * disp ^ 2)) - 3
koeff_ex
v <- sort(d)
szv <- length(v) 
s <- 0
for (i in 4 : (szv - 3)){ s = s + v[i] }
a <- (1 / (szv - 2 * 6)) * s
a
koeff_var <- 100 * sqrt(var(d)) / mean(d)
koeff_var
sm <- 0
for (i in 1:szv){ sm = sm + abs(v[i] - mean(d)) }
sm <- sm / szv
otn_lin <- 100 * sm / mean(d)
otn_lin