{{ config(materialized='table') }}

WITH chv_activity_summary AS (
    SELECT 
    	activity_type,
        -- 1. Total Activities
        COUNT(activity_id) AS total_activities,

        -- 2. Unique Households Visited
        -- Logic: Only count distinct household_ids if the conditions are met
        COUNT(DISTINCT CASE 
            WHEN activity_type LIKE '%visit' AND activity_timestamp IS NOT NULL 
            THEN household_id 
        END) AS unique_households_visited,

        -- 3. Unique Patients Served
        -- Logic: SQL COUNT(col) automatically ignores NULLs, so explicit NOT NULL check is handled naturally
        COUNT(DISTINCT patient_id) AS unique_patients_served,

        -- 4. Pregnancy Visits
        COUNT(DISTINCT CASE 
            WHEN activity_type = 'pregnancy_visit' 
            THEN activity_id 
        END) AS pregnancy_visits,

        -- 5. Child Assessments
        COUNT(DISTINCT CASE 
            WHEN activity_type = 'child_assessment' 
            THEN activity_id 
        END) AS child_assessments,

        -- 6. Family Planning Visits
        COUNT(DISTINCT CASE 
            WHEN activity_type = 'family_planning' 
            THEN activity_id 
        END) AS family_planning_visits

FROM 
        {{ source('chwdb', 'fct_chv_activity') }} GROUP BY activity_type
)

SELECT * FROM chv_activity_summary