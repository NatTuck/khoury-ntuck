---
layout: default
---

# Some Notes on R

## Installing R on Ubuntu

    $ sudo apt-get install r-base r-cran-ggplot2

Start R with:

    $ R

## Loading a File

    > players =  read.csv("Master.csv")
    > summary(players) # Show a summary of the data

## Creating a Plot

    > library("ggplot2")
    > qplot(weight, height, data=players)
    > ggsave("weight-height.png")


