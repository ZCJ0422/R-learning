# https://zhuanlan.zhihu.com/p/358532080
library(sloop)

# create a S3 object with atrr()
a <- 1
attr(a, "class ") <- "bar" # nolint
class(a)
attr(a, "class")
sloop::otype(a)

# create a S3 object with structure()
b <- structure(2, class = "foo")
b
otype(b)

# create a S3 object with class()
x <- list(a = 1)
class(x)
otype(x)

class(x) <- "foo"
class(x)
otype(x)

c <- structure(3, class = c("bar", "foo"))
class(c)
otype(c)

# create a generic function with UseMethod()
person <- function(x, ...) {
    UseMethod("person")
}

person.default <- function(x, ...) {
    print("I am human.")
}

person.sing <- function(x, ...) {
    print("I can sing")
}

person.name <- function(x, ...) {
    print(paste0("My name is ", x))
}

a <- structure("tom", class = "sing")
person(tom)
person(a)
person("joy")
a

# the method of S3 object
methods(person)
methods(generic.function = print) |> head()
methods(class = lm) |> head()

print.xtabs
getAnywhere(print.xtabs)
getS3method("print", "xtabs")

# the inherit of S3 object
person <- function(x, ...) {
    UseMethod("person")
}

person.father <- function(x, ...) {
    print("I am father")
}

person.son <- function(x, ...) {
    NextMethod()
    print("I am son")
}

p1 <- structure(1, class = c("father"))
person(p1)
p2 <- structure(1, class = c("son", "father"))
person(p2)

ab <- structure(1, class = c("father", "son"))
person(ab)
