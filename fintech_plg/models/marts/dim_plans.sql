select
    plan_id,
    plan_name,
    monthly_price
from (
    values
        ('free', 'Free', 0.00),
        ('premium', 'Premium', 99.99),
        ('enterprise', 'Enterprise', 299.99)
) as plans(plan_id, plan_name, monthly_price)