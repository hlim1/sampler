--
-- PostgreSQL database dump
--

SET search_path = public, pg_catalog;

ALTER TABLE ONLY public.build DROP CONSTRAINT build_distribution;
ALTER TABLE ONLY public.build_suppress DROP CONSTRAINT build_suppress_id;
ALTER TABLE ONLY public.run DROP CONSTRAINT run_build_id;
ALTER TABLE ONLY public.scheme DROP CONSTRAINT scheme_pkey;
ALTER TABLE ONLY public.distribution DROP CONSTRAINT distribution_pkey;
ALTER TABLE ONLY public.run_suppress DROP CONSTRAINT run_suppress_pkey;
ALTER TABLE ONLY public.run DROP CONSTRAINT run_pkey;
ALTER TABLE ONLY public.build DROP CONSTRAINT build_application_name_key;
ALTER TABLE ONLY public.build DROP CONSTRAINT build_pkey;
DROP INDEX public.run_exit_signal;
DROP INDEX public.run_run_id_build_id;
DROP INDEX public.run_build_id;
DROP TABLE public.distribution;
DROP TABLE public.foo;
DROP TABLE public.build_suppress;
DROP TABLE public.run_suppress;
DROP TABLE public.run;
DROP TABLE public.build;
DROP TABLE public.scheme;
--
-- TOC entry 4 (OID 62143717)
-- Name: scheme; Type: TABLE; Schema: public; Owner: liblit
--

CREATE TABLE scheme (
    scheme_name character varying(16) NOT NULL,
    predicates_per_site smallint NOT NULL,
    CONSTRAINT scheme_predicates_per_site CHECK ((predicates_per_site > 0))
);


--
-- TOC entry 5 (OID 62143722)
-- Name: build; Type: TABLE; Schema: public; Owner: liblit
--

CREATE TABLE build (
    build_id serial NOT NULL,
    application_name character varying(50) NOT NULL,
    application_version character varying(50) NOT NULL,
    application_release character varying(50) NOT NULL,
    build_distribution character varying(50) NOT NULL,
    build_date timestamp without time zone NOT NULL
);


--
-- TOC entry 6 (OID 62143725)
-- Name: run; Type: TABLE; Schema: public; Owner: liblit
--

CREATE TABLE run (
    run_id character varying(24) NOT NULL,
    build_id integer NOT NULL,
    "version" character varying(255),
    sparsity integer NOT NULL,
    exit_signal smallint NOT NULL,
    exit_status smallint NOT NULL,
    date timestamp without time zone NOT NULL,
    CONSTRAINT run_exit_choice CHECK (((exit_status = 0) OR (exit_signal = 0))),
    CONSTRAINT run_exit_signal CHECK ((exit_signal >= 0)),
    CONSTRAINT run_exit_status CHECK ((exit_status >= 0)),
    CONSTRAINT run_sparsity CHECK ((sparsity > 0))
);


--
-- TOC entry 7 (OID 62143731)
-- Name: run_suppress; Type: TABLE; Schema: public; Owner: liblit
--

CREATE TABLE run_suppress (
    run_id character varying(24) NOT NULL,
    reason character varying(255) NOT NULL
);


--
-- TOC entry 8 (OID 62144182)
-- Name: build_suppress; Type: TABLE; Schema: public; Owner: liblit
--

CREATE TABLE build_suppress (
    build_id integer NOT NULL,
    reason character varying(255) NOT NULL
);


--
-- TOC entry 9 (OID 62228194)
-- Name: foo; Type: TABLE; Schema: public; Owner: liblit
--

CREATE TABLE foo (
    date timestamp without time zone
);


--
-- TOC entry 10 (OID 62228287)
-- Name: distribution; Type: TABLE; Schema: public; Owner: liblit
--

CREATE TABLE distribution (
    distribution_name character varying(50) NOT NULL
);


--
-- TOC entry 14 (OID 62143733)
-- Name: run_build_id; Type: INDEX; Schema: public; Owner: liblit
--

CREATE INDEX run_build_id ON run USING btree (build_id);


--
-- TOC entry 17 (OID 62143734)
-- Name: run_run_id_build_id; Type: INDEX; Schema: public; Owner: liblit
--

CREATE INDEX run_run_id_build_id ON run USING btree (run_id, build_id);


--
-- TOC entry 15 (OID 62143735)
-- Name: run_exit_signal; Type: INDEX; Schema: public; Owner: liblit
--

CREATE INDEX run_exit_signal ON run USING btree (exit_signal);


--
-- TOC entry 13 (OID 62143738)
-- Name: build_pkey; Type: CONSTRAINT; Schema: public; Owner: liblit
--

ALTER TABLE ONLY build
    ADD CONSTRAINT build_pkey PRIMARY KEY (build_id);


--
-- TOC entry 12 (OID 62143740)
-- Name: build_application_name_key; Type: CONSTRAINT; Schema: public; Owner: liblit
--

ALTER TABLE ONLY build
    ADD CONSTRAINT build_application_name_key UNIQUE (application_name, application_version, application_release, build_distribution);


--
-- TOC entry 16 (OID 62143742)
-- Name: run_pkey; Type: CONSTRAINT; Schema: public; Owner: liblit
--

ALTER TABLE ONLY run
    ADD CONSTRAINT run_pkey PRIMARY KEY (run_id);


--
-- TOC entry 18 (OID 62143744)
-- Name: run_suppress_pkey; Type: CONSTRAINT; Schema: public; Owner: liblit
--

ALTER TABLE ONLY run_suppress
    ADD CONSTRAINT run_suppress_pkey PRIMARY KEY (run_id);


--
-- TOC entry 19 (OID 62228289)
-- Name: distribution_pkey; Type: CONSTRAINT; Schema: public; Owner: liblit
--

ALTER TABLE ONLY distribution
    ADD CONSTRAINT distribution_pkey PRIMARY KEY (distribution_name);


--
-- TOC entry 11 (OID 62228368)
-- Name: scheme_pkey; Type: CONSTRAINT; Schema: public; Owner: liblit
--

ALTER TABLE ONLY scheme
    ADD CONSTRAINT scheme_pkey PRIMARY KEY (scheme_name);


--
-- TOC entry 21 (OID 62143746)
-- Name: run_build_id; Type: FK CONSTRAINT; Schema: public; Owner: liblit
--

ALTER TABLE ONLY run
    ADD CONSTRAINT run_build_id FOREIGN KEY (build_id) REFERENCES build(build_id);


--
-- TOC entry 22 (OID 62144493)
-- Name: build_suppress_id; Type: FK CONSTRAINT; Schema: public; Owner: liblit
--

ALTER TABLE ONLY build_suppress
    ADD CONSTRAINT build_suppress_id FOREIGN KEY (build_id) REFERENCES build(build_id);


--
-- TOC entry 20 (OID 62228431)
-- Name: build_distribution; Type: FK CONSTRAINT; Schema: public; Owner: liblit
--

ALTER TABLE ONLY build
    ADD CONSTRAINT build_distribution FOREIGN KEY (build_distribution) REFERENCES distribution(distribution_name);


--
-- TOC entry 2 (OID 2200)
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

-- COMMENT ON SCHEMA public IS 'Standard public namespace';


