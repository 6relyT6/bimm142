# My first R script

x <- 1:50
plot(x,sin(x))
plot(x, sin(x), typ = "l")
plot(x, sin(x), typ = "l", col = 'blue')
plot(x, sin(x), typ = "l", col = 'blue', lwd = 2)
plot(x, sin(x), typ = "l", col = 'blue', lwd = 2, xlab = 'Hello')
