% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summary_qa_chart.R
\name{summary_qa_chart}
\alias{summary_qa_chart}
\title{summary_qa_chart}
\usage{
summary_qa_chart(data)
}
\arguments{
\item{data}{table resulting from  prepare_qa_data()}
}
\value{
ggplot2 chart
}
\description{
Display a summary QA charts based on data
}
\examples{
data <- prepare_qa_data(activityInfoTable= "cdn6y40lm87wi522")
summary_qa_chart(data)
}
