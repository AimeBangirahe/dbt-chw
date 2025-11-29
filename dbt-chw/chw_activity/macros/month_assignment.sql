{% macro month_assignment(date_expr) %}
  --
  -- Assign an activity to a month according to business rules:
  -- Activities on or after the 26th of a month are assigned to the NEXT month.
  -- Accepts a SQL expression that resolves to a DATE or TIMESTAMP (e.g. activity_date or activity_timestamp::date).
  -- Returns a DATE which is the first day of the assigned month.
  --
  (
    case
      when {{ date_expr }} is null then null
      when extract(day from {{ date_expr }}::date) >= 26
        then (date_trunc('month', ({{ date_expr }}::date + interval '1 month'))::date)
      else date_trunc('month', {{ date_expr }}::date)::date
    end
  )
{% endmacro %}