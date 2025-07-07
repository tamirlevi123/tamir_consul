--
-- PostgreSQL database dump
--

-- Dumped from database version 13.16 (Debian 13.16-1.pgdg120+1)
-- Dumped by pg_dump version 13.16 (Debian 13.16-1.pgdg120+1)

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
-- Name: decision_nodes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.decision_nodes (
    id bigint NOT NULL,
    content text,
    "position" integer,
    decision_tree_id bigint,
    user_id bigint,
    parent_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    url character varying,
    url_confirmed boolean DEFAULT false NOT NULL
);


ALTER TABLE public.decision_nodes OWNER TO postgres;

--
-- Name: decision_nodes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.decision_nodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.decision_nodes_id_seq OWNER TO postgres;

--
-- Name: decision_nodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.decision_nodes_id_seq OWNED BY public.decision_nodes.id;


--
-- Name: decision_trees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.decision_trees (
    id bigint NOT NULL,
    title character varying,
    description text,
    user_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.decision_trees OWNER TO postgres;

--
-- Name: decision_trees_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.decision_trees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.decision_trees_id_seq OWNER TO postgres;

--
-- Name: decision_trees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.decision_trees_id_seq OWNED BY public.decision_trees.id;


--
-- Name: node_votes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.node_votes (
    id bigint NOT NULL,
    vote_type character varying,
    decision_node_id bigint,
    user_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.node_votes OWNER TO postgres;

--
-- Name: node_votes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.node_votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.node_votes_id_seq OWNER TO postgres;

--
-- Name: node_votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.node_votes_id_seq OWNED BY public.node_votes.id;


--
-- Name: decision_nodes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.decision_nodes ALTER COLUMN id SET DEFAULT nextval('public.decision_nodes_id_seq'::regclass);


--
-- Name: decision_trees id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.decision_trees ALTER COLUMN id SET DEFAULT nextval('public.decision_trees_id_seq'::regclass);


--
-- Name: node_votes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_votes ALTER COLUMN id SET DEFAULT nextval('public.node_votes_id_seq'::regclass);


--
-- Data for Name: decision_nodes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.decision_nodes (id, content, "position", decision_tree_id, user_id, parent_id, created_at, updated_at, url, url_confirmed) FROM stdin;
1	Root Decision	1	1	1	\N	2025-06-10 21:37:15.477154	2025-06-10 21:37:15.477154	\N	f
2	Child Decision	1	1	1	1	2025-06-10 21:37:15.50794	2025-06-10 21:37:15.50794	\N	f
3	grand sun	1	1	1	2	2025-06-10 22:56:53.713867	2025-06-10 22:56:53.713867	\N	f
4	brother child	2	1	1	1	2025-06-10 22:57:11.961505	2025-06-10 22:57:11.961505	\N	f
\.


--
-- Data for Name: decision_trees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.decision_trees (id, title, description, user_id, created_at, updated_at) FROM stdin;
1	Test Decision Tree	A test decision tree	1	2025-06-10 21:37:15.442722	2025-06-10 21:37:15.442722
\.


--
-- Data for Name: node_votes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.node_votes (id, vote_type, decision_node_id, user_id, created_at, updated_at) FROM stdin;
1	like	2	1	2025-06-10 21:37:16.850956	2025-06-10 21:37:16.850956
\.


--
-- Name: decision_nodes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.decision_nodes_id_seq', 4, true);


--
-- Name: decision_trees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.decision_trees_id_seq', 1, true);


--
-- Name: node_votes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.node_votes_id_seq', 1, true);


--
-- Name: decision_nodes decision_nodes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.decision_nodes
    ADD CONSTRAINT decision_nodes_pkey PRIMARY KEY (id);


--
-- Name: decision_trees decision_trees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.decision_trees
    ADD CONSTRAINT decision_trees_pkey PRIMARY KEY (id);


--
-- Name: node_votes node_votes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_votes
    ADD CONSTRAINT node_votes_pkey PRIMARY KEY (id);


--
-- Name: index_decision_nodes_on_decision_tree_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_decision_nodes_on_decision_tree_id ON public.decision_nodes USING btree (decision_tree_id);


--
-- Name: index_decision_nodes_on_parent_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_decision_nodes_on_parent_id ON public.decision_nodes USING btree (parent_id);


--
-- Name: index_decision_nodes_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_decision_nodes_on_user_id ON public.decision_nodes USING btree (user_id);


--
-- Name: index_decision_trees_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_decision_trees_on_user_id ON public.decision_trees USING btree (user_id);


--
-- Name: index_node_votes_on_decision_node_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_node_votes_on_decision_node_id ON public.node_votes USING btree (decision_node_id);


--
-- Name: index_node_votes_on_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX index_node_votes_on_user_id ON public.node_votes USING btree (user_id);


--
-- Name: decision_trees fk_rails_3dc66832d0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.decision_trees
    ADD CONSTRAINT fk_rails_3dc66832d0 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: node_votes fk_rails_567353c0e9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_votes
    ADD CONSTRAINT fk_rails_567353c0e9 FOREIGN KEY (decision_node_id) REFERENCES public.decision_nodes(id);


--
-- Name: decision_nodes fk_rails_7cc9f13401; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.decision_nodes
    ADD CONSTRAINT fk_rails_7cc9f13401 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: decision_nodes fk_rails_982297d6f6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.decision_nodes
    ADD CONSTRAINT fk_rails_982297d6f6 FOREIGN KEY (parent_id) REFERENCES public.decision_nodes(id);


--
-- Name: node_votes fk_rails_a68d761f89; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.node_votes
    ADD CONSTRAINT fk_rails_a68d761f89 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: decision_nodes fk_rails_ad0ad8d232; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.decision_nodes
    ADD CONSTRAINT fk_rails_ad0ad8d232 FOREIGN KEY (decision_tree_id) REFERENCES public.decision_trees(id);


--
-- PostgreSQL database dump complete
--

