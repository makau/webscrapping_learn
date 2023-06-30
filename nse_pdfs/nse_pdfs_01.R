library(httr)
library(lubridate)

# Define the URL pattern
url_pattern <- "https://www.nse.co.ke/wp-content/uploads/%s.pdf"

# Define the start date
start_date <- as.Date("2023-06-22")

# Iterate through 1000 days
for (i in 0:999) {
    # Calculate the date for the current iteration
    current_date <- start_date - days(i)

    # Format the date as required by the URL (e.g., 22-JUN-23)
    formatted_date <- format(current_date, "%d-%b-%y")
    formatted_date <- toupper(formatted_date)

    # Construct the URL for the current date
    url <- sprintf(url_pattern, formatted_date)

    # Check if the PDF file exists
    response <- GET(url)
    if (http_status(response)$category == "Success") {
        # Download the PDF file
        pdf_filename <- paste0(formatted_date, ".pdf")
        writeBin(content(response, "raw"), pdf_filename)
        cat("Downloaded:", pdf_filename, "\n")
    } else {
        cat("No PDF for:", formatted_date, "\n")
    }

    # Optional: sleep for 1 second to be polite to the server
    Sys.sleep(1)
}

# Reached 8th december and stopped so start from 7th december

library(pdftools)

# List all the PDF files in the current directory
pdf_files <- list.files("nse_pdfs/extracted_pdfs", pattern = "*.pdf")

# Function to parse tables from the text content of a PDF
# NOTE: This is a placeholder function. The actual implementation will depend on the structure of your PDFs.
parse_tables <- function(text_content) {
    # Custom logic to parse tables from text_content goes here
    # ...

    # Return the parsed tables
    # Example: return(list(table1, table2, ...))
}

# Loop through each PDF file
for (pdf_file in pdf_files) {
    # Extract text content from the PDF
    text_content <- pdf_text(pdf_file)

    # Parse tables from the text content
    tables <- parse_tables(text_content)

    # Write the tables to CSV files
    for (i in seq_along(tables)) {
        csv_filename <- paste0(tools::file_path_sans_ext(pdf_file), "_table", i, ".csv")
        write.csv(tables[[i]], file = csv_filename)
    }
}
