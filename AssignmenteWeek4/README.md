---
title: "README"
author: "Raúl B. Rodas"
date: "8/5/2016"
---

This file explains what was done for this project assignment. The final output are two files: **tidy_data_set.csv** and **tidy_data_set_2.csv**. The first file is the tidy data set which includes just the means and standard deviations. On the other hand the second file are the averages grouped by **activity** and **subject**.

In this file is explained how both were worked out, starting for the first file and then second one. Before doing anything it's important to point out that was downloaded the original data set from the site showed in Coursera Site, once downloaded the file this one was unzip.

### Main Tidy Data Set

For the first tidy data set was created a function to help import the raw data sets, after that the training and test set were imported and binded. Second that were selected just the columns concerning the means and standard deviations. Third the label was added and the names of the variables labeled appropriately.

### Second Tidy Data Set
A combined factor variables was created based on the activity and the subject, once done that it was easy to calculate the average of the columns with the **sapply** function.
