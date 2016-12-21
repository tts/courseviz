library(dplyr)
library(tidyr)
library(ggplot2)
library(ggiraph)
library(readxl)


##################
#
# Parameters
#
##################

colour_file <- "väri1tuijakaikki-1.xlsx"

colour_course_default <- "cornsilk"
colour_rect_margin <- "gray10"
colour_absent <- "darkred"
colour_term_spring <- "darkolivegreen"
colour_term_autumn <- "darkgoldenrod1"
colour_term_spring_sum_points <- "white"
colour_term_autumn_sum_points <- "black"
colour_css_hoverfill <- "fill:orange; opacity: 0.5;"
label_substring_length <- 30
term_height_base <- -0.30
term_label_x_offset <- 1
term_label_y <- -0.15
y_axis_ticks <- c(1,2,"3 (hyv, tt)",4,"5 (ht, et, kh)")
y_axis_empty_ticks <- c("","","","") # first is 0
y_axis_nr_empty_ticks_above_zero <- 3
dark_colors <- c("darkblue", "blue1") # white font for these
y_axis_max <- 3
width_absent <- 10.1
width_zeropoint <- 2.1
height_absent <- 0.2
max_years_per_row <- 8 
font_size <- 6
y_axis_font_size <- 20
year_font_size <- 20
title_font_size <- 20
# Second plot
y_axis_fix_value <- 5

#######################################
#
# Functions for plotting and filtering
#
######################################


draw <- function(df) {
  
  df$onclick <- sprintf("highlight(this); function highlight(e) {var rect = document.querySelectorAll(\"rect[class^=cl_data_id_]\");for (var i = 0; i < rect.length; i++) { var thisattr = e.getAttribute(\"data-id\") ; if ( rect[i].classList.contains(\"myclass\") && rect[i].getAttribute(\"data-id\")===thisattr ) { rect[i].classList.remove(\"myclass\"); } else if ( !rect[i].classList.contains(\"myclass\") && rect[i].getAttribute(\"data-id\")===thisattr ) { rect[i].classList.add(\"myclass\"); } }}")
  
  p <- ggplot(df, aes(ymin = -0.20)) + 
    geom_rect_interactive(aes(xmin = wm,
                              xmax = w,
                              ymin = 0,
                              ymax = height,
                              tooltip = tooltip,
                              onclick = onclick,
                              data_id = uid),
                              #data_id=combinedkey),
                          fill = df$color,
                          colour = colour_rect_margin) +
    geom_rect(aes(xmin = wm, # Lukukausi
                  xmax = w,
                  ymin = term_height_base,
                  ymax = 0),
              fill = ifelse(df$Lukukausi == 'Kevät', colour_term_spring, colour_term_autumn)) +
    geom_text(aes(x = w-term_label_x_offset, # Opintopisteet per lukukausi
                  y = term_label_y,
                  label = termsum),
              size = font_size,
              colour=ifelse(df$Lukukausi == 'Kevät', colour_term_spring_sum_points, colour_term_autumn_sum_points)) +
    geom_text(aes(x = wt, # Opintopisteet
                  y = height + 0.1,
                  label = ifelse(width != width_absent, width, "")),
              #   ifelse(Kurssi_koodi == 'P' || Kurssi_koodi == 'Zero', "", 0))),
              size = font_size) +
    geom_text(aes(x = wt, # Kurssikoodi ja nimi
                  y = height * 0.5,
                  label = ifelse(Kurssi_koodi != "P" & height > 2 , paste0(Kurssi_koodi, " ",Kurssi_nimi), 
                                 ifelse(Kurssi_koodi != "P" & height == 2, Kurssi_koodi,
                                        ifelse(Kurssi_koodi != "P" & height <= 1, "", 
                                               ""))),
                  angle = 90),
              size = font_size,
              colour = ifelse(df$color %in% dark_colors, 'white', 'black')) +
    theme_light() +
    theme(legend.position="none",
          axis.text.x = element_blank(),
          axis.title.x = element_blank(),
          axis.text.y = element_text(size=y_axis_font_size)) + 
    labs(y = "") +
    scale_y_continuous(breaks = seq(0,
                                    y_axis_nr_empty_ticks_above_zero+length(y_axis_ticks),
                                    by=1),
                       labels = c(y_axis_empty_ticks, y_axis_ticks)) 
  # +
  #  ggtitle(paste0(df$Opiskelijanumero, " ",  df$Nimi[1])) +
  #  theme(plot.title = element_text(size = title_font_size))
  #              " ",
  #              ceiling(as.numeric(min(df$schoolyear))),
  #              "-",
  #              ceiling(as.numeric(max(df$schoolyear)))))
  # 
  return(p)
  
}

draw_order <- function(df) {
  
  df$onclick <- sprintf("highlight(this); function highlight(e) {var rect = document.querySelectorAll(\"rect[class^=cl_data_id_]\");for (var i = 0; i < rect.length; i++) { var thisattr = e.getAttribute(\"data-id\") ; if ( rect[i].classList.contains(\"myclass\") && rect[i].getAttribute(\"data-id\")===thisattr ) { rect[i].classList.remove(\"myclass\"); } else if ( !rect[i].classList.contains(\"myclass\") && rect[i].getAttribute(\"data-id\")===thisattr ) { rect[i].classList.add(\"myclass\"); } }}")
  
  p <- ggplot(df, aes(ymin = -0.20)) + 
    geom_rect_interactive(aes(xmin = wm,
                              #xmax = ifelse(!is.na(w), w, x_axis_fix_value),
                              xmax = w,
                              ymin = 0,
                              ymax = y_axis_fix_value,
                             # tooltip = tooltip,
                              onclick = onclick,
                              data_id = uid),
                          fill = df$Vari,
                          colour = colour_rect_margin) +
    geom_rect(aes(xmin = wm, # Lukukausi
                  xmax = w,
                  ymin = term_height_base,
                  ymax = 0),
              fill = ifelse(df$Lukukausi == "Syksy", colour_term_autumn, colour_term_spring)) +
    geom_text(aes(x = wt, # Opintopisteet
                  y = y_axis_fix_value + 0.1,
                  label = ifelse(width != 1.1, width, "")), # Kyps etc
              size = font_size) +
    geom_text(aes(x = wt, # Kurssikoodi ja nimi
                  y = y_axis_fix_value * 0.5,
                  # label = Kurssikoodi,
                  label = Kurssinimi,
                  angle = 90),
              size = font_size,
              colour = ifelse(df$Vari %in% dark_colors, 'white', 'black')) +
    theme_light() +
    theme(legend.position="none",
          axis.text.x = element_blank(),
          axis.title.x = element_blank(),
          axis.text.y = element_blank(),
          axis.title.y = element_blank())
  
  return(p)
  
}



filterdata <- function(df, p) {
  
  courses_of_student <- df %>%
    filter(Nimi == p)
  
  # Add zero terms processing
  #
  # All combinations of term+schoolyear
  min_year <- min(courses_of_student$schoolyear)
  max_year <- max(courses_of_student$schoolyear)
  schoolyear <- rep(seq(min_year, max_year, 1), each=2)
  Lukukausi <- rep(c("Syksy", "Kevät"), length.out=length(schoolyear))
  year_term <- data.frame(schoolyear, Lukukausi, stringsAsFactors = F)
  
  courses_join_year_term <-  merge(courses_of_student, year_term, by = c("Lukukausi", "schoolyear"), all.y = T)
  
  # These terms are not present
  zero_terms <- courses_join_year_term[is.na(courses_join_year_term$Vuosi),]
  
  # Fill in data
  zero_terms_df <- zero_terms %>% 
    mutate(Opiskelijanumero = courses_of_student$Opiskelijanumero[1]) %>% 
    mutate(Nimi = courses_of_student$Nimi[1]) %>% 
    mutate(Kurssi_koodi = "Zero") %>% 
    mutate(Kurssi_nimi = "Ei suorituksia, ei poissaoloa") %>% 
    mutate(Opintopisteet = 0) %>% 
    mutate(Vuosi = ifelse(Lukukausi == 'Kevät', schoolyear+1, schoolyear)) %>% 
    mutate(Vari = "black") %>% 
    mutate(schoolyearrange = ifelse(Lukukausi == 'Kevät', paste0(Vuosi-1, "-", Vuosi), paste0(Vuosi,"-",Vuosi+1)))  %>% 
    mutate(color = "black") %>% 
    mutate(height = height_absent) %>% 
    mutate(width = width_absent) %>% 
    mutate(tooltip = paste0(schoolyearrange, " ", Lukukausi, ": Ei suorituksia")) %>% 
    select(Opiskelijanumero,Nimi,Kurssi_koodi,Kurssi_nimi,Opintopisteet,Lukukausi,Vuosi,Vari,schoolyear,schoolyearrange,color,height,width,tooltip)
  
  # and add to rest of data
  courses_of_student_w_zeros <- rbind(courses_of_student, zero_terms_df)
  #courses_of_student_w_zeros <- courses_of_student_w_zeros %>% 
    #mutate(uid = row.names(.))    
    #mutate(uid = Kurssi_koodi)
    #mutate(uid = Kurssi_nimi)
  
  
  # arrange
  courses_of_student <- courses_of_student_w_zeros %>% 
    arrange(schoolyear, desc(Lukukausi)) 
  
  courses_grouped <- courses_of_student %>%
    group_by(schoolyear) %>%
    mutate(w = cumsum(width)) %>%
    mutate(wm = w - width) %>%
    mutate(wt = wm + (w - wm)/2) %>% 
    group_by(schoolyear, Lukukausi) %>% 
    mutate(termsum = ifelse(row_number()==n(), as.character(sum(Opintopisteet)), "")) # Save the sum(Opintopisteet) in the last course on that term
  
  return(courses_grouped)
}


labels <- function(variable, value){
  if (variable == "schoolyear"){
    value[value == 1980] <- "1980-1981"
    value[value == 1981] <- "1981-1982"
    value[value == 1982] <- "1982-1983"
    value[value == 1983] <- "1983-1984"
    value[value == 1984] <- "1984-1985"
    value[value == 1985] <- "1985-1986"
    value[value == 1986] <- '1986-1987'
    value[value == 1987] <- "1987-1988"
    value[value == 1988] <- "1988-1989"
    value[value == 1989] <- "1989-1990"
    value[value == 1990] <- "1990-1991"
    value[value == 1991] <- "1991-1992"
    value[value == 1992] <- "1992-1993"
    value[value == 1993] <- "1993-1994"
    value[value == 1994] <- '1994-1995'
    value[value == 1995] <- "1995-1996"
    value[value == 1996] <- "1996-1997"
    value[value == 1997] <- "1997-1998"
    value[value == 1998] <- "1998-1999"
    value[value == 1999] <- "1999-2000"
    value[value == 2000] <- "2000-2001"
    value[value == 2001] <- "2001-2002"
    value[value == 2002] <- '2002-2003'
    value[value == 2003] <- "2003-2004"
    value[value == 2004] <- "2004-2005"
    value[value == 2005] <- "2005-2006"
    value[value == 2006] <- "2006-2007"
    value[value == 2007] <- "2007-2008"
    value[value == 2008] <- "2008-2009"
    value[value == 2009] <- "2009-2010"
    value[value == 2010] <- '2010-2011'
    value[value == 2011] <- "2011-2012"
    value[value == 2012] <- "2012-2013"
    value[value == 2013] <- "2013-2014"
    value[value == 2014] <- "2014-2015"
    value[value == 2015] <- "2015-2016"
    value[value == 2016] <- "2016-2017"
    value[value == 2017] <- "2017-2018"
  }
  return(value)
}



################################
#
# Main process begins here.
#
#
#
# 1. Import colors from Excel
#
################################

# colordata <- read_excel("kurssivari.xlsx", sheet=1)
#colordata <- read.csv(colour_file, stringsAsFactors = F)
colordata <- read_excel(colour_file, sheet = 1)

cColors <-
  with(colordata,
       data.frame(course = Kurssikoodi,
                  color = I(Vari)))

###############################
#
# 2. Import course data, and add color
#
###############################

data <- read.csv("CSExport.csv", stringsAsFactors = F, fileEncoding  = "UTF-8-BOM")

# Remove courses with no code nore name
data <- data %>% 
  filter(Kurssi_koodi != '')

data <- data[1:100,]


# Remove single quotes
data$Nimi <- gsub("'", "", data$Nimi)
data$Kurssi_nimi <- gsub("'", "", data$Kurssi_nimi)

data_joined <- left_join(data, colordata, by=c("Kurssi_koodi"= "Kurssikoodi"))

coursedata <- data_joined %>%
  mutate(schoolyear = ifelse(Lukukausi == 'Kevät', Vuosi-1, Vuosi)) %>% # Kevät belongs to the school year that started the previous fall
  mutate(schoolyearrange = ifelse(Lukukausi == 'Kevät', paste0(Vuosi-1, "-", Vuosi), paste0(Vuosi,"-",Vuosi+1))) %>%  # for the tooltip
  mutate(color = ifelse(is.na(Vari) & Kurssi_koodi != 'P', colour_course_default, 
                        ifelse(is.na(Vari) & Kurssi_koodi == 'P', colour_absent, 
                               cColors$color[match(Kurssi_koodi, cColors$course)]))) %>% 
  mutate(height = sapply(Arvosana, function(x){
    as.numeric(ifelse(x == 'hyv', 3+y_axis_max  , # hyväksytty
                    ifelse(x == 'kh', 5+y_axis_max, # kh esim. TFM.kand
                           ifelse(x == 'tt', 3+y_axis_max, # tyydyttävät tiedot
                                  ifelse(x == 'ht', 5+y_axis_max,  # hyvät tiedot
                                         ifelse(x == 'et', 5+y_axis_max, # erinomaiset tiedot
                                                ifelse(x == '', height_absent, as.numeric(x)+y_axis_max)))))))
    })) %>%
  mutate(width = sapply(Opintopisteet, function(x){
    ifelse(x == 0.0, width_zeropoint, x)
  })) %>%
  mutate(width2 = ifelse(is.na(width), width_absent, width)) %>%
  rename(oldwith = width) %>%
  rename(width = width2) %>%
  mutate(tooltip = ifelse(Kurssi_nimi != '',
                          paste0(schoolyearrange, " ", Lukukausi, ": ", Kurssi_nimi, " (", Arvosana, ")"),
                          paste0(schoolyearrange, " ", Lukukausi, ": Poissaolo"))) %>%
  select(-Arvosana, -oldwith, -Koodi)

##########################################
#
# 2.1 Import suositus data, add color
#
##############################################
suositus <- read_excel("kandikurssisynonyymit.xlsx", sheet = 1)
# Name empty columns
names(suositus)[6:ncol(suositus)] <- paste0("col", seq(from=6, to=ncol(suositus), by=1))
# Delete whitespace
suositus$Lukukausi <- gsub("\\s","", suositus$Lukukausi)
# Join with color data
suositus_joined <- left_join(suositus, colordata, by=c("Kurssikoodi"= "Kurssikoodi"))

# tidyr::gather all combinations
# suositus_joined_gathered <- suositus_joined %>%
#   gather(n, k, -Vuosi, -Lukukausi, -Kurssinimi, -Opintopisteet, -Koodi, -Vari, na.rm=TRUE) %>%
#   rename(Kurssikoodi=k) %>%
#   select(-n)

# Construct a combined key from all kurssikoodi variations
suositus_united <- tidyr::unite_(suositus_joined, "combined", colnames(suositus_joined)[5:(ncol(suositus_joined)-2)])
suositus_united$combined <- gsub("_NA","",suositus_united$combined)

#################################
#
# 3. Render course data by student
# as a HTML file 
# with one or two SVG figures
#
#################################

sapply(unique(coursedata$Nimi), function(x) {
  
  Nimi <- x
  
  sapply("html", function(y) {
    
    rmarkdown::render(paste0("kurssi_suositus2_", y, ".Rmd"),
                      output_file = paste0(gsub("[ ,]","", Nimi), ".", y),
                      params = list(
                        person = Nimi))
  })
  
})



