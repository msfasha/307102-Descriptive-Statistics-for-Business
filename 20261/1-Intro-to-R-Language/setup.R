# =============================================================================
# 307102 Descriptive Statistics for Business - R Track
# University of Petra
#
# SETUP SCRIPT - run this once, before you start section 1.
#
# How to run it:
#   Click the "Source" button at the top right of this editor pane.
#   (Or press Ctrl+Shift+S on Windows, Cmd+Shift+S on Mac.)
#
# The first run downloads packages and may take five minutes.
# A lot of red text will scroll past. That is normal.
# You are done when you see SETUP COMPLETE at the bottom.
# =============================================================================


# -----------------------------------------------------------------------------
# 0. Check the R version
# -----------------------------------------------------------------------------
# The course uses the pipe operator |>, which was introduced in R 4.1.0.
# On an older version every notebook will fail with "unexpected '>'".

r_version <- getRversion()

cat("R version:", as.character(r_version), "\n\n")

if (r_version < "4.1.0") {
  stop(
    "\n\nYour version of R is too old for this course.\n",
    "You have ", as.character(r_version), "; you need 4.1.0 or newer.\n\n",
    "Fix: install the current version of R from https://cran.r-project.org\n",
    "then restart RStudio and run this script again.\n"
  )
}


# -----------------------------------------------------------------------------
# 1. Work out where we are
# -----------------------------------------------------------------------------
# R needs to know which folder to look in for files. This section finds the
# R-Version folder no matter where you launched R from.

find_r_version_root <- function() {

  here <- normalizePath(getwd(), mustWork = FALSE)

  candidates <- c(
    here,                                   # already in R-Version
    dirname(here),                          # in one of the section folders
    file.path(here, "R-Version"),           # in the course root
    file.path(dirname(here), "R-Version")   # in a sibling folder
  )

  for (path in candidates) {
    if (dir.exists(file.path(path, "1-Intro-to-R-Language"))) {
      return(normalizePath(path, mustWork = FALSE))
    }
  }

  NA_character_
}

R_VERSION_ROOT <- find_r_version_root()

if (is.na(R_VERSION_ROOT)) {
  stop(
    "\n\nCould not locate the R-Version folder.\n",
    "Fix: in the RStudio menu choose\n",
    "  Session -> Set Working Directory -> To Source File Location\n",
    "then click Source again.\n"
  )
}

COURSE_ROOT <- dirname(R_VERSION_ROOT)
DATA_DIR    <- file.path(R_VERSION_ROOT, "data")

cat("R-Version folder:", R_VERSION_ROOT, "\n")
cat("Course folder:   ", COURSE_ROOT, "\n\n")


# -----------------------------------------------------------------------------
# 2. Install the packages the course uses
# -----------------------------------------------------------------------------
# A "package" is an add-on that gives R extra abilities. Base R can already do
# statistics; these make the code easier to read and the graphs nicer.

required_packages <- c(
  "tidyverse",   # data handling (dplyr) and graphs (ggplot2)     - all sections
  "readxl",      # reads .xlsx files                              - all sections
  "knitr",       # turns notebooks into HTML documents            - all sections
  "rmarkdown",   # the notebook format itself                     - all sections
  "scales",      # readable axis labels on graphs                 - section 2
  "moments",     # skewness and kurtosis                          - section 2
  "car",         # Levene's test for equal variances              - section 3.3
  "effectsize",  # Cohen's d and eta-squared                      - section 3.3
  "broom"        # tidies up model output                         - section 3.4
)

cat("Checking packages...\n")

missing_packages <- required_packages[
  !(required_packages %in% rownames(installed.packages()))
]

if (length(missing_packages) > 0) {
  cat("Installing:", paste(missing_packages, collapse = ", "), "\n")
  cat("This may take several minutes. Please wait.\n\n")
  install.packages(missing_packages, repos = "https://cloud.r-project.org")
} else {
  cat("All packages already installed.\n\n")
}

still_missing <- required_packages[
  !(required_packages %in% rownames(installed.packages()))
]

if (length(still_missing) > 0) {
  cat("\nWARNING - these packages did not install:\n")
  cat(paste(" -", still_missing, collapse = "\n"), "\n")
  cat("\nTry running this line in the Console, then run setup again:\n")
  cat('  install.packages(c("', paste(still_missing, collapse = '", "'),
      '"), type = "binary")\n', sep = "")
  cat("\nSections 1 and 2 will still work without car, effectsize or broom.\n")
} else {
  cat("Package check passed.\n\n")
}


# -----------------------------------------------------------------------------
# 3. Copy the datasets into R-Version/data/
# -----------------------------------------------------------------------------
# The datasets already exist elsewhere in the course folder. This copies them
# into one place so the notebooks can find them with a short, simple path.

if (!dir.exists(DATA_DIR)) {
  dir.create(DATA_DIR, recursive = TRUE)
  cat("Created folder:", DATA_DIR, "\n")
}

datasets <- list(
  list(
    name = "supermarket_sales.xlsx",
    from = file.path(COURSE_ROOT, "Practical", "beta", "supermarket_sales.xlsx"),
    required = TRUE
  ),
  list(
    name = "superstore.xlsx",
    from = file.path(COURSE_ROOT, "Practical", "analysis_scenarios",
                     "superstore dataset", "superstore.xlsx"),
    required = FALSE
  ),
  list(
    name = "fifa18_clean.csv",
    from = file.path(COURSE_ROOT, "Practical", "analysis_scenarios",
                     "sport analytics", "fifa18_clean.csv"),
    required = FALSE
  )
)

cat("Checking datasets...\n")

for (ds in datasets) {

  destination <- file.path(DATA_DIR, ds$name)

  if (file.exists(destination)) {
    cat(" ok      ", ds$name, "\n")
  } else if (file.exists(ds$from)) {
    file.copy(ds$from, destination)
    cat(" copied  ", ds$name, "\n")
  } else if (ds$required) {
    cat(" MISSING ", ds$name, "\n")
    cat("          Expected at:", ds$from, "\n")
    cat("          Copy this file into:", DATA_DIR, "\n")
  } else {
    cat(" skipped ", ds$name, "(optional, not found)\n")
  }
}

cat("\n")


# -----------------------------------------------------------------------------
# 4. Load the main dataset and check it looks right
# -----------------------------------------------------------------------------

supermarket_path <- file.path(DATA_DIR, "supermarket_sales.xlsx")

if (!file.exists(supermarket_path)) {

  cat("Cannot run the data check - supermarket_sales.xlsx is not in the data\n")
  cat("folder yet. Copy it there and run this script again.\n")

} else if (!requireNamespace("readxl", quietly = TRUE)) {

  cat("Cannot run the data check - the readxl package did not install.\n")

} else {

  sales <- readxl::read_excel(supermarket_path)

  cat("Loaded supermarket_sales.xlsx\n")
  cat("  Rows:   ", nrow(sales), "\n")
  cat("  Columns:", ncol(sales), "\n\n")

  expected <- c(
    "Invoice ID", "Branch", "City", "Customer type", "Gender",
    "Product line", "Unit price", "Quantity", "Tax 5%", "Total",
    "Date", "Time", "Payment", "cogs", "gross margin percentage",
    "gross income", "Rating"
  )

  absent <- setdiff(expected, names(sales))

  if (length(absent) == 0) {
    cat("Data check passed - all 17 expected columns are present.\n\n")
  } else {
    cat("NOTE - these expected columns were not found:\n")
    cat(paste("  -", absent, collapse = "\n"), "\n")
    cat("\nThe notebooks may need small edits to match your file.\n")
    cat("Show this message to your instructor.\n\n")
    cat("Column names actually found:\n")
    for (nm in names(sales)) cat("  -", nm, "\n")
    cat("\n")
  }
}


# -----------------------------------------------------------------------------
# 5. Done
# -----------------------------------------------------------------------------

cat("=====================================================\n")
cat("  SETUP COMPLETE\n")
cat("=====================================================\n")
cat("\nNext step: open\n")
cat("  1-Intro-to-R-Language/Intro-to-R.qmd\n")
cat("and work through it.\n\n")
