--
-- PostgreSQL database dump
--

-- Dumped from database version 14.0
-- Dumped by pg_dump version 14.13 (Homebrew)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ab_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ab_permission (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.ab_permission OWNER TO postgres;

--
-- Name: ab_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ab_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ab_permission_id_seq OWNER TO postgres;

--
-- Name: ab_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ab_permission_id_seq OWNED BY public.ab_permission.id;


--
-- Name: ab_permission_view; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ab_permission_view (
    id integer NOT NULL,
    permission_id integer,
    view_menu_id integer
);


ALTER TABLE public.ab_permission_view OWNER TO postgres;

--
-- Name: ab_permission_view_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ab_permission_view_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ab_permission_view_id_seq OWNER TO postgres;

--
-- Name: ab_permission_view_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ab_permission_view_id_seq OWNED BY public.ab_permission_view.id;


--
-- Name: ab_permission_view_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ab_permission_view_role (
    id integer NOT NULL,
    permission_view_id integer,
    role_id integer
);


ALTER TABLE public.ab_permission_view_role OWNER TO postgres;

--
-- Name: ab_permission_view_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ab_permission_view_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ab_permission_view_role_id_seq OWNER TO postgres;

--
-- Name: ab_permission_view_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ab_permission_view_role_id_seq OWNED BY public.ab_permission_view_role.id;


--
-- Name: ab_register_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ab_register_user (
    id integer NOT NULL,
    first_name character varying(256) NOT NULL,
    last_name character varying(256) NOT NULL,
    username character varying(512) NOT NULL,
    password character varying(256),
    email character varying(512) NOT NULL,
    registration_date timestamp without time zone,
    registration_hash character varying(256)
);


ALTER TABLE public.ab_register_user OWNER TO postgres;

--
-- Name: ab_register_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ab_register_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ab_register_user_id_seq OWNER TO postgres;

--
-- Name: ab_register_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ab_register_user_id_seq OWNED BY public.ab_register_user.id;


--
-- Name: ab_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ab_role (
    id integer NOT NULL,
    name character varying(64) NOT NULL
);


ALTER TABLE public.ab_role OWNER TO postgres;

--
-- Name: ab_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ab_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ab_role_id_seq OWNER TO postgres;

--
-- Name: ab_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ab_role_id_seq OWNED BY public.ab_role.id;


--
-- Name: ab_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ab_user (
    id integer NOT NULL,
    first_name character varying(256) NOT NULL,
    last_name character varying(256) NOT NULL,
    username character varying(512) NOT NULL,
    password character varying(256),
    active boolean,
    email character varying(512) NOT NULL,
    last_login timestamp without time zone,
    login_count integer,
    fail_login_count integer,
    created_on timestamp without time zone,
    changed_on timestamp without time zone,
    created_by_fk integer,
    changed_by_fk integer
);


ALTER TABLE public.ab_user OWNER TO postgres;

--
-- Name: ab_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ab_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ab_user_id_seq OWNER TO postgres;

--
-- Name: ab_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ab_user_id_seq OWNED BY public.ab_user.id;


--
-- Name: ab_user_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ab_user_role (
    id integer NOT NULL,
    user_id integer,
    role_id integer
);


ALTER TABLE public.ab_user_role OWNER TO postgres;

--
-- Name: ab_user_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ab_user_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ab_user_role_id_seq OWNER TO postgres;

--
-- Name: ab_user_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ab_user_role_id_seq OWNED BY public.ab_user_role.id;


--
-- Name: ab_view_menu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ab_view_menu (
    id integer NOT NULL,
    name character varying(250) NOT NULL
);


ALTER TABLE public.ab_view_menu OWNER TO postgres;

--
-- Name: ab_view_menu_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ab_view_menu_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ab_view_menu_id_seq OWNER TO postgres;

--
-- Name: ab_view_menu_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ab_view_menu_id_seq OWNED BY public.ab_view_menu.id;


--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- Name: callback_request; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.callback_request (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    priority_weight integer NOT NULL,
    callback_data json NOT NULL,
    callback_type character varying(20) NOT NULL,
    processor_subdir character varying(2000)
);


ALTER TABLE public.callback_request OWNER TO postgres;

--
-- Name: callback_request_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.callback_request_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.callback_request_id_seq OWNER TO postgres;

--
-- Name: callback_request_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.callback_request_id_seq OWNED BY public.callback_request.id;


--
-- Name: connection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.connection (
    id integer NOT NULL,
    conn_id character varying(250) NOT NULL,
    conn_type character varying(500) NOT NULL,
    host character varying(500),
    schema character varying(500),
    login text,
    password text,
    port integer,
    extra text,
    is_encrypted boolean,
    is_extra_encrypted boolean,
    description text
);


ALTER TABLE public.connection OWNER TO postgres;

--
-- Name: connection_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.connection_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.connection_id_seq OWNER TO postgres;

--
-- Name: connection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.connection_id_seq OWNED BY public.connection.id;


--
-- Name: dag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dag (
    dag_id character varying(250) NOT NULL,
    is_paused boolean,
    is_subdag boolean,
    is_active boolean,
    last_parsed_time timestamp with time zone,
    last_pickled timestamp with time zone,
    last_expired timestamp with time zone,
    scheduler_lock boolean,
    pickle_id integer,
    fileloc character varying(2000),
    owners character varying(2000),
    description text,
    default_view character varying(25),
    schedule_interval text,
    root_dag_id character varying(250),
    next_dagrun timestamp with time zone,
    next_dagrun_create_after timestamp with time zone,
    max_active_tasks integer NOT NULL,
    has_task_concurrency_limits boolean NOT NULL,
    max_active_runs integer,
    next_dagrun_data_interval_start timestamp with time zone,
    next_dagrun_data_interval_end timestamp with time zone,
    has_import_errors boolean DEFAULT false,
    timetable_description character varying(1000),
    processor_subdir character varying(2000),
    dataset_expression json,
    max_consecutive_failed_dag_runs integer,
    dag_display_name character varying(2000)
);


ALTER TABLE public.dag OWNER TO postgres;

--
-- Name: dag_code; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dag_code (
    fileloc_hash bigint NOT NULL,
    fileloc character varying(2000) NOT NULL,
    source_code text NOT NULL,
    last_updated timestamp with time zone NOT NULL
);


ALTER TABLE public.dag_code OWNER TO postgres;

--
-- Name: dag_owner_attributes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dag_owner_attributes (
    dag_id character varying(250) NOT NULL,
    owner character varying(500) NOT NULL,
    link character varying(500) NOT NULL
);


ALTER TABLE public.dag_owner_attributes OWNER TO postgres;

--
-- Name: dag_pickle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dag_pickle (
    id integer NOT NULL,
    pickle bytea,
    created_dttm timestamp with time zone,
    pickle_hash bigint
);


ALTER TABLE public.dag_pickle OWNER TO postgres;

--
-- Name: dag_pickle_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dag_pickle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dag_pickle_id_seq OWNER TO postgres;

--
-- Name: dag_pickle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dag_pickle_id_seq OWNED BY public.dag_pickle.id;


--
-- Name: dag_run; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dag_run (
    id integer NOT NULL,
    dag_id character varying(250) NOT NULL,
    execution_date timestamp with time zone NOT NULL,
    state character varying(50),
    run_id character varying(250) NOT NULL,
    external_trigger boolean,
    conf bytea,
    end_date timestamp with time zone,
    start_date timestamp with time zone,
    run_type character varying(50) NOT NULL,
    last_scheduling_decision timestamp with time zone,
    dag_hash character varying(32),
    creating_job_id integer,
    queued_at timestamp without time zone,
    data_interval_start timestamp with time zone,
    data_interval_end timestamp with time zone,
    log_template_id integer,
    updated_at timestamp with time zone,
    clear_number integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.dag_run OWNER TO postgres;

--
-- Name: dag_run_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dag_run_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dag_run_id_seq OWNER TO postgres;

--
-- Name: dag_run_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dag_run_id_seq OWNED BY public.dag_run.id;


--
-- Name: dag_run_note; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dag_run_note (
    user_id integer,
    dag_run_id integer NOT NULL,
    content character varying(1000),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.dag_run_note OWNER TO postgres;

--
-- Name: dag_schedule_dataset_reference; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dag_schedule_dataset_reference (
    dataset_id integer NOT NULL,
    dag_id character varying(250) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.dag_schedule_dataset_reference OWNER TO postgres;

--
-- Name: dag_warning; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dag_warning (
    dag_id character varying(250) NOT NULL,
    warning_type character varying(50) NOT NULL,
    message text NOT NULL,
    "timestamp" timestamp with time zone NOT NULL
);


ALTER TABLE public.dag_warning OWNER TO postgres;

--
-- Name: dagrun_dataset_event; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dagrun_dataset_event (
    dag_run_id integer NOT NULL,
    event_id integer NOT NULL
);


ALTER TABLE public.dagrun_dataset_event OWNER TO postgres;

--
-- Name: dataset; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dataset (
    id integer NOT NULL,
    uri character varying(3000) NOT NULL,
    extra json NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    is_orphaned boolean DEFAULT false NOT NULL
);


ALTER TABLE public.dataset OWNER TO postgres;

--
-- Name: dataset_dag_run_queue; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dataset_dag_run_queue (
    dataset_id integer NOT NULL,
    target_dag_id character varying(250) NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.dataset_dag_run_queue OWNER TO postgres;

--
-- Name: dataset_event; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dataset_event (
    id integer NOT NULL,
    dataset_id integer NOT NULL,
    extra json NOT NULL,
    source_task_id character varying(250),
    source_dag_id character varying(250),
    source_run_id character varying(250),
    source_map_index integer DEFAULT '-1'::integer,
    "timestamp" timestamp with time zone NOT NULL
);


ALTER TABLE public.dataset_event OWNER TO postgres;

--
-- Name: dataset_event_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dataset_event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dataset_event_id_seq OWNER TO postgres;

--
-- Name: dataset_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dataset_event_id_seq OWNED BY public.dataset_event.id;


--
-- Name: dataset_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dataset_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dataset_id_seq OWNER TO postgres;

--
-- Name: dataset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dataset_id_seq OWNED BY public.dataset.id;


--
-- Name: import_error; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.import_error (
    id integer NOT NULL,
    "timestamp" timestamp with time zone,
    filename character varying(1024),
    stacktrace text,
    processor_subdir character varying(2000)
);


ALTER TABLE public.import_error OWNER TO postgres;

--
-- Name: import_error_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.import_error_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.import_error_id_seq OWNER TO postgres;

--
-- Name: import_error_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.import_error_id_seq OWNED BY public.import_error.id;


--
-- Name: job; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job (
    id integer NOT NULL,
    dag_id character varying(250),
    state character varying(20),
    job_type character varying(30),
    start_date timestamp with time zone,
    end_date timestamp with time zone,
    latest_heartbeat timestamp with time zone,
    executor_class character varying(500),
    hostname character varying(500),
    unixname character varying(1000)
);


ALTER TABLE public.job OWNER TO postgres;

--
-- Name: job_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.job_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.job_id_seq OWNER TO postgres;

--
-- Name: job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.job_id_seq OWNED BY public.job.id;


--
-- Name: log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log (
    id integer NOT NULL,
    dttm timestamp with time zone,
    dag_id character varying(250),
    task_id character varying(250),
    event character varying(60),
    execution_date timestamp with time zone,
    owner character varying(500),
    extra text,
    map_index integer,
    owner_display_name character varying(500),
    run_id character varying(250)
);


ALTER TABLE public.log OWNER TO postgres;

--
-- Name: log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.log_id_seq OWNER TO postgres;

--
-- Name: log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.log_id_seq OWNED BY public.log.id;


--
-- Name: log_template; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log_template (
    id integer NOT NULL,
    filename text NOT NULL,
    elasticsearch_id text NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.log_template OWNER TO postgres;

--
-- Name: log_template_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.log_template_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.log_template_id_seq OWNER TO postgres;

--
-- Name: log_template_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.log_template_id_seq OWNED BY public.log_template.id;


--
-- Name: rendered_task_instance_fields; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rendered_task_instance_fields (
    dag_id character varying(250) NOT NULL,
    task_id character varying(250) NOT NULL,
    rendered_fields json NOT NULL,
    k8s_pod_yaml json,
    map_index integer DEFAULT '-1'::integer NOT NULL,
    run_id character varying(250) NOT NULL,
    execution_date timestamp with time zone
);


ALTER TABLE public.rendered_task_instance_fields OWNER TO postgres;

--
-- Name: run_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.run_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.run_id_seq OWNER TO postgres;

--
-- Name: serialized_dag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serialized_dag (
    dag_id character varying(250) NOT NULL,
    fileloc character varying(2000) NOT NULL,
    fileloc_hash bigint NOT NULL,
    data json,
    last_updated timestamp with time zone NOT NULL,
    dag_hash character varying(32) NOT NULL,
    data_compressed bytea,
    processor_subdir character varying(2000)
);


ALTER TABLE public.serialized_dag OWNER TO postgres;

--
-- Name: sla_miss; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sla_miss (
    task_id character varying(250) NOT NULL,
    dag_id character varying(250) NOT NULL,
    execution_date timestamp with time zone NOT NULL,
    email_sent boolean,
    "timestamp" timestamp with time zone,
    description text,
    notification_sent boolean
);


ALTER TABLE public.sla_miss OWNER TO postgres;

--
-- Name: slot_pool; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.slot_pool (
    id integer NOT NULL,
    pool character varying(256),
    slots integer,
    description text,
    include_deferred boolean NOT NULL
);


ALTER TABLE public.slot_pool OWNER TO postgres;

--
-- Name: slot_pool_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.slot_pool_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.slot_pool_id_seq OWNER TO postgres;

--
-- Name: slot_pool_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.slot_pool_id_seq OWNED BY public.slot_pool.id;


--
-- Name: task_fail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_fail (
    id integer NOT NULL,
    task_id character varying(250) NOT NULL,
    dag_id character varying(250) NOT NULL,
    start_date timestamp with time zone,
    end_date timestamp with time zone,
    duration integer,
    map_index integer DEFAULT '-1'::integer NOT NULL,
    run_id character varying(250),
    execution_date timestamp with time zone NOT NULL
);


ALTER TABLE public.task_fail OWNER TO postgres;

--
-- Name: task_fail_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.task_fail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_fail_id_seq OWNER TO postgres;

--
-- Name: task_fail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.task_fail_id_seq OWNED BY public.task_fail.id;


--
-- Name: task_instance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_instance (
    task_id character varying(250) NOT NULL,
    dag_id character varying(250) NOT NULL,
    run_id character varying(250) NOT NULL,
    start_date timestamp with time zone,
    end_date timestamp with time zone,
    duration double precision,
    state character varying(20),
    try_number integer,
    hostname character varying(1000),
    unixname character varying(1000),
    job_id integer,
    pool character varying(256) NOT NULL,
    queue character varying(256),
    priority_weight integer,
    operator character varying(1000),
    queued_dttm timestamp with time zone,
    pid integer,
    max_tries integer DEFAULT '-1'::integer,
    executor_config bytea,
    pool_slots integer NOT NULL,
    queued_by_job_id integer,
    external_executor_id character varying(250),
    trigger_id integer,
    trigger_timeout timestamp without time zone,
    next_method character varying(1000),
    next_kwargs json,
    map_index integer DEFAULT '-1'::integer NOT NULL,
    updated_at timestamp with time zone,
    custom_operator_name character varying(1000),
    rendered_map_index character varying(250),
    task_display_name character varying(2000)
);


ALTER TABLE public.task_instance OWNER TO postgres;

--
-- Name: task_instance_note; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_instance_note (
    user_id integer,
    task_id character varying(250) NOT NULL,
    dag_id character varying(250) NOT NULL,
    run_id character varying(250) NOT NULL,
    map_index integer NOT NULL,
    content character varying(1000),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.task_instance_note OWNER TO postgres;

--
-- Name: task_map; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_map (
    dag_id character varying(250) NOT NULL,
    task_id character varying(250) NOT NULL,
    run_id character varying(250) NOT NULL,
    map_index integer NOT NULL,
    length integer NOT NULL,
    keys json,
    CONSTRAINT ck_task_map_task_map_length_not_negative CHECK ((length >= 0))
);


ALTER TABLE public.task_map OWNER TO postgres;

--
-- Name: task_outlet_dataset_reference; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_outlet_dataset_reference (
    dataset_id integer NOT NULL,
    dag_id character varying(250) NOT NULL,
    task_id character varying(250) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.task_outlet_dataset_reference OWNER TO postgres;

--
-- Name: trigger; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trigger (
    id integer NOT NULL,
    classpath character varying(1000) NOT NULL,
    kwargs text NOT NULL,
    created_date timestamp with time zone NOT NULL,
    triggerer_id integer
);


ALTER TABLE public.trigger OWNER TO postgres;

--
-- Name: trigger_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.trigger_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.trigger_id_seq OWNER TO postgres;

--
-- Name: trigger_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.trigger_id_seq OWNED BY public.trigger.id;


--
-- Name: variable; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.variable (
    id integer NOT NULL,
    key character varying(250),
    val text,
    is_encrypted boolean,
    description text
);


ALTER TABLE public.variable OWNER TO postgres;

--
-- Name: variable_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.variable_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.variable_id_seq OWNER TO postgres;

--
-- Name: variable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.variable_id_seq OWNED BY public.variable.id;


--
-- Name: xcom; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.xcom (
    dag_run_id integer NOT NULL,
    task_id character varying(250) NOT NULL,
    key character varying(512) NOT NULL,
    value bytea,
    "timestamp" timestamp with time zone NOT NULL,
    dag_id character varying(250) NOT NULL,
    run_id character varying(250) NOT NULL,
    map_index integer DEFAULT '-1'::integer NOT NULL,
    execution_date timestamp with time zone
);


ALTER TABLE public.xcom OWNER TO postgres;

--
-- Name: ab_permission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_permission ALTER COLUMN id SET DEFAULT nextval('public.ab_permission_id_seq'::regclass);


--
-- Name: ab_permission_view id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_permission_view ALTER COLUMN id SET DEFAULT nextval('public.ab_permission_view_id_seq'::regclass);


--
-- Name: ab_permission_view_role id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_permission_view_role ALTER COLUMN id SET DEFAULT nextval('public.ab_permission_view_role_id_seq'::regclass);


--
-- Name: ab_register_user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_register_user ALTER COLUMN id SET DEFAULT nextval('public.ab_register_user_id_seq'::regclass);


--
-- Name: ab_role id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_role ALTER COLUMN id SET DEFAULT nextval('public.ab_role_id_seq'::regclass);


--
-- Name: ab_user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_user ALTER COLUMN id SET DEFAULT nextval('public.ab_user_id_seq'::regclass);


--
-- Name: ab_user_role id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_user_role ALTER COLUMN id SET DEFAULT nextval('public.ab_user_role_id_seq'::regclass);


--
-- Name: ab_view_menu id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_view_menu ALTER COLUMN id SET DEFAULT nextval('public.ab_view_menu_id_seq'::regclass);


--
-- Name: callback_request id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.callback_request ALTER COLUMN id SET DEFAULT nextval('public.callback_request_id_seq'::regclass);


--
-- Name: connection id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.connection ALTER COLUMN id SET DEFAULT nextval('public.connection_id_seq'::regclass);


--
-- Name: dag_pickle id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dag_pickle ALTER COLUMN id SET DEFAULT nextval('public.dag_pickle_id_seq'::regclass);


--
-- Name: dag_run id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dag_run ALTER COLUMN id SET DEFAULT nextval('public.dag_run_id_seq'::regclass);


--
-- Name: dataset id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset ALTER COLUMN id SET DEFAULT nextval('public.dataset_id_seq'::regclass);


--
-- Name: dataset_event id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset_event ALTER COLUMN id SET DEFAULT nextval('public.dataset_event_id_seq'::regclass);


--
-- Name: import_error id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.import_error ALTER COLUMN id SET DEFAULT nextval('public.import_error_id_seq'::regclass);


--
-- Name: job id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job ALTER COLUMN id SET DEFAULT nextval('public.job_id_seq'::regclass);


--
-- Name: log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log ALTER COLUMN id SET DEFAULT nextval('public.log_id_seq'::regclass);


--
-- Name: log_template id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_template ALTER COLUMN id SET DEFAULT nextval('public.log_template_id_seq'::regclass);


--
-- Name: slot_pool id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.slot_pool ALTER COLUMN id SET DEFAULT nextval('public.slot_pool_id_seq'::regclass);


--
-- Name: task_fail id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_fail ALTER COLUMN id SET DEFAULT nextval('public.task_fail_id_seq'::regclass);


--
-- Name: trigger id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trigger ALTER COLUMN id SET DEFAULT nextval('public.trigger_id_seq'::regclass);


--
-- Name: variable id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variable ALTER COLUMN id SET DEFAULT nextval('public.variable_id_seq'::regclass);


--
-- Data for Name: ab_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ab_permission (id, name) FROM stdin;
1	can_read
2	can_edit
3	can_delete
4	can_create
5	menu_access
6	can_get
\.


--
-- Data for Name: ab_permission_view; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ab_permission_view (id, permission_id, view_menu_id) FROM stdin;
1	3	1
2	1	1
3	2	1
4	4	1
5	1	2
6	2	2
7	3	2
8	1	3
9	1	4
10	2	4
11	3	3
12	4	3
13	2	3
14	1	5
15	1	6
16	3	7
17	1	7
18	2	7
19	4	7
20	1	8
21	3	9
22	1	9
23	2	9
24	4	9
25	1	10
26	1	11
27	1	12
28	1	13
29	1	14
30	1	15
31	3	14
32	2	14
33	4	14
34	1	16
35	4	16
36	2	16
37	3	16
38	1	17
39	1	18
40	1	19
41	2	19
42	1	20
43	2	20
44	1	21
45	1	22
46	1	23
47	5	24
48	5	17
49	5	3
50	5	25
51	5	26
52	5	18
53	5	5
54	5	13
55	5	21
56	5	4
57	4	4
58	3	4
59	5	27
60	5	12
61	5	1
62	5	7
63	5	9
64	5	10
65	3	10
66	1	28
67	5	28
68	1	29
69	5	29
70	1	30
71	2	30
72	1	31
73	2	31
74	1	32
75	2	32
76	1	33
77	2	33
78	1	34
79	2	34
80	1	35
81	2	35
82	1	36
83	2	36
84	1	37
85	2	37
86	1	38
87	2	38
88	1	39
89	2	39
90	1	40
91	2	40
92	1	41
93	2	41
94	1	42
95	2	42
96	1	43
97	2	43
98	1	44
99	2	44
100	1	45
101	2	45
102	1	46
103	2	46
104	1	47
105	2	47
106	1	48
107	2	48
108	1	49
109	2	49
110	1	50
111	2	50
112	1	51
113	2	51
114	1	52
115	2	52
116	1	53
117	2	53
118	1	54
119	2	54
120	1	55
121	2	55
122	1	56
123	2	56
124	1	57
125	2	57
126	1	58
127	2	58
128	1	59
129	2	59
130	1	60
131	2	60
132	1	61
133	2	61
134	5	66
135	5	67
136	5	68
137	1	69
138	5	70
139	5	71
140	1	72
141	5	73
142	1	74
143	5	75
146	5	8
147	5	2
148	5	82
149	5	83
150	1	83
151	1	82
152	1	84
153	5	86
154	5	87
155	5	88
156	6	89
158	3	31
159	3	32
160	3	33
161	3	34
162	3	90
163	2	90
164	1	90
165	3	91
166	2	91
167	1	91
168	3	36
169	3	37
170	3	38
171	3	39
172	3	92
173	2	92
174	1	92
175	3	40
176	3	42
177	3	93
178	2	93
179	1	93
180	3	43
181	3	45
182	3	94
183	2	94
184	1	94
185	3	46
186	3	47
187	3	48
188	3	49
189	3	50
190	3	51
191	3	52
192	3	53
193	3	95
194	2	95
195	1	95
196	3	54
197	3	55
198	3	96
199	2	96
200	1	96
201	3	97
202	2	97
203	1	97
204	3	98
205	2	98
206	1	98
207	3	99
208	2	99
209	1	99
210	3	100
211	2	100
212	1	100
213	3	101
214	2	101
215	1	101
216	3	102
217	2	102
218	1	102
219	3	103
220	2	103
221	1	103
222	3	56
223	3	104
224	2	104
225	1	104
226	3	57
227	3	105
228	2	105
229	1	105
230	3	106
231	2	106
232	1	106
233	3	107
234	2	107
235	1	107
236	3	58
237	3	108
238	2	108
239	1	108
240	3	59
241	3	60
242	3	109
243	2	109
244	1	109
245	3	61
246	3	110
247	2	110
248	1	110
249	3	111
250	2	111
251	1	111
253	1	112
254	2	112
255	2	113
256	1	113
257	2	114
258	1	114
270	1	115
271	2	115
272	3	115
273	3	21
274	2	21
275	2	116
276	3	117
277	3	116
278	2	117
279	1	116
280	1	117
281	5	118
282	3	119
283	4	118
284	5	119
285	3	118
286	4	119
287	1	118
288	1	119
\.


--
-- Data for Name: ab_permission_view_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ab_permission_view_role (id, permission_view_id, role_id) FROM stdin;
1	14	3
2	5	3
3	38	3
4	26	3
5	8	3
6	15	3
7	39	3
8	40	3
9	41	3
10	42	3
11	43	3
12	28	3
13	44	3
14	9	3
15	45	3
16	25	3
17	46	3
18	47	3
19	48	3
20	49	3
21	50	3
22	51	3
23	52	3
24	53	3
25	54	3
26	55	3
27	56	3
28	14	4
29	5	4
30	38	4
31	26	4
32	8	4
33	15	4
34	39	4
35	40	4
36	41	4
37	42	4
38	43	4
39	28	4
40	44	4
41	9	4
42	45	4
43	25	4
44	46	4
45	47	4
46	48	4
47	49	4
48	50	4
49	51	4
50	52	4
51	53	4
52	54	4
53	55	4
54	56	4
55	6	4
56	7	4
57	57	4
58	10	4
59	58	4
60	12	4
61	13	4
62	11	4
63	14	5
64	5	5
65	38	5
66	26	5
67	8	5
68	15	5
69	39	5
70	40	5
71	41	5
72	42	5
73	43	5
74	28	5
75	44	5
76	9	5
77	45	5
78	25	5
79	46	5
80	47	5
81	48	5
82	49	5
83	50	5
84	51	5
85	52	5
86	53	5
87	54	5
88	55	5
89	56	5
90	6	5
91	7	5
92	57	5
93	10	5
94	58	5
95	12	5
96	13	5
97	11	5
98	27	5
99	59	5
100	60	5
101	61	5
102	62	5
103	63	5
104	64	5
105	4	5
106	2	5
107	3	5
108	1	5
109	19	5
110	17	5
111	18	5
112	16	5
113	20	5
114	24	5
115	22	5
116	23	5
117	21	5
118	65	5
119	14	1
120	5	1
121	38	1
122	26	1
123	8	1
124	15	1
125	39	1
126	40	1
127	41	1
128	42	1
129	43	1
130	28	1
131	44	1
132	9	1
133	45	1
134	25	1
135	46	1
136	47	1
137	48	1
138	49	1
139	50	1
140	51	1
141	52	1
142	53	1
143	54	1
144	55	1
145	56	1
146	6	1
147	7	1
148	57	1
149	10	1
150	58	1
151	12	1
152	13	1
153	11	1
154	27	1
155	59	1
156	60	1
157	61	1
158	62	1
159	63	1
160	64	1
161	4	1
162	2	1
163	3	1
164	1	1
165	19	1
166	17	1
167	18	1
168	16	1
169	20	1
170	24	1
171	22	1
172	23	1
173	21	1
174	65	1
175	66	1
176	67	1
177	68	1
178	69	1
179	70	1
180	71	1
181	29	1
182	32	1
183	31	1
184	37	1
185	35	1
186	36	1
187	33	1
188	30	1
189	34	1
190	134	1
191	135	1
192	136	1
193	137	1
194	138	1
195	139	1
196	140	1
197	141	1
198	142	1
199	143	1
202	146	1
203	147	1
204	148	1
205	149	1
206	150	3
207	151	3
208	17	3
209	152	3
210	147	3
211	149	3
212	148	3
213	150	4
214	151	4
215	17	4
216	152	4
217	147	4
218	149	4
219	148	4
220	150	5
221	151	5
222	152	5
223	147	5
224	149	5
225	148	5
226	146	5
227	150	1
228	151	1
229	152	1
230	153	1
231	154	1
232	155	1
233	156	1
247	273	1
248	274	1
\.


--
-- Data for Name: ab_register_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ab_register_user (id, first_name, last_name, username, password, email, registration_date, registration_hash) FROM stdin;
\.


--
-- Data for Name: ab_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ab_role (id, name) FROM stdin;
1	Admin
2	Public
3	Viewer
4	User
5	Op
\.


--
-- Data for Name: ab_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ab_user (id, first_name, last_name, username, password, active, email, last_login, login_count, fail_login_count, created_on, changed_on, created_by_fk, changed_by_fk) FROM stdin;
1	Kevin	corcoran	admin	pbkdf2:sha256:260000$82dl4P1hqagtxw5a$9c60c3287c8de651812777ef9b49fa47baa335413cbf734db22ac928f095255a	t	Kevin.corcoran@hotmail.com	2024-02-19 13:26:37.499353	1	0	2024-02-19 13:26:26.752817	2024-02-19 13:26:26.752825	\N	\N
\.


--
-- Data for Name: ab_user_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ab_user_role (id, user_id, role_id) FROM stdin;
1	1	1
\.


--
-- Data for Name: ab_view_menu; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ab_view_menu (id, name) FROM stdin;
1	Connections
2	DAGs
3	DAG Runs
4	Task Instances
5	Audit Logs
6	ImportError
7	Pools
8	Providers
9	Variables
10	XComs
11	DAG Code
12	Configurations
13	Plugins
14	Roles
15	Permissions
16	Users
17	DAG Dependencies
18	Jobs
19	My Password
20	My Profile
21	SLA Misses
22	Task Logs
23	Website
24	Browse
25	Documentation
26	Docs
27	Admin
28	Task Reschedules
29	Triggers
30	Passwords
31	DAG:latest_only
32	DAG:example_task_group_decorator
33	DAG:example_complex
34	DAG:example_python_operator
35	DAG:tutorial_taskflow_api_etl
36	DAG:example_external_task_marker_parent
37	DAG:example_external_task_marker_child
38	DAG:example_bash_operator
39	DAG:example_short_circuit_operator
40	DAG:example_branch_operator
41	DAG:tutorial_etl_dag
42	DAG:example_branch_labels
43	DAG:example_task_group
44	DAG:tutorial_taskflow_api_etl_virtualenv
45	DAG:tutorial
46	DAG:example_sla_dag
47	DAG:example_passing_params_via_test_command
48	DAG:latest_only_with_trigger
49	DAG:example_time_delta_sensor_async
50	DAG:example_dag_decorator
51	DAG:example_xcom
52	DAG:example_xcom_args
53	DAG:example_xcom_args_with_operators
54	DAG:example_weekday_branch_operator
55	DAG:example_skip_dag
56	DAG:example_trigger_target_dag
57	DAG:example_branch_dop_operator_v3
58	DAG:example_branch_datetime_operator_2
59	DAG:example_nested_branch_dag
60	DAG:example_subdag_operator
61	DAG:example_trigger_controller_dag
62	IndexView
63	UtilView
64	LocaleView
65	AuthDBView
66	List Users
67	Security
68	List Roles
69	User Stats Chart
70	User's Statistics
71	Actions
72	View Menus
73	Resources
74	Permission Views
75	Permission Pairs
76	AutocompleteView
77	Airflow
78	DagDependenciesView
79	RedocView
80	DevView
81	DocsView
82	Cluster Activity
83	Datasets
84	DAG Warnings
85	SecurityApi
86	Base Permissions
87	Views/Menus
88	Permission on Views/Menus
89	MenuApi
90	DAG:tutorial_taskflow_api_virtualenv
91	DAG:example_params_trigger_ui
92	DAG:example_setup_teardown
93	DAG:tutorial_taskflow_api
94	DAG:example_python_decorator
95	DAG:example_branch_python_operator_decorator
96	DAG:example_short_circuit_decorator
97	DAG:dataset_produces_1
98	DAG:dataset_produces_2
99	DAG:dataset_consumes_1_never_scheduled
100	DAG:dataset_consumes_1_and_2
101	DAG:dataset_consumes_1
102	DAG:dataset_consumes_unknown_never_scheduled
103	DAG:tutorial_dag
104	DAG:example_sensor_decorator
105	DAG:example_sensors
106	DAG:example_setup_teardown_taskflow
107	DAG:example_branch_datetime_operator_3
108	DAG:example_branch_datetime_operator
109	DAG:example_dynamic_task_mapping_with_no_taskflow_operators
110	DAG:example_params_ui_tutorial
111	DAG:example_dynamic_task_mapping
112	DAG:update_downstream_table
113	DAG:a_example_trigger_target_dag_kc
114	DAG:cdm_pure_growth_dag
115	DAG:tutorial_objectstorage
116	DAG:yfinance_to_raw_test_dag
117	DAG:cdm_ticker_count_by_date_dag
118	DAG Run:yfinance_to_raw_test_dag
119	DAG Run:cdm_ticker_count_by_date_dag
\.


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
bff083ad727d
\.


--
-- Data for Name: callback_request; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.callback_request (id, created_at, priority_weight, callback_data, callback_type, processor_subdir) FROM stdin;
\.


--
-- Data for Name: connection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.connection (id, conn_id, conn_type, host, schema, login, password, port, extra, is_encrypted, is_extra_encrypted, description) FROM stdin;
1	airflow_db	mysql	mysql	airflow	root	\N	\N	\N	f	f	\N
2	aws_default	aws	\N	\N	\N	\N	\N	\N	f	f	\N
3	azure_batch_default	azure_batch	\N	\N	<ACCOUNT_NAME>	\N	\N	{"account_url": "<ACCOUNT_URL>"}	f	f	\N
4	azure_cosmos_default	azure_cosmos	\N	\N	\N	\N	\N	{"database_name": "<DATABASE_NAME>", "collection_name": "<COLLECTION_NAME>" }	f	f	\N
5	azure_data_explorer_default	azure_data_explorer	https://<CLUSTER>.kusto.windows.net	\N	\N	\N	\N	{"auth_method": "<AAD_APP | AAD_APP_CERT | AAD_CREDS | AAD_DEVICE>",\n                    "tenant": "<TENANT ID>", "certificate": "<APPLICATION PEM CERTIFICATE>",\n                    "thumbprint": "<APPLICATION CERTIFICATE THUMBPRINT>"}	f	f	\N
6	azure_data_lake_default	azure_data_lake	\N	\N	\N	\N	\N	{"tenant": "<TENANT>", "account_name": "<ACCOUNTNAME>" }	f	f	\N
7	azure_default	azure	\N	\N	\N	\N	\N	\N	f	f	\N
8	cassandra_default	cassandra	cassandra	\N	\N	\N	9042	\N	f	f	\N
9	databricks_default	databricks	localhost	\N	\N	\N	\N	\N	f	f	\N
10	dingding_default	http		\N	\N	\N	\N	\N	f	f	\N
11	drill_default	drill	localhost	\N	\N	\N	8047	{"dialect_driver": "drill+sadrill", "storage_plugin": "dfs"}	f	f	\N
12	druid_broker_default	druid	druid-broker	\N	\N	\N	8082	{"endpoint": "druid/v2/sql"}	f	f	\N
13	druid_ingest_default	druid	druid-overlord	\N	\N	\N	8081	{"endpoint": "druid/indexer/v1/task"}	f	f	\N
14	elasticsearch_default	elasticsearch	localhost	http	\N	\N	9200	\N	f	f	\N
15	emr_default	emr	\N	\N	\N	\N	\N	\n                {   "Name": "default_job_flow_name",\n                    "LogUri": "s3://my-emr-log-bucket/default_job_flow_location",\n                    "ReleaseLabel": "emr-4.6.0",\n                    "Instances": {\n                        "Ec2KeyName": "mykey",\n                        "Ec2SubnetId": "somesubnet",\n                        "InstanceGroups": [\n                            {\n                                "Name": "Master nodes",\n                                "Market": "ON_DEMAND",\n                                "InstanceRole": "MASTER",\n                                "InstanceType": "r3.2xlarge",\n                                "InstanceCount": 1\n                            },\n                            {\n                                "Name": "Core nodes",\n                                "Market": "ON_DEMAND",\n                                "InstanceRole": "CORE",\n                                "InstanceType": "r3.2xlarge",\n                                "InstanceCount": 1\n                            }\n                        ],\n                        "TerminationProtected": false,\n                        "KeepJobFlowAliveWhenNoSteps": false\n                    },\n                    "Applications":[\n                        { "Name": "Spark" }\n                    ],\n                    "VisibleToAllUsers": true,\n                    "JobFlowRole": "EMR_EC2_DefaultRole",\n                    "ServiceRole": "EMR_DefaultRole",\n                    "Tags": [\n                        {\n                            "Key": "app",\n                            "Value": "analytics"\n                        },\n                        {\n                            "Key": "environment",\n                            "Value": "development"\n                        }\n                    ]\n                }\n            	f	f	\N
16	facebook_default	facebook_social	\N	\N	\N	\N	\N	\n                {   "account_id": "<AD_ACCOUNT_ID>",\n                    "app_id": "<FACEBOOK_APP_ID>",\n                    "app_secret": "<FACEBOOK_APP_SECRET>",\n                    "access_token": "<FACEBOOK_AD_ACCESS_TOKEN>"\n                }\n            	f	f	\N
17	fs_default	fs	\N	\N	\N	\N	\N	{"path": "/"}	f	f	\N
18	google_cloud_default	google_cloud_platform	\N	default	\N	\N	\N	\N	f	f	\N
19	hive_cli_default	hive_cli	localhost	default	\N	\N	10000	{"use_beeline": true, "auth": ""}	f	f	\N
20	hiveserver2_default	hiveserver2	localhost	default	\N	\N	10000	\N	f	f	\N
21	http_default	http	https://www.httpbin.org/	\N	\N	\N	\N	\N	f	f	\N
22	kubernetes_default	kubernetes	\N	\N	\N	\N	\N	\N	f	f	\N
23	kylin_default	kylin	localhost	\N	ADMIN	KYLIN	7070	\N	f	f	\N
24	leveldb_default	leveldb	localhost	\N	\N	\N	\N	\N	f	f	\N
25	livy_default	livy	livy	\N	\N	\N	8998	\N	f	f	\N
26	local_mysql	mysql	localhost	airflow	airflow	airflow	\N	\N	f	f	\N
27	metastore_default	hive_metastore	localhost	\N	\N	\N	9083	{"authMechanism": "PLAIN"}	f	f	\N
28	mongo_default	mongo	mongo	\N	\N	\N	27017	\N	f	f	\N
29	mssql_default	mssql	localhost	\N	\N	\N	1433	\N	f	f	\N
30	mysql_default	mysql	mysql	airflow	root	\N	\N	\N	f	f	\N
31	opsgenie_default	http		\N	\N	\N	\N	\N	f	f	\N
32	oss_default	oss	\N	\N	\N	\N	\N	{\n                "auth_type": "AK",\n                "access_key_id": "<ACCESS_KEY_ID>",\n                "access_key_secret": "<ACCESS_KEY_SECRET>"}\n                	f	f	\N
33	pig_cli_default	pig_cli	\N	default	\N	\N	\N	\N	f	f	\N
34	pinot_admin_default	pinot	localhost	\N	\N	\N	9000	\N	f	f	\N
35	pinot_broker_default	pinot	localhost	\N	\N	\N	9000	{"endpoint": "/query", "schema": "http"}	f	f	\N
37	presto_default	presto	localhost	hive	\N	\N	3400	\N	f	f	\N
38	qubole_default	qubole	localhost	\N	\N	\N	\N	\N	f	f	\N
39	redis_default	redis	redis	\N	\N	\N	6379	{"db": 0}	f	f	\N
40	segment_default	segment	\N	\N	\N	\N	\N	{"write_key": "my-segment-write-key"}	f	f	\N
41	sftp_default	sftp	localhost	\N	airflow	\N	22	{"key_file": "~/.ssh/id_rsa", "no_host_key_check": true}	f	f	\N
42	spark_default	spark	yarn	\N	\N	\N	\N	{"queue": "root.default"}	f	f	\N
43	sqlite_default	sqlite	/var/folders/qt/v4kx0jtn7rnfml4j14v2v3s00000gn/T/sqlite_default.db	\N	\N	\N	\N	\N	f	f	\N
44	sqoop_default	sqoop	rdbms	\N	\N	\N	\N	\N	f	f	\N
45	ssh_default	ssh	localhost	\N	\N	\N	\N	\N	f	f	\N
46	tableau_default	tableau	https://tableau.server.url	\N	user	password	\N	{"site_id": "my_site"}	f	f	\N
47	trino_default	trino	localhost	hive	\N	\N	3400	\N	f	f	\N
48	vertica_default	vertica	localhost	\N	\N	\N	5433	\N	f	f	\N
49	wasb_default	wasb	\N	\N	\N	\N	\N	{"sas_token": null}	f	f	\N
50	webhdfs_default	hdfs	localhost	\N	\N	\N	50070	\N	f	f	\N
51	yandexcloud_default	yandexcloud	\N	default	\N	\N	\N	\N	f	f	\N
52	ftp_default	ftp	localhost	\N	airflow	airflow	21	{"key_file": "~/.ssh/id_rsa", "no_host_key_check": true}	f	f	\N
53	impala_default	impala	localhost	\N	\N	\N	21050	\N	f	f	\N
54	kafka_default	kafka	\N	\N	\N	\N	\N	{"bootstrap.servers": "broker:29092"}	f	f	\N
55	oracle_default	oracle	localhost	schema	root	password	1521	\N	f	f	\N
56	redshift_default	redshift	\N	\N	\N	\N	\N	{\n    "iam": true,\n    "cluster_identifier": "<REDSHIFT_CLUSTER_IDENTIFIER>",\n    "port": 5439,\n    "profile": "default",\n    "db_user": "awsuser",\n    "database": "dev",\n    "region": ""\n}	f	f	\N
57	salesforce_default	salesforce	\N	\N	username	password	\N	{"security_token": "security_token"}	f	f	\N
58	tabular_default	tabular	https://api.tabulardata.io/ws/v1	\N	\N	\N	\N	\N	f	f	\N
36	postgres_default	postgres	localhost	airflow	postgres	9356	5433		f	f	
\.


--
-- Data for Name: dag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dag (dag_id, is_paused, is_subdag, is_active, last_parsed_time, last_pickled, last_expired, scheduler_lock, pickle_id, fileloc, owners, description, default_view, schedule_interval, root_dag_id, next_dagrun, next_dagrun_create_after, max_active_tasks, has_task_concurrency_limits, max_active_runs, next_dagrun_data_interval_start, next_dagrun_data_interval_end, has_import_errors, timetable_description, processor_subdir, dataset_expression, max_consecutive_failed_dag_runs, dag_display_name) FROM stdin;
dataset_produces_2	t	f	f	2024-02-19 16:55:42.064376+01	\N	\N	\N	\N	/Users/kevin/airflow_venv/lib/python3.11/site-packages/airflow/example_dags/example_datasets.py	airflow	\N	grid	null	\N	\N	\N	16	f	16	\N	\N	f	Never, external triggers only	\N	\N	\N	\N
example_branch_datetime_operator	t	f	f	2024-02-19 16:55:42.066545+01	\N	\N	\N	\N	/Users/kevin/airflow_venv/lib/python3.11/site-packages/airflow/example_dags/example_branch_datetime_operator.py	airflow	\N	grid	"@daily"	\N	2024-02-18 01:00:00+01	2024-02-19 01:00:00+01	16	f	16	2024-02-18 01:00:00+01	2024-02-19 01:00:00+01	f	At 00:00	\N	\N	\N	\N
example_branch_datetime_operator_3	t	f	f	2024-02-19 16:55:42.070113+01	\N	\N	\N	\N	/Users/kevin/airflow_venv/lib/python3.11/site-packages/airflow/example_dags/example_branch_datetime_operator.py	airflow	\N	grid	"@daily"	\N	2024-02-18 01:00:00+01	2024-02-19 01:00:00+01	16	f	16	2024-02-18 01:00:00+01	2024-02-19 01:00:00+01	f	At 00:00	\N	\N	\N	\N
example_branch_python_operator_decorator	t	f	f	2024-02-19 16:55:42.081272+01	\N	\N	\N	\N	/Users/kevin/airflow_venv/lib/python3.11/site-packages/airflow/example_dags/example_branch_operator_decorator.py	airflow	\N	grid	"@daily"	\N	2024-02-18 01:00:00+01	2024-02-19 01:00:00+01	16	f	16	2024-02-18 01:00:00+01	2024-02-19 01:00:00+01	f	At 00:00	\N	\N	\N	\N
example_dynamic_task_mapping	t	f	f	2024-02-19 16:55:42.084188+01	\N	\N	\N	\N	/Users/kevin/airflow_venv/lib/python3.11/site-packages/airflow/example_dags/example_dynamic_task_mapping.py	airflow	\N	grid	{"type": "timedelta", "attrs": {"days": 1, "seconds": 0, "microseconds": 0}}	\N	2022-03-04 01:00:00+01	2022-03-05 01:00:00+01	16	f	16	2022-03-04 01:00:00+01	2022-03-05 01:00:00+01	f		\N	\N	\N	\N
example_dynamic_task_mapping_with_no_taskflow_operators	t	f	f	2024-02-19 16:55:42.085322+01	\N	\N	\N	\N	/Users/kevin/airflow_venv/lib/python3.11/site-packages/airflow/example_dags/example_dynamic_task_mapping_with_no_taskflow_operators.py	airflow	\N	grid	{"type": "timedelta", "attrs": {"days": 1, "seconds": 0, "microseconds": 0}}	\N	2024-02-18 01:00:00+01	2024-02-19 01:00:00+01	16	f	16	2024-02-18 01:00:00+01	2024-02-19 01:00:00+01	f		\N	\N	\N	\N
example_python_decorator	t	f	f	2024-02-19 16:55:42.09362+01	\N	\N	\N	\N	/Users/kevin/airflow_venv/lib/python3.11/site-packages/airflow/example_dags/example_python_decorator.py	airflow	\N	grid	null	\N	\N	\N	16	f	16	\N	\N	f	Never, external triggers only	\N	\N	\N	\N
latest_only_with_trigger	t	f	f	2024-02-21 17:42:39.069172+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_latest_only_with_trigger.py	airflow	\N	tree	{"type": "timedelta", "attrs": {"days": 0, "seconds": 14400, "microseconds": 0}}	\N	2024-02-21 13:42:39.069393+01	2024-02-21 17:42:39.069393+01	16	f	16	2024-02-21 13:42:39.069393+01	2024-02-21 17:42:39.069393+01	f		\N	\N	\N	\N
tutorial_taskflow_api_etl	t	f	f	2024-02-21 17:42:40.088144+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/tutorial_taskflow_api_etl.py	airflow	\N	tree	null	\N	\N	\N	16	f	16	\N	\N	f	\N	\N	\N	\N	\N
example_dag_decorator	t	f	f	2024-02-21 17:42:50.704134+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_dag_decorator.py	airflow	\N	tree	null	\N	\N	\N	16	f	16	\N	\N	f	Never, external triggers only	\N	\N	\N	\N
example_trigger_target_dag	t	f	f	2024-02-21 17:42:59.948768+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_trigger_target_dag.py	airflow	\N	tree	null	\N	\N	\N	16	f	16	\N	\N	f	Never, external triggers only	\N	\N	\N	\N
example_branch_datetime_operator_2	t	f	f	2024-02-21 17:42:46.927766+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_branch_datetime_operator.py	airflow	\N	tree	"@daily"	\N	2024-02-20 01:00:00+01	2024-02-21 01:00:00+01	16	f	16	2024-02-20 01:00:00+01	2024-02-21 01:00:00+01	f	At 00:00	\N	\N	\N	\N
example_bash_operator	t	f	f	2024-02-21 17:42:46.932467+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_bash_operator.py	airflow	\N	tree	"0 0 * * *"	\N	2024-02-20 01:00:00+01	2024-02-21 01:00:00+01	16	f	16	2024-02-20 01:00:00+01	2024-02-21 01:00:00+01	f	At 00:00	\N	\N	\N	\N
tutorial_etl_dag	t	f	f	2024-02-21 17:42:52.10908+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/tutorial_etl_dag.py	airflow	ETL DAG tutorial	tree	null	\N	\N	\N	16	f	16	\N	\N	f	\N	\N	\N	\N	\N
cdm_pure_growth_dag	f	f	f	2024-02-21 17:42:35.792195+01	\N	\N	\N	\N	/Users/kevin/Dropbox/applications/cp/dags/cdm_pure_growth_dag.py	airflow	\N	tree	null	\N	\N	\N	16	f	16	\N	\N	t	\N	\N	\N	\N	\N
example_nested_branch_dag	t	f	f	2024-02-21 17:42:39.069226+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_nested_branch_dag.py	airflow	\N	tree	"@daily"	\N	2024-02-20 01:00:00+01	2024-02-21 01:00:00+01	16	f	16	2024-02-20 01:00:00+01	2024-02-21 01:00:00+01	f	At 00:00	\N	\N	\N	\N
example_complex	t	f	f	2024-02-21 17:42:40.49305+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_complex.py	airflow	\N	tree	null	\N	\N	\N	16	f	16	\N	\N	f	Never, external triggers only	\N	\N	\N	\N
example_params_ui_tutorial	t	f	f	2024-02-19 16:55:42.089471+01	\N	\N	\N	\N	/Users/kevin/airflow_venv/lib/python3.11/site-packages/airflow/example_dags/example_params_ui_tutorial.py	airflow	DAG demonstrating various options for a trigger form generated by DAG params	grid	null	\N	\N	\N	16	f	16	\N	\N	f	Never, external triggers only	\N	\N	\N	\N
example_branch_dop_operator_v3	t	f	f	2024-02-21 17:42:40.558014+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_branch_python_dop_operator_3.py	airflow	\N	tree	"*/1 * * * *"	\N	2024-02-21 17:41:00+01	2024-02-21 17:42:00+01	16	f	16	2024-02-21 17:41:00+01	2024-02-21 17:42:00+01	f	Every minute	\N	\N	\N	\N
example_skip_dag	t	f	f	2024-02-21 17:42:37.844963+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_skip_dag.py	airflow	\N	tree	{"type": "timedelta", "attrs": {"days": 1, "seconds": 0, "microseconds": 0}}	\N	2024-02-20 17:42:37.84519+01	2024-02-21 17:42:37.84519+01	16	f	16	2024-02-20 17:42:37.84519+01	2024-02-21 17:42:37.84519+01	f		\N	\N	\N	\N
example_short_circuit_operator	t	f	f	2024-02-21 17:42:37.947619+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_short_circuit_operator.py	airflow	\N	tree	{"type": "timedelta", "attrs": {"days": 1, "seconds": 0, "microseconds": 0}}	\N	2024-02-20 17:42:37.947838+01	2024-02-21 17:42:37.947838+01	16	f	16	2024-02-20 17:42:37.947838+01	2024-02-21 17:42:37.947838+01	f		\N	\N	\N	\N
example_python_operator	t	f	f	2024-02-21 17:42:38.066313+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_python_operator.py	airflow	\N	tree	null	\N	\N	\N	16	f	16	\N	\N	f	Never, external triggers only	\N	\N	\N	\N
tutorial_taskflow_api_etl_virtualenv	t	f	f	2024-02-21 17:42:35.895995+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/tutorial_taskflow_api_etl_virtualenv.py	airflow	\N	tree	null	\N	\N	\N	16	f	16	\N	\N	f	\N	\N	\N	\N	\N
example_passing_params_via_test_command	t	f	f	2024-02-21 17:42:38.071871+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_passing_params_via_test_command.py	airflow	\N	tree	"*/1 * * * *"	\N	2024-02-21 17:41:00+01	2024-02-21 17:42:00+01	16	f	16	2024-02-21 17:41:00+01	2024-02-21 17:42:00+01	f	Every minute	\N	\N	\N	\N
example_sensor_decorator	t	f	f	2024-02-19 16:55:42.094659+01	\N	\N	\N	\N	/Users/kevin/airflow_venv/lib/python3.11/site-packages/airflow/example_dags/example_sensor_decorator.py	airflow	\N	grid	null	\N	\N	\N	16	f	16	\N	\N	f	Never, external triggers only	\N	\N	\N	\N
example_params_trigger_ui	t	f	f	2024-02-19 16:55:42.088924+01	\N	\N	\N	\N	/Users/kevin/airflow_venv/lib/python3.11/site-packages/airflow/example_dags/example_params_trigger_ui.py	airflow	Example DAG demonstrating the usage DAG params to model a trigger UI with a user form	grid	null	\N	\N	\N	16	f	16	\N	\N	f	Never, external triggers only	\N	\N	\N	\N
example_sensors	t	f	f	2024-02-19 16:55:42.095141+01	\N	\N	\N	\N	/Users/kevin/airflow_venv/lib/python3.11/site-packages/airflow/example_dags/example_sensors.py	airflow	\N	grid	null	\N	\N	\N	16	f	16	\N	\N	f	Never, external triggers only	\N	\N	\N	\N
example_setup_teardown	t	f	f	2024-02-19 16:55:42.095618+01	\N	\N	\N	\N	/Users/kevin/airflow_venv/lib/python3.11/site-packages/airflow/example_dags/example_setup_teardown.py	airflow	\N	grid	{"type": "timedelta", "attrs": {"days": 1, "seconds": 0, "microseconds": 0}}	\N	2024-02-18 01:00:00+01	2024-02-19 01:00:00+01	16	f	16	2024-02-18 01:00:00+01	2024-02-19 01:00:00+01	f		\N	\N	\N	\N
example_setup_teardown_taskflow	t	f	f	2024-02-19 16:55:42.096206+01	\N	\N	\N	\N	/Users/kevin/airflow_venv/lib/python3.11/site-packages/airflow/example_dags/example_setup_teardown_taskflow.py	airflow	\N	grid	{"type": "timedelta", "attrs": {"days": 1, "seconds": 0, "microseconds": 0}}	\N	2024-02-18 01:00:00+01	2024-02-19 01:00:00+01	16	f	16	2024-02-18 01:00:00+01	2024-02-19 01:00:00+01	f		\N	\N	\N	\N
example_short_circuit_decorator	t	f	f	2024-02-19 16:55:42.096863+01	\N	\N	\N	\N	/Users/kevin/airflow_venv/lib/python3.11/site-packages/airflow/example_dags/example_short_circuit_decorator.py	airflow	\N	grid	{"type": "timedelta", "attrs": {"days": 1, "seconds": 0, "microseconds": 0}}	\N	2024-02-18 01:00:00+01	2024-02-19 01:00:00+01	16	f	16	2024-02-18 01:00:00+01	2024-02-19 01:00:00+01	f		\N	\N	\N	\N
example_external_task_marker_child	t	f	f	2024-02-21 17:42:40.365646+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_external_task_marker_dag.py	airflow	\N	tree	null	\N	\N	\N	16	f	16	\N	\N	f	Never, external triggers only	\N	\N	\N	\N
example_external_task_marker_parent	t	f	f	2024-02-21 17:42:40.366826+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_external_task_marker_dag.py	airflow	\N	tree	null	\N	\N	\N	16	f	16	\N	\N	f	Never, external triggers only	\N	\N	\N	\N
example_branch_operator	t	f	f	2024-02-21 17:42:40.606488+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_branch_operator.py	airflow	\N	tree	"@daily"	\N	2024-02-20 01:00:00+01	2024-02-21 01:00:00+01	16	f	16	2024-02-20 01:00:00+01	2024-02-21 01:00:00+01	f	At 00:00	\N	\N	\N	\N
example_branch_labels	t	f	f	2024-02-21 17:42:40.676952+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_branch_labels.py	airflow	\N	tree	"@daily"	\N	2024-02-20 01:00:00+01	2024-02-21 01:00:00+01	16	f	16	2024-02-20 01:00:00+01	2024-02-21 01:00:00+01	f	At 00:00	\N	\N	\N	\N
example_task_group_decorator	t	f	f	2024-02-21 17:42:40.742053+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_task_group_decorator.py	airflow	\N	tree	{"type": "timedelta", "attrs": {"days": 1, "seconds": 0, "microseconds": 0}}	\N	2024-02-20 17:42:40.74216+01	2024-02-21 17:42:40.74216+01	16	f	16	2024-02-20 17:42:40.74216+01	2024-02-21 17:42:40.74216+01	f		\N	\N	\N	\N
example_subdag_operator	t	f	f	2024-02-21 17:42:34.842225+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_subdag_operator.py	airflow	\N	tree	"@once"	\N	2024-02-19 01:00:00+01	2024-02-19 01:00:00+01	16	f	16	2024-02-19 01:00:00+01	2024-02-19 01:00:00+01	f	Once, as soon as possible	\N	\N	\N	\N
example_time_delta_sensor_async	t	f	f	2024-02-21 17:42:53.247949+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_time_delta_sensor_async.py	airflow	\N	tree	null	\N	\N	\N	16	f	16	\N	\N	f	Never, external triggers only	\N	\N	\N	\N
example_task_group	t	f	f	2024-02-21 17:42:53.276061+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_task_group.py	airflow	\N	tree	{"type": "timedelta", "attrs": {"days": 1, "seconds": 0, "microseconds": 0}}	\N	2024-02-20 17:42:53.27627+01	2024-02-21 17:42:53.27627+01	16	f	16	2024-02-20 17:42:53.27627+01	2024-02-21 17:42:53.27627+01	f		\N	\N	\N	\N
example_sla_dag	t	f	f	2024-02-21 17:42:37.844655+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_sla_dag.py	airflow	\N	tree	"*/2 * * * *"	\N	2024-02-21 17:40:00+01	2024-02-21 17:42:00+01	16	f	16	2024-02-21 17:40:00+01	2024-02-21 17:42:00+01	f	Every 2 minutes	\N	\N	\N	\N
example_weekday_branch_operator	t	f	f	2024-02-21 17:42:40.720901+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_branch_day_of_week_operator.py	airflow	\N	tree	"@daily"	\N	2024-02-20 01:00:00+01	2024-02-21 01:00:00+01	16	f	16	2024-02-20 01:00:00+01	2024-02-21 01:00:00+01	f	At 00:00	\N	\N	\N	\N
example_subdag_operator.section-1	t	t	f	2024-02-21 17:42:34.858136+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_subdag_operator.py	airflow	\N	tree	"@daily"	example_subdag_operator	\N	\N	16	f	16	\N	\N	f	At 00:00	\N	\N	\N	\N
example_subdag_operator.section-2	t	t	f	2024-02-21 17:42:34.859331+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_subdag_operator.py	airflow	\N	tree	"@daily"	example_subdag_operator	\N	\N	16	f	16	\N	\N	f	At 00:00	\N	\N	\N	\N
latest_only	t	f	f	2024-02-21 17:42:40.181508+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_latest_only.py	airflow	\N	tree	{"type": "timedelta", "attrs": {"days": 0, "seconds": 14400, "microseconds": 0}}	\N	2024-02-21 13:42:40.181728+01	2024-02-21 17:42:40.181728+01	16	f	16	2024-02-21 13:42:40.181728+01	2024-02-21 17:42:40.181728+01	f		\N	\N	\N	\N
example_xcom	t	f	f	2024-02-21 17:42:51.730486+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_xcom.py	airflow	\N	tree	"@once"	\N	2021-01-01 01:00:00+01	2021-01-01 01:00:00+01	16	f	16	2021-01-01 01:00:00+01	2021-01-01 01:00:00+01	f	Once, as soon as possible	\N	\N	\N	\N
tutorial	t	f	f	2024-02-21 17:42:52.109273+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/tutorial.py	airflow	A simple tutorial DAG	tree	{"type": "timedelta", "attrs": {"days": 1, "seconds": 0, "microseconds": 0}}	\N	2024-02-20 17:42:52.109469+01	2024-02-21 17:42:52.109469+01	16	f	16	2024-02-20 17:42:52.109469+01	2024-02-21 17:42:52.109469+01	f		\N	\N	\N	\N
example_xcom_args	t	f	f	2024-02-21 17:42:53.142237+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_xcomargs.py	airflow	\N	tree	null	\N	\N	\N	16	f	16	\N	\N	f	Never, external triggers only	\N	\N	\N	\N
example_xcom_args_with_operators	t	f	f	2024-02-21 17:42:53.143347+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_xcomargs.py	airflow	\N	tree	null	\N	\N	\N	16	f	16	\N	\N	f	Never, external triggers only	\N	\N	\N	\N
example_trigger_controller_dag	t	f	f	2024-02-21 17:42:53.178999+01	\N	\N	\N	\N	/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/airflow/example_dags/example_trigger_controller_dag.py	airflow	\N	tree	"@once"	\N	2021-01-01 01:00:00+01	2021-01-01 01:00:00+01	16	f	16	2021-01-01 01:00:00+01	2021-01-01 01:00:00+01	f	Once, as soon as possible	\N	\N	\N	\N
dataset_consumes_1_and_2	t	f	f	2024-02-19 16:55:42.060708+01	\N	\N	\N	\N	/Users/kevin/airflow_venv/lib/python3.11/site-packages/airflow/example_dags/example_datasets.py	airflow	\N	grid	"Dataset"	\N	\N	\N	16	f	16	\N	\N	f	Triggered by datasets	\N	\N	\N	\N
dataset_consumes_1_never_scheduled	t	f	f	2024-02-19 16:55:42.061297+01	\N	\N	\N	\N	/Users/kevin/airflow_venv/lib/python3.11/site-packages/airflow/example_dags/example_datasets.py	airflow	\N	grid	"Dataset"	\N	\N	\N	16	f	16	\N	\N	f	Triggered by datasets	\N	\N	\N	\N
dataset_consumes_unknown_never_scheduled	t	f	f	2024-02-19 16:55:42.061856+01	\N	\N	\N	\N	/Users/kevin/airflow_venv/lib/python3.11/site-packages/airflow/example_dags/example_datasets.py	airflow	\N	grid	"Dataset"	\N	\N	\N	16	f	16	\N	\N	f	Triggered by datasets	\N	\N	\N	\N
dataset_consumes_1	t	f	f	2024-02-19 16:55:42.0588+01	\N	\N	\N	\N	/Users/kevin/airflow_venv/lib/python3.11/site-packages/airflow/example_dags/example_datasets.py	airflow	\N	grid	"Dataset"	\N	\N	\N	16	f	16	\N	\N	f	Triggered by datasets	\N	\N	\N	\N
dataset_produces_1	t	f	f	2024-02-19 16:55:42.062415+01	\N	\N	\N	\N	/Users/kevin/airflow_venv/lib/python3.11/site-packages/airflow/example_dags/example_datasets.py	airflow	\N	grid	"@daily"	\N	2024-02-18 01:00:00+01	2024-02-19 01:00:00+01	16	f	16	2024-02-18 01:00:00+01	2024-02-19 01:00:00+01	f	At 00:00	\N	\N	\N	\N
tutorial_dag	t	f	f	2024-02-19 16:55:42.1101+01	\N	\N	\N	\N	/Users/kevin/airflow_venv/lib/python3.11/site-packages/airflow/example_dags/tutorial_dag.py	airflow	DAG tutorial	grid	null	\N	\N	\N	16	f	16	\N	\N	f	Never, external triggers only	\N	\N	\N	\N
tutorial_taskflow_api	t	f	f	2024-02-19 16:55:42.110537+01	\N	\N	\N	\N	/Users/kevin/airflow_venv/lib/python3.11/site-packages/airflow/example_dags/tutorial_taskflow_api.py	airflow	\N	grid	null	\N	\N	\N	16	f	16	\N	\N	f	Never, external triggers only	\N	\N	\N	\N
tutorial_taskflow_api_virtualenv	t	f	f	2024-02-19 16:55:42.11099+01	\N	\N	\N	\N	/Users/kevin/airflow_venv/lib/python3.11/site-packages/airflow/example_dags/tutorial_taskflow_api_virtualenv.py	airflow	\N	grid	null	\N	\N	\N	16	f	16	\N	\N	f	Never, external triggers only	\N	\N	\N	\N
a_example_trigger_target_dag_kc	t	f	f	2024-02-21 15:45:19.831334+01	\N	\N	\N	\N	/Users/kevin/Dropbox/applications/cp/dags/cdm_pure_growth_dag.py	airflow	\N	tree	null	\N	\N	\N	16	f	16	\N	\N	t	\N	\N	\N	\N	\N
update_downstream_table	t	f	f	2024-02-20 17:12:07.073068+01	\N	\N	\N	\N	/Users/kevin/Dropbox/applications/cp/dags/cdm_pure_growth_dag.py	airflow	A DAG to run an SQL insert statement on a downstream table	tree	null	\N	\N	\N	16	f	16	\N	\N	t	\N	\N	\N	\N	\N
\.


--
-- Data for Name: dag_code; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dag_code (fileloc_hash, fileloc, source_code, last_updated) FROM stdin;
\.


--
-- Data for Name: dag_owner_attributes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dag_owner_attributes (dag_id, owner, link) FROM stdin;
\.


--
-- Data for Name: dag_pickle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dag_pickle (id, pickle, created_dttm, pickle_hash) FROM stdin;
\.


--
-- Data for Name: dag_run; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dag_run (id, dag_id, execution_date, state, run_id, external_trigger, conf, end_date, start_date, run_type, last_scheduling_decision, dag_hash, creating_job_id, queued_at, data_interval_start, data_interval_end, log_template_id, updated_at, clear_number) FROM stdin;
5	cdm_pure_growth_dag	2024-02-21 16:49:24.30447+01	failed	manual__2024-02-21T15:49:24.304470+00:00	t	\\x80047d942e	2024-02-21 16:49:27.146607+01	2024-02-21 16:49:24.488315+01	manual	2024-02-21 16:49:27.139373+01	299889079eb3b792e96c3c32a72630ca	\N	2024-02-21 16:49:24.331175	2024-02-21 16:49:24.30447+01	2024-02-21 16:49:24.30447+01	\N	\N	0
7	cdm_pure_growth_dag	2024-02-21 16:53:39.397884+01	failed	manual__2024-02-21T15:53:39.397884+00:00	t	\\x80047d942e	2024-02-21 16:53:42.297282+01	2024-02-21 16:53:39.444843+01	manual	2024-02-21 16:53:42.292706+01	299889079eb3b792e96c3c32a72630ca	\N	2024-02-21 16:53:39.40655	2024-02-21 16:53:39.397884+01	2024-02-21 16:53:39.397884+01	\N	\N	0
8	cdm_pure_growth_dag	2024-02-21 17:15:39.469849+01	failed	manual__2024-02-21T16:15:39.469849+00:00	t	\\x80047d942e	2024-02-21 17:15:42.122191+01	2024-02-21 17:15:39.611351+01	manual	2024-02-21 17:15:42.116065+01	299889079eb3b792e96c3c32a72630ca	\N	2024-02-21 17:15:39.477449	2024-02-21 17:15:39.469849+01	2024-02-21 17:15:39.469849+01	\N	\N	0
10	cdm_pure_growth_dag	2024-02-21 17:32:46.097045+01	failed	manual__2024-02-21T16:32:46.097045+00:00	t	\\x80047d942e	2024-02-21 17:32:49.254532+01	2024-02-21 17:32:46.591167+01	manual	2024-02-21 17:32:49.248863+01	299889079eb3b792e96c3c32a72630ca	\N	2024-02-21 17:32:46.144252	2024-02-21 17:32:46.097045+01	2024-02-21 17:32:46.097045+01	\N	\N	0
6	cdm_pure_growth_dag	2024-02-21 16:52:59.198297+01	failed	manual__2024-02-21T15:52:59.198297+00:00	t	\\x80047d942e	2024-02-21 16:53:02.249019+01	2024-02-21 16:52:59.5459+01	manual	2024-02-21 16:53:02.243372+01	299889079eb3b792e96c3c32a72630ca	\N	2024-02-21 16:52:59.230603	2024-02-21 16:52:59.198297+01	2024-02-21 16:52:59.198297+01	\N	\N	0
9	cdm_pure_growth_dag	2024-02-21 17:27:13.498261+01	failed	manual__2024-02-21T16:27:13.498261+00:00	t	\\x80047d942e	2024-02-21 17:27:16.490528+01	2024-02-21 17:27:13.697062+01	manual	2024-02-21 17:27:16.484161+01	299889079eb3b792e96c3c32a72630ca	\N	2024-02-21 17:27:13.509517	2024-02-21 17:27:13.498261+01	2024-02-21 17:27:13.498261+01	\N	\N	0
2	cdm_pure_growth_dag	2024-02-21 16:12:22.25392+01	failed	manual__2024-02-21T15:12:22.253920+00:00	t	\\x80047d942e	2024-02-21 16:48:57.832618+01	2024-02-21 16:12:23.165523+01	manual	2024-02-21 16:48:57.826266+01	299889079eb3b792e96c3c32a72630ca	\N	2024-02-21 16:12:22.259085	2024-02-21 16:12:22.25392+01	2024-02-21 16:12:22.25392+01	\N	\N	0
1	cdm_pure_growth_dag	2024-02-21 15:56:17.593835+01	failed	manual__2024-02-21T14:56:17.593835+00:00	t	\\x80047d942e	2024-02-21 16:48:57.844073+01	2024-02-21 15:56:17.950759+01	manual	2024-02-21 16:48:57.838479+01	299889079eb3b792e96c3c32a72630ca	\N	2024-02-21 15:56:17.611503	2024-02-21 15:56:17.593835+01	2024-02-21 15:56:17.593835+01	\N	\N	0
4	cdm_pure_growth_dag	2024-02-21 16:47:37.34857+01	failed	manual__2024-02-21T15:47:37.348570+00:00	t	\\x80047d942e	2024-02-21 16:48:58.19343+01	2024-02-21 16:47:37.394555+01	manual	2024-02-21 16:48:58.185376+01	299889079eb3b792e96c3c32a72630ca	\N	2024-02-21 16:47:37.356805	2024-02-21 16:47:37.34857+01	2024-02-21 16:47:37.34857+01	\N	\N	0
3	cdm_pure_growth_dag	2024-02-21 16:35:44.539793+01	failed	manual__2024-02-21T15:35:44.539793+00:00	t	\\x80047d942e	2024-02-21 16:47:31.98859+01	2024-02-21 16:35:44.885223+01	manual	2024-02-21 16:47:31.590521+01	299889079eb3b792e96c3c32a72630ca	\N	2024-02-21 16:35:44.546281	2024-02-21 16:35:44.539793+01	2024-02-21 16:35:44.539793+01	\N	\N	0
\.


--
-- Data for Name: dag_run_note; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dag_run_note (user_id, dag_run_id, content, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: dag_schedule_dataset_reference; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dag_schedule_dataset_reference (dataset_id, dag_id, created_at, updated_at) FROM stdin;
6	dataset_consumes_1_never_scheduled	2024-02-19 16:51:05.185715+01	2024-02-19 16:51:05.185721+01
1	dataset_consumes_1_never_scheduled	2024-02-19 16:51:05.185725+01	2024-02-19 16:51:05.185728+01
2	dataset_consumes_1_and_2	2024-02-19 16:51:05.186415+01	2024-02-19 16:51:05.186421+01
1	dataset_consumes_1_and_2	2024-02-19 16:51:05.186424+01	2024-02-19 16:51:05.186427+01
1	dataset_consumes_1	2024-02-19 16:51:05.186987+01	2024-02-19 16:51:05.186994+01
7	dataset_consumes_unknown_never_scheduled	2024-02-19 16:51:05.187339+01	2024-02-19 16:51:05.187345+01
8	dataset_consumes_unknown_never_scheduled	2024-02-19 16:51:05.187349+01	2024-02-19 16:51:05.187351+01
\.


--
-- Data for Name: dag_warning; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dag_warning (dag_id, warning_type, message, "timestamp") FROM stdin;
\.


--
-- Data for Name: dagrun_dataset_event; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dagrun_dataset_event (dag_run_id, event_id) FROM stdin;
\.


--
-- Data for Name: dataset; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dataset (id, uri, extra, created_at, updated_at, is_orphaned) FROM stdin;
1	s3://dag1/output_1.txt	{"hi": "bye"}	2024-02-19 16:51:05.178389+01	2024-02-19 16:55:42.144682+01	f
2	s3://dag2/output_1.txt	{"hi": "bye"}	2024-02-19 16:51:05.178401+01	2024-02-19 16:55:42.145111+01	f
3	s3://consuming_2_task/dataset_other_unknown.txt	{}	2024-02-19 16:51:05.179242+01	2024-02-19 16:55:42.145473+01	f
4	s3://consuming_1_task/dataset_other.txt	{}	2024-02-19 16:51:05.179252+01	2024-02-19 16:55:42.145833+01	f
5	s3://unrelated_task/dataset_other_unknown.txt	{}	2024-02-19 16:51:05.179262+01	2024-02-19 16:55:42.146197+01	f
6	s3://this-dataset-doesnt-get-triggered	{}	2024-02-19 16:51:05.179267+01	2024-02-19 16:55:42.146552+01	f
7	s3://unrelated/dataset3.txt	{}	2024-02-19 16:51:05.179273+01	2024-02-19 16:55:42.146902+01	f
8	s3://unrelated/dataset_other_unknown.txt	{}	2024-02-19 16:51:05.179278+01	2024-02-19 16:55:42.147232+01	f
\.


--
-- Data for Name: dataset_dag_run_queue; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dataset_dag_run_queue (dataset_id, target_dag_id, created_at) FROM stdin;
\.


--
-- Data for Name: dataset_event; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dataset_event (id, dataset_id, extra, source_task_id, source_dag_id, source_run_id, source_map_index, "timestamp") FROM stdin;
\.


--
-- Data for Name: import_error; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.import_error (id, "timestamp", filename, stacktrace, processor_subdir) FROM stdin;
\.


--
-- Data for Name: job; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job (id, dag_id, state, job_type, start_date, end_date, latest_heartbeat, executor_class, hostname, unixname) FROM stdin;
1	\N	failed	SchedulerJob	2024-02-19 16:38:13.102188+01	\N	2024-02-22 13:40:33.763439+01	SequentialExecutor	kevins-mbp-2.home	kevin
37	\N	success	SchedulerJob	2025-01-02 21:33:24.594899+01	2025-01-02 21:33:55.916126+01	2025-01-02 21:33:24.550622+01	\N	kevins-mbp-2.home	kevin
31	cdm_pure_growth_dag	success	LocalTaskJob	2024-02-21 17:27:15.814279+01	2024-02-21 17:27:16.294602+01	2024-02-21 17:27:15.814292+01	SequentialExecutor	kevins-mbp-2.home	kevin
38	\N	success	SchedulerJob	2025-01-02 21:34:07.714609+01	2025-01-02 21:34:46.596032+01	2025-01-02 21:34:07.677678+01	\N	kevins-mbp-2.home	kevin
39	\N	running	SchedulerJob	2025-01-02 21:35:05.476665+01	\N	2025-01-02 21:35:05.440584+01	\N	kevins-mbp-2.home	kevin
14	\N	success	SchedulerJob	2024-02-20 14:51:19.932183+01	2024-02-20 15:05:43.999377+01	2024-02-20 15:05:38.452897+01	SequentialExecutor	kevins-mbp-2.home	kevin
34	\N	success	SchedulerJob	2024-02-21 17:53:24.149898+01	2024-02-21 19:22:24.581891+01	2024-02-21 19:22:21.197959+01	SequentialExecutor	kevins-mbp-2.home	kevin
22	cdm_pure_growth_dag	failed	LocalTaskJob	2024-02-21 16:12:24.829053+01	2024-02-21 16:12:25.243929+01	2024-02-21 16:12:24.829065+01	SequentialExecutor	kevins-mbp-2.home	kevin
8	\N	success	SchedulerJob	2024-02-20 13:58:29.390851+01	2024-02-20 14:13:48.650129+01	2024-02-20 14:13:43.117245+01	SequentialExecutor	kevins-mbp-2.home	kevin
13	\N	success	SchedulerJob	2024-02-20 14:43:17.892773+01	2024-02-20 14:50:56.826459+01	2024-02-20 14:50:52.402758+01	SequentialExecutor	kevins-mbp-2.home	kevin
30	cdm_pure_growth_dag	success	LocalTaskJob	2024-02-21 17:15:41.343658+01	2024-02-21 17:15:41.829036+01	2024-02-21 17:15:41.343672+01	SequentialExecutor	kevins-mbp-2.home	kevin
9	\N	success	SchedulerJob	2024-02-20 14:14:04.734801+01	2024-02-20 14:14:27.61215+01	2024-02-20 14:14:25.168924+01	SequentialExecutor	kevins-mbp-2.home	kevin
3	\N	success	SchedulerJob	2024-02-19 16:56:00.148556+01	2024-02-19 16:57:05.131617+01	2024-02-19 16:57:00.980169+01	SequentialExecutor	kevins-mbp-2.home	kevin
10	\N	success	SchedulerJob	2024-02-20 14:16:02.439246+01	2024-02-20 14:39:45.403504+01	2024-02-20 14:39:41.164511+01	SequentialExecutor	kevins-mbp-2.home	kevin
7	\N	success	SchedulerJob	2024-02-20 13:52:55.445126+01	2024-02-20 13:56:53.787625+01	2024-02-20 13:56:47.967806+01	SequentialExecutor	kevins-mbp-2.home	kevin
27	cdm_pure_growth_dag	success	LocalTaskJob	2024-02-21 16:49:26.588385+01	2024-02-21 16:49:26.990361+01	2024-02-21 16:49:26.588399+01	SequentialExecutor	kevins-mbp-2.home	kevin
18	\N	success	SchedulerJob	2024-02-20 15:47:37.365635+01	2024-02-20 17:34:53.816436+01	2024-02-20 17:34:48.305279+01	SequentialExecutor	kevins-mbp-2.home	kevin
12	\N	success	SchedulerJob	2024-02-20 14:41:02.889318+01	2024-02-20 14:42:53.306044+01	2024-02-20 14:42:49.136369+01	SequentialExecutor	kevins-mbp-2.home	kevin
4	\N	failed	SchedulerJob	2024-02-19 16:57:16.506559+01	\N	2024-02-19 16:57:21.800005+01	SequentialExecutor	kevins-mbp-2.home	kevin
33	\N	success	SchedulerJob	2024-02-21 17:52:13.14416+01	2024-02-21 17:52:58.844391+01	2024-02-21 17:52:53.821859+01	SequentialExecutor	kevins-mbp-2.home	kevin
19	\N	success	SchedulerJob	2024-02-20 17:35:08.130529+01	2024-02-20 17:35:24.743168+01	2024-02-20 17:35:18.48443+01	SequentialExecutor	kevins-mbp-2.home	kevin
17	\N	success	SchedulerJob	2024-02-20 15:30:54.849171+01	2024-02-20 15:47:19.984156+01	2024-02-20 15:47:14.398422+01	SequentialExecutor	kevins-mbp-2.home	kevin
11	\N	success	SchedulerJob	2024-02-20 14:39:49.706605+01	2024-02-20 14:40:37.794246+01	2024-02-20 14:40:35.57793+01	SequentialExecutor	kevins-mbp-2.home	kevin
5	\N	success	SchedulerJob	2024-02-19 17:00:39.218805+01	2024-02-19 17:02:36.823248+01	2024-02-19 17:02:35.587922+01	SequentialExecutor	kevins-mbp-2.home	kevin
23	cdm_pure_growth_dag	failed	LocalTaskJob	2024-02-21 16:34:56.71371+01	2024-02-21 16:34:57.165864+01	2024-02-21 16:34:56.713722+01	SequentialExecutor	kevins-mbp-2.home	kevin
24	cdm_pure_growth_dag	failed	LocalTaskJob	2024-02-21 16:34:59.040235+01	2024-02-21 16:34:59.489657+01	2024-02-21 16:34:59.040246+01	SequentialExecutor	kevins-mbp-2.home	kevin
2	\N	success	SchedulerJob	2024-02-19 16:51:45.078854+01	2024-02-19 16:55:26.031409+01	2024-02-19 16:55:22.406443+01	SequentialExecutor	kevins-mbp-2.home	kevin
28	cdm_pure_growth_dag	success	LocalTaskJob	2024-02-21 16:53:01.500384+01	2024-02-21 16:53:01.955824+01	2024-02-21 16:53:01.500396+01	SequentialExecutor	kevins-mbp-2.home	kevin
16	\N	success	SchedulerJob	2024-02-20 15:17:33.767181+01	2024-02-20 15:29:50.685094+01	2024-02-20 15:29:46.048269+01	SequentialExecutor	kevins-mbp-2.home	kevin
15	\N	success	SchedulerJob	2024-02-20 15:06:24.502652+01	2024-02-20 15:08:18.063243+01	2024-02-20 15:08:15.918958+01	SequentialExecutor	kevins-mbp-2.home	kevin
21	cdm_pure_growth_dag	failed	LocalTaskJob	2024-02-21 15:56:20.215549+01	2024-02-21 15:56:20.607168+01	2024-02-21 15:56:20.215561+01	SequentialExecutor	kevins-mbp-2.home	kevin
6	\N	success	SchedulerJob	2024-02-19 17:06:42.479231+01	2024-02-20 13:52:13.194546+01	2024-02-20 13:52:09.078621+01	SequentialExecutor	kevins-mbp-2.home	kevin
36	\N	success	SchedulerJob	2024-02-21 19:45:26.200232+01	2024-02-21 19:54:09.743107+01	2024-02-21 19:54:05.953703+01	\N	kevins-mbp-2.home	kevin
20	\N	success	SchedulerJob	2024-02-20 17:35:48.2991+01	2024-02-21 17:50:14.006725+01	2024-02-21 17:50:11.28252+01	SequentialExecutor	kevins-mbp-2.home	kevin
35	\N	success	SchedulerJob	2024-02-21 19:25:16.797501+01	2024-02-21 19:25:48.596563+01	2024-02-21 19:25:42.112541+01	SequentialExecutor	kevins-mbp-2.home	kevin
26	cdm_pure_growth_dag	failed	LocalTaskJob	2024-02-21 16:47:39.368716+01	2024-02-21 16:47:39.756363+01	2024-02-21 16:47:39.368726+01	SequentialExecutor	kevins-mbp-2.home	kevin
25	cdm_pure_growth_dag	failed	LocalTaskJob	2024-02-21 16:35:46.420868+01	2024-02-21 16:35:46.852903+01	2024-02-21 16:35:46.42088+01	SequentialExecutor	kevins-mbp-2.home	kevin
29	cdm_pure_growth_dag	success	LocalTaskJob	2024-02-21 16:53:41.548224+01	2024-02-21 16:53:42.005632+01	2024-02-21 16:53:41.548236+01	SequentialExecutor	kevins-mbp-2.home	kevin
32	cdm_pure_growth_dag	success	LocalTaskJob	2024-02-21 17:32:48.521486+01	2024-02-21 17:32:48.995185+01	2024-02-21 17:32:48.521499+01	SequentialExecutor	kevins-mbp-2.home	kevin
\.


--
-- Data for Name: log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.log (id, dttm, dag_id, task_id, event, execution_date, owner, extra, map_index, owner_display_name, run_id) FROM stdin;
1	2024-02-19 13:01:19.75945+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Users/kevin/airflow_venv/bin/airflow', 'webserver', '--port', '8080']"}	\N	\N	\N
2	2024-02-19 13:03:40.128589+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'webserver', '--port', '8080']"}	\N	\N	\N
3	2024-02-19 13:26:21.501094+01	\N	\N	cli_users_create	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Users/kevin/airflow_venv/bin/airflow', 'users', 'create', '--username', 'admin', '--firstname', 'Kevin', '--lastname', 'corcoran', '--role', 'Admin', '--email', 'Kevin.corcoran@hotmail.com', '--password', '********']"}	\N	\N	\N
4	2024-02-19 13:42:57.838422+01	example_branch_datetime_operator_2	\N	tree	\N	admin	[('dag_id', 'example_branch_datetime_operator_2')]	\N	\N	\N
5	2024-02-19 13:43:15.32001+01	tutorial	\N	tree	\N	admin	[('dag_id', 'tutorial')]	\N	\N	\N
6	2024-02-19 15:46:54.488702+01	tutorial_etl_dag	\N	tree	\N	admin	[('dag_id', 'tutorial_etl_dag')]	\N	\N	\N
7	2024-02-19 15:47:07.555489+01	tutorial_taskflow_api_etl	\N	tree	\N	admin	[('dag_id', 'tutorial_taskflow_api_etl')]	\N	\N	\N
8	2024-02-19 16:37:36.787569+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'webserver', '-p', '8080', '-D']"}	\N	\N	\N
9	2024-02-19 16:38:13.07226+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'scheduler', '-D']"}	\N	\N	\N
10	2024-02-19 16:40:21.66734+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Users/kevin/airflow_venv/bin/airflow', 'webserver', '--port', '8080']"}	\N	\N	\N
11	2024-02-19 16:46:46.067441+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Users/kevin/airflow_venv/bin/airflow', 'webserver', '--port', '8080']"}	\N	\N	\N
12	2024-02-19 16:48:36.36793+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Users/kevin/airflow_venv/bin/airflow', 'webserver', '--port', '8080']"}	\N	\N	\N
13	2024-02-19 16:51:16.218195+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Users/kevin/airflow_venv/bin/airflow', 'webserver', '--port', '8080']"}	\N	\N	\N
14	2024-02-19 16:51:45.03835+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'scheduler']"}	\N	\N	\N
15	2024-02-19 16:55:51.30636+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Users/kevin/airflow_venv/bin/airflow', 'webserver', '--port', '8080']"}	\N	\N	\N
16	2024-02-19 16:56:00.126221+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'scheduler']"}	\N	\N	\N
17	2024-02-19 16:57:16.482483+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'scheduler']"}	\N	\N	\N
18	2024-02-19 17:00:23.21132+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'webserver', '--port', '8080']"}	\N	\N	\N
19	2024-02-19 17:00:39.200745+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'scheduler']"}	\N	\N	\N
20	2024-02-19 17:06:34.575299+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'webserver', '--port', '8080']"}	\N	\N	\N
21	2024-02-19 17:06:42.460565+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'scheduler']"}	\N	\N	\N
22	2024-02-20 13:52:49.335016+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'webserver']"}	\N	\N	\N
23	2024-02-20 13:52:55.417123+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'scheduler']"}	\N	\N	\N
24	2024-02-20 13:58:23.701743+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'webserver']"}	\N	\N	\N
25	2024-02-20 13:58:29.365279+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'scheduler']"}	\N	\N	\N
26	2024-02-20 14:14:02.56658+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'webserver']"}	\N	\N	\N
27	2024-02-20 14:14:04.708067+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'scheduler']"}	\N	\N	\N
28	2024-02-20 14:15:58.456496+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'webserver', '--port', '8080']"}	\N	\N	\N
29	2024-02-20 14:16:02.408868+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'scheduler']"}	\N	\N	\N
30	2024-02-20 14:39:49.681612+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'scheduler']"}	\N	\N	\N
31	2024-02-20 14:39:56.364656+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'webserver', '--port', '8080']"}	\N	\N	\N
32	2024-02-20 14:41:02.856556+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'scheduler']"}	\N	\N	\N
33	2024-02-20 14:41:08.845142+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'webserver', '--port', '8080']"}	\N	\N	\N
34	2024-02-20 14:42:58.532348+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'webserver', '--port', '8080']"}	\N	\N	\N
35	2024-02-20 14:43:17.870582+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'scheduler']"}	\N	\N	\N
36	2024-02-20 14:51:19.908132+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'scheduler']"}	\N	\N	\N
37	2024-02-20 14:51:25.884445+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'webserver', '--port', '8080']"}	\N	\N	\N
38	2024-02-20 15:06:24.480032+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'scheduler']"}	\N	\N	\N
39	2024-02-20 15:06:28.628359+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'webserver', '--port', '8080']"}	\N	\N	\N
40	2024-02-20 15:17:33.743966+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'scheduler']"}	\N	\N	\N
41	2024-02-20 15:17:53.074387+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'webserver', '--port', '8080']"}	\N	\N	\N
42	2024-02-20 15:30:52.086437+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'webserver', '--port', '8080']"}	\N	\N	\N
43	2024-02-20 15:30:54.827688+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'scheduler']"}	\N	\N	\N
44	2024-02-20 15:35:19.964274+01	tutorial_etl_dag	\N	tree	\N	admin	[('dag_id', 'tutorial_etl_dag')]	\N	\N	\N
45	2024-02-20 15:47:37.318153+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'scheduler']"}	\N	\N	\N
46	2024-02-20 15:47:42.084587+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'webserver', '--port', '8080']"}	\N	\N	\N
47	2024-02-20 15:50:24.664472+01	example_bash_operator	\N	tree	\N	admin	[('dag_id', 'example_bash_operator')]	\N	\N	\N
48	2024-02-20 15:50:33.874571+01	example_bash_operator	\N	tree	\N	admin	[('dag_id', 'example_bash_operator')]	\N	\N	\N
49	2024-02-20 15:56:13.376661+01	example_trigger_target_dag	\N	tree	\N	admin	[('dag_id', 'example_trigger_target_dag')]	\N	\N	\N
50	2024-02-20 17:35:06.020111+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'webserver', '--port', '8080']"}	\N	\N	\N
51	2024-02-20 17:35:08.111874+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'scheduler']"}	\N	\N	\N
52	2024-02-20 17:35:48.268309+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'scheduler']"}	\N	\N	\N
53	2024-02-20 17:35:53.614459+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'webserver', '--port', '8080']"}	\N	\N	\N
54	2024-02-21 14:03:20.96236+01	a_example_trigger_target_dag_kc	\N	tree	\N	admin	[('dag_id', 'a_example_trigger_target_dag_kc')]	\N	\N	\N
55	2024-02-21 15:55:09.748171+01	a_example_trigger_target_dag_kc	\N	graph	\N	admin	[('dag_id', 'a_example_trigger_target_dag_kc')]	\N	\N	\N
56	2024-02-21 15:56:01.76801+01	cdm_pure_growth_dag	\N	paused	\N	admin	[('is_paused', 'true'), ('dag_id', 'cdm_pure_growth_dag')]	\N	\N	\N
57	2024-02-21 15:56:06.267171+01	cdm_pure_growth_dag	\N	tree	\N	admin	[('dag_id', 'cdm_pure_growth_dag')]	\N	\N	\N
58	2024-02-21 15:56:17.590803+01	cdm_pure_growth_dag	\N	trigger	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('unpause', 'True'), ('origin', '/tree?dag_id=cdm_pure_growth_dag')]	\N	\N	\N
59	2024-02-21 15:56:17.670294+01	cdm_pure_growth_dag	\N	tree	\N	admin	[('dag_id', 'cdm_pure_growth_dag')]	\N	\N	\N
60	2024-02-21 15:56:19.668919+01	cdm_pure_growth_dag	insert_into_pure_growth	cli_task_run	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'tasks', 'run', 'cdm_pure_growth_dag', 'insert_into_pure_growth', 'manual__2024-02-21T14:56:17.593835+00:00', '--local', '--subdir', 'DAGS_FOLDER/cdm_pure_growth_dag.py']"}	\N	\N	\N
61	2024-02-21 15:56:20.309833+01	cdm_pure_growth_dag	insert_into_pure_growth	running	2024-02-21 15:56:17.593835+01	airflow	\N	\N	\N	\N
62	2024-02-21 15:56:20.33051+01	cdm_pure_growth_dag	insert_into_pure_growth	cli_task_run	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'tasks', 'run', 'cdm_pure_growth_dag', 'insert_into_pure_growth', 'manual__2024-02-21T14:56:17.593835+00:00', '--local', '--subdir', 'DAGS_FOLDER/cdm_pure_growth_dag.py']"}	\N	\N	\N
64	2024-02-21 15:56:21.297138+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
65	2024-02-21 15:56:24.294594+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
67	2024-02-21 15:56:27.29494+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
68	2024-02-21 15:56:30.294154+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
69	2024-02-21 15:56:33.292773+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
70	2024-02-21 15:56:36.292995+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
71	2024-02-21 15:56:39.294275+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
72	2024-02-21 15:56:42.294714+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
73	2024-02-21 15:56:45.300716+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
74	2024-02-21 15:56:48.300208+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
75	2024-02-21 15:56:51.295896+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
76	2024-02-21 15:56:54.294249+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
77	2024-02-21 15:56:57.293929+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
78	2024-02-21 15:57:00.295155+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
79	2024-02-21 15:57:03.295503+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
80	2024-02-21 15:57:06.298182+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
82	2024-02-21 15:57:09.303962+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
83	2024-02-21 15:57:12.302512+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
84	2024-02-21 15:57:15.299157+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
231	2024-02-21 16:12:15.702777+01	cdm_pure_growth_dag	\N	paused	\N	admin	[('is_paused', 'true'), ('dag_id', 'cdm_pure_growth_dag')]	\N	\N	\N
86	2024-02-21 15:57:18.293995+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
87	2024-02-21 15:57:21.298549+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
92	2024-02-21 15:57:33.293924+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
94	2024-02-21 15:57:39.299073+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
96	2024-02-21 15:57:45.296163+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
102	2024-02-21 15:57:57.295045+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
110	2024-02-21 15:58:12.294751+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
111	2024-02-21 15:58:15.29528+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
118	2024-02-21 15:58:33.295407+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
119	2024-02-21 15:58:36.301174+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
121	2024-02-21 15:58:39.30214+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
124	2024-02-21 15:58:48.296043+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
232	2024-02-21 16:12:16.722628+01	cdm_pure_growth_dag	\N	tree	\N	admin	[('dag_id', 'cdm_pure_growth_dag')]	\N	\N	\N
234	2024-02-21 16:12:22.252424+01	cdm_pure_growth_dag	\N	trigger	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('unpause', 'True'), ('origin', '/tree?dag_id=cdm_pure_growth_dag')]	\N	\N	\N
237	2024-02-21 16:12:24.918457+01	cdm_pure_growth_dag	insert_into_pure_growth	running	2024-02-21 16:12:22.25392+01	airflow	\N	\N	\N	\N
242	2024-02-21 16:12:28.652932+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
243	2024-02-21 16:12:31.65518+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
244	2024-02-21 16:12:34.653026+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
251	2024-02-21 16:12:48.398999+01	cdm_pure_growth_dag	insert_into_pure_growth	log	2024-02-21 16:12:22.25392+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('task_id', 'insert_into_pure_growth'), ('execution_date', '2024-02-21T15:12:22.253920+00:00')]	\N	\N	\N
517	2024-02-21 16:34:56.811319+01	cdm_pure_growth_dag	test_connection	running	2024-02-21 15:56:17.593835+01	airflow	\N	\N	\N	\N
882	2024-02-21 16:47:05.940903+01	cdm_pure_growth_dag	\N	tree	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('root', '')]	\N	\N	\N
540	2024-02-21 16:35:39.539464+01	cdm_pure_growth_dag	\N	tree	\N	admin	[('dag_id', 'cdm_pure_growth_dag')]	\N	\N	\N
545	2024-02-21 16:35:46.509741+01	cdm_pure_growth_dag	test_connection	running	2024-02-21 16:35:44.539793+01	airflow	\N	\N	\N	\N
910	2024-02-21 16:47:38.882326+01	cdm_pure_growth_dag	test_connection	cli_task_run	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'tasks', 'run', 'cdm_pure_growth_dag', 'test_connection', 'manual__2024-02-21T15:47:37.348570+00:00', '--local', '--subdir', '/Users/kevin/Dropbox/applications/cp/dags/cdm_pure_growth_dag.py']"}	\N	\N	\N
384	2024-02-21 16:23:42.952333+01	cdm_pure_growth_dag	insert_into_pure_growth	get_logs_with_metadata	2024-02-21 16:12:22.25392+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('task_id', 'insert_into_pure_growth'), ('execution_date', '2024-02-21T15:12:22.253920+00:00'), ('try_number', '1'), ('metadata', 'null')]	\N	\N	\N
922	2024-02-21 16:47:49.744109+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
923	2024-02-21 16:47:52.739915+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
925	2024-02-21 16:47:54.948373+01	cdm_pure_growth_dag	test_connection	get_logs_with_metadata	2024-02-21 16:47:37.34857+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('task_id', 'test_connection'), ('execution_date', '2024-02-21T15:47:37.348570+00:00'), ('try_number', '1'), ('metadata', 'null')]	\N	\N	\N
88	2024-02-21 15:57:24.294459+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
89	2024-02-21 15:57:27.294451+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
95	2024-02-21 15:57:42.295274+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
98	2024-02-21 15:57:48.297031+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
101	2024-02-21 15:57:54.295002+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
105	2024-02-21 15:58:03.298374+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
106	2024-02-21 15:58:06.295263+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
109	2024-02-21 15:58:09.29522+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
113	2024-02-21 15:58:21.300844+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
115	2024-02-21 15:58:27.295266+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
123	2024-02-21 15:58:45.295419+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
127	2024-02-21 15:58:54.297067+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
233	2024-02-21 16:12:20.053487+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
238	2024-02-21 16:12:24.953558+01	cdm_pure_growth_dag	insert_into_pure_growth	cli_task_run	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'tasks', 'run', 'cdm_pure_growth_dag', 'insert_into_pure_growth', 'manual__2024-02-21T15:12:22.253920+00:00', '--local', '--subdir', '/Users/kevin/Dropbox/applications/cp/dags/cdm_pure_growth_dag.py']"}	\N	\N	\N
518	2024-02-21 16:34:56.849246+01	cdm_pure_growth_dag	test_connection	cli_task_run	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'tasks', 'run', 'cdm_pure_growth_dag', 'test_connection', 'manual__2024-02-21T14:56:17.593835+00:00', '--local', '--subdir', '/Users/kevin/Dropbox/applications/cp/dags/cdm_pure_growth_dag.py']"}	\N	\N	\N
522	2024-02-21 16:34:58.468676+01	cdm_pure_growth_dag	test_connection	cli_task_run	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'tasks', 'run', 'cdm_pure_growth_dag', 'test_connection', 'manual__2024-02-21T15:12:22.253920+00:00', '--local', '--subdir', '/Users/kevin/Dropbox/applications/cp/dags/cdm_pure_growth_dag.py']"}	\N	\N	\N
541	2024-02-21 16:35:43.199201+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
542	2024-02-21 16:35:44.538465+01	cdm_pure_growth_dag	\N	trigger	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('unpause', 'True'), ('origin', '/tree?dag_id=cdm_pure_growth_dag')]	\N	\N	\N
546	2024-02-21 16:35:46.528424+01	cdm_pure_growth_dag	test_connection	cli_task_run	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'tasks', 'run', 'cdm_pure_growth_dag', 'test_connection', 'manual__2024-02-21T15:35:44.539793+00:00', '--local', '--subdir', '/Users/kevin/Dropbox/applications/cp/dags/cdm_pure_growth_dag.py']"}	\N	\N	\N
380	2024-02-21 16:23:36.42748+01	cdm_pure_growth_dag	\N	graph	2024-02-21 16:12:22.25392+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('root', ''), ('execution_date', '2024-02-21T15:12:22.253920+00:00')]	\N	\N	\N
555	2024-02-21 16:35:50.888805+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
559	2024-02-21 16:35:58.655788+01	cdm_pure_growth_dag	test_connection	get_logs_with_metadata	2024-02-21 16:35:44.539793+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('task_id', 'test_connection'), ('execution_date', '2024-02-21T15:35:44.539793+00:00'), ('try_number', '1'), ('metadata', 'null')]	\N	\N	\N
887	2024-02-21 16:47:15.291452+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
891	2024-02-21 16:47:18.29071+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
892	2024-02-21 16:47:21.288963+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
900	2024-02-21 16:47:31.982428+01	cdm_pure_growth_dag	\N	dagrun_failed	2024-02-21 16:35:44.539793+01	admin	[('confirmed', 'true'), ('dag_id', 'cdm_pure_growth_dag'), ('execution_date', '2024-02-21T15:35:44.539793+00:00'), ('origin', 'http://localhost:8080/tree?dag_id=cdm_pure_growth_dag&root=')]	\N	\N	\N
794	2024-02-21 16:44:19.378843+01	\N	\N	cli_upgradedb	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'db', 'upgrade']"}	\N	\N	\N
905	2024-02-21 16:47:35.389648+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
907	2024-02-21 16:47:37.40725+01	cdm_pure_growth_dag	\N	tree	\N	admin	[('dag_id', 'cdm_pure_growth_dag')]	\N	\N	\N
911	2024-02-21 16:47:39.446776+01	cdm_pure_growth_dag	test_connection	running	2024-02-21 16:47:37.34857+01	airflow	\N	\N	\N	\N
915	2024-02-21 16:47:43.743754+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
918	2024-02-21 16:47:46.742566+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
91	2024-02-21 15:57:30.294881+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
114	2024-02-21 15:58:24.294809+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
117	2024-02-21 15:58:30.295052+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
122	2024-02-21 15:58:42.296311+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
128	2024-02-21 15:58:57.299338+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
514	2024-02-21 16:34:56.191917+01	cdm_pure_growth_dag	test_connection	cli_task_run	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'tasks', 'run', 'cdm_pure_growth_dag', 'test_connection', 'manual__2024-02-21T14:56:17.593835+00:00', '--local', '--subdir', '/Users/kevin/Dropbox/applications/cp/dags/cdm_pure_growth_dag.py']"}	\N	\N	\N
229	2024-02-21 16:12:14.401437+01	cdm_pure_growth_dag	\N	paused	\N	admin	[('is_paused', 'false'), ('dag_id', 'cdm_pure_growth_dag')]	\N	\N	\N
235	2024-02-21 16:12:22.303995+01	cdm_pure_growth_dag	\N	tree	\N	admin	[('dag_id', 'cdm_pure_growth_dag')]	\N	\N	\N
239	2024-02-21 16:12:25.655819+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
523	2024-02-21 16:34:59.137037+01	cdm_pure_growth_dag	test_connection	running	2024-02-21 16:12:22.25392+01	airflow	\N	\N	\N	\N
245	2024-02-21 16:12:37.654348+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
248	2024-02-21 16:12:40.655224+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
249	2024-02-21 16:12:43.65332+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
250	2024-02-21 16:12:46.655463+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
254	2024-02-21 16:12:48.707111+01	cdm_pure_growth_dag	insert_into_pure_growth	get_logs_with_metadata	2024-02-21 16:12:22.25392+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('task_id', 'insert_into_pure_growth'), ('execution_date', '2024-02-21T15:12:22.253920+00:00'), ('try_number', '1'), ('metadata', 'null')]	\N	\N	\N
543	2024-02-21 16:35:44.594576+01	cdm_pure_growth_dag	\N	tree	\N	admin	[('dag_id', 'cdm_pure_growth_dag')]	\N	\N	\N
549	2024-02-21 16:35:47.860673+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
556	2024-02-21 16:35:53.864291+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
557	2024-02-21 16:35:56.857965+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
558	2024-02-21 16:35:58.304365+01	cdm_pure_growth_dag	test_connection	log	2024-02-21 16:35:44.539793+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('task_id', 'test_connection'), ('execution_date', '2024-02-21T15:35:44.539793+00:00')]	\N	\N	\N
381	2024-02-21 16:23:39.212894+01	cdm_pure_growth_dag	\N	tree	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('root', '')]	\N	\N	\N
383	2024-02-21 16:23:42.619403+01	cdm_pure_growth_dag	insert_into_pure_growth	log	2024-02-21 16:12:22.25392+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('task_id', 'insert_into_pure_growth'), ('execution_date', '2024-02-21T15:12:22.253920+00:00')]	\N	\N	\N
884	2024-02-21 16:47:09.289641+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
899	2024-02-21 16:47:29.487548+01	cdm_pure_growth_dag	\N	dagrun_failed	2024-02-21 16:35:44.539793+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('execution_date', '2024-02-21T15:35:44.539793+00:00'), ('origin', 'http://localhost:8080/tree?dag_id=cdm_pure_growth_dag&root=')]	\N	\N	\N
901	2024-02-21 16:47:32.054605+01	cdm_pure_growth_dag	\N	tree	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('root', '')]	\N	\N	\N
906	2024-02-21 16:47:37.347062+01	cdm_pure_growth_dag	\N	trigger	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('unpause', 'True'), ('origin', '/tree?dag_id=cdm_pure_growth_dag')]	\N	\N	\N
912	2024-02-21 16:47:39.463821+01	cdm_pure_growth_dag	test_connection	cli_task_run	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'tasks', 'run', 'cdm_pure_growth_dag', 'test_connection', 'manual__2024-02-21T15:47:37.348570+00:00', '--local', '--subdir', '/Users/kevin/Dropbox/applications/cp/dags/cdm_pure_growth_dag.py']"}	\N	\N	\N
914	2024-02-21 16:47:40.740009+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
924	2024-02-21 16:47:54.656307+01	cdm_pure_growth_dag	test_connection	log	2024-02-21 16:47:37.34857+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('task_id', 'test_connection'), ('execution_date', '2024-02-21T15:47:37.348570+00:00')]	\N	\N	\N
93	2024-02-21 15:57:36.294662+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
100	2024-02-21 15:57:51.295048+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
104	2024-02-21 15:58:00.300142+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
236	2024-02-21 16:12:24.329327+01	cdm_pure_growth_dag	insert_into_pure_growth	cli_task_run	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'tasks', 'run', 'cdm_pure_growth_dag', 'insert_into_pure_growth', 'manual__2024-02-21T15:12:22.253920+00:00', '--local', '--subdir', '/Users/kevin/Dropbox/applications/cp/dags/cdm_pure_growth_dag.py']"}	\N	\N	\N
112	2024-02-21 15:58:18.295864+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
524	2024-02-21 16:34:59.161209+01	cdm_pure_growth_dag	test_connection	cli_task_run	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'tasks', 'run', 'cdm_pure_growth_dag', 'test_connection', 'manual__2024-02-21T15:12:22.253920+00:00', '--local', '--subdir', '/Users/kevin/Dropbox/applications/cp/dags/cdm_pure_growth_dag.py']"}	\N	\N	\N
126	2024-02-21 15:58:51.293296+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
544	2024-02-21 16:35:45.92821+01	cdm_pure_growth_dag	test_connection	cli_task_run	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'tasks', 'run', 'cdm_pure_growth_dag', 'test_connection', 'manual__2024-02-21T15:35:44.539793+00:00', '--local', '--subdir', '/Users/kevin/Dropbox/applications/cp/dags/cdm_pure_growth_dag.py']"}	\N	\N	\N
131	2024-02-21 15:59:00.295935+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
132	2024-02-21 15:59:03.296463+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
133	2024-02-21 15:59:06.296751+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
134	2024-02-21 15:59:09.295943+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
885	2024-02-21 16:47:12.289131+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
136	2024-02-21 15:59:12.293593+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
137	2024-02-21 15:59:15.297529+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
138	2024-02-21 15:59:18.296813+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
893	2024-02-21 16:47:24.28781+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
140	2024-02-21 15:59:21.296534+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
141	2024-02-21 15:59:24.300544+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
142	2024-02-21 15:59:27.296641+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
144	2024-02-21 15:59:30.30358+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
145	2024-02-21 15:59:33.29602+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
146	2024-02-21 15:59:36.298226+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
147	2024-02-21 15:59:39.298157+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
149	2024-02-21 15:59:42.297405+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
150	2024-02-21 15:59:45.300734+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
151	2024-02-21 15:59:48.297132+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
896	2024-02-21 16:47:27.290364+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
154	2024-02-21 15:59:51.298428+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
155	2024-02-21 15:59:54.298013+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
156	2024-02-21 15:59:57.298247+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
157	2024-02-21 15:59:57.519373+01	cdm_pure_growth_dag	insert_into_pure_growth	log	2024-02-21 15:56:17.593835+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('task_id', 'insert_into_pure_growth'), ('execution_date', '2024-02-21T14:56:17.593835+00:00')]	\N	\N	\N
158	2024-02-21 15:59:58.054852+01	cdm_pure_growth_dag	insert_into_pure_growth	get_logs_with_metadata	2024-02-21 15:56:17.593835+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('task_id', 'insert_into_pure_growth'), ('execution_date', '2024-02-21T14:56:17.593835+00:00'), ('try_number', '1'), ('metadata', 'null')]	\N	\N	\N
382	2024-02-21 16:23:42.504996+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
168	2024-02-21 16:01:12.243331+01	\N	\N	cli_upgradedb	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'db', 'upgrade']"}	\N	\N	\N
954	2024-02-21 16:48:56.999222+01	cdm_pure_growth_dag	insert_into_pure_growth	failed	\N	airflow	\N	\N	\N	\N
955	2024-02-21 16:48:57.038687+01	cdm_pure_growth_dag	test_connection	failed	\N	airflow	\N	\N	\N	\N
956	2024-02-21 16:48:57.055051+01	cdm_pure_growth_dag	insert_into_pure_growth	failed	\N	airflow	\N	\N	\N	\N
957	2024-02-21 16:48:57.087171+01	cdm_pure_growth_dag	test_connection	failed	\N	airflow	\N	\N	\N	\N
958	2024-02-21 16:48:57.104865+01	cdm_pure_growth_dag	test_connection	failed	\N	airflow	\N	\N	\N	\N
959	2024-02-21 16:49:24.302349+01	cdm_pure_growth_dag	\N	trigger	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('unpause', 'True'), ('origin', '/tree?dag_id=cdm_pure_growth_dag')]	\N	\N	\N
960	2024-02-21 16:49:24.380119+01	cdm_pure_growth_dag	\N	tree	\N	admin	[('dag_id', 'cdm_pure_growth_dag')]	\N	\N	\N
961	2024-02-21 16:49:26.067339+01	cdm_pure_growth_dag	test_connection	cli_task_run	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'tasks', 'run', 'cdm_pure_growth_dag', 'test_connection', 'manual__2024-02-21T15:49:24.304470+00:00', '--local', '--subdir', 'DAGS_FOLDER/cdm_pure_growth_dag.py']"}	\N	\N	\N
962	2024-02-21 16:49:26.677703+01	cdm_pure_growth_dag	test_connection	running	2024-02-21 16:49:24.30447+01	airflow	\N	\N	\N	\N
963	2024-02-21 16:49:26.695617+01	cdm_pure_growth_dag	test_connection	cli_task_run	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'tasks', 'run', 'cdm_pure_growth_dag', 'test_connection', 'manual__2024-02-21T15:49:24.304470+00:00', '--local', '--subdir', 'DAGS_FOLDER/cdm_pure_growth_dag.py']"}	\N	\N	\N
964	2024-02-21 16:49:26.88951+01	cdm_pure_growth_dag	test_connection	failed	2024-02-21 16:49:24.30447+01	airflow	\N	\N	\N	\N
965	2024-02-21 16:49:27.696631+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
966	2024-02-21 16:49:33.254922+01	cdm_pure_growth_dag	test_connection	log	2024-02-21 16:49:24.30447+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('task_id', 'test_connection'), ('execution_date', '2024-02-21T15:49:24.304470+00:00')]	\N	\N	\N
967	2024-02-21 16:49:33.582764+01	cdm_pure_growth_dag	test_connection	get_logs_with_metadata	2024-02-21 16:49:24.30447+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('task_id', 'test_connection'), ('execution_date', '2024-02-21T15:49:24.304470+00:00'), ('try_number', '1'), ('metadata', 'null')]	\N	\N	\N
968	2024-02-21 16:52:59.196272+01	cdm_pure_growth_dag	\N	trigger	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('unpause', 'True'), ('origin', '/tree?dag_id=cdm_pure_growth_dag')]	\N	\N	\N
969	2024-02-21 16:52:59.2805+01	cdm_pure_growth_dag	\N	tree	\N	admin	[('dag_id', 'cdm_pure_growth_dag')]	\N	\N	\N
970	2024-02-21 16:53:00.984723+01	cdm_pure_growth_dag	test_connection	cli_task_run	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'tasks', 'run', 'cdm_pure_growth_dag', 'test_connection', 'manual__2024-02-21T15:52:59.198297+00:00', '--local', '--subdir', '/Users/kevin/Dropbox/applications/cp/dags/cdm_pure_growth_dag.py']"}	\N	\N	\N
971	2024-02-21 16:53:01.593188+01	cdm_pure_growth_dag	test_connection	running	2024-02-21 16:52:59.198297+01	airflow	\N	\N	\N	\N
972	2024-02-21 16:53:01.612116+01	cdm_pure_growth_dag	test_connection	cli_task_run	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'tasks', 'run', 'cdm_pure_growth_dag', 'test_connection', 'manual__2024-02-21T15:52:59.198297+00:00', '--local', '--subdir', '/Users/kevin/Dropbox/applications/cp/dags/cdm_pure_growth_dag.py']"}	\N	\N	\N
973	2024-02-21 16:53:01.834047+01	cdm_pure_growth_dag	test_connection	failed	2024-02-21 16:52:59.198297+01	airflow	\N	\N	\N	\N
974	2024-02-21 16:53:02.55615+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
975	2024-02-21 16:53:06.630337+01	cdm_pure_growth_dag	test_connection	log	2024-02-21 16:52:59.198297+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('task_id', 'test_connection'), ('execution_date', '2024-02-21T15:52:59.198297+00:00')]	\N	\N	\N
976	2024-02-21 16:53:06.955174+01	cdm_pure_growth_dag	test_connection	get_logs_with_metadata	2024-02-21 16:52:59.198297+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('task_id', 'test_connection'), ('execution_date', '2024-02-21T15:52:59.198297+00:00'), ('try_number', '1'), ('metadata', 'null')]	\N	\N	\N
977	2024-02-21 16:53:39.396051+01	cdm_pure_growth_dag	\N	trigger	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('unpause', 'True'), ('origin', '/tree?dag_id=cdm_pure_growth_dag')]	\N	\N	\N
978	2024-02-21 16:53:39.459758+01	cdm_pure_growth_dag	\N	tree	\N	admin	[('dag_id', 'cdm_pure_growth_dag')]	\N	\N	\N
979	2024-02-21 16:53:40.962076+01	cdm_pure_growth_dag	test_connection	cli_task_run	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'tasks', 'run', 'cdm_pure_growth_dag', 'test_connection', 'manual__2024-02-21T15:53:39.397884+00:00', '--local', '--subdir', 'DAGS_FOLDER/cdm_pure_growth_dag.py']"}	\N	\N	\N
980	2024-02-21 16:53:41.63536+01	cdm_pure_growth_dag	test_connection	running	2024-02-21 16:53:39.397884+01	airflow	\N	\N	\N	\N
981	2024-02-21 16:53:41.65797+01	cdm_pure_growth_dag	test_connection	cli_task_run	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'tasks', 'run', 'cdm_pure_growth_dag', 'test_connection', 'manual__2024-02-21T15:53:39.397884+00:00', '--local', '--subdir', 'DAGS_FOLDER/cdm_pure_growth_dag.py']"}	\N	\N	\N
982	2024-02-21 16:53:41.893719+01	cdm_pure_growth_dag	test_connection	failed	2024-02-21 16:53:39.397884+01	airflow	\N	\N	\N	\N
983	2024-02-21 16:53:42.781055+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
984	2024-02-21 16:53:45.880744+01	cdm_pure_growth_dag	test_connection	log	2024-02-21 16:53:39.397884+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('task_id', 'test_connection'), ('execution_date', '2024-02-21T15:53:39.397884+00:00')]	\N	\N	\N
985	2024-02-21 16:53:46.259443+01	cdm_pure_growth_dag	test_connection	get_logs_with_metadata	2024-02-21 16:53:39.397884+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('task_id', 'test_connection'), ('execution_date', '2024-02-21T15:53:39.397884+00:00'), ('try_number', '1'), ('metadata', 'null')]	\N	\N	\N
986	2024-02-21 17:15:36.06098+01	cdm_pure_growth_dag	test_connection	log	2024-02-21 16:53:39.397884+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('task_id', 'test_connection'), ('execution_date', '2024-02-21T15:53:39.397884+00:00')]	\N	\N	\N
987	2024-02-21 17:15:36.428567+01	cdm_pure_growth_dag	test_connection	get_logs_with_metadata	2024-02-21 16:53:39.397884+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('task_id', 'test_connection'), ('execution_date', '2024-02-21T15:53:39.397884+00:00'), ('try_number', '1'), ('metadata', 'null')]	\N	\N	\N
989	2024-02-21 17:15:39.523256+01	cdm_pure_growth_dag	\N	tree	\N	admin	[('dag_id', 'cdm_pure_growth_dag')]	\N	\N	\N
994	2024-02-21 17:15:42.837157+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
995	2024-02-21 17:15:47.324624+01	cdm_pure_growth_dag	test_connection	log	2024-02-21 17:15:39.469849+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('task_id', 'test_connection'), ('execution_date', '2024-02-21T16:15:39.469849+00:00')]	\N	\N	\N
997	2024-02-21 17:27:13.496221+01	cdm_pure_growth_dag	\N	trigger	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('unpause', 'True'), ('origin', '/tree?dag_id=cdm_pure_growth_dag')]	\N	\N	\N
1008	2024-02-21 17:28:41.045916+01	cdm_pure_growth_dag	\N	paused	\N	admin	[('is_paused', 'false'), ('dag_id', 'cdm_pure_growth_dag')]	\N	\N	\N
1009	2024-02-21 17:28:50.933681+01	example_task_group	\N	tree	\N	admin	[('dag_id', 'example_task_group')]	\N	\N	\N
988	2024-02-21 17:15:39.468436+01	cdm_pure_growth_dag	\N	trigger	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('unpause', 'True'), ('origin', '/tree?dag_id=cdm_pure_growth_dag')]	\N	\N	\N
990	2024-02-21 17:15:40.808909+01	cdm_pure_growth_dag	test_connection	cli_task_run	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'tasks', 'run', 'cdm_pure_growth_dag', 'test_connection', 'manual__2024-02-21T16:15:39.469849+00:00', '--local', '--subdir', '/Users/kevin/Dropbox/applications/cp/dags/cdm_pure_growth_dag.py']"}	\N	\N	\N
991	2024-02-21 17:15:41.46048+01	cdm_pure_growth_dag	test_connection	running	2024-02-21 17:15:39.469849+01	airflow	\N	\N	\N	\N
992	2024-02-21 17:15:41.47817+01	cdm_pure_growth_dag	test_connection	cli_task_run	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'tasks', 'run', 'cdm_pure_growth_dag', 'test_connection', 'manual__2024-02-21T16:15:39.469849+00:00', '--local', '--subdir', '/Users/kevin/Dropbox/applications/cp/dags/cdm_pure_growth_dag.py']"}	\N	\N	\N
993	2024-02-21 17:15:41.691431+01	cdm_pure_growth_dag	test_connection	failed	2024-02-21 17:15:39.469849+01	airflow	\N	\N	\N	\N
996	2024-02-21 17:15:47.628243+01	cdm_pure_growth_dag	test_connection	get_logs_with_metadata	2024-02-21 17:15:39.469849+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('task_id', 'test_connection'), ('execution_date', '2024-02-21T16:15:39.469849+00:00'), ('try_number', '1'), ('metadata', 'null')]	\N	\N	\N
998	2024-02-21 17:27:13.559693+01	cdm_pure_growth_dag	\N	tree	\N	admin	[('dag_id', 'cdm_pure_growth_dag')]	\N	\N	\N
999	2024-02-21 17:27:15.279923+01	cdm_pure_growth_dag	test_connection	cli_task_run	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'tasks', 'run', 'cdm_pure_growth_dag', 'test_connection', 'manual__2024-02-21T16:27:13.498261+00:00', '--local', '--subdir', '/Users/kevin/Dropbox/applications/cp/dags/cdm_pure_growth_dag.py']"}	\N	\N	\N
1000	2024-02-21 17:27:15.910192+01	cdm_pure_growth_dag	test_connection	running	2024-02-21 17:27:13.498261+01	airflow	\N	\N	\N	\N
1001	2024-02-21 17:27:15.947539+01	cdm_pure_growth_dag	test_connection	cli_task_run	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'tasks', 'run', 'cdm_pure_growth_dag', 'test_connection', 'manual__2024-02-21T16:27:13.498261+00:00', '--local', '--subdir', '/Users/kevin/Dropbox/applications/cp/dags/cdm_pure_growth_dag.py']"}	\N	\N	\N
1002	2024-02-21 17:27:16.18406+01	cdm_pure_growth_dag	test_connection	failed	2024-02-21 17:27:13.498261+01	airflow	\N	\N	\N	\N
1003	2024-02-21 17:27:16.895864+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
1004	2024-02-21 17:27:21.285867+01	cdm_pure_growth_dag	test_connection	log	2024-02-21 17:27:13.498261+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('task_id', 'test_connection'), ('execution_date', '2024-02-21T16:27:13.498261+00:00')]	\N	\N	\N
1005	2024-02-21 17:27:21.653608+01	cdm_pure_growth_dag	test_connection	get_logs_with_metadata	2024-02-21 17:27:13.498261+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('task_id', 'test_connection'), ('execution_date', '2024-02-21T16:27:13.498261+00:00'), ('try_number', '1'), ('metadata', 'null')]	\N	\N	\N
1006	2024-02-21 17:28:38.637241+01	cdm_pure_growth_dag	\N	tree	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('root', '')]	\N	\N	\N
1007	2024-02-21 17:28:41.045664+01	cdm_pure_growth_dag	\N	paused	\N	admin	[('is_paused', 'false'), ('dag_id', 'cdm_pure_growth_dag')]	\N	\N	\N
1010	2024-02-21 17:32:41.405382+01	cdm_pure_growth_dag	\N	tree	\N	admin	[('dag_id', 'cdm_pure_growth_dag')]	\N	\N	\N
1011	2024-02-21 17:32:46.093372+01	cdm_pure_growth_dag	\N	trigger	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('unpause', 'True'), ('origin', '/tree?dag_id=cdm_pure_growth_dag')]	\N	\N	\N
1012	2024-02-21 17:32:46.206822+01	cdm_pure_growth_dag	\N	tree	\N	admin	[('dag_id', 'cdm_pure_growth_dag')]	\N	\N	\N
1013	2024-02-21 17:32:47.982147+01	cdm_pure_growth_dag	test_connection	cli_task_run	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'tasks', 'run', 'cdm_pure_growth_dag', 'test_connection', 'manual__2024-02-21T16:32:46.097045+00:00', '--local', '--subdir', 'DAGS_FOLDER/cdm_pure_growth_dag.py']"}	\N	\N	\N
1014	2024-02-21 17:32:48.615495+01	cdm_pure_growth_dag	test_connection	running	2024-02-21 17:32:46.097045+01	airflow	\N	\N	\N	\N
1015	2024-02-21 17:32:48.650494+01	cdm_pure_growth_dag	test_connection	cli_task_run	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'tasks', 'run', 'cdm_pure_growth_dag', 'test_connection', 'manual__2024-02-21T16:32:46.097045+00:00', '--local', '--subdir', 'DAGS_FOLDER/cdm_pure_growth_dag.py']"}	\N	\N	\N
1016	2024-02-21 17:32:48.888683+01	cdm_pure_growth_dag	test_connection	failed	2024-02-21 17:32:46.097045+01	airflow	\N	\N	\N	\N
1017	2024-02-21 17:32:49.503207+01	cdm_pure_growth_dag	\N	tree_data	\N	admin	[('dag_id', 'cdm_pure_growth_dag'), ('num_runs', '25'), ('root', '')]	\N	\N	\N
1018	2024-02-21 17:32:55.441713+01	cdm_pure_growth_dag	test_connection	log	2024-02-21 17:32:46.097045+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('task_id', 'test_connection'), ('execution_date', '2024-02-21T16:32:46.097045+00:00')]	\N	\N	\N
1019	2024-02-21 17:32:55.802555+01	cdm_pure_growth_dag	test_connection	get_logs_with_metadata	2024-02-21 17:32:46.097045+01	admin	[('dag_id', 'cdm_pure_growth_dag'), ('task_id', 'test_connection'), ('execution_date', '2024-02-21T16:32:46.097045+00:00'), ('try_number', '1'), ('metadata', 'null')]	\N	\N	\N
1020	2024-02-21 17:41:12.339005+01	\N	\N	cli_upgradedb	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'db', 'upgrade']"}	\N	\N	\N
1021	2024-02-21 17:43:01.112875+01	\N	\N	cli_upgradedb	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'db', 'upgrade']"}	\N	\N	\N
1022	2024-02-21 17:43:35.08305+01	\N	\N	cli_upgradedb	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'db', 'upgrade']"}	\N	\N	\N
1023	2024-02-21 17:52:01.235581+01	\N	\N	cli_upgradedb	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'db', 'upgrade']"}	\N	\N	\N
1024	2024-02-21 17:52:13.117004+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'scheduler']"}	\N	\N	\N
1025	2024-02-21 17:52:18.397096+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Library/Frameworks/Python.framework/Versions/3.7/bin/airflow', 'webserver', '--port', '8080']"}	\N	\N	\N
1026	2024-02-21 17:53:14.186233+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Users/kevin/.pyenv/versions/3.11.6/bin/airflow', 'webserver', '--port', '8080']"}	\N	\N	\N
1027	2024-02-21 17:53:19.117419+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Users/kevin/.pyenv/versions/3.11.6/bin/airflow', 'scheduler']"}	\N	\N	\N
1028	2024-02-21 18:22:24.798946+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Users/kevin/.pyenv/versions/3.11.6/bin/airflow', 'webserver', '--port', '8080']"}	\N	\N	\N
1029	2024-02-21 19:25:11.830443+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Users/kevin/.pyenv/versions/3.11.6/bin/airflow', 'scheduler']"}	\N	\N	\N
1030	2024-02-21 19:25:25.903747+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Users/kevin/.pyenv/versions/3.11.6/bin/airflow', 'webserver', '--port', '8080']"}	\N	\N	\N
1031	2024-02-21 19:25:53.719769+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Users/kevin/.pyenv/versions/3.11.6/bin/airflow', 'scheduler']"}	\N	\N	\N
1032	2024-02-21 19:30:11.348983+01	\N	\N	cli_upgradedb	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Users/kevin/.pyenv/versions/3.11.6/bin/airflow', 'db', 'upgrade']"}	\N	\N	\N
1033	2024-02-21 19:45:25.610014+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Users/kevin/.pyenv/versions/3.11.6/bin/airflow', 'scheduler']"}	\N	\N	\N
1034	2024-02-21 19:45:38.192733+01	\N	\N	cli_webserver	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Users/kevin/.pyenv/versions/3.11.6/bin/airflow', 'webserver', '--port', '8080']"}	\N	\N	\N
1035	2025-01-02 21:33:19.74321+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Users/kevin/.pyenv/versions/3.11.6/bin/airflow', 'scheduler']"}	\N	\N	\N
1036	2025-01-02 21:34:02.852911+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Users/kevin/.pyenv/versions/3.11.6/bin/airflow', 'scheduler']"}	\N	\N	\N
1037	2025-01-02 21:35:00.569127+01	\N	\N	cli_scheduler	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Users/kevin/.pyenv/versions/3.11.6/bin/airflow', 'scheduler']"}	\N	\N	\N
1038	2025-01-02 21:36:49.441304+01	\N	\N	cli_check	\N	kevin	{"host_name": "Kevins-MBP-2.home", "full_command": "['/Users/kevin/.pyenv/versions/3.11.6/bin/airflow', 'db', 'check']"}	\N	\N	\N
\.


--
-- Data for Name: log_template; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.log_template (id, filename, elasticsearch_id, created_at) FROM stdin;
1	{{ ti.dag_id }}/{{ ti.task_id }}/{{ ts }}/{{ try_number }}.log	{dag_id}-{task_id}-{execution_date}-{try_number}	2024-02-19 16:51:05.232759+01
2	dag_id={{ ti.dag_id }}/run_id={{ ti.run_id }}/task_id={{ ti.task_id }}/{% if ti.map_index >= 0 %}map_index={{ ti.map_index }}/{% endif %}attempt={{ try_number }}.log	{dag_id}-{task_id}-{run_id}-{map_index}-{try_number}	2024-02-19 16:51:05.232769+01
\.


--
-- Data for Name: rendered_task_instance_fields; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rendered_task_instance_fields (dag_id, task_id, rendered_fields, k8s_pod_yaml, map_index, run_id, execution_date) FROM stdin;
\.


--
-- Data for Name: serialized_dag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serialized_dag (dag_id, fileloc, fileloc_hash, data, last_updated, dag_hash, data_compressed, processor_subdir) FROM stdin;
yfinance_to_raw_test_dag	/Users/kevin/Dropbox/applications/ELT/dags/yfinance_to_raw_test_dag.py	4397684308586184	{"__version": 1, "dag": {"_description": "DAG to run a Python script that updates raw.", "timezone": "UTC", "_task_group": {"_group_id": null, "prefix_group_id": true, "tooltip": "", "ui_color": "CornflowerBlue", "ui_fgcolor": "#000", "children": {"fetch_yfinance_data": ["operator", "fetch_yfinance_data"], "trigger_dag_for_cdm_api_cdm_data_ingestion_table": ["operator", "trigger_dag_for_cdm_api_cdm_data_ingestion_table"]}, "upstream_group_ids": [], "downstream_group_ids": [], "upstream_task_ids": [], "downstream_task_ids": []}, "edge_info": {}, "_dag_id": "yfinance_to_raw_test_dag", "default_args": {"__var": {"owner": "airflow", "depends_on_past": false, "start_date": {"__var": 1672531200.0, "__type": "datetime"}, "email_on_failure": false, "email_on_retry": false, "retries": 0, "retry_delay": {"__var": 300.0, "__type": "timedelta"}}, "__type": "dict"}, "schedule_interval": null, "fileloc": "/Users/kevin/Dropbox/applications/ELT/dags/yfinance_to_raw_test_dag.py", "_processor_dags_folder": "/Users/kevin/Dropbox/applications/ELT/dags", "tasks": [{"__var": {"template_fields_renderers": {"bash_command": "bash", "env": "json"}, "email_on_failure": false, "weight_rule": "downstream", "email_on_retry": false, "retry_delay": 300.0, "owner": "airflow", "_log_config_logger_name": "airflow.task.operators", "is_setup": false, "pool": "default_pool", "start_from_trigger": false, "start_date": 1672531200.0, "template_ext": [".sh", ".bash"], "is_teardown": false, "downstream_task_ids": ["trigger_dag_for_cdm_api_cdm_data_ingestion_table"], "ui_color": "#f0ede4", "ui_fgcolor": "#000", "template_fields": ["bash_command", "env", "cwd"], "task_id": "fetch_yfinance_data", "_needs_expansion": false, "on_failure_fail_dagrun": false, "_task_type": "BashOperator", "_task_module": "airflow.operators.bash", "_is_empty": false, "start_trigger_args": null, "bash_command": "export ENV={{ var.value.ENV }} && echo \\"Airflow ENV: $ENV\\" && python /app/python/src/dev/raw/yfinance_to_raw_etl.py --start_date \\"1950-01-01\\" --end_date \\"{{ macros.ds_add(ds, 0) }}\\"", "env": {"DB_CONNECTION_STRING": "postgresql://postgres:9356@localhost:5433/dev", "ENV": "dev"}}, "__type": "operator"}, {"__var": {"template_fields_renderers": {"conf": "py"}, "email_on_failure": false, "weight_rule": "downstream", "email_on_retry": false, "retry_delay": 300.0, "owner": "airflow", "_log_config_logger_name": "airflow.task.operators", "is_setup": false, "pool": "default_pool", "start_from_trigger": false, "start_date": 1672531200.0, "template_ext": [], "is_teardown": false, "downstream_task_ids": [], "ui_color": "#ffefeb", "ui_fgcolor": "#000", "template_fields": ["trigger_dag_id", "trigger_run_id", "logical_date", "conf", "wait_for_completion", "skip_when_already_exists"], "task_id": "trigger_dag_for_cdm_api_cdm_data_ingestion_table", "_needs_expansion": false, "on_failure_fail_dagrun": false, "_task_type": "TriggerDagRunOperator", "_task_module": "airflow.operators.trigger_dagrun", "_is_empty": false, "start_trigger_args": null, "_operator_extra_links": [{"airflow.operators.trigger_dagrun.TriggerDagRunLink": {}}], "trigger_dag_id": "raw_to_api_cdm_data_ingestion_dag", "wait_for_completion": false, "skip_when_already_exists": false}, "__type": "operator"}], "dag_dependencies": [{"source": "yfinance_to_raw_test_dag", "target": "raw_to_api_cdm_data_ingestion_dag", "dependency_type": "trigger", "dependency_id": "trigger_dag_for_cdm_api_cdm_data_ingestion_table"}], "params": []}}	2025-01-02 21:33:50.790433+01	9e3dad68e3dffe501258ca22833419f5	\N	/Users/kevin/Dropbox/applications/ELT/dags
cdm_ticker_count_by_date_dag	/Users/kevin/Dropbox/applications/ELT/dags/cdm_ticker_count_by_date_dag.py	57619331643657825	{"__version": 1, "dag": {"start_date": 1735689600.0, "schedule_interval": {"__var": 86400.0, "__type": "timedelta"}, "fileloc": "/Users/kevin/Dropbox/applications/ELT/dags/cdm_ticker_count_by_date_dag.py", "_task_group": {"_group_id": null, "prefix_group_id": true, "tooltip": "", "ui_color": "CornflowerBlue", "ui_fgcolor": "#000", "children": {"test_connection": ["operator", "test_connection"], "dbt_run_model_ticker_counts_by_date": ["operator", "dbt_run_model_ticker_counts_by_date"]}, "upstream_group_ids": [], "downstream_group_ids": [], "upstream_task_ids": [], "downstream_task_ids": []}, "_description": "DAG for creating cdm.ticker_counts_by_date", "_dag_id": "cdm_ticker_count_by_date_dag", "default_args": {"__var": {"owner": "airflow", "depends_on_past": false, "email_on_failure": false, "email_on_retry": false, "retries": 1, "retry_delay": {"__var": 300.0, "__type": "timedelta"}}, "__type": "dict"}, "timezone": "UTC", "edge_info": {}, "_processor_dags_folder": "/Users/kevin/Dropbox/applications/ELT/dags", "tasks": [{"__var": {"start_from_trigger": false, "ui_color": "#cdaaed", "ui_fgcolor": "#000", "template_ext": [".sql", ".json"], "retries": 1, "pool": "default_pool", "_log_config_logger_name": "airflow.task.operators", "email_on_failure": false, "task_id": "test_connection", "_needs_expansion": false, "weight_rule": "downstream", "downstream_task_ids": ["dbt_run_model_ticker_counts_by_date"], "is_setup": false, "email_on_retry": false, "template_fields_renderers": {"sql": "sql", "parameters": "json"}, "on_failure_fail_dagrun": false, "retry_delay": 300.0, "template_fields": ["sql", "parameters", "conn_id", "database", "hook_params"], "owner": "airflow", "is_teardown": false, "_task_type": "SQLExecuteQueryOperator", "_task_module": "airflow.providers.common.sql.operators.sql", "_is_empty": false, "start_trigger_args": null, "sql": "SELECT 1;", "conn_id": "postgres_default", "hook_params": {}}, "__type": "operator"}, {"__var": {"start_from_trigger": false, "ui_color": "#f0ede4", "ui_fgcolor": "#000", "template_ext": [".sh", ".bash"], "retries": 1, "pool": "default_pool", "_log_config_logger_name": "airflow.task.operators", "email_on_failure": false, "task_id": "dbt_run_model_ticker_counts_by_date", "_needs_expansion": false, "weight_rule": "downstream", "downstream_task_ids": [], "is_setup": false, "email_on_retry": false, "template_fields_renderers": {"bash_command": "bash", "env": "json"}, "on_failure_fail_dagrun": false, "retry_delay": 300.0, "template_fields": ["bash_command", "env", "cwd"], "owner": "airflow", "is_teardown": false, "_task_type": "BashOperator", "_task_module": "airflow.operators.bash", "_is_empty": false, "start_trigger_args": null, "bash_command": "export ENV={{ var.value.ENV }} && echo \\"Airflow ENV: $ENV\\" && cd /Users/kevin/Dropbox/applications/ELT/dbt/src/app && dbt run --models ticker_counts_by_date"}, "__type": "operator"}], "dag_dependencies": [], "params": []}}	2025-01-02 21:33:50.80417+01	efb4253b2f793f084c931c6a69b6c66f	\N	/Users/kevin/Dropbox/applications/ELT/dags
\.


--
-- Data for Name: sla_miss; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sla_miss (task_id, dag_id, execution_date, email_sent, "timestamp", description, notification_sent) FROM stdin;
\.


--
-- Data for Name: slot_pool; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.slot_pool (id, pool, slots, description, include_deferred) FROM stdin;
1	default_pool	128	Default pool	f
\.


--
-- Data for Name: task_fail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_fail (id, task_id, dag_id, start_date, end_date, duration, map_index, run_id, execution_date) FROM stdin;
111	insert_into_pure_growth	cdm_pure_growth_dag	2024-02-21 15:56:20.302394+01	2024-02-21 16:48:56.99916+01	3156	-1	\N	2024-02-21 15:56:17.593835+01
112	test_connection	cdm_pure_growth_dag	2024-02-21 16:34:56.80264+01	2024-02-21 16:48:57.038653+01	840	-1	\N	2024-02-21 15:56:17.593835+01
113	insert_into_pure_growth	cdm_pure_growth_dag	2024-02-21 16:12:24.91143+01	2024-02-21 16:48:57.05502+01	2192	-1	\N	2024-02-21 16:12:22.25392+01
114	test_connection	cdm_pure_growth_dag	2024-02-21 16:34:59.114089+01	2024-02-21 16:48:57.087129+01	837	-1	\N	2024-02-21 16:12:22.25392+01
115	test_connection	cdm_pure_growth_dag	2024-02-21 16:47:39.440496+01	2024-02-21 16:48:57.104821+01	77	-1	\N	2024-02-21 16:47:37.34857+01
116	test_connection	cdm_pure_growth_dag	2024-02-21 16:49:26.655867+01	2024-02-21 16:49:26.889453+01	0	-1	\N	2024-02-21 16:49:24.30447+01
117	test_connection	cdm_pure_growth_dag	2024-02-21 16:53:01.586481+01	2024-02-21 16:53:01.833983+01	0	-1	\N	2024-02-21 16:52:59.198297+01
118	test_connection	cdm_pure_growth_dag	2024-02-21 16:53:41.611432+01	2024-02-21 16:53:41.893669+01	0	-1	\N	2024-02-21 16:53:39.397884+01
119	test_connection	cdm_pure_growth_dag	2024-02-21 17:15:41.435682+01	2024-02-21 17:15:41.691384+01	0	-1	\N	2024-02-21 17:15:39.469849+01
120	test_connection	cdm_pure_growth_dag	2024-02-21 17:27:15.902586+01	2024-02-21 17:27:16.184019+01	0	-1	\N	2024-02-21 17:27:13.498261+01
121	test_connection	cdm_pure_growth_dag	2024-02-21 17:32:48.608065+01	2024-02-21 17:32:48.888629+01	0	-1	\N	2024-02-21 17:32:46.097045+01
\.


--
-- Data for Name: task_instance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_instance (task_id, dag_id, run_id, start_date, end_date, duration, state, try_number, hostname, unixname, job_id, pool, queue, priority_weight, operator, queued_dttm, pid, max_tries, executor_config, pool_slots, queued_by_job_id, external_executor_id, trigger_id, trigger_timeout, next_method, next_kwargs, map_index, updated_at, custom_operator_name, rendered_map_index, task_display_name) FROM stdin;
insert_into_pure_growth	cdm_pure_growth_dag	manual__2024-02-21T15:52:59.198297+00:00	2024-02-21 16:53:01.937863+01	2024-02-21 16:53:01.937863+01	0	upstream_failed	0		kevin	\N	default_pool	default	1	PostgresOperator	\N	\N	0	\\x80047d942e	1	\N	\N	\N	\N	\N	null	-1	\N	\N	\N	\N
insert_into_pure_growth	cdm_pure_growth_dag	manual__2024-02-21T15:35:44.539793+00:00	\N	\N	\N	\N	0		kevin	\N	default_pool	default	1	PostgresOperator	\N	\N	0	\\x80047d942e	1	\N	\N	\N	\N	\N	null	-1	\N	\N	\N	\N
test_connection	cdm_pure_growth_dag	manual__2024-02-21T15:35:44.539793+00:00	2024-02-21 16:35:46.503314+01	2024-02-21 16:47:32.026178+01	705.522864	failed	1	kevins-mbp-2.home	kevin	25	default_pool	default	2	PostgresOperator	2024-02-21 16:35:44.953227+01	9963	0	\\x80047d942e	1	1	\N	\N	\N	\N	null	-1	\N	\N	\N	\N
insert_into_pure_growth	cdm_pure_growth_dag	manual__2024-02-21T14:56:17.593835+00:00	2024-02-21 15:56:20.302394+01	2024-02-21 16:48:56.99916+01	3156.696766	failed	1	kevins-mbp-2.home	kevin	21	default_pool	default	1	PostgresOperator	2024-02-21 15:56:18.005778+01	88462	0	\\x80047d942e	1	20	\N	\N	\N	\N	null	-1	\N	\N	\N	\N
test_connection	cdm_pure_growth_dag	manual__2024-02-21T14:56:17.593835+00:00	2024-02-21 16:34:56.80264+01	2024-02-21 16:48:57.038653+01	840.236013	failed	1	kevins-mbp-2.home	kevin	23	default_pool	default	2	PostgresOperator	2024-02-21 16:34:54.556607+01	9442	0	\\x80047d942e	1	1	\N	\N	\N	\N	null	-1	\N	\N	\N	\N
insert_into_pure_growth	cdm_pure_growth_dag	manual__2024-02-21T15:12:22.253920+00:00	2024-02-21 16:12:24.91143+01	2024-02-21 16:48:57.05502+01	2192.14359	failed	1	kevins-mbp-2.home	kevin	22	default_pool	default	1	PostgresOperator	2024-02-21 16:12:23.245483+01	96980	0	\\x80047d942e	1	1	\N	\N	\N	\N	null	-1	\N	\N	\N	\N
test_connection	cdm_pure_growth_dag	manual__2024-02-21T15:12:22.253920+00:00	2024-02-21 16:34:59.114089+01	2024-02-21 16:48:57.087129+01	837.97304	failed	1	kevins-mbp-2.home	kevin	24	default_pool	default	2	PostgresOperator	2024-02-21 16:34:54.556607+01	9477	0	\\x80047d942e	1	1	\N	\N	\N	\N	null	-1	\N	\N	\N	\N
test_connection	cdm_pure_growth_dag	manual__2024-02-21T15:47:37.348570+00:00	2024-02-21 16:47:39.440496+01	2024-02-21 16:48:57.104821+01	77.664325	failed	1	kevins-mbp-2.home	kevin	26	default_pool	default	2	PostgresOperator	2024-02-21 16:47:37.492065+01	16101	0	\\x80047d942e	1	1	\N	\N	\N	\N	null	-1	\N	\N	\N	\N
insert_into_pure_growth	cdm_pure_growth_dag	manual__2024-02-21T15:47:37.348570+00:00	2024-02-21 16:48:57.855622+01	2024-02-21 16:48:57.855622+01	0	upstream_failed	0		kevin	\N	default_pool	default	1	PostgresOperator	\N	\N	0	\\x80047d942e	1	\N	\N	\N	\N	\N	null	-1	\N	\N	\N	\N
test_connection	cdm_pure_growth_dag	manual__2024-02-21T15:49:24.304470+00:00	2024-02-21 16:49:26.655867+01	2024-02-21 16:49:26.889453+01	0.233586	failed	1	kevins-mbp-2.home	kevin	27	default_pool	default	2	PostgresOperator	2024-02-21 16:49:24.539201+01	16989	0	\\x80047d942e	1	20	\N	\N	\N	\N	null	-1	\N	\N	\N	\N
insert_into_pure_growth	cdm_pure_growth_dag	manual__2024-02-21T15:49:24.304470+00:00	2024-02-21 16:49:26.959216+01	2024-02-21 16:49:26.959216+01	0	upstream_failed	0		kevin	\N	default_pool	default	1	PostgresOperator	\N	\N	0	\\x80047d942e	1	\N	\N	\N	\N	\N	null	-1	\N	\N	\N	\N
test_connection	cdm_pure_growth_dag	manual__2024-02-21T15:52:59.198297+00:00	2024-02-21 16:53:01.586481+01	2024-02-21 16:53:01.833983+01	0.247502	failed	1	kevins-mbp-2.home	kevin	28	default_pool	default	2	PostgresOperator	2024-02-21 16:52:59.606845+01	18832	0	\\x80047d942e	1	1	\N	\N	\N	\N	null	-1	\N	\N	\N	\N
test_connection	cdm_pure_growth_dag	manual__2024-02-21T15:53:39.397884+00:00	2024-02-21 16:53:41.611432+01	2024-02-21 16:53:41.893669+01	0.282237	failed	1	kevins-mbp-2.home	kevin	29	default_pool	default	2	PostgresOperator	2024-02-21 16:53:39.495583+01	19199	0	\\x80047d942e	1	20	\N	\N	\N	\N	null	-1	\N	\N	\N	\N
insert_into_pure_growth	cdm_pure_growth_dag	manual__2024-02-21T15:53:39.397884+00:00	2024-02-21 16:53:41.983268+01	2024-02-21 16:53:41.983268+01	0	upstream_failed	0		kevin	\N	default_pool	default	1	PostgresOperator	\N	\N	0	\\x80047d942e	1	\N	\N	\N	\N	\N	null	-1	\N	\N	\N	\N
test_connection	cdm_pure_growth_dag	manual__2024-02-21T16:15:39.469849+00:00	2024-02-21 17:15:41.435682+01	2024-02-21 17:15:41.691384+01	0.255702	failed	1	kevins-mbp-2.home	kevin	30	default_pool	default	2	PostgresOperator	2024-02-21 17:15:39.663884+01	30612	0	\\x80047d942e	1	1	\N	\N	\N	\N	null	-1	\N	\N	\N	\N
insert_into_pure_growth	cdm_pure_growth_dag	manual__2024-02-21T16:15:39.469849+00:00	2024-02-21 17:15:41.809719+01	2024-02-21 17:15:41.809719+01	0	upstream_failed	0		kevin	\N	default_pool	default	1	PostgresOperator	\N	\N	0	\\x80047d942e	1	\N	\N	\N	\N	\N	null	-1	\N	\N	\N	\N
test_connection	cdm_pure_growth_dag	manual__2024-02-21T16:27:13.498261+00:00	2024-02-21 17:27:15.902586+01	2024-02-21 17:27:16.184019+01	0.281433	failed	1	kevins-mbp-2.home	kevin	31	default_pool	default	2	PostgresOperator	2024-02-21 17:27:13.770656+01	36484	0	\\x80047d942e	1	1	\N	\N	\N	\N	null	-1	\N	\N	\N	\N
insert_into_pure_growth	cdm_pure_growth_dag	manual__2024-02-21T16:27:13.498261+00:00	2024-02-21 17:27:16.260686+01	2024-02-21 17:27:16.260686+01	0	upstream_failed	0		kevin	\N	default_pool	default	1	PostgresOperator	\N	\N	0	\\x80047d942e	1	\N	\N	\N	\N	\N	null	-1	\N	\N	\N	\N
test_connection	cdm_pure_growth_dag	manual__2024-02-21T16:32:46.097045+00:00	2024-02-21 17:32:48.608065+01	2024-02-21 17:32:48.888629+01	0.280564	failed	1	kevins-mbp-2.home	kevin	32	default_pool	default	2	PostgresOperator	2024-02-21 17:32:46.639685+01	39304	0	\\x80047d942e	1	20	\N	\N	\N	\N	null	-1	\N	\N	\N	\N
insert_into_pure_growth	cdm_pure_growth_dag	manual__2024-02-21T16:32:46.097045+00:00	2024-02-21 17:32:48.961485+01	2024-02-21 17:32:48.961485+01	0	upstream_failed	0		kevin	\N	default_pool	default	1	PostgresOperator	\N	\N	0	\\x80047d942e	1	\N	\N	\N	\N	\N	null	-1	\N	\N	\N	\N
\.


--
-- Data for Name: task_instance_note; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_instance_note (user_id, task_id, dag_id, run_id, map_index, content, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: task_map; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_map (dag_id, task_id, run_id, map_index, length, keys) FROM stdin;
\.


--
-- Data for Name: task_outlet_dataset_reference; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_outlet_dataset_reference (dataset_id, dag_id, task_id, created_at, updated_at) FROM stdin;
1	dataset_produces_1	producing_task_1	2024-02-19 16:51:05.187946+01	2024-02-19 16:51:05.187953+01
2	dataset_produces_2	producing_task_2	2024-02-19 16:51:05.188474+01	2024-02-19 16:51:05.188482+01
3	dataset_consumes_1_never_scheduled	consuming_3	2024-02-19 16:51:05.188809+01	2024-02-19 16:51:05.188816+01
3	dataset_consumes_1_and_2	consuming_2	2024-02-19 16:51:05.189183+01	2024-02-19 16:51:05.189189+01
4	dataset_consumes_1	consuming_1	2024-02-19 16:51:05.189517+01	2024-02-19 16:51:05.189523+01
5	dataset_consumes_unknown_never_scheduled	unrelated_task	2024-02-19 16:51:05.189877+01	2024-02-19 16:51:05.189884+01
\.


--
-- Data for Name: trigger; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trigger (id, classpath, kwargs, created_date, triggerer_id) FROM stdin;
\.


--
-- Data for Name: variable; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.variable (id, key, val, is_encrypted, description) FROM stdin;
\.


--
-- Data for Name: xcom; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.xcom (dag_run_id, task_id, key, value, "timestamp", dag_id, run_id, map_index, execution_date) FROM stdin;
\.


--
-- Name: ab_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ab_permission_id_seq', 17, true);


--
-- Name: ab_permission_view_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ab_permission_view_id_seq', 288, true);


--
-- Name: ab_permission_view_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ab_permission_view_role_id_seq', 248, true);


--
-- Name: ab_register_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ab_register_user_id_seq', 1, false);


--
-- Name: ab_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ab_role_id_seq', 5, true);


--
-- Name: ab_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ab_user_id_seq', 1, true);


--
-- Name: ab_user_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ab_user_role_id_seq', 1, true);


--
-- Name: ab_view_menu_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ab_view_menu_id_seq', 119, true);


--
-- Name: callback_request_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.callback_request_id_seq', 1, false);


--
-- Name: connection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.connection_id_seq', 58, true);


--
-- Name: dag_pickle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dag_pickle_id_seq', 1, false);


--
-- Name: dag_run_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dag_run_id_seq', 10, true);


--
-- Name: dataset_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dataset_event_id_seq', 1, false);


--
-- Name: dataset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dataset_id_seq', 8, true);


--
-- Name: import_error_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.import_error_id_seq', 43642, true);


--
-- Name: job_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.job_id_seq', 39, true);


--
-- Name: log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.log_id_seq', 1038, true);


--
-- Name: log_template_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.log_template_id_seq', 2, true);


--
-- Name: run_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.run_id_seq', 1, true);


--
-- Name: slot_pool_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.slot_pool_id_seq', 1, true);


--
-- Name: task_fail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.task_fail_id_seq', 121, true);


--
-- Name: trigger_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.trigger_id_seq', 1, false);


--
-- Name: variable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.variable_id_seq', 1, false);


--
-- Name: ab_permission ab_permission_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_permission
    ADD CONSTRAINT ab_permission_name_key UNIQUE (name);


--
-- Name: ab_permission ab_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_permission
    ADD CONSTRAINT ab_permission_pkey PRIMARY KEY (id);


--
-- Name: ab_permission_view ab_permission_view_permission_id_view_menu_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_permission_view
    ADD CONSTRAINT ab_permission_view_permission_id_view_menu_id_key UNIQUE (permission_id, view_menu_id);


--
-- Name: ab_permission_view ab_permission_view_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_permission_view
    ADD CONSTRAINT ab_permission_view_pkey PRIMARY KEY (id);


--
-- Name: ab_permission_view_role ab_permission_view_role_permission_view_id_role_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_permission_view_role
    ADD CONSTRAINT ab_permission_view_role_permission_view_id_role_id_key UNIQUE (permission_view_id, role_id);


--
-- Name: ab_permission_view_role ab_permission_view_role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_permission_view_role
    ADD CONSTRAINT ab_permission_view_role_pkey PRIMARY KEY (id);


--
-- Name: ab_register_user ab_register_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_register_user
    ADD CONSTRAINT ab_register_user_pkey PRIMARY KEY (id);


--
-- Name: ab_register_user ab_register_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_register_user
    ADD CONSTRAINT ab_register_user_username_key UNIQUE (username);


--
-- Name: ab_role ab_role_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_role
    ADD CONSTRAINT ab_role_name_key UNIQUE (name);


--
-- Name: ab_role ab_role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_role
    ADD CONSTRAINT ab_role_pkey PRIMARY KEY (id);


--
-- Name: ab_user ab_user_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_user
    ADD CONSTRAINT ab_user_email_key UNIQUE (email);


--
-- Name: ab_user ab_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_user
    ADD CONSTRAINT ab_user_pkey PRIMARY KEY (id);


--
-- Name: ab_user_role ab_user_role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_user_role
    ADD CONSTRAINT ab_user_role_pkey PRIMARY KEY (id);


--
-- Name: ab_user_role ab_user_role_user_id_role_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_user_role
    ADD CONSTRAINT ab_user_role_user_id_role_id_key UNIQUE (user_id, role_id);


--
-- Name: ab_user ab_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_user
    ADD CONSTRAINT ab_user_username_key UNIQUE (username);


--
-- Name: ab_view_menu ab_view_menu_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_view_menu
    ADD CONSTRAINT ab_view_menu_name_key UNIQUE (name);


--
-- Name: ab_view_menu ab_view_menu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_view_menu
    ADD CONSTRAINT ab_view_menu_pkey PRIMARY KEY (id);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: callback_request callback_request_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.callback_request
    ADD CONSTRAINT callback_request_pkey PRIMARY KEY (id);


--
-- Name: connection connection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.connection
    ADD CONSTRAINT connection_pkey PRIMARY KEY (id);


--
-- Name: dag_code dag_code_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dag_code
    ADD CONSTRAINT dag_code_pkey PRIMARY KEY (fileloc_hash);


--
-- Name: dag_owner_attributes dag_owner_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dag_owner_attributes
    ADD CONSTRAINT dag_owner_attributes_pkey PRIMARY KEY (dag_id, owner);


--
-- Name: dag_pickle dag_pickle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dag_pickle
    ADD CONSTRAINT dag_pickle_pkey PRIMARY KEY (id);


--
-- Name: dag dag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dag
    ADD CONSTRAINT dag_pkey PRIMARY KEY (dag_id);


--
-- Name: dag_run dag_run_dag_id_execution_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dag_run
    ADD CONSTRAINT dag_run_dag_id_execution_date_key UNIQUE (dag_id, execution_date);


--
-- Name: dag_run dag_run_dag_id_run_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dag_run
    ADD CONSTRAINT dag_run_dag_id_run_id_key UNIQUE (dag_id, run_id);


--
-- Name: dag_run_note dag_run_note_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dag_run_note
    ADD CONSTRAINT dag_run_note_pkey PRIMARY KEY (dag_run_id);


--
-- Name: dag_run dag_run_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dag_run
    ADD CONSTRAINT dag_run_pkey PRIMARY KEY (id);


--
-- Name: dag_schedule_dataset_reference dag_schedule_dataset_reference_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dag_schedule_dataset_reference
    ADD CONSTRAINT dag_schedule_dataset_reference_pkey PRIMARY KEY (dataset_id, dag_id);


--
-- Name: dag_warning dag_warning_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dag_warning
    ADD CONSTRAINT dag_warning_pkey PRIMARY KEY (dag_id, warning_type);


--
-- Name: dagrun_dataset_event dagrun_dataset_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dagrun_dataset_event
    ADD CONSTRAINT dagrun_dataset_events_pkey PRIMARY KEY (dag_run_id, event_id);


--
-- Name: dataset_dag_run_queue dataset_dag_run_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset_dag_run_queue
    ADD CONSTRAINT dataset_dag_run_queue_pkey PRIMARY KEY (dataset_id, target_dag_id);


--
-- Name: dataset_event dataset_event_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset_event
    ADD CONSTRAINT dataset_event_pkey PRIMARY KEY (id);


--
-- Name: dataset dataset_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset
    ADD CONSTRAINT dataset_pkey PRIMARY KEY (id);


--
-- Name: import_error import_error_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.import_error
    ADD CONSTRAINT import_error_pkey PRIMARY KEY (id);


--
-- Name: job job_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job
    ADD CONSTRAINT job_pkey PRIMARY KEY (id);


--
-- Name: log log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log
    ADD CONSTRAINT log_pkey PRIMARY KEY (id);


--
-- Name: log_template log_template_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_template
    ADD CONSTRAINT log_template_pkey PRIMARY KEY (id);


--
-- Name: rendered_task_instance_fields rendered_task_instance_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rendered_task_instance_fields
    ADD CONSTRAINT rendered_task_instance_fields_pkey PRIMARY KEY (dag_id, task_id, run_id, map_index);


--
-- Name: serialized_dag serialized_dag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serialized_dag
    ADD CONSTRAINT serialized_dag_pkey PRIMARY KEY (dag_id);


--
-- Name: sla_miss sla_miss_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sla_miss
    ADD CONSTRAINT sla_miss_pkey PRIMARY KEY (task_id, dag_id, execution_date);


--
-- Name: slot_pool slot_pool_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.slot_pool
    ADD CONSTRAINT slot_pool_pkey PRIMARY KEY (id);


--
-- Name: slot_pool slot_pool_pool_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.slot_pool
    ADD CONSTRAINT slot_pool_pool_key UNIQUE (pool);


--
-- Name: task_fail task_fail_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_fail
    ADD CONSTRAINT task_fail_pkey PRIMARY KEY (id);


--
-- Name: task_instance_note task_instance_note_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_instance_note
    ADD CONSTRAINT task_instance_note_pkey PRIMARY KEY (task_id, dag_id, run_id, map_index);


--
-- Name: task_instance task_instance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_instance
    ADD CONSTRAINT task_instance_pkey PRIMARY KEY (dag_id, task_id, run_id, map_index);


--
-- Name: task_map task_map_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_map
    ADD CONSTRAINT task_map_pkey PRIMARY KEY (dag_id, task_id, run_id, map_index);


--
-- Name: task_outlet_dataset_reference task_outlet_dataset_reference_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_outlet_dataset_reference
    ADD CONSTRAINT task_outlet_dataset_reference_pkey PRIMARY KEY (dataset_id, dag_id, task_id);


--
-- Name: trigger trigger_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trigger
    ADD CONSTRAINT trigger_pkey PRIMARY KEY (id);


--
-- Name: connection unique_conn_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.connection
    ADD CONSTRAINT unique_conn_id UNIQUE (conn_id);


--
-- Name: variable variable_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variable
    ADD CONSTRAINT variable_key_key UNIQUE (key);


--
-- Name: variable variable_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variable
    ADD CONSTRAINT variable_pkey PRIMARY KEY (id);


--
-- Name: xcom xcom_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.xcom
    ADD CONSTRAINT xcom_pkey PRIMARY KEY (dag_run_id, task_id, map_index, key);


--
-- Name: dag_id_state; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX dag_id_state ON public.dag_run USING btree (dag_id, state);


--
-- Name: idx_ab_register_user_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ab_register_user_username ON public.ab_register_user USING btree (lower((username)::text));


--
-- Name: idx_ab_user_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_ab_user_username ON public.ab_user USING btree (lower((username)::text));


--
-- Name: idx_dag_run_dag_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dag_run_dag_id ON public.dag_run USING btree (dag_id);


--
-- Name: idx_dag_run_queued_dags; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dag_run_queued_dags ON public.dag_run USING btree (state, dag_id) WHERE ((state)::text = 'queued'::text);


--
-- Name: idx_dag_run_running_dags; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dag_run_running_dags ON public.dag_run USING btree (state, dag_id) WHERE ((state)::text = 'running'::text);


--
-- Name: idx_dagrun_dataset_events_dag_run_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dagrun_dataset_events_dag_run_id ON public.dagrun_dataset_event USING btree (dag_run_id);


--
-- Name: idx_dagrun_dataset_events_event_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dagrun_dataset_events_event_id ON public.dagrun_dataset_event USING btree (event_id);


--
-- Name: idx_dataset_id_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_dataset_id_timestamp ON public.dataset_event USING btree (dataset_id, "timestamp");


--
-- Name: idx_fileloc_hash; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fileloc_hash ON public.serialized_dag USING btree (fileloc_hash);


--
-- Name: idx_job_dag_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_dag_id ON public.job USING btree (dag_id);


--
-- Name: idx_job_state_heartbeat; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_job_state_heartbeat ON public.job USING btree (state, latest_heartbeat);


--
-- Name: idx_log_dag; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_log_dag ON public.log USING btree (dag_id);


--
-- Name: idx_log_dttm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_log_dttm ON public.log USING btree (dttm);


--
-- Name: idx_log_event; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_log_event ON public.log USING btree (event);


--
-- Name: idx_next_dagrun_create_after; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_next_dagrun_create_after ON public.dag USING btree (next_dagrun_create_after);


--
-- Name: idx_root_dag_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_root_dag_id ON public.dag USING btree (root_dag_id);


--
-- Name: idx_task_fail_task_instance; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_task_fail_task_instance ON public.task_fail USING btree (dag_id, task_id, run_id, map_index);


--
-- Name: idx_uri_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_uri_unique ON public.dataset USING btree (uri);


--
-- Name: idx_xcom_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_xcom_key ON public.xcom USING btree (key);


--
-- Name: idx_xcom_task_instance; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_xcom_task_instance ON public.xcom USING btree (dag_id, task_id, run_id, map_index);


--
-- Name: job_type_heart; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX job_type_heart ON public.job USING btree (job_type, latest_heartbeat);


--
-- Name: sm_dag; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sm_dag ON public.sla_miss USING btree (dag_id);


--
-- Name: ti_dag_run; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ti_dag_run ON public.task_instance USING btree (dag_id, run_id);


--
-- Name: ti_dag_state; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ti_dag_state ON public.task_instance USING btree (dag_id, state);


--
-- Name: ti_job_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ti_job_id ON public.task_instance USING btree (job_id);


--
-- Name: ti_pool; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ti_pool ON public.task_instance USING btree (pool, state, priority_weight);


--
-- Name: ti_state; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ti_state ON public.task_instance USING btree (state);


--
-- Name: ti_state_lkp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ti_state_lkp ON public.task_instance USING btree (dag_id, task_id, run_id, state);


--
-- Name: ti_trigger_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ti_trigger_id ON public.task_instance USING btree (trigger_id);


--
-- Name: ab_permission_view ab_permission_view_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_permission_view
    ADD CONSTRAINT ab_permission_view_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.ab_permission(id);


--
-- Name: ab_permission_view_role ab_permission_view_role_permission_view_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_permission_view_role
    ADD CONSTRAINT ab_permission_view_role_permission_view_id_fkey FOREIGN KEY (permission_view_id) REFERENCES public.ab_permission_view(id);


--
-- Name: ab_permission_view_role ab_permission_view_role_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_permission_view_role
    ADD CONSTRAINT ab_permission_view_role_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.ab_role(id);


--
-- Name: ab_permission_view ab_permission_view_view_menu_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_permission_view
    ADD CONSTRAINT ab_permission_view_view_menu_id_fkey FOREIGN KEY (view_menu_id) REFERENCES public.ab_view_menu(id);


--
-- Name: ab_user ab_user_changed_by_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_user
    ADD CONSTRAINT ab_user_changed_by_fk_fkey FOREIGN KEY (changed_by_fk) REFERENCES public.ab_user(id);


--
-- Name: ab_user ab_user_created_by_fk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_user
    ADD CONSTRAINT ab_user_created_by_fk_fkey FOREIGN KEY (created_by_fk) REFERENCES public.ab_user(id);


--
-- Name: ab_user_role ab_user_role_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_user_role
    ADD CONSTRAINT ab_user_role_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.ab_role(id);


--
-- Name: ab_user_role ab_user_role_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ab_user_role
    ADD CONSTRAINT ab_user_role_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.ab_user(id);


--
-- Name: dag_owner_attributes dag_owner_attributes_dag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dag_owner_attributes
    ADD CONSTRAINT dag_owner_attributes_dag_id_fkey FOREIGN KEY (dag_id) REFERENCES public.dag(dag_id) ON DELETE CASCADE;


--
-- Name: dag_run_note dag_run_note_dr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dag_run_note
    ADD CONSTRAINT dag_run_note_dr_fkey FOREIGN KEY (dag_run_id) REFERENCES public.dag_run(id) ON DELETE CASCADE;


--
-- Name: dag_run_note dag_run_note_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dag_run_note
    ADD CONSTRAINT dag_run_note_user_fkey FOREIGN KEY (user_id) REFERENCES public.ab_user(id);


--
-- Name: dagrun_dataset_event dagrun_dataset_events_dag_run_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dagrun_dataset_event
    ADD CONSTRAINT dagrun_dataset_events_dag_run_id_fkey FOREIGN KEY (dag_run_id) REFERENCES public.dag_run(id) ON DELETE CASCADE;


--
-- Name: dagrun_dataset_event dagrun_dataset_events_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dagrun_dataset_event
    ADD CONSTRAINT dagrun_dataset_events_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.dataset_event(id) ON DELETE CASCADE;


--
-- Name: dag_warning dcw_dag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dag_warning
    ADD CONSTRAINT dcw_dag_id_fkey FOREIGN KEY (dag_id) REFERENCES public.dag(dag_id) ON DELETE CASCADE;


--
-- Name: dataset_dag_run_queue ddrq_dag_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset_dag_run_queue
    ADD CONSTRAINT ddrq_dag_fkey FOREIGN KEY (target_dag_id) REFERENCES public.dag(dag_id) ON DELETE CASCADE;


--
-- Name: dataset_dag_run_queue ddrq_dataset_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dataset_dag_run_queue
    ADD CONSTRAINT ddrq_dataset_fkey FOREIGN KEY (dataset_id) REFERENCES public.dataset(id) ON DELETE CASCADE;


--
-- Name: dag_schedule_dataset_reference dsdr_dag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dag_schedule_dataset_reference
    ADD CONSTRAINT dsdr_dag_id_fkey FOREIGN KEY (dag_id) REFERENCES public.dag(dag_id) ON DELETE CASCADE;


--
-- Name: dag_schedule_dataset_reference dsdr_dataset_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dag_schedule_dataset_reference
    ADD CONSTRAINT dsdr_dataset_fkey FOREIGN KEY (dataset_id) REFERENCES public.dataset(id) ON DELETE CASCADE;


--
-- Name: rendered_task_instance_fields rtif_ti_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rendered_task_instance_fields
    ADD CONSTRAINT rtif_ti_fkey FOREIGN KEY (dag_id, task_id, run_id, map_index) REFERENCES public.task_instance(dag_id, task_id, run_id, map_index) ON DELETE CASCADE;


--
-- Name: task_fail task_fail_ti_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_fail
    ADD CONSTRAINT task_fail_ti_fkey FOREIGN KEY (dag_id, task_id, run_id, map_index) REFERENCES public.task_instance(dag_id, task_id, run_id, map_index) ON DELETE CASCADE;


--
-- Name: task_instance task_instance_dag_run_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_instance
    ADD CONSTRAINT task_instance_dag_run_fkey FOREIGN KEY (dag_id, run_id) REFERENCES public.dag_run(dag_id, run_id) ON DELETE CASCADE;


--
-- Name: dag_run task_instance_log_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dag_run
    ADD CONSTRAINT task_instance_log_template_id_fkey FOREIGN KEY (log_template_id) REFERENCES public.log_template(id);


--
-- Name: task_instance_note task_instance_note_ti_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_instance_note
    ADD CONSTRAINT task_instance_note_ti_fkey FOREIGN KEY (dag_id, task_id, run_id, map_index) REFERENCES public.task_instance(dag_id, task_id, run_id, map_index) ON DELETE CASCADE;


--
-- Name: task_instance_note task_instance_note_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_instance_note
    ADD CONSTRAINT task_instance_note_user_fkey FOREIGN KEY (user_id) REFERENCES public.ab_user(id);


--
-- Name: task_instance task_instance_trigger_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_instance
    ADD CONSTRAINT task_instance_trigger_id_fkey FOREIGN KEY (trigger_id) REFERENCES public.trigger(id) ON DELETE CASCADE;


--
-- Name: task_map task_map_task_instance_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_map
    ADD CONSTRAINT task_map_task_instance_fkey FOREIGN KEY (dag_id, task_id, run_id, map_index) REFERENCES public.task_instance(dag_id, task_id, run_id, map_index) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: task_outlet_dataset_reference todr_dag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_outlet_dataset_reference
    ADD CONSTRAINT todr_dag_id_fkey FOREIGN KEY (dag_id) REFERENCES public.dag(dag_id) ON DELETE CASCADE;


--
-- Name: task_outlet_dataset_reference todr_dataset_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_outlet_dataset_reference
    ADD CONSTRAINT todr_dataset_fkey FOREIGN KEY (dataset_id) REFERENCES public.dataset(id) ON DELETE CASCADE;


--
-- Name: xcom xcom_task_instance_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.xcom
    ADD CONSTRAINT xcom_task_instance_fkey FOREIGN KEY (dag_id, task_id, run_id, map_index) REFERENCES public.task_instance(dag_id, task_id, run_id, map_index) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

