import pandas as pd
import matplotlib.pyplot as plt



df = pd.read_csv("../data/cookie_cats.csv")


fig, axs = plt.subplots(2, 2, figsize=(14, 10))


groups = ["Gate 30", "Gate 40"]

day1 = [44.82, 44.23]
day7 = [19.02, 18.20]

x = [0, 1]
width = 0.35

axs[0,0].bar([i-width/2 for i in x], day1, width, label="Day 1")
axs[0,0].bar([i+width/2 for i in x], day7, width, label="Day 7")

axs[0,0].set_xticks(x)
axs[0,0].set_xticklabels(groups)
axs[0,0].set_ylabel("Retention (%)")
axs[0,0].set_title("Retention Comparison")
axs[0,0].legend()


filtered = df[df["sum_gamerounds"] <= 200]

axs[0,1].hist(filtered["sum_gamerounds"], bins=40)

axs[0,1].set_title("Distribution of Game Rounds")
axs[0,1].set_xlabel("Game Rounds")
axs[0,1].set_ylabel("Players")


axs[1,0].boxplot(filtered["sum_gamerounds"], vert=False)

axs[1,0].set_title("Game Rounds Distribution")
axs[1,0].set_xlabel("Game Rounds")


bins = [0,10,50,100,500,2500]

labels = [
    "0-10",
    "11-50",
    "51-100",
    "101-500",
    "500+"
]

df["engagement"] = pd.cut(
    df["sum_gamerounds"],
    bins=bins,
    labels=labels,
    include_lowest=True
)

retention = (
    df.groupby("engagement")["retention_7"]
      .mean()*100
)

axs[1,1].bar(retention.index.astype(str), retention.values)

axs[1,1].set_title("7-Day Retention by Engagement")
axs[1,1].set_ylabel("Retention (%)")

plt.tight_layout()

plt.savefig("../OUTPUTS/dashboard.png", dpi=300)

plt.show()