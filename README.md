# Financial Statement EDA — Top 200 US Companies

**Central question: How do profitability, liquidity, and valuation vary across large US public companies, and are they related?**

A SQL exploratory data analysis of real financial statement data for ~225 US public companies. Income statement, balance sheet, and derived accounting ratios pulled from a Kaggle dataset of top US companies.

## Dataset
- Source: [Financial Statement Data for Top 200 US Companies](https://www.kaggle.com/) (Kaggle)
- Scope: 225 companies, 40+ metrics
- Fields: market cap, total revenue, profit margins, current ratio, PEG ratio, total debt, total cash, and other accounting/valuation metrics

## Approach
1. **Validate** — Checked key metrics (`marketCap`, `totalRevenue`, `profitMargins`, `currentRatio`, `pegRatio`) for NULL, empty-string, and whitespace-only values before analysis
2. **Type-cast & filter** — Cast text-stored numeric fields (e.g. `marketCap`, `totalRevenue`) to `DECIMAL(20,2)`, and filtered ratio fields to exclude non-positive or placeholder values so bad data entries didn't distort rankings
3. **Rank** — Used window functions (`RANK() OVER`, `COUNT() OVER`) to identify the top 10 and bottom 10 companies by market cap, revenue, profit margin, current ratio, and PEG ratio
4. **Segment** — Used CASE-based segmentation to bucket companies into liquidity status groups (`Liquidity Risk` vs. `Adequate Liquidity`) and compared average market cap and profit margin across them
5. **Cross-analyze** — Built a derived `net_debt` metric (`totalDebt − totalCash`) via a CTE, then cross-segmented companies by liquidity status and leverage status (`Net Debtor` vs. `Net Cash Position`) to compare average net debt across groups

## Key findings
- Companies with Adequate Liquidity have higher average profit margins and higher market capitalization than companies at Liquidity Risk
- Companies that have Liqudity Risk and are Net Debtors have the highest average net debt. 

## Files
- `data_loading.sql` — loads data into database
- `data_analysis.sql` — data validation checks, top/bottom-10 rankings, and liquidity/leverage segmentation queries


## Tools
MySQL