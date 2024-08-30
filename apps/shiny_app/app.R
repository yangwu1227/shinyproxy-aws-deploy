library(bs4Dash)
library(shiny)
library(glmnet)
library(plotly)

# Simulation function -----------------------------------------------------

simulate_data <- function(n = 1000) {
  # Predictor variables used to simulate the response variable
  significant_predictors <- lapply(
    c("x1", "x2", "x3"),
    function(x) rnorm(n = n, mean = 0, sd = 1)
  )

  # Predictor variables not used to simulate the response variable
  insignificant_predictors <- lapply(
    c("x4", "x5", "x6"),
    function(x) rnorm(n = n, mean = 0, sd = 1)
  )

  # True parameter values
  b_1 <- 12.34
  b_2 <- 23.45
  b_3 <- 2.45

  # Simulate the response variable
  intercept <- 20
  y <- intercept + b_1 * significant_predictors[[1]] + 
      b_2 * significant_predictors[[2]] + b_3 * significant_predictors[[3]]

  # Standardize the response variable
  y <- (y - mean(y)) / sd(y)
  
  data <- data.frame(
    y = y,
    x1 = significant_predictors[[1]],
    x2 = significant_predictors[[2]],
    x3 = significant_predictors[[3]],
    x4 = insignificant_predictors[[1]],
    x5 = insignificant_predictors[[2]],
    x6 = insignificant_predictors[[3]]
  )

  return(data)
}

# Train models ------------------------------------------------------------

train_models <- function(data, regularization_strength) {
  predictors <- c("x1", "x2", "x3", "x4", "x5", "x6")

  # Train models
  lasso <- glmnet(
    x = as.matrix(data[, predictors]),
    y = data$y,
    alpha = 1,
    lambda = regularization_strength
  )

  ridge <- glmnet(
    x = as.matrix(data[, predictors]),
    y = data$y,
    alpha = 0,
    lambda = regularization_strength
  )

  # Coefficients
  coefs <- data.frame(
    predictor = rep(predictors, times = 2),
    beta = c(coef(ridge)[predictors, ], coef(lasso)[predictors, ]),
    model = rep(c("Ridge", "Lasso"), each = length(predictors))
  )

  return(coefs)
}

# UI ----------------------------------------------------------------------

ui <- bs4DashPage(
  title = "Shiny Application",
  header = bs4DashNavbar(disable = TRUE),
  sidebar = bs4DashSidebar(disable = TRUE),
  body = bs4DashBody(
    bs4Card(
      sliderInput(
        inputId = "regularization_strength",
        label = "Use the slider to change the regularization strength for Lasso and Ridge regression models:",
        min = 0,
        max = 1,
        value = 0.2
      ),
      title = "Regularization Strength",
      width = 12
    ),
    bs4Card(
      plotlyOutput("box_plot"),
      width = 12
    )
  ),
  controlbar = dashboardControlbar(disable = TRUE)
)

# Server ------------------------------------------------------------------

server <- function(input, output) {
  # Simulate 200 data sets, each with 200 observations
  data <- reactive({
    replicate(200, simulate_data(n = 200), simplify = FALSE)
  })

  # Train models for each data set
  results <- reactive({
    models <- lapply(data(), train_models, regularization_strength = input$regularization_strength)
    # Combine results (row-bind)
    do.call(rbind, models)
  })

  # Box plot
  output$box_plot <- renderPlotly({
    plot_ly(
      data = results(),
      x = ~predictor,
      y = ~beta,
      color = ~model,
      type = "box"
    ) %>%
      layout(
        title = "Box plot",
        xaxis = list(title = "Predictor"),
        yaxis = list(title = "Coefficient")
      )
  })
}

shinyApp(ui, server)
