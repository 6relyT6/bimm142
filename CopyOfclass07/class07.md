---
title: "Class 7: Machine Learning"
author: "Tyler Sy (PID: A16651122)"
format: pdf
---

# First up kmeans()

Demo of using kmeans() function in base R. First make up some data with a known structure.

```{r}
tmp <- c(rnorm(30, mean = -3), rnorm(30, mean = 3))
tmp
x <- cbind(x = tmp, y = rev(tmp))
plot(x)
```

Now we have some made up data in `x` let's see how kmeans works with this data

```{r}
k <- kmeans(x, centers = 2, nstart = 20)
k
```

> Q. How many points are in each cluster?

```{r}
k$size
```

> Q. How do we get to the cluster membership/assignment?

```{r}
k$cluster
```

> Q. What about cluster centers?

```{r}
k$centers
```

Now that we got to the main results, let's use them to plot our data with the kmeans result.

```{r}
plot(x, col = k$cluster)
points(k$centers, col = 'blue', pch = 15)
```
Cluster the data into 4 groups now

```{r}
k_4 <- kmeans (x, centers = 4)
k_4
```

```{r}
plot(x, col=k_4$cluster)
points(k_4$centers, col="purple", pch=15, cex=2)
```

## Now for Hierarchical Clustering

We will cluster the same data `x` with the `hclust()`. In this case `hclust()` requires a distance matrix as input.

```{r}
hc <- hclust(dist(x))
hc
```

Let's plot our hclust result

```{r}
plot(hc)
```

To get our cluster membership vector, we need to "cut" the tree with the `cutree()`.

```{r}
grps <- cutree(hc, h = 8)
grps
```

Now plot our data with the hclust() results.

```{r}
plot(x, col = grps)
```

## Principal Component Analysis (PCA)

```{r}
url <- "https://tinyurl.com/UK-foods"
x <- read.csv(url)
```

>Q1. How many rows and columns are in your new data frame named x? What R functions could you use to answer this questions?

```{r}
x
dim(x)
```

There are 17 columns and 5 rows.

Preview the first 6 rows.
```{r}
head(x)
```

```{r}
# Note how the minus indexing works
rownames(x) <- x[,1]
x <- x[,-1]
head(x)
```

The dimensions have been changed.
```{r}
dim(x)
```

The proper amount of rows and columns are 17 and 4 respectively.

Alternative method
```{r}
x <- read.csv(url, row.names=1)
head(x)
```

> Q2. Which approach to solving the ‘row-names problem’ mentioned above do you prefer and why? Is one approach more robust than another under certain circumstances?

I prefer the second option since the first option results in an error if it is run too many times. Thus, the second option is more robust since it can be more consistently ran.

```{r}
barplot(as.matrix(x), beside=T, col=rainbow(nrow(x)))
```

> Q3. Changing what optional argument in the above barplot() function results in the following plot?

```{r}
barplot(as.matrix(x), beside=F, col=rainbow(nrow(x)))
```

Changing `beside = T` to `beside = F` or simply removing the argument `beside = T` results in the plot above.

> Q5. Generating all pairwise plots may help somewhat. Can you make sense of the following code and resulting figure? What does it mean if a given point lies on the diagonal for a given plot?

The following code determines the pairs between matching values for those that are in the same countries against one another. The y-axis is a certain country in that row. As a result, the graphs represent each pair of countries plotted against each other. If a point is on a diagonal, there isn't a difference in that category for the countries that are being compared.

```{r}
pairs(x, col=rainbow(10), pch=16)
```

> Q6. What is the main differences between N. Ireland and the other countries of the UK in terms of this data-set?

The data points in each of the graphs for N. Ireland are not as diagonal. This suggests a greater difference in food consumption relative to the other countries of the UK. The points that differ the most are the orange and blue points.


## PCA to the Rescue

```{r}
# Use the prcomp() PCA function 
pca <- prcomp(t(x))
summary(pca)
```

PC1 captures 67.44% and PC2 captures 29.05% for a total of 96.5% variance captured in the first 2 PCs.

> Q7. Complete the code below to generate a plot of PC1 vs PC2. The second line adds text labels over the data points.

```{r}
# Plot of the first 2 PCs
plot(pca$x [,1], pca$x[,2])

# Plot PC1 vs PC2
plot(pca$x[,1], pca$x[,2], xlab = "PC1", ylab = "PC2", xlim = c(-270,500))
text(pca$x[,1], pca$x[,2], colnames(x))
```

> Q8. Customize your plot so that the colors of the country names match the colors in our UK and Ireland map and table at start of this document.

```{r}
my_colors <- c("orange", "red", "blue", "darkgreen")
plot(pca$x[,1], pca$x[,2], pch = -10, xlab = "PC1", ylab = "PC2")
text(pca$x[,1], pca$x[,2], colnames(x), col = my_colors)
```


### Digging Deeper

```{r}
## Lets focus on PC1 as it accounts for > 90% of variance 
par(mar=c(10, 3, 0.35, 0))
barplot( pca$rotation[,1], las=2 )
```

Plot along PC1.

```{r}
library(ggplot2)
contrib <- as.data.frame((pca$rotation))
ggplot(contrib) +
  aes(PC1, rownames(contrib)) + geom_col()
```


> Q9: Generate a similar ‘loadings plot’ for PC2. What two food groups feature prominantely and what does PC2 maninly tell us about?

```{r}
par(mar=c(10, 3, 0.35, 0))
barplot( pca$rotation[,2], las=2 )
```

```{r}
ggplot(contrib) +
  aes(PC2, rownames(contrib)) + geom_col()
```

Soft drinks and fresh potatoes are the most prominent food groups and PC2 mainly tells us that the variance is due to these two food groups - soft drinks and fresh potatoes.