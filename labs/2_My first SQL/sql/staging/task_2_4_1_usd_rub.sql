select toInt32(sum(revenue_rub / usdrub)) as total_revenue
from revenue_rub
join usd_rub
using (date);