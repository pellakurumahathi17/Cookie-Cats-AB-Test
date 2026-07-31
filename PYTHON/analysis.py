import math
from statsmodels.stats.proportion import proportions_ztest, confint_proportions_2indep



gate30_users = 44700
gate40_users = 45489

gate30_day1 = 20034
gate40_day1 = 20119

gate30_day7 = 8502
gate40_day7 = 8279


def analyze_metric(metric_name, success1, success2, total1, total2):

    print("\n" + "=" * 65)
    print(metric_name)
    print("=" * 65)

    rate1 = success1 / total1
    rate2 = success2 / total2

    print(f"Gate 30 Retention : {rate1:.2%}")
    print(f"Gate 40 Retention : {rate2:.2%}")

    absolute_diff = rate1 - rate2
    relative_diff = ((rate1-rate2)/rate2)*100

    print(f"\nAbsolute Difference : {absolute_diff:.2%}")
    print(f"Relative Difference : {relative_diff:.2f}%")

    z_stat, p_value = proportions_ztest(
        [success1, success2],
        [total1, total2]
    )

    print(f"\nZ Statistic : {z_stat:.4f}")
    print(f"P-value     : {p_value:.6f}")

    if p_value < 0.05:
        print("Statistical Significance : YES")
    else:
        print("Statistical Significance : NO")

    low, high = confint_proportions_2indep(
        success1,
        total1,
        success2,
        total2,
        method="wald"
    )

    print(f"\n95% Confidence Interval")
    print(f"({low:.4%}, {high:.4%})")




analyze_metric(
    "DAY 1 RETENTION",
    gate30_day1,
    gate40_day1,
    gate30_users,
    gate40_users
)

analyze_metric(
    "DAY 7 RETENTION",
    gate30_day7,
    gate40_day7,
    gate30_users,
    gate40_users
)