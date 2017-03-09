--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: article_endorsements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE article_endorsements (
    id integer NOT NULL,
    user_id integer,
    article_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: article_endorsements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE article_endorsements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: article_endorsements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE article_endorsements_id_seq OWNED BY article_endorsements.id;


--
-- Name: article_subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE article_subscriptions (
    id integer NOT NULL,
    article_id integer,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: article_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE article_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: article_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE article_subscriptions_id_seq OWNED BY article_subscriptions.id;


--
-- Name: article_views; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE article_views (
    id integer NOT NULL,
    article_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    count integer DEFAULT 1
);


--
-- Name: article_views_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE article_views_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: article_views_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE article_views_id_seq OWNED BY article_views.id;


--
-- Name: articles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE articles (
    id integer NOT NULL,
    title character varying,
    content text,
    author_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    slug character varying,
    editor_id integer,
    last_notified_author_at timestamp without time zone,
    archived_at timestamp without time zone,
    rotted_at timestamp without time zone,
    tags_count integer DEFAULT 0 NOT NULL,
    guide boolean DEFAULT false,
    subscriptions_count integer DEFAULT 0,
    endorsements_count integer DEFAULT 0,
    visits integer DEFAULT 0 NOT NULL,
    rot_reporter_id integer
);


--
-- Name: articles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE articles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE articles_id_seq OWNED BY articles.id;


--
-- Name: articles_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE articles_tags (
    id integer NOT NULL,
    article_id integer,
    tag_id integer
);


--
-- Name: articles_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE articles_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: articles_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE articles_tags_id_seq OWNED BY articles_tags.id;


--
-- Name: attachinary_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE attachinary_files (
    id integer NOT NULL,
    attachinariable_type character varying,
    attachinariable_id integer,
    scope character varying,
    public_id character varying,
    version character varying,
    width integer,
    height integer,
    format character varying,
    resource_type character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: attachinary_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE attachinary_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attachinary_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE attachinary_files_id_seq OWNED BY attachinary_files.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE delayed_jobs (
    id integer NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    handler text NOT NULL,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by character varying,
    queue character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE delayed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE delayed_jobs_id_seq OWNED BY delayed_jobs.id;


--
-- Name: friendly_id_slugs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE friendly_id_slugs (
    id integer NOT NULL,
    slug character varying NOT NULL,
    sluggable_id integer NOT NULL,
    sluggable_type character varying(50),
    scope character varying,
    created_at timestamp without time zone
);


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE friendly_id_slugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE friendly_id_slugs_id_seq OWNED BY friendly_id_slugs.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    slug character varying,
    articles_count integer DEFAULT 0 NOT NULL
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: update_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE update_requests (
    id integer NOT NULL,
    article_id integer,
    reporter_id integer,
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: update_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE update_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: update_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE update_requests_id_seq OWNED BY update_requests.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    provider character varying,
    uid character varying,
    name character varying,
    email character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    image character varying,
    avatar character varying,
    active boolean DEFAULT true,
    shtick text,
    preferences json
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE versions (
    id integer NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object text,
    created_at timestamp without time zone,
    object_changes text
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE versions_id_seq OWNED BY versions.id;


--
-- Name: article_endorsements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY article_endorsements ALTER COLUMN id SET DEFAULT nextval('article_endorsements_id_seq'::regclass);


--
-- Name: article_subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY article_subscriptions ALTER COLUMN id SET DEFAULT nextval('article_subscriptions_id_seq'::regclass);


--
-- Name: article_views id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY article_views ALTER COLUMN id SET DEFAULT nextval('article_views_id_seq'::regclass);


--
-- Name: articles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY articles ALTER COLUMN id SET DEFAULT nextval('articles_id_seq'::regclass);


--
-- Name: articles_tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY articles_tags ALTER COLUMN id SET DEFAULT nextval('articles_tags_id_seq'::regclass);


--
-- Name: attachinary_files id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY attachinary_files ALTER COLUMN id SET DEFAULT nextval('attachinary_files_id_seq'::regclass);


--
-- Name: delayed_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY delayed_jobs ALTER COLUMN id SET DEFAULT nextval('delayed_jobs_id_seq'::regclass);


--
-- Name: friendly_id_slugs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY friendly_id_slugs ALTER COLUMN id SET DEFAULT nextval('friendly_id_slugs_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: update_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY update_requests ALTER COLUMN id SET DEFAULT nextval('update_requests_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: article_endorsements article_endorsements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY article_endorsements
    ADD CONSTRAINT article_endorsements_pkey PRIMARY KEY (id);


--
-- Name: article_subscriptions article_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY article_subscriptions
    ADD CONSTRAINT article_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: article_views article_views_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY article_views
    ADD CONSTRAINT article_views_pkey PRIMARY KEY (id);


--
-- Name: articles articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: articles_tags articles_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY articles_tags
    ADD CONSTRAINT articles_tags_pkey PRIMARY KEY (id);


--
-- Name: attachinary_files attachinary_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY attachinary_files
    ADD CONSTRAINT attachinary_files_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: friendly_id_slugs friendly_id_slugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY friendly_id_slugs
    ADD CONSTRAINT friendly_id_slugs_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: update_requests update_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY update_requests
    ADD CONSTRAINT update_requests_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versions versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: articles_content; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX articles_content ON articles USING gin (to_tsvector('english'::regconfig, content));


--
-- Name: articles_title; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX articles_title ON articles USING gin (to_tsvector('english'::regconfig, (title)::text));


--
-- Name: by_scoped_parent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_scoped_parent ON attachinary_files USING btree (attachinariable_type, attachinariable_id, scope);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX delayed_jobs_priority ON delayed_jobs USING btree (priority, run_at);


--
-- Name: index_article_views_on_article_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_article_views_on_article_id ON article_views USING btree (article_id);


--
-- Name: index_article_views_on_article_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_article_views_on_article_id_and_user_id ON article_views USING btree (article_id, user_id);


--
-- Name: index_article_views_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_article_views_on_user_id ON article_views USING btree (user_id);


--
-- Name: index_articles_on_archived_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_articles_on_archived_at ON articles USING btree (archived_at);


--
-- Name: index_articles_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_articles_on_slug ON articles USING btree (slug);


--
-- Name: index_articles_tags_on_article_id_and_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_articles_tags_on_article_id_and_tag_id ON articles_tags USING btree (article_id, tag_id);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type ON friendly_id_slugs USING btree (slug, sluggable_type);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope ON friendly_id_slugs USING btree (slug, sluggable_type, scope);


--
-- Name: index_friendly_id_slugs_on_sluggable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_id ON friendly_id_slugs USING btree (sluggable_id);


--
-- Name: index_friendly_id_slugs_on_sluggable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_type ON friendly_id_slugs USING btree (sluggable_type);


--
-- Name: index_tags_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tags_on_slug ON tags USING btree (slug);


--
-- Name: index_versions_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_created_at ON versions USING btree (created_at);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING btree (item_type, item_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: article_subscriptions fk_rails_a02cfe7c2a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY article_subscriptions
    ADD CONSTRAINT fk_rails_a02cfe7c2a FOREIGN KEY (article_id) REFERENCES articles(id);


--
-- Name: article_endorsements fk_rails_d3f9d85708; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY article_endorsements
    ADD CONSTRAINT fk_rails_d3f9d85708 FOREIGN KEY (article_id) REFERENCES articles(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20121012052227'), ('20121012053216'), ('20121024172653'), ('20121101215757'), ('20121101230245'), ('20121107203955'), ('20121107205723'), ('20121228090236'), ('20130218024132'), ('20130224191645'), ('20130302074219'), ('20130519172832'), ('20131002145513'), ('20131003155044'), ('20140215004410'), ('20140216160144'), ('20140217025247'), ('20140522210252'), ('20140602153320'), ('20140606204236'), ('20140923231243'), ('20141111222212'), ('20150117041549'), ('20150129150300'), ('20150328040718'), ('20150328040918'), ('20150328074815'), ('20150416104151'), ('20150829203748'), ('20150901204841'), ('20150921154734'), ('20150922194413'), ('20150922233803'), ('20160220002317'), ('20160220002318'), ('20160222234001'), ('20160710170239'), ('20161028171951'), ('20161108170423'), ('20170205101633'), ('20170205222526'), ('20170308184000'), ('20170308184021');


