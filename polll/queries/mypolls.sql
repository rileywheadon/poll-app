CREATE OR REPLACE FUNCTION mypolls(cid bigint, page int, lim int) 
RETURNS TABLE(
  id bigint, 
  created_at timestamp with time zone, 
  creator_id bigint, 
  question text, 
  poll_type text, 
  is_pinned boolean, 
  is_anonymous boolean, 
  is_active boolean, 
  response_count int,
  comment_count int,
  creator text,
  answers jsonb
) AS $$
  SELECT 
    poll.id,
    poll.created_at,
    poll.creator_id,
    poll.question,
    poll.poll_type,
    poll.is_pinned,
    poll.is_anonymous,
    poll.is_active,
    COUNT(DISTINCT response.id) AS response_count,
    COUNT(DISTINCT comment.id) AS comment_count,
    "user".username AS creator,
    jsonb_agg(DISTINCT jsonb_build_object(
      'id', answer.id, 
      'answer', answer.answer
    )) AS answers
  FROM poll 
  INNER JOIN "user" ON "user".id = poll.creator_id
  LEFT JOIN answer ON answer.poll_id = poll.id
  LEFT JOIN response ON response.poll_id = poll.id
  LEFT JOIN comment ON comment.poll_id = poll.id
  WHERE poll.creator_id = cid
  GROUP BY poll.id, "user".username
  ORDER BY poll.created_at DESC
  LIMIT lim
  OFFSET lim * page;
$$ LANGUAGE sql;
