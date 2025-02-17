

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pgsodium" WITH SCHEMA "pgsodium";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE OR REPLACE FUNCTION "public"."feed"("bid" bigint, "uid" bigint, "cutoff" timestamp with time zone) RETURNS TABLE("id" bigint, "created_at" timestamp with time zone, "creator_id" bigint, "question" "text", "poll_type" "text", "is_pinned" boolean, "is_anonymous" boolean, "is_active" boolean, "response_count" integer, "comment_count" integer, "creator" "text", "answers" "jsonb")
    LANGUAGE "sql"
    AS $$
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
  WHERE poll.id IN (
    SELECT poll_id
    FROM poll_board
    WHERE board_id = bid
    intersect
    SELECT id
    FROM poll
    WHERE creator_id != uid AND is_active = true AND created_at > cutoff
    except
    SELECT poll_id
    FROM poll_report
    WHERE poll_report.creator_id = uid
    except
    SELECT poll_id
    FROM response
    WHERE response.user_id = uid
  )
  GROUP BY poll.id, "user".username; 
$$;


ALTER FUNCTION "public"."feed"("bid" bigint, "uid" bigint, "cutoff" timestamp with time zone) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."feed"("bid" bigint, "uid" bigint, "cutoff" timestamp with time zone, "page" integer) RETURNS TABLE("id" bigint, "created_at" timestamp with time zone, "creator_id" bigint, "question" "text", "poll_type" "text", "is_pinned" boolean, "is_anonymous" boolean, "is_active" boolean, "response_count" integer, "comment_count" integer, "creator" "text", "answers" "jsonb")
    LANGUAGE "sql"
    AS $$
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
  WHERE poll.id IN (
    SELECT poll_id
    FROM poll_board
    WHERE board_id = bid
    intersect
    SELECT id
    FROM poll
    WHERE creator_id != uid AND is_active = true AND created_at > cutoff
    except
    SELECT poll_id
    FROM poll_report
    WHERE poll_report.creator_id = uid
    except
    SELECT poll_id
    FROM response
    WHERE response.user_id = uid
  )
  GROUP BY poll.id, "user".username
  LIMIT 10
  OFFSET 10 * page;
$$;


ALTER FUNCTION "public"."feed"("bid" bigint, "uid" bigint, "cutoff" timestamp with time zone, "page" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."feed"("bid" bigint, "uid" bigint, "cutoff" timestamp with time zone, "page" integer, "lim" integer) RETURNS TABLE("id" bigint, "created_at" timestamp with time zone, "creator_id" bigint, "question" "text", "poll_type" "text", "is_pinned" boolean, "is_anonymous" boolean, "is_active" boolean, "response_count" integer, "comment_count" integer, "creator" "text", "answers" "jsonb")
    LANGUAGE "sql"
    AS $$
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
  WHERE poll.id IN (
    SELECT poll_id
    FROM poll_board
    WHERE board_id = bid
    intersect
    SELECT id
    FROM poll
    WHERE creator_id != uid AND is_active = true AND created_at > cutoff
    except
    SELECT poll_id
    FROM poll_report
    WHERE poll_report.creator_id = uid
    except
    SELECT poll_id
    FROM response
    WHERE response.user_id = uid
  )
  GROUP BY poll.id, "user".username
  ORDER BY poll.is_pinned DESC, response_count DESC 
  LIMIT lim
  OFFSET lim * page;
$$;


ALTER FUNCTION "public"."feed"("bid" bigint, "uid" bigint, "cutoff" timestamp with time zone, "page" integer, "lim" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."feed_hot"("bid" bigint, "uid" bigint, "page" integer, "lim" integer) RETURNS TABLE("id" bigint, "created_at" timestamp with time zone, "creator_id" bigint, "question" "text", "poll_type" "text", "is_pinned" boolean, "is_anonymous" boolean, "is_active" boolean, "response_count" integer, "comment_count" integer, "creator" "text", "answers" "jsonb")
    LANGUAGE "sql"
    AS $$
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
  WHERE poll.id IN (
    SELECT poll_id
    FROM poll_board
    WHERE board_id = bid
    intersect
    SELECT id
    FROM poll
    WHERE creator_id != uid AND is_active = true
    except
    SELECT poll_id
    FROM poll_report
    WHERE poll_report.creator_id = uid
    except
    SELECT poll_id
    FROM response
    WHERE response.user_id = uid
  )
  GROUP BY poll.id, "user".username
  ORDER BY 
    poll.is_pinned DESC, 
    COUNT(DISTINCT response.id)/EXTRACT(SECONDS from poll.created_at) DESC 
  LIMIT lim
  OFFSET lim * page;
$$;


ALTER FUNCTION "public"."feed_hot"("bid" bigint, "uid" bigint, "page" integer, "lim" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."feed_info"() RETURNS TABLE("poll_id" bigint, "created_at" timestamp with time zone, "creator_id" bigint, "question" "text", "poll_type" "text", "is_pinned" boolean, "is_anonymous" boolean, "is_active" boolean, "response_count" integer, "comment_count" integer, "username" "text", "answers" "jsonb")
    LANGUAGE "sql"
    AS $$
  SELECT 
    poll.id AS poll_id,
    poll.created_at,
    poll.creator_id,
    poll.question,
    poll.poll_type,
    poll.is_pinned,
    poll.is_anonymous,
    poll.is_active,
    COUNT(DISTINCT response.id) AS response_count,
    COUNT(DISTINCT comment.id) AS comment_count,
    "user".username,
    jsonb_agg(DISTINCT jsonb_build_object(
      'id', answer.id, 
      'answer', answer.answer
    )) AS answers
  FROM poll 
  INNER JOIN "user" ON "user".id = poll.creator_id
  LEFT JOIN answer ON answer.poll_id = poll.id
  LEFT JOIN response ON response.poll_id = poll.id
  LEFT JOIN comment ON comment.poll_id = poll.id
  GROUP BY poll.id, "user".username; 
$$;


ALTER FUNCTION "public"."feed_info"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."feed_new"("bid" bigint, "uid" bigint, "page" integer, "lim" integer) RETURNS TABLE("id" bigint, "created_at" timestamp with time zone, "creator_id" bigint, "question" "text", "poll_type" "text", "is_pinned" boolean, "is_anonymous" boolean, "is_active" boolean, "response_count" integer, "comment_count" integer, "creator" "text", "answers" "jsonb")
    LANGUAGE "sql"
    AS $$
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
  WHERE poll.id IN (
    SELECT poll_id
    FROM poll_board
    WHERE board_id = bid
    intersect
    SELECT id
    FROM poll
    WHERE creator_id != uid AND is_active = true
    except
    SELECT poll_id
    FROM poll_report
    WHERE poll_report.creator_id = uid
    except
    SELECT poll_id
    FROM response
    WHERE response.user_id = uid
  )
  GROUP BY poll.id, "user".username
  ORDER BY poll.is_pinned DESC, poll.created_at DESC 
  LIMIT lim
  OFFSET lim * page;
$$;


ALTER FUNCTION "public"."feed_new"("bid" bigint, "uid" bigint, "page" integer, "lim" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."feed_top"("bid" bigint, "uid" bigint, "cutoff" timestamp with time zone, "page" integer, "lim" integer) RETURNS TABLE("id" bigint, "created_at" timestamp with time zone, "creator_id" bigint, "question" "text", "poll_type" "text", "is_pinned" boolean, "is_anonymous" boolean, "is_active" boolean, "response_count" integer, "comment_count" integer, "creator" "text", "answers" "jsonb")
    LANGUAGE "sql"
    AS $$
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
  WHERE poll.id IN (
    SELECT poll_id
    FROM poll_board
    WHERE board_id = bid
    intersect
    SELECT id
    FROM poll
    WHERE creator_id != uid AND is_active = true AND created_at > cutoff
    except
    SELECT poll_id
    FROM poll_report
    WHERE poll_report.creator_id = uid
    except
    SELECT poll_id
    FROM response
    WHERE response.user_id = uid
  )
  GROUP BY poll.id, "user".username
  ORDER BY poll.is_pinned DESC, response_count DESC 
  LIMIT lim
  OFFSET lim * page;
$$;


ALTER FUNCTION "public"."feed_top"("bid" bigint, "uid" bigint, "cutoff" timestamp with time zone, "page" integer, "lim" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."hello_world"() RETURNS "text"
    LANGUAGE "sql"
    AS $$
  select 'Hello world';
$$;


ALTER FUNCTION "public"."hello_world"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."history"("uid" bigint) RETURNS TABLE("id" bigint, "created_at" timestamp with time zone, "creator_id" bigint, "question" "text", "poll_type" "text", "is_pinned" boolean, "is_anonymous" boolean, "is_active" boolean, "response_count" integer, "comment_count" integer, "creator" "text", "answers" "jsonb")
    LANGUAGE "sql"
    AS $$
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
  INNER JOIN response ON response.poll_id = poll.id
  LEFT JOIN comment ON comment.poll_id = poll.id
  WHERE response.user_id = uid
  GROUP BY poll.id, "user".username
  ORDER BY poll.created_at DESC
  LIMIT 5
$$;


ALTER FUNCTION "public"."history"("uid" bigint) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."history"("uid" bigint, "page" integer) RETURNS TABLE("id" bigint, "created_at" timestamp with time zone, "creator_id" bigint, "question" "text", "poll_type" "text", "is_pinned" boolean, "is_anonymous" boolean, "is_active" boolean, "response_count" integer, "comment_count" integer, "creator" "text", "answers" "jsonb")
    LANGUAGE "sql"
    AS $$
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
  INNER JOIN response ON response.poll_id = poll.id
  LEFT JOIN comment ON comment.poll_id = poll.id
  WHERE response.user_id = uid
  GROUP BY poll.id, "user".username
  ORDER BY poll.created_at DESC
  LIMIT 10
  OFFSET 10 * page;
$$;


ALTER FUNCTION "public"."history"("uid" bigint, "page" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."history"("uid" bigint, "page" integer, "lim" integer) RETURNS TABLE("id" bigint, "created_at" timestamp with time zone, "creator_id" bigint, "question" "text", "poll_type" "text", "is_pinned" boolean, "is_anonymous" boolean, "is_active" boolean, "response_count" integer, "comment_count" integer, "creator" "text", "answers" "jsonb")
    LANGUAGE "sql"
    AS $$
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
  WHERE response.user_id = uid
  GROUP BY poll.id, "user".username
  ORDER BY poll.created_at DESC
  LIMIT lim
  OFFSET lim * page;
$$;


ALTER FUNCTION "public"."history"("uid" bigint, "page" integer, "lim" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."mypolls"("cid" bigint) RETURNS TABLE("id" bigint, "created_at" timestamp with time zone, "creator_id" bigint, "question" "text", "poll_type" "text", "is_pinned" boolean, "is_anonymous" boolean, "is_active" boolean, "response_count" integer, "comment_count" integer, "creator" "text", "answers" "jsonb")
    LANGUAGE "sql"
    AS $$
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
  ORDER BY poll.created_at DESC;
$$;


ALTER FUNCTION "public"."mypolls"("cid" bigint) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."mypolls"("cid" bigint, "page" integer) RETURNS TABLE("id" bigint, "created_at" timestamp with time zone, "creator_id" bigint, "question" "text", "poll_type" "text", "is_pinned" boolean, "is_anonymous" boolean, "is_active" boolean, "response_count" integer, "comment_count" integer, "creator" "text", "answers" "jsonb")
    LANGUAGE "sql"
    AS $$
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
  LIMIT 10
  OFFSET 10 * page;
$$;


ALTER FUNCTION "public"."mypolls"("cid" bigint, "page" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."mypolls"("cid" bigint, "page" integer, "lim" integer) RETURNS TABLE("id" bigint, "created_at" timestamp with time zone, "creator_id" bigint, "question" "text", "poll_type" "text", "is_pinned" boolean, "is_anonymous" boolean, "is_active" boolean, "response_count" integer, "comment_count" integer, "creator" "text", "answers" "jsonb")
    LANGUAGE "sql"
    AS $$
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
$$;


ALTER FUNCTION "public"."mypolls"("cid" bigint, "page" integer, "lim" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."poll"("pid" bigint) RETURNS TABLE("id" bigint, "created_at" timestamp with time zone, "creator_id" bigint, "question" "text", "poll_type" "text", "is_pinned" boolean, "is_anonymous" boolean, "is_active" boolean, "response_count" integer, "comment_count" integer, "creator" "text", "answers" "jsonb")
    LANGUAGE "sql"
    AS $$
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
  WHERE poll.id = pid
  GROUP BY poll.id, "user".username
$$;


ALTER FUNCTION "public"."poll"("pid" bigint) OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."answer" (
    "id" bigint NOT NULL,
    "poll_id" bigint NOT NULL,
    "answer" "text" NOT NULL
);


ALTER TABLE "public"."answer" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."board" (
    "id" bigint NOT NULL,
    "name" "text" NOT NULL,
    "primary" boolean DEFAULT false NOT NULL
);


ALTER TABLE "public"."board" OWNER TO "postgres";


ALTER TABLE "public"."board" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."board_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."comment" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "poll_id" bigint NOT NULL,
    "user_id" bigint NOT NULL,
    "parent_id" bigint,
    "comment" "text" NOT NULL
);


ALTER TABLE "public"."comment" OWNER TO "postgres";


ALTER TABLE "public"."comment" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."comment_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."comment_report" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "comment_id" bigint NOT NULL,
    "receiver_id" bigint NOT NULL,
    "creator_id" bigint NOT NULL,
    "handled" boolean DEFAULT false NOT NULL
);


ALTER TABLE "public"."comment_report" OWNER TO "postgres";


ALTER TABLE "public"."comment_report" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."comment_report_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."discrete_response" (
    "id" bigint NOT NULL,
    "response_id" bigint NOT NULL,
    "answer_id" bigint NOT NULL
);


ALTER TABLE "public"."discrete_response" OWNER TO "postgres";


ALTER TABLE "public"."discrete_response" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."discrete_response_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."dislike" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" bigint NOT NULL,
    "comment_id" bigint NOT NULL
);


ALTER TABLE "public"."dislike" OWNER TO "postgres";


ALTER TABLE "public"."dislike" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."dislike_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."like" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" bigint NOT NULL,
    "comment_id" bigint NOT NULL
);


ALTER TABLE "public"."like" OWNER TO "postgres";


ALTER TABLE "public"."like" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."like_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."numeric_response" (
    "id" bigint NOT NULL,
    "response_id" bigint NOT NULL,
    "value" smallint NOT NULL
);


ALTER TABLE "public"."numeric_response" OWNER TO "postgres";


ALTER TABLE "public"."numeric_response" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."numeric_response_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."poll" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "creator_id" bigint NOT NULL,
    "question" "text" NOT NULL,
    "poll_type" "text" NOT NULL,
    "is_pinned" boolean DEFAULT false NOT NULL,
    "is_anonymous" boolean NOT NULL,
    "is_active" boolean DEFAULT true NOT NULL
);


ALTER TABLE "public"."poll" OWNER TO "postgres";


ALTER TABLE "public"."answer" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."poll_answer_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."poll_board" (
    "id" bigint NOT NULL,
    "poll_id" bigint NOT NULL,
    "board_id" bigint NOT NULL
);


ALTER TABLE "public"."poll_board" OWNER TO "postgres";


ALTER TABLE "public"."poll_board" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."poll_board_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



ALTER TABLE "public"."poll" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."poll_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE OR REPLACE VIEW "public"."poll_info" AS
 SELECT "poll"."id",
    "poll"."created_at",
    "poll"."creator_id",
    "poll"."question",
    "poll"."poll_type",
    "poll"."is_pinned",
    "poll"."is_anonymous",
    "poll"."is_active"
   FROM "public"."poll";


ALTER TABLE "public"."poll_info" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."poll_report" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "poll_id" bigint NOT NULL,
    "receiver_id" bigint NOT NULL,
    "creator_id" bigint NOT NULL,
    "handled" boolean DEFAULT false NOT NULL
);


ALTER TABLE "public"."poll_report" OWNER TO "postgres";


ALTER TABLE "public"."poll_report" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."poll_report_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."ranked_response" (
    "id" bigint NOT NULL,
    "response_id" bigint NOT NULL,
    "answer_id" bigint NOT NULL,
    "rank" smallint NOT NULL
);


ALTER TABLE "public"."ranked_response" OWNER TO "postgres";


ALTER TABLE "public"."ranked_response" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."ranked_response_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."response" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" bigint NOT NULL,
    "poll_id" bigint NOT NULL
);


ALTER TABLE "public"."response" OWNER TO "postgres";


ALTER TABLE "public"."response" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."response_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."tiered_response" (
    "id" bigint NOT NULL,
    "response_id" bigint NOT NULL,
    "answer_id" bigint NOT NULL,
    "tier" smallint NOT NULL
);


ALTER TABLE "public"."tiered_response" OWNER TO "postgres";


ALTER TABLE "public"."tiered_response" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."tiered_response_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."user" (
    "id" bigint NOT NULL,
    "username" "text" NOT NULL,
    "email" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "last_poll_created" timestamp with time zone,
    "next_poll_allowed" timestamp with time zone,
    "is_admin" boolean NOT NULL
);


ALTER TABLE "public"."user" OWNER TO "postgres";


COMMENT ON TABLE "public"."user" IS 'Public user profiles.';



ALTER TABLE "public"."user" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."user_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



ALTER TABLE ONLY "public"."board"
    ADD CONSTRAINT "board_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."comment"
    ADD CONSTRAINT "comment_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."comment_report"
    ADD CONSTRAINT "comment_report_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."discrete_response"
    ADD CONSTRAINT "discrete_response_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."dislike"
    ADD CONSTRAINT "dislike_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."like"
    ADD CONSTRAINT "like_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."numeric_response"
    ADD CONSTRAINT "numeric_response_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."answer"
    ADD CONSTRAINT "poll_answer_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."poll_board"
    ADD CONSTRAINT "poll_board_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."poll"
    ADD CONSTRAINT "poll_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."poll_report"
    ADD CONSTRAINT "poll_report_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."ranked_response"
    ADD CONSTRAINT "ranked_response_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."response"
    ADD CONSTRAINT "response_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tiered_response"
    ADD CONSTRAINT "tiered_response_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."user"
    ADD CONSTRAINT "user_email_key" UNIQUE ("email");



ALTER TABLE ONLY "public"."user"
    ADD CONSTRAINT "user_pkey" PRIMARY KEY ("id");



CREATE INDEX "comment_poll_id_idx" ON "public"."comment" USING "btree" ("poll_id");



CREATE INDEX "comment_user_id_idx" ON "public"."comment" USING "btree" ("user_id");



ALTER TABLE ONLY "public"."comment"
    ADD CONSTRAINT "comment_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "public"."comment"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."comment"
    ADD CONSTRAINT "comment_poll_id_fkey" FOREIGN KEY ("poll_id") REFERENCES "public"."poll"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."comment_report"
    ADD CONSTRAINT "comment_report_comment_id_fkey" FOREIGN KEY ("comment_id") REFERENCES "public"."comment"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."comment_report"
    ADD CONSTRAINT "comment_report_creator_id_fkey" FOREIGN KEY ("creator_id") REFERENCES "public"."user"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."comment_report"
    ADD CONSTRAINT "comment_report_receiver_id_fkey" FOREIGN KEY ("receiver_id") REFERENCES "public"."user"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."comment"
    ADD CONSTRAINT "comment_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."user"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."discrete_response"
    ADD CONSTRAINT "discrete_response_answer_id_fkey" FOREIGN KEY ("answer_id") REFERENCES "public"."answer"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."discrete_response"
    ADD CONSTRAINT "discrete_response_response_id_fkey" FOREIGN KEY ("response_id") REFERENCES "public"."response"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."dislike"
    ADD CONSTRAINT "dislike_comment_id_fkey" FOREIGN KEY ("comment_id") REFERENCES "public"."comment"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."dislike"
    ADD CONSTRAINT "dislike_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."user"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."like"
    ADD CONSTRAINT "like_comment_id_fkey" FOREIGN KEY ("comment_id") REFERENCES "public"."comment"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."like"
    ADD CONSTRAINT "like_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."user"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."numeric_response"
    ADD CONSTRAINT "numeric_response_response_id_fkey" FOREIGN KEY ("response_id") REFERENCES "public"."response"("id");



ALTER TABLE ONLY "public"."answer"
    ADD CONSTRAINT "poll_answer_poll_id_fkey" FOREIGN KEY ("poll_id") REFERENCES "public"."poll"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."poll_board"
    ADD CONSTRAINT "poll_board_board_id_fkey" FOREIGN KEY ("board_id") REFERENCES "public"."board"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."poll_board"
    ADD CONSTRAINT "poll_board_poll_id_fkey" FOREIGN KEY ("poll_id") REFERENCES "public"."poll"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."poll"
    ADD CONSTRAINT "poll_creator_id_fkey" FOREIGN KEY ("creator_id") REFERENCES "public"."user"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."poll_report"
    ADD CONSTRAINT "poll_report_creator_id_fkey" FOREIGN KEY ("creator_id") REFERENCES "public"."user"("id");



ALTER TABLE ONLY "public"."poll_report"
    ADD CONSTRAINT "poll_report_poll_id_fkey" FOREIGN KEY ("poll_id") REFERENCES "public"."poll"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."poll_report"
    ADD CONSTRAINT "poll_report_receiver_id_fkey" FOREIGN KEY ("receiver_id") REFERENCES "public"."user"("id");



ALTER TABLE ONLY "public"."ranked_response"
    ADD CONSTRAINT "ranked_response_answer_id_fkey" FOREIGN KEY ("answer_id") REFERENCES "public"."answer"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."ranked_response"
    ADD CONSTRAINT "ranked_response_response_id_fkey" FOREIGN KEY ("response_id") REFERENCES "public"."response"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."response"
    ADD CONSTRAINT "response_poll_id_fkey" FOREIGN KEY ("poll_id") REFERENCES "public"."poll"("id");



ALTER TABLE ONLY "public"."response"
    ADD CONSTRAINT "response_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."user"("id");



ALTER TABLE ONLY "public"."tiered_response"
    ADD CONSTRAINT "tiered_response_answer_id_fkey" FOREIGN KEY ("answer_id") REFERENCES "public"."answer"("id") ON UPDATE CASCADE ON DELETE CASCADE;



ALTER TABLE ONLY "public"."tiered_response"
    ADD CONSTRAINT "tiered_response_response_id_fkey" FOREIGN KEY ("response_id") REFERENCES "public"."response"("id") ON UPDATE CASCADE ON DELETE CASCADE;





ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";




















































































































































































GRANT ALL ON FUNCTION "public"."feed"("bid" bigint, "uid" bigint, "cutoff" timestamp with time zone) TO "anon";
GRANT ALL ON FUNCTION "public"."feed"("bid" bigint, "uid" bigint, "cutoff" timestamp with time zone) TO "authenticated";
GRANT ALL ON FUNCTION "public"."feed"("bid" bigint, "uid" bigint, "cutoff" timestamp with time zone) TO "service_role";



GRANT ALL ON FUNCTION "public"."feed"("bid" bigint, "uid" bigint, "cutoff" timestamp with time zone, "page" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."feed"("bid" bigint, "uid" bigint, "cutoff" timestamp with time zone, "page" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."feed"("bid" bigint, "uid" bigint, "cutoff" timestamp with time zone, "page" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."feed"("bid" bigint, "uid" bigint, "cutoff" timestamp with time zone, "page" integer, "lim" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."feed"("bid" bigint, "uid" bigint, "cutoff" timestamp with time zone, "page" integer, "lim" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."feed"("bid" bigint, "uid" bigint, "cutoff" timestamp with time zone, "page" integer, "lim" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."feed_hot"("bid" bigint, "uid" bigint, "page" integer, "lim" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."feed_hot"("bid" bigint, "uid" bigint, "page" integer, "lim" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."feed_hot"("bid" bigint, "uid" bigint, "page" integer, "lim" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."feed_info"() TO "anon";
GRANT ALL ON FUNCTION "public"."feed_info"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."feed_info"() TO "service_role";



GRANT ALL ON FUNCTION "public"."feed_new"("bid" bigint, "uid" bigint, "page" integer, "lim" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."feed_new"("bid" bigint, "uid" bigint, "page" integer, "lim" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."feed_new"("bid" bigint, "uid" bigint, "page" integer, "lim" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."feed_top"("bid" bigint, "uid" bigint, "cutoff" timestamp with time zone, "page" integer, "lim" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."feed_top"("bid" bigint, "uid" bigint, "cutoff" timestamp with time zone, "page" integer, "lim" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."feed_top"("bid" bigint, "uid" bigint, "cutoff" timestamp with time zone, "page" integer, "lim" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."hello_world"() TO "anon";
GRANT ALL ON FUNCTION "public"."hello_world"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."hello_world"() TO "service_role";



GRANT ALL ON FUNCTION "public"."history"("uid" bigint) TO "anon";
GRANT ALL ON FUNCTION "public"."history"("uid" bigint) TO "authenticated";
GRANT ALL ON FUNCTION "public"."history"("uid" bigint) TO "service_role";



GRANT ALL ON FUNCTION "public"."history"("uid" bigint, "page" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."history"("uid" bigint, "page" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."history"("uid" bigint, "page" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."history"("uid" bigint, "page" integer, "lim" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."history"("uid" bigint, "page" integer, "lim" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."history"("uid" bigint, "page" integer, "lim" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."mypolls"("cid" bigint) TO "anon";
GRANT ALL ON FUNCTION "public"."mypolls"("cid" bigint) TO "authenticated";
GRANT ALL ON FUNCTION "public"."mypolls"("cid" bigint) TO "service_role";



GRANT ALL ON FUNCTION "public"."mypolls"("cid" bigint, "page" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."mypolls"("cid" bigint, "page" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."mypolls"("cid" bigint, "page" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."mypolls"("cid" bigint, "page" integer, "lim" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."mypolls"("cid" bigint, "page" integer, "lim" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."mypolls"("cid" bigint, "page" integer, "lim" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."poll"("pid" bigint) TO "anon";
GRANT ALL ON FUNCTION "public"."poll"("pid" bigint) TO "authenticated";
GRANT ALL ON FUNCTION "public"."poll"("pid" bigint) TO "service_role";


















GRANT ALL ON TABLE "public"."answer" TO "anon";
GRANT ALL ON TABLE "public"."answer" TO "authenticated";
GRANT ALL ON TABLE "public"."answer" TO "service_role";



GRANT ALL ON TABLE "public"."board" TO "anon";
GRANT ALL ON TABLE "public"."board" TO "authenticated";
GRANT ALL ON TABLE "public"."board" TO "service_role";



GRANT ALL ON SEQUENCE "public"."board_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."board_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."board_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."comment" TO "anon";
GRANT ALL ON TABLE "public"."comment" TO "authenticated";
GRANT ALL ON TABLE "public"."comment" TO "service_role";



GRANT ALL ON SEQUENCE "public"."comment_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."comment_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."comment_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."comment_report" TO "anon";
GRANT ALL ON TABLE "public"."comment_report" TO "authenticated";
GRANT ALL ON TABLE "public"."comment_report" TO "service_role";



GRANT ALL ON SEQUENCE "public"."comment_report_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."comment_report_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."comment_report_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."discrete_response" TO "anon";
GRANT ALL ON TABLE "public"."discrete_response" TO "authenticated";
GRANT ALL ON TABLE "public"."discrete_response" TO "service_role";



GRANT ALL ON SEQUENCE "public"."discrete_response_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."discrete_response_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."discrete_response_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."dislike" TO "anon";
GRANT ALL ON TABLE "public"."dislike" TO "authenticated";
GRANT ALL ON TABLE "public"."dislike" TO "service_role";



GRANT ALL ON SEQUENCE "public"."dislike_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."dislike_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."dislike_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."like" TO "anon";
GRANT ALL ON TABLE "public"."like" TO "authenticated";
GRANT ALL ON TABLE "public"."like" TO "service_role";



GRANT ALL ON SEQUENCE "public"."like_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."like_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."like_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."numeric_response" TO "anon";
GRANT ALL ON TABLE "public"."numeric_response" TO "authenticated";
GRANT ALL ON TABLE "public"."numeric_response" TO "service_role";



GRANT ALL ON SEQUENCE "public"."numeric_response_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."numeric_response_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."numeric_response_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."poll" TO "anon";
GRANT ALL ON TABLE "public"."poll" TO "authenticated";
GRANT ALL ON TABLE "public"."poll" TO "service_role";



GRANT ALL ON SEQUENCE "public"."poll_answer_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."poll_answer_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."poll_answer_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."poll_board" TO "anon";
GRANT ALL ON TABLE "public"."poll_board" TO "authenticated";
GRANT ALL ON TABLE "public"."poll_board" TO "service_role";



GRANT ALL ON SEQUENCE "public"."poll_board_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."poll_board_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."poll_board_id_seq" TO "service_role";



GRANT ALL ON SEQUENCE "public"."poll_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."poll_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."poll_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."poll_info" TO "anon";
GRANT ALL ON TABLE "public"."poll_info" TO "authenticated";
GRANT ALL ON TABLE "public"."poll_info" TO "service_role";



GRANT ALL ON TABLE "public"."poll_report" TO "anon";
GRANT ALL ON TABLE "public"."poll_report" TO "authenticated";
GRANT ALL ON TABLE "public"."poll_report" TO "service_role";



GRANT ALL ON SEQUENCE "public"."poll_report_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."poll_report_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."poll_report_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."ranked_response" TO "anon";
GRANT ALL ON TABLE "public"."ranked_response" TO "authenticated";
GRANT ALL ON TABLE "public"."ranked_response" TO "service_role";



GRANT ALL ON SEQUENCE "public"."ranked_response_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."ranked_response_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."ranked_response_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."response" TO "anon";
GRANT ALL ON TABLE "public"."response" TO "authenticated";
GRANT ALL ON TABLE "public"."response" TO "service_role";



GRANT ALL ON SEQUENCE "public"."response_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."response_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."response_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."tiered_response" TO "anon";
GRANT ALL ON TABLE "public"."tiered_response" TO "authenticated";
GRANT ALL ON TABLE "public"."tiered_response" TO "service_role";



GRANT ALL ON SEQUENCE "public"."tiered_response_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."tiered_response_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."tiered_response_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."user" TO "anon";
GRANT ALL ON TABLE "public"."user" TO "authenticated";
GRANT ALL ON TABLE "public"."user" TO "service_role";



GRANT ALL ON SEQUENCE "public"."user_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."user_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."user_id_seq" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";






























RESET ALL;
