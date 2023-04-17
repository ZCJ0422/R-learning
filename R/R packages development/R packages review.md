# [review](https://r-pkgs.org/whole-game.html#review)

![The devtools package development workflow](https://r-pkgs.org/diagrams/workflow.png)

## These functions setup parts of the package and are typically called once per package:

* `create_package()`
* `use_git()`
* `use_mit_license()`
* `use_testthat()`
* `use_github()`
* `use_readme_rmd()`

## You wil call these functions on a regular basis, as you add functions and tests or take on dependencies:

* `use_r()`
* `use_test()`
* `use_package()`

## You will call these functions multiple times per day or per hour, during development:

* `load_all()`
* `document()`
* `test()`
* `check()`
