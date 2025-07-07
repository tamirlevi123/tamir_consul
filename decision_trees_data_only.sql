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

--
-- Data for Name: decision_trees; Type: TABLE DATA; Schema: public; Owner: postgres
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE public.decision_trees DISABLE TRIGGER ALL;

COPY public.decision_trees (id, title, description, user_id, created_at, updated_at) FROM stdin;
1	Test Decision Tree	A test decision tree	1	2025-06-10 21:37:15.442722	2025-06-10 21:37:15.442722
\.


ALTER TABLE public.decision_trees ENABLE TRIGGER ALL;

--
-- Data for Name: decision_nodes; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE public.decision_nodes DISABLE TRIGGER ALL;

COPY public.decision_nodes (id, content, "position", decision_tree_id, user_id, parent_id, created_at, updated_at, url, url_confirmed) FROM stdin;
1	Root Decision	1	1	1	\N	2025-06-10 21:37:15.477154	2025-06-10 21:37:15.477154	\N	f
2	Child Decision	1	1	1	1	2025-06-10 21:37:15.50794	2025-06-10 21:37:15.50794	\N	f
3	grand sun	1	1	1	2	2025-06-10 22:56:53.713867	2025-06-10 22:56:53.713867	\N	f
4	brother child	2	1	1	1	2025-06-10 22:57:11.961505	2025-06-10 22:57:11.961505	\N	f
\.


ALTER TABLE public.decision_nodes ENABLE TRIGGER ALL;

--
-- Data for Name: node_votes; Type: TABLE DATA; Schema: public; Owner: postgres
--

ALTER TABLE public.node_votes DISABLE TRIGGER ALL;

COPY public.node_votes (id, vote_type, decision_node_id, user_id, created_at, updated_at) FROM stdin;
1	like	2	1	2025-06-10 21:37:16.850956	2025-06-10 21:37:16.850956
\.


ALTER TABLE public.node_votes ENABLE TRIGGER ALL;

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
-- PostgreSQL database dump complete
--

