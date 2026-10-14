# Ecommerce-data-Analytics-and-Refund-Prediction
data analyzes how different mediums and products affected orders and predicts refunds
# Maven Fuzzy Factory — E-commerce Data Analysis & Refund Prediction

## Project Overview

This project analyzes e-commerce data from Maven Fuzzy Factory to understand business performance, customer purchasing behavior, marketing channel effectiveness, and product refund patterns.

The goal is to transform raw business data into actionable insights that can help improve marketing decisions, understand profitability, and investigate refund risks.

The project uses SQL and Python for data analysis and explores machine learning for item-level refund prediction.

## Business Objectives

- Analyze revenue, cost of goods sold (COGS), gross profit, and profit margins.
- Evaluate product sales and purchasing patterns.
- Investigate marketing channel performance and website conversion.
- Analyze product refund rates and identify unusual patterns.
- Develop a machine-learning model to investigate whether refund risk can be predicted using information available at purchase time.

## Tools & Technologies

- **Python:** Data analysis and data preparation
- **Pandas:** Data cleaning, transformation, and analysis
- **Matplotlib:** Data visualization
- **MySQL:** SQL-based business analysis
- **Jupyter Notebook:** Interactive analysis and experimentation
- **Git & GitHub:** Version control and project documentation
- **Scikit-learn:** Planned/ongoing machine-learning experimentation

## Dataset

The dataset contains e-commerce records covering website sessions, pageviews, orders, order items, refunds, and products.

The analysis uses the original CSV files supplied with the Maven Fuzzy Factory dataset.

Key datasets include:

- `website_sessions`
- `website_pageviews`
- `orders`
- `order_items`
- `order_item_refunds`
- `products`

## Key Business Findings

### 1. Overall Financial Performance

- **Total revenue:** $1,938,509.75
- **Cost of goods sold:** $722,370.25
- **Gross profit:** $1,216,139.50
- **Gross profit margin:** 62.74%
- **Average order value:** $59.99

These results summarize the financial performance of 32,313 recorded orders.

### 2. Product and Order Analysis

The business recorded 40,025 order-item records across 32,313 orders. Most orders contained one item, while a smaller proportion contained two items.

Product-level analysis helps compare sales contribution, purchasing patterns, and potential differences in product performance.

### 3. Refund Analysis

The dataset contains 1,731 refund records, representing approximately **4.32% of all recorded order items**.

Refund analysis revealed a notable increase in refunds associated with purchases made during August and September 2014. The Original Mr. Fuzzy product accounted for most of the refunded items during this period.

These findings identify patterns for further investigation; they do not establish the causes of the refund increase.

## Machine Learning: Refund Prediction

The planned modeling task is to investigate whether an order item is likely to be refunded using information available at or before purchase.

The intended target is item-level refund status:

- `1` — The item was refunded within the defined observation window.
- `0` — The item was not refunded within that window.

Before modeling, the project will define the prediction window, address differences in refund observation time, and prevent data leakage from information recorded after the prediction point.

Model performance will be evaluated using metrics appropriate for an imbalanced classification problem, including precision, recall, F1-score, PR-AUC, and a confusion matrix.

## Project Workflow

1. Inspect and validate the source datasets.
2. Clean and prepare data for analysis.
3. Perform SQL-based business analysis.
4. Analyze sales, profitability, marketing performance, and refunds.
5. Create visualizations to communicate findings.
6. Define the refund prediction target and observation window.
7. Engineer appropriate features and build classification models.
8. Evaluate model performance and interpret business implications.

## Repository Structure

The repository will contain the analysis notebooks, relevant project documentation, and supporting files.

A typical structure may look like this:

```text
maven-fuzzy-factory/
├── data/                  # Data files, if appropriate to share
├── notebooks/             # Analysis and modeling notebooks
├── visuals/               # Exported charts and figures
├── README.md
└── .gitignore
```

## Business Value

This project demonstrates how e-commerce data can be used to understand financial performance, evaluate marketing and product patterns, and investigate potential refund risks.

The analysis aims to connect technical work with business questions and support evidence-based decision-making.

## Current Status

Business analysis and refund exploration have been completed. Refund prediction is the next modeling focus, with target definition, observation-window validation, and model development to be documented as the work progresses.


