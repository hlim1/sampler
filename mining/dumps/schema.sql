--
-- PostgreSQL database dump
--

SET client_encoding = 'UNICODE';
SET check_function_bodies = false;

SET search_path = public, pg_catalog;

ALTER TABLE ONLY public.build DROP CONSTRAINT "$1";
ALTER TABLE ONLY public.build DROP CONSTRAINT build_distribution;
ALTER TABLE ONLY public.build_suppress DROP CONSTRAINT build_suppress_id;
ALTER TABLE ONLY public.run DROP CONSTRAINT run_build_id;
ALTER TABLE ONLY public.deployment DROP CONSTRAINT deployment_pkey;
ALTER TABLE ONLY public.distribution DROP CONSTRAINT distribution_pkey;
ALTER TABLE ONLY public.run_suppress DROP CONSTRAINT run_suppress_pkey;
ALTER TABLE ONLY public.run DROP CONSTRAINT run_pkey;
ALTER TABLE ONLY public.build DROP CONSTRAINT build_application_name_key;
ALTER TABLE ONLY public.build DROP CONSTRAINT build_pkey;
DROP INDEX public.run_exit_signal;
DROP INDEX public.run_run_id_build_id;
DROP INDEX public.run_build_id;
DROP TABLE public.deployment;
DROP TABLE public.distribution;
DROP TABLE public.build_suppress;
DROP TABLE public.run_suppress;
DROP TABLE public.run;
DROP TABLE public.build;
DROP PROCEDURAL LANGUAGE plpgsql;
DROP FUNCTION public.plpgsql_call_handler();
--
-- TOC entry 21 (OID 14352816)
-- Name: plpgsql_call_handler(); Type: FUNC PROCEDURAL LANGUAGE; Schema: public; Owner: postgres
--

CREATE FUNCTION plpgsql_call_handler() RETURNS language_handler
    AS '$libdir/plpgsql', 'plpgsql_call_handler'
    LANGUAGE c;


--
-- TOC entry 20 (OID 14352817)
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: public; Owner: 
--

CREATE TRUSTED PROCEDURAL LANGUAGE plpgsql HANDLER plpgsql_call_handler;


--
-- TOC entry 5 (OID 2101557)
-- Name: build; Type: TABLE; Schema: public; Owner: liblit
--

CREATE TABLE build (
    build_id serial NOT NULL,
    application_name character varying(50) NOT NULL,
    application_version character varying(50) NOT NULL,
    application_release character varying(50) NOT NULL,
    build_distribution character varying(50) NOT NULL,
    build_date timestamp without time zone NOT NULL,
    deployment_name character varying(50) NOT NULL
);


--
-- TOC entry 6 (OID 2101560)
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
-- TOC entry 7 (OID 2101566)
-- Name: run_suppress; Type: TABLE; Schema: public; Owner: liblit
--

CREATE TABLE run_suppress (
    run_id character varying(24) NOT NULL,
    reason character varying(255) NOT NULL
);


--
-- TOC entry 8 (OID 2101568)
-- Name: build_suppress; Type: TABLE; Schema: public; Owner: liblit
--

CREATE TABLE build_suppress (
    build_id integer NOT NULL,
    reason character varying(255) NOT NULL
);


--
-- TOC entry 9 (OID 2101572)
-- Name: distribution; Type: TABLE; Schema: public; Owner: liblit
--

CREATE TABLE distribution (
    distribution_name character varying(50) NOT NULL
);


--
-- TOC entry 10 (OID 32934615)
-- Name: deployment; Type: TABLE; Schema: public; Owner: liblit
--

CREATE TABLE deployment (
    deployment_name character varying(50) NOT NULL
);


--
-- TOC entry 13 (OID 2118965)
-- Name: run_build_id; Type: INDEX; Schema: public; Owner: liblit
--

CREATE INDEX run_build_id ON run USING btree (build_id);


--
-- TOC entry 16 (OID 2118966)
-- Name: run_run_id_build_id; Type: INDEX; Schema: public; Owner: liblit
--

CREATE INDEX run_run_id_build_id ON run USING btree (run_id, build_id);


--
-- TOC entry 14 (OID 2118967)
-- Name: run_exit_signal; Type: INDEX; Schema: public; Owner: liblit
--

CREATE INDEX run_exit_signal ON run USING btree (exit_signal);


--
-- TOC entry 12 (OID 2118968)
-- Name: build_pkey; Type: CONSTRAINT; Schema: public; Owner: liblit
--

ALTER TABLE ONLY build
    ADD CONSTRAINT build_pkey PRIMARY KEY (build_id);


--
-- TOC entry 11 (OID 2118970)
-- Name: build_application_name_key; Type: CONSTRAINT; Schema: public; Owner: liblit
--

ALTER TABLE ONLY build
    ADD CONSTRAINT build_application_name_key UNIQUE (application_name, application_version, application_release, build_distribution);


--
-- TOC entry 15 (OID 2118972)
-- Name: run_pkey; Type: CONSTRAINT; Schema: public; Owner: liblit
--

ALTER TABLE ONLY run
    ADD CONSTRAINT run_pkey PRIMARY KEY (run_id);


--
-- TOC entry 17 (OID 2118974)
-- Name: run_suppress_pkey; Type: CONSTRAINT; Schema: public; Owner: liblit
--

ALTER TABLE ONLY run_suppress
    ADD CONSTRAINT run_suppress_pkey PRIMARY KEY (run_id);


--
-- TOC entry 18 (OID 2118976)
-- Name: distribution_pkey; Type: CONSTRAINT; Schema: public; Owner: liblit
--

ALTER TABLE ONLY distribution
    ADD CONSTRAINT distribution_pkey PRIMARY KEY (distribution_name);


--
-- TOC entry 19 (OID 32934617)
-- Name: deployment_pkey; Type: CONSTRAINT; Schema: public; Owner: liblit
--

ALTER TABLE ONLY deployment
    ADD CONSTRAINT deployment_pkey PRIMARY KEY (deployment_name);


--
-- TOC entry 24 (OID 2118980)
-- Name: run_build_id; Type: FK CONSTRAINT; Schema: public; Owner: liblit
--

ALTER TABLE ONLY run
    ADD CONSTRAINT run_build_id FOREIGN KEY (build_id) REFERENCES build(build_id);


--
-- TOC entry 25 (OID 2118984)
-- Name: build_suppress_id; Type: FK CONSTRAINT; Schema: public; Owner: liblit
--

ALTER TABLE ONLY build_suppress
    ADD CONSTRAINT build_suppress_id FOREIGN KEY (build_id) REFERENCES build(build_id);


--
-- TOC entry 22 (OID 2118988)
-- Name: build_distribution; Type: FK CONSTRAINT; Schema: public; Owner: liblit
--

ALTER TABLE ONLY build
    ADD CONSTRAINT build_distribution FOREIGN KEY (build_distribution) REFERENCES distribution(distribution_name);


--
-- TOC entry 23 (OID 268567849)
-- Name: $1; Type: FK CONSTRAINT; Schema: public; Owner: liblit
--

ALTER TABLE ONLY build
    ADD CONSTRAINT "$1" FOREIGN KEY (deployment_name) REFERENCES deployment(deployment_name);


--
-- TOC entry 3 (OID 2200)
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

-- COMMENT ON SCHEMA public IS 'Standard public namespace';


