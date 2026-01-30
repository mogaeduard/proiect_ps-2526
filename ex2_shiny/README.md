# Exercițiul 2 - Aplicație Shiny pentru Simularea Distribuțiilor

**Proiect Probabilități și Statistică - Grupa 242**

---

## Cuprins

- [Descriere](#descriere)
- [Funcționalități](#funcționalități)
- [Cerințe Tehnice](#cerințe-tehnice)
- [Instalare și Rulare](#instalare-și-rulare)
- [Utilizare](#utilizare)
- [Structura Aplicației](#structura-aplicației)
- [Aspecte Teoretice](#aspecte-teoretice)
- [Exemple de Utilizare](#exemple-de-utilizare)
- [Pachete Utilizate](#pachete-utilizate)

---

## Descriere {#descriere}

Această aplicație **Shiny** permite simularea și vizualizarea funcțiilor de repartiție empirice pentru diverse variabile aleatoare și transformările lor, conform cerințelor Exercițiului 2 din proiectul de laborator.

Aplicația acoperă toate cele 5 subpuncte din enunț: 1. **Normal(0,1)**: X, 3+2X, X², ΣXᵢ, ΣXᵢ² 2. **Normal(μ,σ²)**: X, 3+2X, X², ΣXᵢ, ΣXᵢ² 3. **Exponential(λ)**: X, 2-5X, X², ΣXᵢ 4. **Poisson(λ)**: X, 3X+2, X², ΣXᵢ 5. **Binomial(r,p)**: X, 5X+4, X³, ΣXᵢ

---

## Funcționalități {#funcționalități}

### Simulări Statistice

- Generare de eșantioane aleatorii pentru 5 tipuri de distribuții
- Aplicarea automată a transformărilor specifice fiecărei distribuții
- Reproducibilitate garantată prin `set.seed(123)`

### Vizualizări Interactive

- **Histograme** cu densitate empirică suprapusă
- **Funcții de repartiție empirice (ECDF)** cu marcaje pentru quartile
- **Q-Q Plots** pentru verificarea normalității
- **Statistici descriptive** complete (medie, mediană, varianță, etc.)

### Interval de Încredere

- Calcul automat al intervalului de încredere 95% pentru medie (aproximativ)
- Bazat pe distribuția normală standard

### Interfață Intuitivă

- Design curat și ușor de utilizat
- ️ Parametri ajustabili dinamic în funcție de distribuția selectată
- Responsive și rapid

---

## Cerințe Tehnice {#cerințe-tehnice}

### Software Necesar

- **R** (versiunea ≥ 4.0.0)
- **RStudio** (recomandat, dar opțional)

### Pachete R Necesare

```r
install.packages("shiny")
```

---

## Instalare și Rulare {#instalare-și-rulare}

### Varianta 1: Din RStudio

1.  Deschideți fișierul `app.R` în RStudio
2.  Apăsați butonul **"Run App"** din bara de sus
3.  Aplicația se va deschide într-o fereastră nouă

### Varianta 2: Din Consola R

```r
# Navigati în directorul unde se afla app.R
setwd("/cale/catre/ex2_shiny")

# Rulati aplicatia
library(shiny)
runApp("app.R")
```

### Varianta 3: Rulare directă

```r
library(shiny)
runApp("/cale/catre/ex2_shiny/app.R")
```

---

## Utilizare {#utilizare}

### Pași de Bază

1.  **Selectați Distribuția**
    - Alegeți din dropdown una dintre cele 5 distribuții disponibile
2.  **Configurați Parametrii**
    - Ajustați parametrii specifici distribuției (μ, σ, λ, r, p)
    - Setați mărimea eșantionului (10-5000)
3.  **Alegeți Transformarea**
    - Selectați transformarea dorită din lista disponibilă
    - Pentru sume (ΣXᵢ), specificați numărul de variabile
4.  **Generați Rezultatele**
    - Apăsați butonul **"Generează"**
    - Explorați cele 5 tab-uri cu rezultate

### Tab-urile Disponibile

| Tab                       | Conținut                                         |
| ------------------------- | ------------------------------------------------ |
| **Rezumat**               | Statistici descriptive + IC 95% + Q-Q Plot       |
| **Histogram**             | Histogramă cu densitate empirică și medie        |
| **Funcția de Repartiție** | ECDF cu quartile marcate                         |
| **Date**                  | Primele 50 de valori din eșantion                |
| **Informații Teoretice**  | Formulele teoretice pentru distribuția selectată |

---

## ️ Structura Aplicației {#structura-aplicației}

```
ex2_shiny/
│
├── app.R
├── README.md
```

### Componentele Codului

#### 1. **Funcții Auxiliare**

```r
gen_sample()             # Generare esantioane
apply_transformation()   # Aplicare transformari
ci_mean_approx()        # Calcul interval de incredere
```

#### 2. **User Interface (UI)**

- Sidebar cu controale pentru parametri
- Main panel cu 5 tab-uri pentru rezultate
- UI dinamic care se adaptează la distribuția selectată

#### 3. **Server Logic**

- Generare reactivă a datelor
- Calculare statistici
- Generare grafice

---

## Aspecte Teoretice {#aspecte-teoretice}

### Distribuții Implementate

#### 1. Normal(0,1) - Distribuția Normală Standard

- **Densitate**: f(x) = (1/√(2π)) exp(-x²/2)
- **Media**: E[X] = 0
- **Varianța**: Var(X) = 1

#### 2. Normal(μ,σ²) - Distribuția Normală Generală

- **Densitate**: f(x) = (1/(σ√(2π))) exp(-(x-μ)²/(2σ²))
- **Media**: E[X] = μ
- **Varianța**: Var(X) = σ²

#### 3. Exponential(λ) - Distribuția Exponențială

- **Densitate**: f(x) = λ exp(-λx), x ≥ 0
- **Media**: E[X] = 1/λ
- **Varianța**: Var(X) = 1/λ²

#### 4. Poisson(λ) - Distribuția Poisson

- **Probabilitate**: P(X=k) = (λᵏ exp(-λ))/k!
- **Media**: E[X] = λ
- **Varianța**: Var(X) = λ

#### 5. Binomial(r,p) - Distribuția Binomială

- **Probabilitate**: P(X=k) = C(r,k) pᵏ (1-p)ʳ⁻ᵏ
- **Media**: E[X] = rp
- **Varianța**: Var(X) = rp(1-p)

### Transformări Liniare

Pentru o transformare de forma **Y = aX + b**: - E[aX + b] = aE[X] + b - Var(aX + b) = a²Var(X)

### Suma Variabilelor i.i.d.

Pentru **S = X₁ + X₂ + ... + Xₙ** unde Xᵢ sunt i.i.d.: - E[S] = n·E[X] - Var(S) = n·Var(X)

### Funcția de Repartiție Empirică (ECDF)

Pentru un eșantion x₁, x₂, ..., xₙ:

**Fₙ(x) = (1/n) · #{i : xᵢ ≤ x}**

Adică, proporția valorilor din eșantion mai mici sau egale cu x.

---

## Exemple de Utilizare {#exemple-de-utilizare}

### Exemplul 1: Verificarea Teoremei Limită Centrale

1.  Selectați **Normal(0,1)**
2.  Alegeți transformarea **ΣXᵢ**
3.  Setați n = 30 variabile
4.  Generați rezultatele
5.  Observați în Q-Q Plot că distribuția sumei este normală

**Interpretare**: Conform TLC, suma a n variabile i.i.d. converge către o distribuție normală.

### Exemplul 2: Transformări Liniare

1.  Selectați **Exponential(λ)** cu λ = 1
2.  Alegeți **X** → Media teoretică = 1
3.  Alegeți **2-5X** → Media teoretică = 2 - 5·(1) = -3
4.  Verificați în tab-ul "Rezumat" că media empirică ≈ -3

### Exemplul 3: Comparație Distribuții

1.  Rulați **Normal(0,1)** cu transformarea **X²**
2.  Rulați **Exponential(0.5)** cu transformarea **X**
3.  Comparați funcțiile de repartiție empirice
4.  Observați asemănările și diferențele

---

## Pachete Utilizate {#pachete-utilizate}

| Pachet       | Versiune | Scop                                       |
| ------------ | -------- | ------------------------------------------ |
| **shiny**    | ≥1.7.0   | Framework pentru aplicații web interactive |
| **stats**    | base     | Funcții statistice (rnorm, rpois, etc.)    |
| **graphics** | base     | Funcții grafice (hist, plot, etc.)         |

---

## Obiectivul Exercițiului

Această aplicație demonstrează:

**Înțelegerea distribuțiilor**: Implementarea corectă a generării de eșantioane pentru 5 distribuții diferite

**Transformări de variabile**: Aplicarea corectă a transformărilor specificate în enunț

**Vizualizare statistică**: Reprezentarea grafică a funcțiilor de repartiție empirice

**Verificare empirică**: Comparația între rezultatele teoretice și cele empirice

**Interactivitate**: Permiterea utilizatorului să exploreze diferite configurații

---

## Statistici și Calcule

### Statistici Descriptive Calculate

- **Media**: Tendința centrală
- **Mediana**: Valoarea care împarte eșantionul în două jumătăți egale
- **Deviația standard**: Măsură a dispersiei datelor
- **Varianța**: Pătratul deviației standard
- **Quartile**: Q1 (25%), Q2 (50%), Q3 (75%)
- **Min/Max**: Valorile extreme

### Interval de Încredere

Formula pentru IC 95% (aproximativ):

**IC = [x̄ - z₀.₉₇₅ · (s/√n), x̄ + z₀.₉₇₅ · (s/√n)]**

unde: - x̄ = media eșantionului - s = deviația standard - n = mărimea eșantionului - z₀.₉₇₅ ≈ 1.96

---

## Detalii de Implementare

### Reproducibilitate

Toate generările de date folosesc `set.seed(123)` pentru a asigura: - Rezultate identice la fiecare rulare - Verificabilitate - Debugging mai ușor

### Performanță

- Optimizat pentru eșantioane de până la 5000 de observații
- Generare rapidă de grafice
- Calcule vectorizate pentru eficiență

### Validare

- Verificare parametri de intrare
- Previne erori prin validare UI
- Mesaje de eroare clare (dacă este cazul)

---

## Referințe

- Documentație Shiny: <https://shiny.posit.co/>
- Curs Probabilități și Statistică FMI: <https://alexamarioarei.quarto.pub/curs-ps-fmi/>
- R Documentation: <https://www.rdocumentation.org/>

---

## Autor

**Moga Eduard-Andrei** - Responsabil Exercițiul 2\
Proiect Probabilități și Statistică 2025-2026\
Grupela 242

---

_Ultima actualizare: Ianuarie 2026_
