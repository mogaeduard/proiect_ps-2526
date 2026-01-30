
# EXERCITIUL 2 

library(shiny)


# FUNCTII AUXILIARE

# Genereaza esantion pentru distributiile specificate
gen_sample <- function(dist, n, p1, p2 = NA) {
  set.seed(123)  # Pentru reproducibilitate
  
  if (dist == "Normal(0,1)") {
    return(rnorm(n, mean = 0, sd = 1))
  } else if (dist == "Normal(μ,σ²)") {
    return(rnorm(n, mean = p1, sd = p2))
  } else if (dist == "Exponential(λ)") {
    return(rexp(n, rate = p1))
  } else if (dist == "Poisson(λ)") {
    return(rpois(n, lambda = p1))
  } else if (dist == "Binomial(r,p)") {
    return(rbinom(n, size = p1, prob = p2))
  } else {
    stop("Distribuție necunoscută.")
  }
}

# Aplica transformarea la esantion
apply_transformation <- function(x, trans, n_vars) {
  if (trans == "X") {
    return(x)
  } else if (trans == "3+2X" || trans == "2-5X" || trans == "3X+2" || trans == "5X+4") {
    # Extrage coeficientii din string
    if (trans == "3+2X") {
      a <- 2; b <- 3
    } else if (trans == "2-5X") {
      a <- -5; b <- 2
    } else if (trans == "3X+2") {
      a <- 3; b <- 2
    } else if (trans == "5X+4") {
      a <- 5; b <- 4
    }
    return(a * x + b)
  } else if (trans == "X²" || trans == "X³") {
    power <- ifelse(trans == "X²", 2, 3)
    return(x^power)
  } else if (trans == "Σ Xᵢ") {
    # Suma primelor n_vars variabile
    n_samples <- length(x) %/% n_vars
    if (n_samples > 0) {
      mat <- matrix(x[1:(n_samples * n_vars)], ncol = n_vars, byrow = FALSE)
      return(rowSums(mat))
    } else {
      return(x)
    }
  } else if (trans == "Σ Xᵢ²") {
    # Suma patratelor primelor n_vars variabile
    n_samples <- length(x) %/% n_vars
    if (n_samples > 0) {
      mat <- matrix(x[1:(n_samples * n_vars)], ncol = n_vars, byrow = FALSE)
      return(rowSums(mat^2))
    } else {
      return(x)
    }
  }
  return(x)
}

# Calculeaza interval de incredere aproximativ pentru medie
ci_mean_approx <- function(x, alpha = 0.05) {
  n <- length(x)
  m <- mean(x)
  s <- sd(x)
  z <- qnorm(1 - alpha/2)
  err <- z * s / sqrt(n)
  c(lower = m - err, upper = m + err)
}

# ==============================================================================
# USER INTERFACE
# ==============================================================================

ui <- fluidPage(
  titlePanel("Ex.2 Shiny – Simulator Distributii & Statistica"),
  
  sidebarLayout(
    sidebarPanel(
      h4("Configurare Distribuție"),
      
      # Selectarea distribuției
      selectInput("dist", "Distribuție:",
                  choices = c("Normal(0,1)", 
                              "Normal(μ,σ²)", 
                              "Exponential(λ)", 
                              "Poisson(λ)", 
                              "Binomial(r,p)")),
      
      # Mărimea eșantionului
      sliderInput("n", "Mărimea eșantionului n:", 
                  min = 10, max = 5000, value = 500, step = 10),
      
      # Parametri dinamici
      uiOutput("param1_ui"),
      uiOutput("param2_ui"),
      
      hr(),
      
      h4("Transformări"),
      
      # Selectarea transformării
      uiOutput("transformation_ui"),
      
      # Numărul de variabile pentru sume
      conditionalPanel(
        condition = "input.transformation == 'Σ Xᵢ' || input.transformation == 'Σ Xᵢ²'",
        sliderInput("n_vars", "Număr variabile n:", 
                    min = 2, max = 50, value = 10, step = 1)
      ),
      
      hr(),
      
      # Opțiuni de afișare
      checkboxInput("show_ci", "Afișează IC 95% pentru medie (aprox.)", TRUE),
      checkboxInput("show_ecdf", "Afișează funcția de repartiție empirică", TRUE),
      
      hr(),
      
      actionButton("regen", "Generează", class = "btn-primary btn-block"),
      
      br(), br(),
      
      helpText("Reproductibilitate: set.seed(123)"),
      helpText("Aplicație pentru Exercițiul 2 - Proiect PS")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Rezumat", 
                 verbatimTextOutput("summary_txt"),
                 br(),
                 plotOutput("qq_plot", height = "300px")),
        
        tabPanel("Histogram", 
                 plotOutput("hist_plot", height = "500px")),
        
        tabPanel("Funcția de Repartiție", 
                 plotOutput("ecdf_plot", height = "500px")),
        
        tabPanel("Date (primele 50)", 
                 tableOutput("head_tbl")),
        
        tabPanel("Informații Teoretice",
                 uiOutput("theory_text"))
      )
    )
  )
)

# SERVER LOGIC

server <- function(input, output, session) {
  
  # UI Dinamica pentru Parametri
  
  output$param1_ui <- renderUI({
    if (input$dist == "Normal(0,1)") {
      return(NULL)  # Nu are parametri ajustabili
    } else if (input$dist == "Normal(μ,σ²)") {
      numericInput("p1", "Media μ:", value = 0, step = 0.5)
    } else if (input$dist == "Exponential(λ)") {
      numericInput("p1", "Rate λ:", value = 1, min = 0.01, step = 0.1)
    } else if (input$dist == "Poisson(λ)") {
      numericInput("p1", "Lambda λ:", value = 4, min = 0.01, step = 0.5)
    } else if (input$dist == "Binomial(r,p)") {
      numericInput("p1", "Număr încercări r:", value = 10, min = 1, step = 1)
    }
  })
  
  output$param2_ui <- renderUI({
    if (input$dist == "Normal(μ,σ²)") {
      numericInput("p2", "Deviația standard σ:", value = 1, min = 0.01, step = 0.2)
    } else if (input$dist == "Binomial(r,p)") {
      sliderInput("p2", "Probabilitate p:", min = 0.01, max = 0.99, value = 0.5, step = 0.01)
    } else {
      return(NULL)
    }
  })
  
  output$transformation_ui <- renderUI({
    if (input$dist == "Normal(0,1)") {
      choices <- c("X", "3+2X", "X²", "Σ Xᵢ", "Σ Xᵢ²")
    } else if (input$dist == "Normal(μ,σ²)") {
      choices <- c("X", "3+2X", "X²", "Σ Xᵢ", "Σ Xᵢ²")
    } else if (input$dist == "Exponential(λ)") {
      choices <- c("X", "2-5X", "X²", "Σ Xᵢ")
    } else if (input$dist == "Poisson(λ)") {
      choices <- c("X", "3X+2", "X²", "Σ Xᵢ")
    } else if (input$dist == "Binomial(r,p)") {
      choices <- c("X", "5X+4", "X³", "Σ Xᵢ")
    } else {
      choices <- c("X")
    }
    
    selectInput("transformation", "Transformare:",
                choices = choices, selected = "X")
  })
  
    # Generare Date
 
  sample_data <- eventReactive(input$regen, {
    p1 <- if (!is.null(input$p1)) input$p1 else NA
    p2 <- if (!is.null(input$p2)) input$p2 else NA
    
    # Dimensiune esantion ajustata pentru transformari
    n_total <- input$n
    if (input$transformation %in% c("Σ Xᵢ", "Σ Xᵢ²")) {
      n_vars <- if (!is.null(input$n_vars)) input$n_vars else 10
      n_total <- input$n * n_vars
    }
    
    # Generare esantion
    raw_data <- gen_sample(input$dist, n_total, p1, p2)
    
    # Aplicare transformare
    n_vars <- if (!is.null(input$n_vars)) input$n_vars else 10
    transformed_data <- apply_transformation(raw_data, input$transformation, n_vars)
    
    list(
      raw = raw_data,
      transformed = transformed_data
    )
  }, ignoreInit = FALSE)
  
   #  Rezumat Statistic
  
  output$summary_txt <- renderPrint({
    x <- sample_data()$transformed
    
    cat("=== STATISTICI DESCRIPTIVE ===\n\n")
    cat("Distribuție:", input$dist, "\n")
    cat("Transformare:", input$transformation, "\n")
    cat("Dimensiune eșantion:", length(x), "\n\n")
    
    cat("Media:", round(mean(x), 4), "\n")
    cat("Mediana:", round(median(x), 4), "\n")
    cat("Deviația standard:", round(sd(x), 4), "\n")
    cat("Varianța:", round(var(x), 4), "\n")
    cat("Min:", round(min(x), 4), "\n")
    cat("Max:", round(max(x), 4), "\n\n")
    
    cat("Quartile:\n")
    print(round(quantile(x, probs = c(0.25, 0.5, 0.75)), 4))
    
    if (isTRUE(input$show_ci)) {
      ci <- ci_mean_approx(x)
      cat("\n=== INTERVAL DE ÎNCREDERE 95% (aprox.) ===\n")
      cat("IC pentru medie: [", round(ci["lower"], 4), ", ", 
          round(ci["upper"], 4), "]\n", sep = "")
    }
  })
  
  #  Q-Q Plot
  
  output$qq_plot <- renderPlot({
    x <- sample_data()$transformed
    qqnorm(x, main = "Q-Q Plot (verificare normalitate)")
    qqline(x, col = "red", lwd = 2)
  })

  #  Histogramă
  
  output$hist_plot <- renderPlot({
    x <- sample_data()$transformed
    
    hist(x, breaks = 50, 
         main = paste("Histogramă -", input$transformation),
         xlab = "Valori", 
         ylab = "Frecvență",
         col = "lightblue",
         border = "white",
         probability = TRUE)
    
    # Adauga linia de densitate empiric
    lines(density(x), col = "darkblue", lwd = 2)
    
    # Adauga linia mediei
    abline(v = mean(x), col = "red", lwd = 2, lty = 2)
    legend("topright", 
           legend = c("Densitate empirică", "Media"),
           col = c("darkblue", "red"),
           lty = c(1, 2),
           lwd = 2)
  })
  
   #  Functia de Repartitie Empirica (ECDF)
  
  output$ecdf_plot <- renderPlot({
    if (!input$show_ecdf) {
      plot.new()
      text(0.5, 0.5, "Funcția de repartiție dezactivată", cex = 1.5)
      return()
    }
    
    x <- sample_data()$transformed
    
    # Calculare ECDF
    ecdf_func <- ecdf(x)
    
    # Plot ECDF
    plot(ecdf_func, 
         main = paste("Funcția de Repartiție Empirică -", input$transformation),
         xlab = "Valori",
         ylab = "F(x) = P(X ≤ x)",
         col = "darkblue",
         lwd = 2,
         verticals = TRUE,
         do.points = FALSE)
    
    grid()
    
    # Adauga linii pentru quartile
    q <- quantile(x, probs = c(0.25, 0.5, 0.75))
    abline(v = q, col = c("green", "red", "green"), lty = 2)
    abline(h = c(0.25, 0.5, 0.75), col = "gray", lty = 2)
    
    legend("bottomright",
           legend = c("ECDF", "Mediana", "Q1 & Q3"),
           col = c("darkblue", "red", "green"),
           lty = c(1, 2, 2),
           lwd = c(2, 1, 1))
  })
  
  # Tabel Date
  
  output$head_tbl <- renderTable({
    x <- sample_data()$transformed
    data.frame(
      Index = 1:min(50, length(x)),
      Valoare = head(x, 50)
    )
  }, digits = 4)
  
  #  Informatii Teoretice
  
  output$theory_text <- renderUI({
    HTML(paste0(
      "<h3>Informații Teoretice</h3>",
      "<h4>Distribuție Selectată: ", input$dist, "</h4>",
      
      if (input$dist == "Normal(0,1)") {
        paste0(
          "<p><b>Distribuția Normală Standard N(0,1)</b></p>",
          "<ul>",
          "<li>Densitate: f(x) = (1/√(2π)) exp(-x²/2)</li>",
          "<li>Media: E[X] = 0</li>",
          "<li>Varianța: Var(X) = 1</li>",
          "</ul>"
        )
      } else if (input$dist == "Normal(μ,σ²)") {
        paste0(
          "<p><b>Distribuția Normală N(μ,σ²)</b></p>",
          "<ul>",
          "<li>Densitate: f(x) = (1/(σ√(2π))) exp(-(x-μ)²/(2σ²))</li>",
          "<li>Media: E[X] = μ</li>",
          "<li>Varianța: Var(X) = σ²</li>",
          "</ul>"
        )
      } else if (input$dist == "Exponential(λ)") {
        paste0(
          "<p><b>Distribuția Exponențială Exp(λ)</b></p>",
          "<ul>",
          "<li>Densitate: f(x) = λ exp(-λx), x ≥ 0</li>",
          "<li>Media: E[X] = 1/λ</li>",
          "<li>Varianța: Var(X) = 1/λ²</li>",
          "</ul>"
        )
      } else if (input$dist == "Poisson(λ)") {
        paste0(
          "<p><b>Distribuția Poisson Pois(λ)</b></p>",
          "<ul>",
          "<li>Probabilitate: P(X=k) = (λᵏ exp(-λ))/k!</li>",
          "<li>Media: E[X] = λ</li>",
          "<li>Varianța: Var(X) = λ</li>",
          "</ul>"
        )
      } else if (input$dist == "Binomial(r,p)") {
        paste0(
          "<p><b>Distribuția Binomială Binom(r,p)</b></p>",
          "<ul>",
          "<li>Probabilitate: P(X=k) = C(r,k) pᵏ (1-p)ʳ⁻ᵏ</li>",
          "<li>Media: E[X] = rp</li>",
          "<li>Varianța: Var(X) = rp(1-p)</li>",
          "</ul>"
        )
      } else "",
      
      "<h4>Transformare: ", input$transformation, "</h4>",
      "<p>Pentru transformările liniare aX + b:</p>",
      "<ul>",
      "<li>E[aX + b] = aE[X] + b</li>",
      "<li>Var(aX + b) = a²Var(X)</li>",
      "</ul>",
      
      "<p>Pentru suma de n variabile i.i.d.:</p>",
      "<ul>",
      "<li>E[ΣXᵢ] = n·E[X]</li>",
      "<li>Var(ΣXᵢ) = n·Var(X)</li>",
      "</ul>"
    ))
  })
}

shinyApp(ui = ui, server = server)