CREATE OR REPLACE FUNCTION poll_responses(pid int) 
RETURNS TABLE(
  poll_id int,
  user_id int,
  created_at timestamp with time zone,
  username text
) AS $$
  SELECT
    response.poll_id AS poll_id,
    response.user_id AS user_id,
    MAX(response.created_at) AS created_at,
    "user".username AS username
  FROM response 
  INNER JOIN "user" ON "user".id = response.user_id
  WHERE response.poll_id = pid
  GROUP BY (response.poll_id, response.user_id, "user".username)
$$ LANGUAGE sql;
