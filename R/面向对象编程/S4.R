# https://zhuanlan.zhihu.com/p/358783073
# https://github.com/xiangpin/eclust
# setClass, setGeneric, setMethod, new
help("setClass")

# create a S4 object
setClass("Person", slots = list(name = "character", age = "numeric"))
tom <- new("Person", name = "tom", age = 18)
tom
class(tom)
otype(tom)

# access to slots
slotNames(tom)
getSlots("Person")
slotNames("Person")

tom@name
slot(tom, "name")

getClass(tom)
getClass("Person")

# set default value
setClass("Person",
    slots = list(name = "character", age = "numeric"),
    prototype = list(name = "Unknow", age = 18)
)

new("Person")

# type check
new("Person", name = "tom", age = "0")
setClass("Person",
    slots = list(name = "character", age = "numeric"),
    prototype = list(name = "Unknow", age = 18),
    validity = function(object) {
        if (object@age <= 0) {
            return("Age is negative.")
        }
        return(TRUE)
    }
)

setClass("Person",
    slots = list(name = "character", age = "numeric"),
    prototype = list(name = "Unknow", age = 18)
)

setValidity("Person", function(object) {
    if (object@age <= 0) {
        return("Age is negative.")
    }
    return(TRUE)
})

# create a new sample from a old sample
jay <- initialize(tom, name = "jay", age = 20)
jay

# create function
setGeneric(name = "getName", def = function(object) standardGeneric("getName"))
setMethod(
    f = "getName", signature = "Person",
    definition = function(object) object@name
)

getName(jay)
ftype(getName)
getMethod("getName", "Person")

# the inherit of S4
chinese <- setClass("Chinese", contains = "Person")
chinese(name = "lisin", age = 38)



# example
# 定义一个顶层的类：shape
# 定义两个继承自shape的子类：circle, rectangle
# 添加对应的计算面积和周长的函数：area, circum

shape <- setClass("shape", slots = c(shape = "character"))
setGeneric("get_shape", function(object, ...) {
    standardGeneric("get_shape")
})
setMethod("get_shape", "shape", function(object, ...) {
    return(object@shape)
})

setGeneric("area", function(object, ...) {
    standardGeneric("area")
})
setGeneric("circum", function(object, ...) {
    standardGeneric("circum")
})


circle <- setClass("circle",
    slots = c(radius = "numeric"),
    contains = "shape", prototype = list(radius = 1, shape = "circle"),
    validity = function(object) {
        if (object@radius <= 0) stop("Radius is negative")
    }
)
setMethod("area", "circle", function(object, ...) {
    return(pi * object@radius^2)
})
setMethod("circum", "circle", function(object, ...) {
    return(2 * pi * object@radius)
})



rectangle <- setClass("rectangle",
    slot = c(height = "numeric", width = "numeric"),
    contains = "shape",
    prototype = list(height = 1, width = 1, shape = "rectangel"),
    validity = function(object) {
        if (object@height <= 0 | object@width <= 0) stop("radius is negative")
    }
)
setMethod("area", "rectangle", function(object, ...) {
    return(object@height * object@width)
})
setMethod("circum", "rectangle", function(object, ...) {
    return(2 * (object@height + object@width))
})


a <- circle(radius = 3)
area(a)
circum(a)
