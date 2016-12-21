# courseviz

Plot barcharts from student course data

## Process steps and parameters

### Read in basic data

* Read in course data 
  + *data_file*
  + filter rows non-empty coursed codes if needed
    + *remove_blank_courses*
* Read in course+color data
  + *colour_file*
* Join courses to colors
* Add new data attributes, and wrangle data for plotting purposes
  + add schoolyear
  + if term is Spring, substract Year with 1 (because schoolyear starts from Fall)
  + add schoolyearrange (e.g. 2015-2016) for the tooltip
  + add color. In case there was no special color in the color file, and the course name is not P (absent), use a default one. If the course is P, use that color
    + *colour_course_default*
    + *colour_rect_margin*
    + *colour_absent*
    + *colour_term_spring*
    + *colour_term_autumn*
  + add height. Check if there are grades given in strings rather than in integers. Calculate height based on the number of empty slots on the y axis (for viz purposes) 
    + *y_axis_max*
    + *height_absent*
  + add width
    + *width_zeropoint*
    + *width_absent*
    + *width_zeropoint*
  + add tooltip
* Read in recommendations data, and join with color data
  + *recommendations_file*
* Construct a combined key from all course code variations

### Filter data by student


### Render plots
  
  
  