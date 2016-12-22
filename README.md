courseviz
==========

Courseviz plots two barcharts on an HTML page, representing course data of a student on timeline. There is a tooltip, and corresponding courses are highlighted by clicking. Courseviz aims to help in checking how the student is progressing, how many study points she has done during the terms, and how much she has followed the recommended order of courses in the program.

### Prerequisites

* basic **course** data in CSV from reporting services: student number, student name, course code, course name, year, term, study points, score
* an Excel spreadsheet to **color** courses by type: course code, name of the course type, and color name for that type (TODO: matching step)
* an Excel spreadsheet with the **recommended order** of taking courses: year (1, 2 etc), term, course name, study points, course codes (alternatives in successive cells in the same row)

### How to use

Save data files in `data` subdirectory, and run `run.R`. The HTML files are outputted in the work directory, one file per student. 

If you are looking for a solution that produces a whole HTML site structure with index.html etc, see [coursevizsite](https://github.com/tts/coursevizsite)

### Credits

Thanks to RStudio for [R Markdown](http://rmarkdown.rstudio.com), Hadley Wickham and other contributors for [dplyr](https://github.com/hadley/dplyr), [tidyr](https://github.com/tidyverse/tidyr), [ggplot2](https://github.com/tidyverse/ggplot2) and [readxl](https://github.com/hadley/readxl), David Gohel for [ggiraph](https://github.com/davidgohel/ggiraph), and the whole R community for all the rest. 



  