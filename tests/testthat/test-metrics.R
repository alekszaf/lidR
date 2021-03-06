context("metrics")

test_that("gap fraction returns proper values", {
  Z = runif(50000, 0, 5)
  gf = 1-gap_fraction_profile(Z, 1, 0)$gf

  expect_equal(gf, c(1, 0.5, 0.333, 0.25, 0.2), tolerance = 0.01)
})

test_that("entropy returns proper values", {
  Z = runif(20000, 0, 5)
  S = entropy(Z)

  expect_equal(S, 1, tolerance = 0.001)

  Z = runif(20000, 0, 1)
  Z = c(Z, 5)
  S = entropy(Z)

  expect_equal(S, 0, tolerance = 0.001)
})

test_that("VCI returns the same as entropy values", {
  Z = runif(100, 0, 5)

  S = entropy(Z, zmax = 6)
  V = VCI(Z, 6)

  expect_equal(S, V)
})

test_that("predefined metric set work", {
  las = lidR:::dummy_las(10000)
  las@data[, ScanAngle := runif(.N)]

  expect_error(grid_metrics(las, .stdmetrics_z), NA)
  expect_error(grid_metrics(las, .stdmetrics_i), NA)
  expect_error(grid_metrics(las, .stdmetrics_rn), NA)
  expect_error(grid_metrics(las, .stdmetrics_ctrl), NA)
})

test_that("grid_metric debug mode works", {
  las = lidR:::dummy_las(10000)
  las@data[, ScanAngle := runif(.N)]

  lidr_options(debug = TRUE)

  expect_error(grid_metrics(las, LAD(Z)), "A single number or a list of single number is expected")
  expect_error(grid_metrics(las, quantile(Z)), "A single number or a list of single number is expected")
})

