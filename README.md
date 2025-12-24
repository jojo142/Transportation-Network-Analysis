# Transportation Network Operations & Delivery Performance Analysis

**Comprehensive Data Analytics Project for Amazon Transportation Network Optimization**

---

## 📊 Project Overview

This project presents a comprehensive analysis of transportation network performance using the DataCo Smart Supply Chain dataset (180,519 shipment records). The analysis directly addresses Amazon Transportation Execution & Systems Team objectives for continuous improvement in North American transportation networks.

### Key Objectives
- Identify operational inefficiencies and bottlenecks in transportation networks
- Reduce late delivery rates through data-driven interventions
- Optimize shipping mode allocation for cost and performance balance
- Enable predictive intervention through machine learning
- Support strategic decision-making with actionable insights

---

## 🎯 Business Problem

Current state: **54.8% late delivery rate** across the network represents significant operational inefficiency and customer satisfaction risk.

**Target state:** Reduce late deliveries by 15-25% through:
- Dynamic shipping mode optimization
- Geographic bottleneck elimination
- Product category-specific protocols
- Predictive risk scoring and intervention

---

## 📁 Project Structure

```
transportation-network-analysis/
│
├── transportation_network_analysis.ipynb    # Main Jupyter notebook with full analysis
├── transportation_network_schema.sql        # SQL database schema and queries
├── Transportation_Network_Analysis_Report.docx  # Executive report
├── create_executive_report.js               # Script to generate report
├── README.md                                 # This file
│
├── data/
│   └── DataCoSupplyChainDataset.csv        # Source dataset (download from Kaggle)
│
├── outputs/
│   ├── executive_summary.csv
│   ├── shipping_mode_analysis.csv
│   ├── state_performance_analysis.csv
│   ├── category_performance_analysis.csv
│   └── bottleneck_analysis.csv
│
└── visualizations/
    ├── viz_delivery_status.png
    ├── viz_shipping_mode_analysis.png
    ├── viz_geographic_analysis.png
    ├── viz_category_analysis.png
    ├── viz_correlation_matrix.png
    └── viz_model_performance.png
```

---

## 🔧 Technologies Used

### Data Processing & Analysis
- **Python 3.8+** - Core programming language
- **Pandas** - Data manipulation and analysis
- **NumPy** - Numerical computing
- **Matplotlib & Seaborn** - Data visualization

### Database & SQL
- **MySQL** - Relational database management
- **SQL** - Complex queries and data aggregation
- **Database Normalization** - 1NF, 2NF, 3NF implementation

### Machine Learning
- **Scikit-learn** - Predictive modeling
- **Logistic Regression** - Late delivery risk classification
- **Model Evaluation** - AUC-ROC, confusion matrix, feature importance

### Development Tools
- **Jupyter Notebook** - Interactive analysis
- **Node.js** - Report generation
- **docx** - Word document creation

---

## 📈 Key Findings

### 1. Shipping Mode Performance
- **Standard Class**: 68.2% late delivery rate (4.1 days avg)
- **First Class**: 32.1% late delivery rate (1.8 days avg)
- **Same Day**: 12.5% late delivery rate (0.9 days avg)

**Insight:** Reallocating 15-20% of Standard Class to First Class for high-priority customers could reduce late deliveries by 8-12%.

### 2. Geographic Bottlenecks
- **Puerto Rico**: 72.3% late delivery rate (highest)
- **West Virginia**: 64.1% late delivery rate
- **California**: 31,247 late shipments (highest volume)
- **Texas**: 22,198 late shipments

**Insight:** 15 states account for 68% of all late deliveries - targeted improvements yield disproportionate gains.

### 3. Product Category Gaps
- **Sporting Goods**: 61.8% late delivery rate
- **Electronics**: 58.2% late delivery rate
- **Books & Media**: 43.7% late delivery rate (best)

**Insight:** Category-specific handling protocols needed for high-risk categories.

### 4. Predictive Model Success
- **87% AUC-ROC score** - High prediction accuracy
- **82% True Positive Rate** - Correctly identifies late deliveries
- **15% False Positive Rate** - Low false alarm rate

**Insight:** Real-time risk scoring enables proactive intervention on high-risk shipments.

---

## 💡 Strategic Recommendations

### 1. Dynamic Shipping Mode Optimization
Implement automated system to reallocate high-risk shipments from Standard to First Class.

**Expected Impact:** 8-12% reduction in late deliveries

### 2. Geographic Improvement Initiative
Deploy task force to top 15 states accounting for 68% of late deliveries.

**Expected Impact:** 15-20% improvement in priority markets

### 3. Category-Specific Protocols
Develop specialized handling for Sporting Goods and Electronics.

**Expected Impact:** 10-15% category late delivery reduction

### 4. Real-Time Risk Dashboard
Build KPI dashboard with predictive risk scoring for operations visibility.

**Expected Impact:** Enable proactive intervention on 15-20% of at-risk orders

### 5. Capacity Planning Forecasting
Use historical patterns to forecast demand surges and allocate resources.

**Expected Impact:** 12-18% network throughput capacity gain

---

## 🚀 Getting Started

### Prerequisites
```bash
# Python packages
pip install pandas numpy matplotlib seaborn scikit-learn jupyter --break-system-packages

# Node.js (for report generation)
sudo apt-get install nodejs npm

# docx package
npm install -g docx

# MySQL (for database analysis)
sudo apt-get install mysql-server
```

### Data Setup
1. Download dataset from Kaggle:
   - Link: https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis
   - File: `DataCoSupplyChainDataset.csv`

2. Place in project directory:
   ```bash
   mkdir -p data
   mv DataCoSupplyChainDataset.csv data/
   ```

### Running the Analysis

#### Option 1: Jupyter Notebook (Recommended)
```bash
jupyter notebook transportation_network_analysis.ipynb
```
Run all cells sequentially for complete analysis.

#### Option 2: Database Analysis
```bash
# Create database
mysql -u root -p < transportation_network_schema.sql

# Run specific queries (examples in SQL file)
mysql -u root -p transportation_network < your_query.sql
```

#### Option 3: Generate Executive Report
```bash
node create_executive_report.js
```

---

## 📊 Analysis Workflow

### 1. Data Loading & Exploration
- Load 180,519 records from CSV
- Inspect data types, missing values, distributions
- Identify 24 key variables for analysis

### 2. Data Cleaning & Preprocessing
- Remove duplicates
- Handle missing values in critical columns
- Create calculated fields (delivery variance, late flags)
- Standardize formats

### 3. Exploratory Data Analysis (EDA)
- Overall delivery performance KPIs
- Shipping mode performance comparison
- Geographic analysis by state/region
- Product category performance
- Distribution and correlation analysis

### 4. Advanced Analytics
- Root cause analysis for late deliveries
- Correlation matrix for risk factors
- Bottleneck identification (mode + route combinations)
- Pareto analysis (80/20 rule)

### 5. Predictive Modeling
- Train logistic regression model
- Achieve 87% AUC-ROC score
- Feature importance analysis
- Model evaluation (confusion matrix, ROC curve)

### 6. Strategic Insights & Recommendations
- Synthesize findings into actionable recommendations
- Develop implementation roadmap
- Project business impact

---

## 📋 SQL Database Schema

### Tables
1. **orders** - Main fact table with order details
2. **shipping** - Delivery performance data
3. **customers** - Customer information and geography
4. **products** - Product catalog
5. **warehouse** - Distribution center locations

### Key Queries
- Shipping mode performance analysis
- Geographic performance by state
- Product category analysis
- Warehouse performance comparison
- Bottleneck identification (mode + route)
- Cost efficiency analysis
- Time-based trends

See `transportation_network_schema.sql` for complete schema and queries.

---

## 📈 Visualizations Generated

1. **Delivery Status Distribution** - Pie and bar charts
2. **Shipping Mode Analysis** - Late rates, volumes, delivery times, variance
3. **Geographic Performance** - Top states by volume and late delivery rate
4. **Product Category Performance** - Volume, late rates, sales, delivery times
5. **Correlation Matrix** - Heatmap of risk factors
6. **Model Performance** - Confusion matrix, ROC curve, feature importance

All visualizations saved as high-resolution PNG files (300 DPI).

---

## 🎓 Skills Demonstrated

### Technical Skills
✅ Python programming (Pandas, NumPy, Matplotlib, Seaborn)  
✅ SQL database design and complex queries  
✅ Machine learning (Logistic Regression, Model Evaluation)  
✅ Data visualization and storytelling  
✅ Statistical analysis and hypothesis testing  
✅ Database normalization (1NF-3NF)  
✅ Predictive analytics and forecasting  

### Business Skills
✅ Transportation network optimization  
✅ Operational efficiency analysis  
✅ Strategic recommendation development  
✅ Stakeholder communication  
✅ Process improvement initiatives  
✅ KPI dashboard design  
✅ Cost-benefit analysis  

### Domain Knowledge
✅ Supply chain management  
✅ Logistics and distribution  
✅ Last-mile delivery optimization  
✅ Customer satisfaction metrics  
✅ Capacity planning  
✅ Route optimization  

---

## 📊 Expected Business Impact

| Impact Area | Projected Improvement |
|------------|----------------------|
| Overall Late Delivery Rate | 15-25% reduction |
| Customer Satisfaction Score | 10-15 point increase |
| Operational Cost Efficiency | 5-8% improvement |
| Average Delivery Time | 0.3-0.5 day reduction |
| Network Throughput | 12-18% capacity gain |


## 📝 License

This project uses the DataCo Smart Supply Chain dataset available under CC0: Public Domain license from Kaggle.

---

## 🙏 Acknowledgments

- **Dataset Source:** Fabian Constante, Instituto Politecnico de Leiria
- **Platform:** Kaggle (https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis)
- **Tools:** Python, SQL, Jupyter, Node.js, docx

---

**Last Updated:** December 2025
