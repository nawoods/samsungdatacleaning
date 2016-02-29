---
title: "README"
author: "Nick Woods"
date: "February 29, 2016"
output: html_document
---

This is an implementation of the final project for the 'Getting and Cleaning Data' course administerd by Rice University at Coursera. It consists of a single script, run_analysis.R, which downloads a dataset obtained by Smartlab at the Università degli Studi di Genova containing information obtained by the sensors of Samsung Galaxy S phones while experiment subjects were partaking in various activities. More information can be found in the README file of the original data:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The script will return resultsMeans, which takes the mean of each variable of interest (detailed in the codebook) over observances with the same subject and activity. The data frame results is also of interest; it contains the value of each variable for every observance recorded by the experiment.

Every attempt has been made to follow the principles set forth in the course. For example, the variable names are in all lowercase, use plain English, and are without periods or underscores; because the underlying information is somewhat complex