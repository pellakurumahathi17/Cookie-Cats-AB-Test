CREATE TABLE cookie_cats (
    userid BIGINT PRIMARY KEY,
    version VARCHAR(10),
    sum_gamerounds INT,
    retention_1 BOOLEAN,
    retention_7 BOOLEAN
);

SELECT
    COUNT(*) FILTER (WHERE userid IS NULL) AS missing_userid,
    COUNT(*) FILTER (WHERE version IS NULL) AS missing_version,
    COUNT(*) FILTER (WHERE sum_gamerounds IS NULL) AS missing_rounds,
    COUNT(*) FILTER (WHERE retention_1 IS NULL) AS missing_retention1,
    COUNT(*) FILTER (WHERE retention_7 IS NULL) AS missing_retention7
FROM cookie_cats;

SELECT
    version,
    COUNT(*) AS users
FROM cookie_cats
GROUP BY version;

SELECT
    version,
    COUNT(*) AS users,
    ROUND(AVG(sum_gamerounds),2) AS avg_rounds,
    MIN(sum_gamerounds) AS min_rounds,
    MAX(sum_gamerounds) AS max_rounds,
    ROUND(STDDEV(sum_gamerounds),2) AS std_dev
FROM cookie_cats
GROUP BY version;

SELECT
    version,
    PERCENTILE_CONT(0.5)
    WITHIN GROUP (ORDER BY sum_gamerounds) AS median_rounds
FROM cookie_cats
GROUP BY version;

SELECT
    CASE
        WHEN sum_gamerounds = 0 THEN '0'
        WHEN sum_gamerounds BETWEEN 1 AND 10 THEN '1-10'
        WHEN sum_gamerounds BETWEEN 11 AND 50 THEN '11-50'
        WHEN sum_gamerounds BETWEEN 51 AND 100 THEN '51-100'
        WHEN sum_gamerounds BETWEEN 101 AND 500 THEN '101-500'
        ELSE '500+'
    END AS rounds_bucket,
    COUNT(*) AS players
FROM cookie_cats
GROUP BY rounds_bucket
ORDER BY
MIN(sum_gamerounds);

SELECT
    version,
    COUNT(*) AS total_users,
    SUM(CASE WHEN retention_1 = TRUE THEN 1 ELSE 0 END)
        AS retained_day1,
   ROUND(
        AVG(
            CASE
                WHEN retention_1 = TRUE THEN 1
                ELSE 0
            END
        ) * 100,2
    ) AS day1_retention_pct,
  SUM(CASE WHEN retention_7 = TRUE THEN 1 ELSE 0 END)
        AS retained_day7,
    ROUND(
        AVG(
            CASE
                WHEN retention_7 = TRUE THEN 1
                ELSE 0
            END
        ) * 100,2
    ) AS day7_retention_pct
FROM cookie_cats
GROUP BY version;

SELECT
    version,
    ROUND(
        AVG(retention_1::int)*100,2
    ) AS day1_retention,
    ROUND(
        AVG(retention_7::int)*100,2
    ) AS day7_retention
FROM cookie_cats
GROUP BY version;

SELECT
    version,
    COUNT(*) FILTER (
        WHERE sum_gamerounds >= 100
    ) AS players_100_plus,

    COUNT(*) FILTER (
        WHERE sum_gamerounds >= 500
    ) AS players_500_plus
FROM cookie_cats
GROUP BY version;

SELECT
CASE
WHEN sum_gamerounds BETWEEN 0 AND 10 THEN '0-10'
WHEN sum_gamerounds BETWEEN 11 AND 50 THEN '11-50'
WHEN sum_gamerounds BETWEEN 51 AND 100 THEN '51-100'
WHEN sum_gamerounds BETWEEN 101 AND 500 THEN '101-500'
ELSE '500+'
END AS engagement_group,

COUNT(*) AS users,
ROUND(AVG(retention_1::int)*100,2)
AS day1_retention,
ROUND(AVG(retention_7::int)*100,2)
AS day7_retention
FROM cookie_cats
GROUP BY engagement_group
ORDER BY
MIN(sum_gamerounds);

SELECT
version,
COUNT(*) AS total_users,
SUM(retention_1::int)
AS retained_day1,
SUM(retention_7::int)
AS retained_day7
FROM cookie_cats
GROUP BY version;
