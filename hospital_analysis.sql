CREATE OR REPLACE VIEW hospital_analysis AS
SELECT
    LPAD(CAST("Facility ID" AS INTEGER)::TEXT, 6, '0') AS facility_id,
    "Facility Name" AS facility_name,
    "City/Town" AS city,
    "State" AS state,
    "Hospital Type" AS hospital_type,
    "Hospital Ownership" AS hospital_ownership,
    "Emergency Services" AS emergency_services,

    CASE
        WHEN "Hospital overall rating" <> 'Not Available'
        THEN CAST("Hospital overall rating" AS NUMERIC)
    END AS overall_rating,

    CASE
        WHEN "Count of Safety Measures Better" <> 'Not Available'
        THEN CAST("Count of Safety Measures Better" AS NUMERIC)
    END AS safety_better,

    CASE
        WHEN "Count of Safety Measures Worse" <> 'Not Available'
        THEN CAST("Count of Safety Measures Worse" AS NUMERIC)
    END AS safety_worse

FROM hospital_general_information;


-- Overall hospital rating
SELECT
    ROUND(AVG(overall_rating), 2) AS average_hospital_rating
FROM hospital_analysis;


-- Average hospital rating by state
SELECT
    state,
    COUNT(overall_rating) AS hospitals_rated,
    ROUND(AVG(overall_rating), 2) AS average_rating
FROM hospital_analysis
GROUP BY state
HAVING COUNT(overall_rating) >= 20
ORDER BY average_rating DESC;


-- Average hospital rating by ownership
SELECT
    hospital_ownership,
    COUNT(overall_rating) AS hospitals_rated,
    ROUND(AVG(overall_rating), 2) AS average_rating
FROM hospital_analysis
GROUP BY hospital_ownership
HAVING COUNT(overall_rating) >= 20
ORDER BY average_rating DESC;


-- Compare hospitals by emergency-service availability
SELECT
    emergency_services,
    COUNT(overall_rating) AS hospitals_rated,
    ROUND(AVG(overall_rating), 2) AS average_rating
FROM hospital_analysis
GROUP BY emergency_services
ORDER BY average_rating DESC;


-- Hospitals with the highest overall ratings
SELECT
    facility_name,
    city,
    state,
    hospital_ownership,
    emergency_services,
    overall_rating
FROM hospital_analysis
WHERE overall_rating IS NOT NULL
ORDER BY overall_rating DESC, facility_name;
