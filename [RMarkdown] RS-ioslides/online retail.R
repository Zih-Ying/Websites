library(readxl)
order <- read_xlsx("Online Retail.xlsx", 1)
customer <- read_xlsx("Online Retail.xlsx", 2)
# names(order)
# names(customer)
df <- merge(order, customer, by="CustomerID")
# saveRDS(customer,"data/customer.rds")
names(df)

unique(df$InvoiceNo)|>length() # 發票數
unique(df$CustomerID)|>length() # 消費者人數
unique(c(df$InvoiceNo, df$StockCode))|>length()
unique(df$StockCode)|>length()

tmp <- df[duplicated(df$StockCode), c("StockCode","Description")]
tmp <- tmp[!duplicated(tmp$Description),]

library(dplyr)
tmp <- df %>% 
  group_by(Description, StockCode) %>%
  filter(n()>1) %>%
  select(c("StockCode","Description"))
tmp %>% 
  group_by(StockCode) %>%
  filter(n()>1) 
