SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.8

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
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."audit_log_entries" ("instance_id", "id", "payload", "created_at", "ip_address") FROM stdin;
00000000-0000-0000-0000-000000000000	17fe39f0-cd69-439c-84db-072f500fef78	{"action":"user_confirmation_requested","actor_id":"1792c931-1071-49ac-b636-08ceea11c70c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-26 01:52:20.438116+00	
00000000-0000-0000-0000-000000000000	185ec24c-02ff-483a-acb3-13eebec030fb	{"action":"user_confirmation_requested","actor_id":"1792c931-1071-49ac-b636-08ceea11c70c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-26 01:54:43.880471+00	
00000000-0000-0000-0000-000000000000	a8ad5d42-43d8-4856-8e67-922778ce49e3	{"action":"user_confirmation_requested","actor_id":"1792c931-1071-49ac-b636-08ceea11c70c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-26 01:58:44.237302+00	
00000000-0000-0000-0000-000000000000	2b71a697-5a42-4cf4-8272-05d2a3544155	{"action":"user_signedup","actor_id":"1792c931-1071-49ac-b636-08ceea11c70c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"team"}	2025-01-26 01:59:00.876735+00	
00000000-0000-0000-0000-000000000000	8705e915-1be1-4b2d-bc9c-63d23758ec1f	{"action":"user_repeated_signup","actor_id":"1792c931-1071-49ac-b636-08ceea11c70c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-26 02:10:36.693205+00	
00000000-0000-0000-0000-000000000000	87f34063-f701-4a24-8e61-0b26e34e2910	{"action":"user_repeated_signup","actor_id":"1792c931-1071-49ac-b636-08ceea11c70c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-26 02:11:00.4732+00	
00000000-0000-0000-0000-000000000000	2e6ad582-51bf-4614-abba-e387f5d9b04b	{"action":"user_repeated_signup","actor_id":"1792c931-1071-49ac-b636-08ceea11c70c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-26 02:12:12.660364+00	
00000000-0000-0000-0000-000000000000	576bd400-3162-4a76-81fc-4a2a13612261	{"action":"user_repeated_signup","actor_id":"1792c931-1071-49ac-b636-08ceea11c70c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-26 02:12:22.744914+00	
00000000-0000-0000-0000-000000000000	f4b91623-93e8-4fda-be54-33faebec36a8	{"action":"user_repeated_signup","actor_id":"1792c931-1071-49ac-b636-08ceea11c70c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-26 02:14:14.347353+00	
00000000-0000-0000-0000-000000000000	39ff1da4-ca9a-4219-bd32-a0927ef30e35	{"action":"user_repeated_signup","actor_id":"1792c931-1071-49ac-b636-08ceea11c70c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-26 02:16:26.432223+00	
00000000-0000-0000-0000-000000000000	07cb3676-e5c8-4042-96c4-1697c390f5bc	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"rileywheadon@gmail.com","user_id":"1792c931-1071-49ac-b636-08ceea11c70c","user_phone":""}}	2025-01-26 02:19:51.386387+00	
00000000-0000-0000-0000-000000000000	2fb03d83-deae-4230-8590-62fbfc4fee79	{"action":"user_confirmation_requested","actor_id":"672d24e1-d9c5-4a07-a6ad-99b5742d8929","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-26 02:20:02.167993+00	
00000000-0000-0000-0000-000000000000	98d2ba67-87d8-4581-aadf-c584daf6d10b	{"action":"user_signedup","actor_id":"672d24e1-d9c5-4a07-a6ad-99b5742d8929","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"team"}	2025-01-26 02:20:16.630981+00	
00000000-0000-0000-0000-000000000000	ce9deb9d-f86c-43d3-b5bc-cb547ec97f32	{"action":"login","actor_id":"672d24e1-d9c5-4a07-a6ad-99b5742d8929","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-01-26 02:20:56.211749+00	
00000000-0000-0000-0000-000000000000	00f7c1e2-4bca-4598-8608-313dd4158250	{"action":"login","actor_id":"672d24e1-d9c5-4a07-a6ad-99b5742d8929","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-01-26 02:21:50.772509+00	
00000000-0000-0000-0000-000000000000	8519a659-5607-4d46-89d9-cfc1afbdecf9	{"action":"login","actor_id":"672d24e1-d9c5-4a07-a6ad-99b5742d8929","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-01-26 02:24:12.217086+00	
00000000-0000-0000-0000-000000000000	29ed7f1f-afb2-4ebd-b7f3-3dcc8304cd76	{"action":"login","actor_id":"672d24e1-d9c5-4a07-a6ad-99b5742d8929","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-01-26 02:24:33.868413+00	
00000000-0000-0000-0000-000000000000	1dde1c6a-f8a3-4b6a-879e-707969ae7814	{"action":"login","actor_id":"672d24e1-d9c5-4a07-a6ad-99b5742d8929","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-01-26 02:25:39.997997+00	
00000000-0000-0000-0000-000000000000	c0f3599e-73ba-41f9-bacb-6aad0b60d074	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"rileywheadon@gmail.com","user_id":"672d24e1-d9c5-4a07-a6ad-99b5742d8929","user_phone":""}}	2025-01-26 03:27:54.681559+00	
00000000-0000-0000-0000-000000000000	4cf2c6d7-2d81-49ae-8466-6f87c2e684d4	{"action":"user_confirmation_requested","actor_id":"c253b432-7093-41f3-b043-f4c1e6a0ed25","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-26 03:28:09.621323+00	
00000000-0000-0000-0000-000000000000	b832d871-dfac-4b13-9b7b-657dc42696ec	{"action":"user_signedup","actor_id":"c253b432-7093-41f3-b043-f4c1e6a0ed25","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"team"}	2025-01-26 03:28:53.470964+00	
00000000-0000-0000-0000-000000000000	9c17555b-e0de-486e-a2e7-7df6b6db5103	{"action":"login","actor_id":"c253b432-7093-41f3-b043-f4c1e6a0ed25","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2025-01-26 03:30:37.026605+00	
00000000-0000-0000-0000-000000000000	701cc929-aebb-4ae0-a38b-3bb5fc426d6d	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"rileywheadon@gmail.com","user_id":"c253b432-7093-41f3-b043-f4c1e6a0ed25","user_phone":""}}	2025-01-26 03:31:46.334576+00	
00000000-0000-0000-0000-000000000000	10867599-ed76-4545-bfc8-8dedd48bd4af	{"action":"user_confirmation_requested","actor_id":"002f0f7c-a4c3-4e5d-9bce-5927fd98c98b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-26 03:31:59.514556+00	
00000000-0000-0000-0000-000000000000	270ebd19-5c2e-4b71-ac78-86c3e66ab798	{"action":"user_signedup","actor_id":"002f0f7c-a4c3-4e5d-9bce-5927fd98c98b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"team"}	2025-01-26 03:32:10.369632+00	
00000000-0000-0000-0000-000000000000	a375b19c-23cb-4660-b73c-cc64ca0109b0	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"rileywheadon@gmail.com","user_id":"002f0f7c-a4c3-4e5d-9bce-5927fd98c98b","user_phone":""}}	2025-01-26 03:34:15.611387+00	
00000000-0000-0000-0000-000000000000	d7622958-38a0-4044-886c-d6643854d58a	{"action":"user_confirmation_requested","actor_id":"e543c15d-0798-497e-a08c-d9513a2b0a2a","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-26 03:34:32.858191+00	
00000000-0000-0000-0000-000000000000	ef2b5924-11a9-47ca-8a6f-6ce17be50e94	{"action":"user_signedup","actor_id":"e543c15d-0798-497e-a08c-d9513a2b0a2a","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"team"}	2025-01-26 03:34:44.250861+00	
00000000-0000-0000-0000-000000000000	703410f1-b0c2-4e5c-9383-2c0cbdd4bb88	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"rileywheadon@gmail.com","user_id":"e543c15d-0798-497e-a08c-d9513a2b0a2a","user_phone":""}}	2025-01-26 03:51:32.102389+00	
00000000-0000-0000-0000-000000000000	ce7ef02c-e7d8-4280-bcf3-9df1d96c70d7	{"action":"user_confirmation_requested","actor_id":"91201fd1-ddae-40c4-a97f-8ba8a2a39aa6","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-26 03:51:46.197143+00	
00000000-0000-0000-0000-000000000000	f3e7b9bb-b977-4011-81cf-ea262498ad82	{"action":"user_signedup","actor_id":"91201fd1-ddae-40c4-a97f-8ba8a2a39aa6","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"team"}	2025-01-26 03:51:56.24958+00	
00000000-0000-0000-0000-000000000000	8424ed99-8665-423d-97e0-57d5c2054289	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"rileywheadon@gmail.com","user_id":"91201fd1-ddae-40c4-a97f-8ba8a2a39aa6","user_phone":""}}	2025-01-26 04:02:29.536416+00	
00000000-0000-0000-0000-000000000000	3517e82a-6b97-4967-9c39-54ee5cbc6d00	{"action":"user_confirmation_requested","actor_id":"a4f2ebf3-63e0-4fa2-b9fd-761b4bc49f68","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-26 04:05:53.306166+00	
00000000-0000-0000-0000-000000000000	f89304ee-09ce-4802-b321-160d54375fac	{"action":"user_signedup","actor_id":"a4f2ebf3-63e0-4fa2-b9fd-761b4bc49f68","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"team"}	2025-01-26 04:06:09.49919+00	
00000000-0000-0000-0000-000000000000	7adfba69-7043-46f3-a4aa-016c5ccb9d98	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"rileywheadon@gmail.com","user_id":"a4f2ebf3-63e0-4fa2-b9fd-761b4bc49f68","user_phone":""}}	2025-01-26 04:09:39.475456+00	
00000000-0000-0000-0000-000000000000	df9c6be9-fd05-4cba-9d9e-c834b52ebe2e	{"action":"user_confirmation_requested","actor_id":"991c63ae-4e17-41f6-9a91-3911e022d336","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-26 04:09:50.432652+00	
00000000-0000-0000-0000-000000000000	196fe459-9b4a-4c9f-869d-48850602616c	{"action":"user_signedup","actor_id":"991c63ae-4e17-41f6-9a91-3911e022d336","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"team"}	2025-01-26 04:10:00.512043+00	
00000000-0000-0000-0000-000000000000	8a411635-2528-4a8d-a901-97c1670cc2e2	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"rileywheadon@gmail.com","user_id":"991c63ae-4e17-41f6-9a91-3911e022d336","user_phone":""}}	2025-01-26 04:23:56.386006+00	
00000000-0000-0000-0000-000000000000	7467ce92-dd3c-4012-b391-6d0abf27f24c	{"action":"user_confirmation_requested","actor_id":"d5e7409a-a441-4c79-b2df-2fb3059dff5f","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-26 04:24:23.861381+00	
00000000-0000-0000-0000-000000000000	71c61e71-8ac1-44c8-9ab2-58e4ae91c72f	{"action":"user_signedup","actor_id":"d5e7409a-a441-4c79-b2df-2fb3059dff5f","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"team"}	2025-01-26 04:24:49.959195+00	
00000000-0000-0000-0000-000000000000	c45b58fc-9fd4-42ac-bd65-51e66de483c9	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"rileywheadon@gmail.com","user_id":"d5e7409a-a441-4c79-b2df-2fb3059dff5f","user_phone":""}}	2025-01-26 17:37:26.716495+00	
00000000-0000-0000-0000-000000000000	449bcc6c-5e39-4dd5-8f5d-455f88a6c0fd	{"action":"user_confirmation_requested","actor_id":"60e174c9-9a6f-46a4-ac65-d111de08c688","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-26 17:37:45.078163+00	
00000000-0000-0000-0000-000000000000	67f3b7f4-7cc9-4d76-8a79-36c17aac358f	{"action":"user_signedup","actor_id":"60e174c9-9a6f-46a4-ac65-d111de08c688","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"team"}	2025-01-26 17:38:14.704708+00	
00000000-0000-0000-0000-000000000000	445f87c1-e832-420c-91b8-65e305f8ca85	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"rileywheadon@gmail.com","user_id":"60e174c9-9a6f-46a4-ac65-d111de08c688","user_phone":""}}	2025-01-26 17:41:16.456853+00	
00000000-0000-0000-0000-000000000000	5f88cef9-49c6-4f5d-b6f7-d0582a4373f0	{"action":"user_confirmation_requested","actor_id":"aa2c8cea-7ed8-45bd-8a66-016ee8305c4b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-26 17:41:29.75266+00	
00000000-0000-0000-0000-000000000000	ec03e549-08a2-4e91-96d0-2e7589357fbf	{"action":"user_signedup","actor_id":"aa2c8cea-7ed8-45bd-8a66-016ee8305c4b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"team"}	2025-01-26 17:41:46.659542+00	
00000000-0000-0000-0000-000000000000	744b17c8-b1e1-4420-9e80-3a1d0cc7806e	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"rileywheadon@gmail.com","user_id":"aa2c8cea-7ed8-45bd-8a66-016ee8305c4b","user_phone":""}}	2025-01-26 17:43:28.188989+00	
00000000-0000-0000-0000-000000000000	015dace5-9eea-4255-ab9a-63a5b27dbd08	{"action":"user_confirmation_requested","actor_id":"339a700a-4a18-41f7-911f-6c80675f75a2","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-26 17:43:43.156943+00	
00000000-0000-0000-0000-000000000000	719a04c5-defa-4b1a-a3ba-9f335eee372e	{"action":"user_confirmation_requested","actor_id":"339a700a-4a18-41f7-911f-6c80675f75a2","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-26 17:45:42.313523+00	
00000000-0000-0000-0000-000000000000	196c6276-90ae-47b5-9d25-1f4dd376a172	{"action":"user_signedup","actor_id":"339a700a-4a18-41f7-911f-6c80675f75a2","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"team"}	2025-01-26 17:46:06.283911+00	
00000000-0000-0000-0000-000000000000	405c84e4-93f2-4316-8be2-cec6bf9c30a8	{"action":"user_recovery_requested","actor_id":"339a700a-4a18-41f7-911f-6c80675f75a2","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-26 17:48:13.40733+00	
00000000-0000-0000-0000-000000000000	e7f9a8f0-217a-4822-8943-02d0684a97ed	{"action":"login","actor_id":"339a700a-4a18-41f7-911f-6c80675f75a2","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-26 17:53:58.42352+00	
00000000-0000-0000-0000-000000000000	774efa29-8406-4ca9-8bfa-bfaec3ab8406	{"action":"user_recovery_requested","actor_id":"339a700a-4a18-41f7-911f-6c80675f75a2","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-26 17:57:02.083547+00	
00000000-0000-0000-0000-000000000000	6408d53c-15df-4578-811b-6390786f3d42	{"action":"login","actor_id":"339a700a-4a18-41f7-911f-6c80675f75a2","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-26 17:57:29.108174+00	
00000000-0000-0000-0000-000000000000	d012b432-8490-4e89-ba5a-dc032a5bcfc4	{"action":"user_recovery_requested","actor_id":"339a700a-4a18-41f7-911f-6c80675f75a2","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-26 17:58:17.949252+00	
00000000-0000-0000-0000-000000000000	23751d6b-ad84-4084-8bf6-5c680e16971d	{"action":"login","actor_id":"339a700a-4a18-41f7-911f-6c80675f75a2","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-26 17:58:26.656133+00	
00000000-0000-0000-0000-000000000000	1c5164dd-bca1-43c2-abaf-ab9999addf87	{"action":"user_recovery_requested","actor_id":"339a700a-4a18-41f7-911f-6c80675f75a2","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-26 18:02:35.956799+00	
00000000-0000-0000-0000-000000000000	18758a15-18a9-492d-b84c-c097289c125d	{"action":"login","actor_id":"339a700a-4a18-41f7-911f-6c80675f75a2","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-26 18:03:25.126096+00	
00000000-0000-0000-0000-000000000000	9b5ec4c7-7f92-4fbe-9fbb-9fa4e2edc711	{"action":"user_recovery_requested","actor_id":"339a700a-4a18-41f7-911f-6c80675f75a2","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-26 18:04:36.468947+00	
00000000-0000-0000-0000-000000000000	4bf0c7ab-4fbf-4428-a0d3-983c95dad21c	{"action":"login","actor_id":"339a700a-4a18-41f7-911f-6c80675f75a2","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-26 18:04:44.849822+00	
00000000-0000-0000-0000-000000000000	c9171ed0-0c02-481a-9deb-b0932f9e0222	{"action":"user_recovery_requested","actor_id":"339a700a-4a18-41f7-911f-6c80675f75a2","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-26 18:05:41.426844+00	
00000000-0000-0000-0000-000000000000	d308c460-f568-4d44-9d14-3638d808d297	{"action":"login","actor_id":"339a700a-4a18-41f7-911f-6c80675f75a2","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-26 18:05:53.42549+00	
00000000-0000-0000-0000-000000000000	ee2539c5-a672-40db-9fb6-0e3e738df37f	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"rileywheadon@gmail.com","user_id":"339a700a-4a18-41f7-911f-6c80675f75a2","user_phone":""}}	2025-01-26 18:08:41.414372+00	
00000000-0000-0000-0000-000000000000	9b51121f-5364-4ccc-9f58-f103b50d383b	{"action":"user_confirmation_requested","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-26 18:09:06.390449+00	
00000000-0000-0000-0000-000000000000	67cd21d9-7ccb-4a53-a0f0-09ea79a70ad2	{"action":"user_signedup","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"team"}	2025-01-26 18:10:02.397213+00	
00000000-0000-0000-0000-000000000000	f3738488-a95e-4d72-ab6d-1259aec84df7	{"action":"user_recovery_requested","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-26 18:15:13.366778+00	
00000000-0000-0000-0000-000000000000	95e0e2c8-b8b1-4ffc-aecc-fc644fe8d071	{"action":"login","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-26 18:15:27.96442+00	
00000000-0000-0000-0000-000000000000	9b10c7b4-e81d-4e6f-9d5f-7d90297b61e9	{"action":"user_recovery_requested","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-26 18:16:49.351039+00	
00000000-0000-0000-0000-000000000000	48670d1a-af64-4b5e-8ddd-6ba5f5ef4b70	{"action":"login","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-26 18:16:57.615301+00	
00000000-0000-0000-0000-000000000000	a513e1be-a09c-49a7-abaa-56184108a8ae	{"action":"user_recovery_requested","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-26 18:17:49.631231+00	
00000000-0000-0000-0000-000000000000	d14f5e77-5646-40ba-8f7f-72928abab191	{"action":"login","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-26 18:17:57.544351+00	
00000000-0000-0000-0000-000000000000	9d35dd81-824a-4a30-864d-eb1a154eebfb	{"action":"user_recovery_requested","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-26 18:20:11.225387+00	
00000000-0000-0000-0000-000000000000	0e50fb15-10dd-48be-81e6-3890787db132	{"action":"login","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-26 18:20:32.059619+00	
00000000-0000-0000-0000-000000000000	ae932fa7-c8c8-49a5-9464-d5706f4432ec	{"action":"user_recovery_requested","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-26 18:21:51.853735+00	
00000000-0000-0000-0000-000000000000	358ab322-3644-4e8d-a32f-409a6b11d99b	{"action":"login","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-26 18:22:05.161752+00	
00000000-0000-0000-0000-000000000000	2591cb08-6396-463c-a3a6-d2a9bb8950e0	{"action":"user_recovery_requested","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-26 18:22:55.169158+00	
00000000-0000-0000-0000-000000000000	6483c1ee-0219-4644-b6e5-e237bf1cfaaf	{"action":"login","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-26 18:23:03.614539+00	
00000000-0000-0000-0000-000000000000	801681ce-cafe-47ee-a0e3-2ffe11f8fcb1	{"action":"user_recovery_requested","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-26 18:57:47.805597+00	
00000000-0000-0000-0000-000000000000	cd4deeb1-56b8-492b-a915-902ff003721c	{"action":"user_recovery_requested","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-26 22:35:39.15915+00	
00000000-0000-0000-0000-000000000000	4afaa58b-ad03-482e-9d81-bd344736cb7b	{"action":"login","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-26 22:35:55.135929+00	
00000000-0000-0000-0000-000000000000	8c6bc20b-b622-4290-86a7-428104794676	{"action":"logout","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-26 22:44:08.424108+00	
00000000-0000-0000-0000-000000000000	60a93763-6b32-4a26-8383-a8c253a7f5a5	{"action":"user_recovery_requested","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-26 22:44:32.55442+00	
00000000-0000-0000-0000-000000000000	830349bf-6a7f-49fa-abca-7e9e87fe34c1	{"action":"login","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-26 22:44:44.14538+00	
00000000-0000-0000-0000-000000000000	77c2db48-8ad2-4a37-866b-d465a6c90b58	{"action":"logout","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-26 22:44:49.189069+00	
00000000-0000-0000-0000-000000000000	c45ff533-39a0-4213-a6d8-5520f5be6f43	{"action":"user_confirmation_requested","actor_id":"6992798a-4670-4fab-96f1-374679e07956","actor_username":"admin@polll.org","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-26 22:44:57.102251+00	
00000000-0000-0000-0000-000000000000	4ffdb3eb-52b7-4562-a9bc-0e70d270624e	{"action":"user_confirmation_requested","actor_id":"6992798a-4670-4fab-96f1-374679e07956","actor_username":"admin@polll.org","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-26 22:49:15.729174+00	
00000000-0000-0000-0000-000000000000	e016fa23-853c-4a4d-8b14-0c5ba20024c2	{"action":"user_recovery_requested","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-26 23:01:46.321593+00	
00000000-0000-0000-0000-000000000000	b8a25a9a-15ac-43c2-92fd-d8e760d66f73	{"action":"login","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-26 23:02:54.875346+00	
00000000-0000-0000-0000-000000000000	fd1b9f0a-f92b-4ed2-91a8-a3de783ba8a2	{"action":"logout","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-26 23:05:19.01354+00	
00000000-0000-0000-0000-000000000000	829d4cfd-0522-492d-832d-3e124c5b291e	{"action":"user_recovery_requested","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-26 23:20:40.284245+00	
00000000-0000-0000-0000-000000000000	36e63547-d21b-4146-b7fd-791df63fde7d	{"action":"user_recovery_requested","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-26 23:25:17.803973+00	
00000000-0000-0000-0000-000000000000	8096f4fd-b1be-4c8b-9060-4570a35b3c71	{"action":"login","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-26 23:25:33.968807+00	
00000000-0000-0000-0000-000000000000	97470d2d-10c2-46e0-b0de-d00c66c37b4b	{"action":"logout","actor_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-26 23:46:16.63458+00	
00000000-0000-0000-0000-000000000000	3d87e3d6-5c01-4d62-b94e-f4cb25021e28	{"action":"user_confirmation_requested","actor_id":"6992798a-4670-4fab-96f1-374679e07956","actor_username":"admin@polll.org","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-26 23:49:57.932373+00	
00000000-0000-0000-0000-000000000000	156c1e0f-ce63-46cd-9840-e0b72638cbe0	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"rileywheadon@gmail.com","user_id":"4a7a4b46-80f4-426d-bf88-3d5eebd4869b","user_phone":""}}	2025-01-27 00:17:04.567831+00	
00000000-0000-0000-0000-000000000000	daf2f8ce-2530-4436-ac9d-88a177578e4d	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"admin@polll.org","user_id":"6992798a-4670-4fab-96f1-374679e07956","user_phone":""}}	2025-01-27 00:17:04.584495+00	
00000000-0000-0000-0000-000000000000	882ff61c-a991-49f0-9a2d-2125ac6d07ae	{"action":"user_confirmation_requested","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-01-27 03:45:41.904128+00	
00000000-0000-0000-0000-000000000000	89073163-20d0-4046-92d8-49cd0cb3a17a	{"action":"user_signedup","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"team"}	2025-01-27 03:45:54.556476+00	
00000000-0000-0000-0000-000000000000	90c4b3c9-0f82-4687-85dd-d5b800e4f9bd	{"action":"user_recovery_requested","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-27 03:46:30.528413+00	
00000000-0000-0000-0000-000000000000	e2ed7416-1763-4085-ac48-24a231edc339	{"action":"login","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-27 03:46:41.802434+00	
00000000-0000-0000-0000-000000000000	5d8ff9ef-b2ef-4ea8-be95-068a7adff6a0	{"action":"user_recovery_requested","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-27 03:47:39.298818+00	
00000000-0000-0000-0000-000000000000	4c0d0719-bd81-44fe-8742-9dc1f0318ada	{"action":"login","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-27 03:47:49.607497+00	
00000000-0000-0000-0000-000000000000	1d8f7cca-cda1-4b52-8122-6989f5ef9ecc	{"action":"user_recovery_requested","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-27 03:48:46.251677+00	
00000000-0000-0000-0000-000000000000	b46b76b9-1475-498e-a15a-118284c402e7	{"action":"login","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-27 03:48:54.001171+00	
00000000-0000-0000-0000-000000000000	8f919735-5faa-4961-9bb7-92f1ecd83cf3	{"action":"user_recovery_requested","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-27 03:50:17.08553+00	
00000000-0000-0000-0000-000000000000	6a621c53-9859-4692-9520-4a8ffc4c67ab	{"action":"login","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-27 03:50:25.42205+00	
00000000-0000-0000-0000-000000000000	a8ab3496-84db-4050-a215-8270eb7feca4	{"action":"logout","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-27 03:51:23.851517+00	
00000000-0000-0000-0000-000000000000	874095b2-f37f-4763-bf43-e7e825355117	{"action":"user_recovery_requested","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-27 03:51:29.326098+00	
00000000-0000-0000-0000-000000000000	c632ebf8-7641-4b28-93f4-c056abebe592	{"action":"login","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-27 03:51:37.194791+00	
00000000-0000-0000-0000-000000000000	f500eb15-7cc6-43d7-a62a-b5b3320611be	{"action":"logout","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-27 03:52:57.310896+00	
00000000-0000-0000-0000-000000000000	5941f488-cc14-4252-85b0-6e7796ed48af	{"action":"user_recovery_requested","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-27 03:54:08.238808+00	
00000000-0000-0000-0000-000000000000	b598e349-4188-421d-ac39-6beb4ac7ad89	{"action":"login","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-27 03:54:20.737805+00	
00000000-0000-0000-0000-000000000000	6c51be12-422c-4cc3-90d7-fcb187a60c86	{"action":"user_recovery_requested","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-30 00:54:19.69373+00	
00000000-0000-0000-0000-000000000000	913ad6d7-e6a0-48a4-971b-b79e3345944d	{"action":"login","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-30 00:55:04.64884+00	
00000000-0000-0000-0000-000000000000	df8e900f-cf10-40cf-a5be-ede2b715dc98	{"action":"user_recovery_requested","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-01-30 05:36:11.753222+00	
00000000-0000-0000-0000-000000000000	1f9f30bf-3d70-41a5-ba10-ad883a0c46ac	{"action":"login","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-01-30 05:38:01.658802+00	
00000000-0000-0000-0000-000000000000	9ce105d5-1df5-40d9-a8ce-ad2a03bde937	{"action":"token_refreshed","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-02 04:04:25.640891+00	
00000000-0000-0000-0000-000000000000	2ffc155c-15b9-4527-b5fd-b591f1b591ba	{"action":"token_revoked","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-02 04:04:25.655185+00	
00000000-0000-0000-0000-000000000000	d5fb7f4a-1891-48cc-988f-798f138c6eb9	{"action":"logout","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-02 04:04:26.055896+00	
00000000-0000-0000-0000-000000000000	0b0bf595-8dd9-45bc-b461-b5b547d2dc9d	{"action":"user_recovery_requested","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-02-02 04:04:30.394715+00	
00000000-0000-0000-0000-000000000000	faad3156-b009-4b5f-858b-e2cbfcad21fa	{"action":"login","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-02 04:07:28.901077+00	
00000000-0000-0000-0000-000000000000	9fa1d965-83d9-4e30-b956-c76f121434d2	{"action":"user_recovery_requested","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-02-02 04:08:03.605658+00	
00000000-0000-0000-0000-000000000000	36afcb8f-4eb1-44cb-8456-31b7eecba8b4	{"action":"login","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-02 04:08:51.837412+00	
00000000-0000-0000-0000-000000000000	34d4fc7e-ecd1-48a5-af77-2b46d269fd76	{"action":"logout","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-02 04:09:33.813767+00	
00000000-0000-0000-0000-000000000000	261d9817-78f0-43a5-8ff8-64b4fe69191a	{"action":"user_recovery_requested","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-02-02 04:09:39.229513+00	
00000000-0000-0000-0000-000000000000	6afd7262-334a-47b7-a476-afbe8b6af9e6	{"action":"login","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-02 04:10:09.950929+00	
00000000-0000-0000-0000-000000000000	64b8c4ff-8e75-409d-8f18-fea46df0e705	{"action":"token_refreshed","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-02 21:11:23.376907+00	
00000000-0000-0000-0000-000000000000	c054fcc4-70c1-4c9a-ae92-b8ab8640123e	{"action":"token_revoked","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-02 21:11:23.388788+00	
00000000-0000-0000-0000-000000000000	516a289d-5375-46e7-9208-fb0583267b69	{"action":"logout","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-02 21:11:23.499714+00	
00000000-0000-0000-0000-000000000000	9902f432-5cdb-42b6-af46-26abc42cf022	{"action":"user_recovery_requested","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-02-02 21:11:27.517861+00	
00000000-0000-0000-0000-000000000000	a451700f-e5ff-41f0-b74f-af1b1bb2f6f3	{"action":"login","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-02 21:12:23.747216+00	
00000000-0000-0000-0000-000000000000	4bfdd036-c760-4529-aef1-1a128ef38c5c	{"action":"logout","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-02 21:25:38.611017+00	
00000000-0000-0000-0000-000000000000	49fcbabd-c70e-4f85-a5e2-ef1b89342920	{"action":"user_recovery_requested","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-02-02 21:25:42.590213+00	
00000000-0000-0000-0000-000000000000	e6b3617c-67ac-4c3a-9fa7-c100c21c3861	{"action":"login","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-02 21:25:53.112303+00	
00000000-0000-0000-0000-000000000000	78d05c4e-8ab5-4ee9-bb77-453d25dac8d5	{"action":"logout","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-02 21:26:59.86858+00	
00000000-0000-0000-0000-000000000000	907be5ce-e9d7-40e5-89b9-f38d323ad08d	{"action":"user_recovery_requested","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-02-02 21:27:03.979618+00	
00000000-0000-0000-0000-000000000000	21092356-48ab-4fe7-a981-344db159f88a	{"action":"login","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-02 21:27:18.210983+00	
00000000-0000-0000-0000-000000000000	d5487288-fc8a-409c-8949-37352c9045a2	{"action":"logout","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-02 21:28:35.97356+00	
00000000-0000-0000-0000-000000000000	712dcb53-2e4e-4a51-97f7-0b3324fa14bc	{"action":"user_recovery_requested","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-02-02 21:28:57.847592+00	
00000000-0000-0000-0000-000000000000	aa0532f2-74d9-4249-bbbc-024aa71781d7	{"action":"login","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-02 21:29:07.160675+00	
00000000-0000-0000-0000-000000000000	afc030e3-e6aa-4cae-904b-0d646a7ca2a8	{"action":"token_refreshed","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-03 05:02:10.99682+00	
00000000-0000-0000-0000-000000000000	0235bc57-0921-4109-911c-0206ffd9bfbe	{"action":"token_revoked","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-03 05:02:11.010447+00	
00000000-0000-0000-0000-000000000000	a388551e-b9ce-472d-9a0e-1ed1ca884c4a	{"action":"token_refreshed","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-03 06:05:40.438886+00	
00000000-0000-0000-0000-000000000000	79a668b0-0ed6-4581-8186-d52bd68c8e82	{"action":"token_revoked","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-03 06:05:40.452625+00	
00000000-0000-0000-0000-000000000000	0f17bb7f-08d1-4e7c-8256-1a4da959cc14	{"action":"token_refreshed","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-03 17:25:05.258355+00	
00000000-0000-0000-0000-000000000000	a0768c74-d524-48ed-aa6b-cada3ca5249e	{"action":"token_revoked","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-03 17:25:05.276298+00	
00000000-0000-0000-0000-000000000000	3a48b070-7846-4276-bbc2-a40cc3f6bd99	{"action":"token_refreshed","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-03 22:37:11.06878+00	
00000000-0000-0000-0000-000000000000	dcc63221-01f3-422f-8cd6-27ed7c3377bc	{"action":"token_revoked","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-03 22:37:11.084689+00	
00000000-0000-0000-0000-000000000000	cc8d2044-83e9-4185-ab15-5d9154eec880	{"action":"token_refreshed","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-03 22:38:32.956902+00	
00000000-0000-0000-0000-000000000000	5e327fd6-2c51-40c5-927a-4a4955c632dc	{"action":"token_refreshed","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-03 22:40:28.861862+00	
00000000-0000-0000-0000-000000000000	799abf2d-e877-4149-878b-0e30921da935	{"action":"token_refreshed","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-03 22:45:35.687462+00	
00000000-0000-0000-0000-000000000000	687be258-91db-4a1d-aa21-448c9aabc142	{"action":"token_refreshed","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-03 22:45:52.611675+00	
00000000-0000-0000-0000-000000000000	1c2b8b1b-4b7b-4cc9-98e4-35d93aeaeaf9	{"action":"token_refreshed","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-03 22:47:00.760068+00	
00000000-0000-0000-0000-000000000000	bb373521-e6ad-4e25-b8b4-b4465b9a0756	{"action":"token_refreshed","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-03 22:47:03.238239+00	
00000000-0000-0000-0000-000000000000	a1ee1273-46ad-433a-b710-258819351bec	{"action":"token_refreshed","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-03 22:47:20.652365+00	
00000000-0000-0000-0000-000000000000	efd580f1-7e6f-4b55-a919-39de86824b55	{"action":"token_refreshed","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-03 22:50:52.384131+00	
00000000-0000-0000-0000-000000000000	1dfafbea-2832-43af-8955-98603b8b8dc8	{"action":"token_refreshed","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-03 22:51:23.880086+00	
00000000-0000-0000-0000-000000000000	53eee75a-3517-4d45-a732-d12d43bf3843	{"action":"token_refreshed","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-04 07:40:21.165852+00	
00000000-0000-0000-0000-000000000000	99dfc9a5-8730-4e52-a89d-fd82ed5573aa	{"action":"token_revoked","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-04 07:40:21.194474+00	
00000000-0000-0000-0000-000000000000	94d7f0bc-c229-410b-a38d-e216f82763ee	{"action":"token_refreshed","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-04 09:24:12.218402+00	
00000000-0000-0000-0000-000000000000	1e3d930a-a552-4482-9013-b04b82bfe231	{"action":"token_revoked","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-04 09:24:12.222891+00	
00000000-0000-0000-0000-000000000000	abb8374f-09c2-4b58-92f3-07e75015831c	{"action":"user_confirmation_requested","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2025-02-04 09:29:50.288601+00	
00000000-0000-0000-0000-000000000000	b6d2d9ed-8ca4-4969-a046-834dd4f14e29	{"action":"user_signedup","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"team"}	2025-02-04 09:30:17.504728+00	
00000000-0000-0000-0000-000000000000	bf2d45d5-e375-45e3-b96e-e225ede962b3	{"action":"logout","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-04 09:44:53.25291+00	
00000000-0000-0000-0000-000000000000	b370d7be-d959-451e-9fb0-e11888841469	{"action":"user_recovery_requested","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-02-04 09:44:57.114942+00	
00000000-0000-0000-0000-000000000000	37db04eb-168b-4168-9351-684b2af784ed	{"action":"login","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-04 09:45:07.51536+00	
00000000-0000-0000-0000-000000000000	cc86d84e-38bf-4bad-a3a8-2563adcdd62d	{"action":"logout","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-04 09:45:58.442337+00	
00000000-0000-0000-0000-000000000000	38ca4678-632c-48c2-8185-0f9247f70958	{"action":"user_recovery_requested","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-02-04 09:46:01.65492+00	
00000000-0000-0000-0000-000000000000	6feca225-9a4f-4951-90d7-58220c76ba5b	{"action":"login","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-04 09:46:21.682221+00	
00000000-0000-0000-0000-000000000000	46b636dc-ebca-40a3-8738-53a96b89ab4f	{"action":"token_refreshed","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-04 11:04:02.389885+00	
00000000-0000-0000-0000-000000000000	a8a8faa0-0b0a-4f53-8a78-a60476af0a96	{"action":"token_revoked","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-04 11:04:02.392168+00	
00000000-0000-0000-0000-000000000000	6142f05f-a068-46ee-8ca4-735e94b8a34e	{"action":"token_refreshed","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-04 21:12:22.280465+00	
00000000-0000-0000-0000-000000000000	a8525a2c-7894-4741-9066-8ed292076357	{"action":"token_revoked","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-04 21:12:22.29521+00	
00000000-0000-0000-0000-000000000000	d22cc5cd-d6f5-470a-85b1-bded6c0f560a	{"action":"token_refreshed","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-04 21:38:39.778747+00	
00000000-0000-0000-0000-000000000000	4a3302ae-ee56-4147-bb54-f4f9efff9343	{"action":"token_revoked","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-04 21:38:39.782055+00	
00000000-0000-0000-0000-000000000000	e2247a94-0331-48f7-b5b7-6ddf2e4cfca4	{"action":"token_refreshed","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-04 22:12:18.813976+00	
00000000-0000-0000-0000-000000000000	fc937a17-d76e-4f1a-8e9d-a9153e5dd4ad	{"action":"token_revoked","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-04 22:12:18.816122+00	
00000000-0000-0000-0000-000000000000	075b3c0f-e186-43e2-b6ff-41c98a9bbb98	{"action":"token_refreshed","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-04 23:14:17.390191+00	
00000000-0000-0000-0000-000000000000	9fa94d7b-0ac8-4fa7-a731-76839c1da105	{"action":"token_revoked","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-04 23:14:17.394239+00	
00000000-0000-0000-0000-000000000000	ed856ddf-9246-4f4f-af91-6475d9d6a519	{"action":"token_refreshed","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-05 00:38:26.4906+00	
00000000-0000-0000-0000-000000000000	1c8e0807-5279-4c7e-920e-affd84f28ae1	{"action":"token_revoked","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-05 00:38:26.49224+00	
00000000-0000-0000-0000-000000000000	c0643fe0-1e0f-4313-8616-61d66266f579	{"action":"token_refreshed","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-05 01:39:55.296665+00	
00000000-0000-0000-0000-000000000000	20ea9880-0482-4350-857d-a0fd099e65fc	{"action":"token_revoked","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-05 01:39:55.299821+00	
00000000-0000-0000-0000-000000000000	02b8b743-867a-4d12-800e-6df89daea079	{"action":"token_refreshed","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-05 01:44:36.440502+00	
00000000-0000-0000-0000-000000000000	0571ce8e-e9d7-4d78-aafa-c001beb2c710	{"action":"token_revoked","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-05 01:44:36.44278+00	
00000000-0000-0000-0000-000000000000	a5680b8e-d592-44bc-a693-f80835199ac0	{"action":"token_refreshed","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-05 02:42:27.67186+00	
00000000-0000-0000-0000-000000000000	ee77645a-fd74-45bd-9a6d-cb905587cedd	{"action":"token_revoked","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-05 02:42:27.680493+00	
00000000-0000-0000-0000-000000000000	7720ef6d-8c90-48d0-bfd9-39d9261a6ff5	{"action":"token_refreshed","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-05 02:45:13.037969+00	
00000000-0000-0000-0000-000000000000	d6734913-d8d2-4627-8d31-f3de5561a63b	{"action":"token_revoked","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-05 02:45:13.04017+00	
00000000-0000-0000-0000-000000000000	d051a128-31b2-42af-acdf-3725bb7d0f64	{"action":"token_refreshed","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-05 03:45:13.899093+00	
00000000-0000-0000-0000-000000000000	9d6fc3a7-f039-49a6-9ed1-545089b72d4c	{"action":"token_revoked","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-05 03:45:13.901036+00	
00000000-0000-0000-0000-000000000000	97bfd7e8-434b-4592-a433-8fb9bbdd9d90	{"action":"user_recovery_requested","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-02-05 03:55:18.044289+00	
00000000-0000-0000-0000-000000000000	5fc2c4bd-e34e-4c94-9526-59a001997d5f	{"action":"login","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"account"}	2025-02-05 03:55:27.036518+00	
00000000-0000-0000-0000-000000000000	735dc5f0-969d-4174-8ea1-f1c0aa29c5d3	{"action":"token_refreshed","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-05 04:56:16.27487+00	
00000000-0000-0000-0000-000000000000	e008b57d-5145-45bc-ab89-bfba182a5b66	{"action":"token_revoked","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-05 04:56:16.275738+00	
00000000-0000-0000-0000-000000000000	dff01f2a-216a-4714-a9f0-8746fc9f6004	{"action":"token_refreshed","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-05 06:22:14.548158+00	
00000000-0000-0000-0000-000000000000	b6967b43-c53b-4ec7-b45d-076e907d96cf	{"action":"token_revoked","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-05 06:22:14.550096+00	
00000000-0000-0000-0000-000000000000	285f93af-1b72-4de4-9432-fc8775f8cf56	{"action":"token_refreshed","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-05 07:22:15.800657+00	
00000000-0000-0000-0000-000000000000	8bea4077-4ecc-482a-a82d-980224f6f631	{"action":"token_revoked","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-05 07:22:15.81345+00	
00000000-0000-0000-0000-000000000000	564fb431-916f-42e3-a266-a32b59d690dd	{"action":"token_refreshed","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-05 08:22:23.13401+00	
00000000-0000-0000-0000-000000000000	f7f0f72f-44cb-4fac-923e-096654e7a902	{"action":"token_revoked","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-05 08:22:23.137888+00	
00000000-0000-0000-0000-000000000000	580418f4-fe0b-4fd8-aea3-0cc3b10b5acc	{"action":"token_refreshed","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-05 20:14:20.865476+00	
00000000-0000-0000-0000-000000000000	876b7e29-455c-427a-a035-3cc874d5d6d0	{"action":"token_revoked","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-05 20:14:20.886355+00	
00000000-0000-0000-0000-000000000000	78957f92-3c0b-4f95-aed4-9bced8b583a4	{"action":"token_refreshed","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-05 23:13:34.878203+00	
00000000-0000-0000-0000-000000000000	db1691cb-f1ba-4fe7-8d05-5faa605b8076	{"action":"token_revoked","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-05 23:13:34.892317+00	
00000000-0000-0000-0000-000000000000	6ce84f1b-0bda-4531-ac18-f41cb8b1d984	{"action":"user_recovery_requested","actor_id":"486835a4-f89b-4069-a477-a2a4c0eb0b8c","actor_username":"rileywheadon@gmail.com","actor_via_sso":false,"log_type":"user"}	2025-02-06 18:42:39.003084+00	
00000000-0000-0000-0000-000000000000	d7dee9e9-01f1-40fd-ad92-80d0bde53aad	{"action":"token_refreshed","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-06 21:56:43.427914+00	
00000000-0000-0000-0000-000000000000	e5d9858c-e1de-4574-bb5a-0538ad02a63c	{"action":"token_revoked","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-06 21:56:43.438618+00	
00000000-0000-0000-0000-000000000000	ef647874-b0f2-413a-8143-77ab52881298	{"action":"token_refreshed","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-06 22:56:41.734553+00	
00000000-0000-0000-0000-000000000000	22f06562-9c14-420a-95b1-ac99d0add0f0	{"action":"token_revoked","actor_id":"d09b89ce-b6fa-46f9-9046-eeec478af94d","actor_username":"mattdehaas28@gmail.com","actor_via_sso":false,"log_type":"token"}	2025-02-06 22:56:41.749353+00	
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."flow_state" ("id", "user_id", "auth_code", "code_challenge_method", "code_challenge", "provider_type", "provider_access_token", "provider_refresh_token", "created_at", "updated_at", "authentication_method", "auth_code_issued_at") FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."users" ("instance_id", "id", "aud", "role", "email", "encrypted_password", "email_confirmed_at", "invited_at", "confirmation_token", "confirmation_sent_at", "recovery_token", "recovery_sent_at", "email_change_token_new", "email_change", "email_change_sent_at", "last_sign_in_at", "raw_app_meta_data", "raw_user_meta_data", "is_super_admin", "created_at", "updated_at", "phone", "phone_confirmed_at", "phone_change", "phone_change_token", "phone_change_sent_at", "email_change_token_current", "email_change_confirm_status", "banned_until", "reauthentication_token", "reauthentication_sent_at", "is_sso_user", "deleted_at", "is_anonymous") FROM stdin;
00000000-0000-0000-0000-000000000000	d09b89ce-b6fa-46f9-9046-eeec478af94d	authenticated	authenticated	mattdehaas28@gmail.com	$2a$10$VTVxdwF398Tz5Ze6YFMZc.ep1IE9/53FsvCZP61alQKfUkp.QMk5S	2025-02-04 09:30:17.505336+00	\N		2025-02-04 09:29:50.290912+00		2025-02-05 03:55:18.050351+00			\N	2025-02-05 03:55:27.039561+00	{"provider": "email", "providers": ["email"]}	{"sub": "d09b89ce-b6fa-46f9-9046-eeec478af94d", "email": "mattdehaas28@gmail.com", "username": "Matt", "email_verified": true, "phone_verified": false}	\N	2025-02-04 09:29:50.263421+00	2025-02-06 22:56:41.757585+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	486835a4-f89b-4069-a477-a2a4c0eb0b8c	authenticated	authenticated	rileywheadon@gmail.com	$2a$10$cQE8NEoDVoZqQzzacoeRzeXTCe6BCZW/a8h./RLdgOJraxBq42Ni6	2025-01-27 03:45:54.55714+00	\N		2025-01-27 03:45:41.90679+00	54c52c2a7c9980733fdd81b472d2b17d88e7a367767efa10433121ac	2025-02-06 18:42:39.028731+00			\N	2025-02-02 21:29:07.162811+00	{"provider": "email", "providers": ["email"]}	{"sub": "486835a4-f89b-4069-a477-a2a4c0eb0b8c", "email": "rileywheadon@gmail.com", "username": "rileywheadon", "email_verified": true, "phone_verified": false}	\N	2025-01-27 03:45:41.888453+00	2025-02-06 18:42:40.326611+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."identities" ("provider_id", "user_id", "identity_data", "provider", "last_sign_in_at", "created_at", "updated_at", "id") FROM stdin;
486835a4-f89b-4069-a477-a2a4c0eb0b8c	486835a4-f89b-4069-a477-a2a4c0eb0b8c	{"sub": "486835a4-f89b-4069-a477-a2a4c0eb0b8c", "email": "rileywheadon@gmail.com", "username": "rileywheadon", "email_verified": true, "phone_verified": false}	email	2025-01-27 03:45:41.90138+00	2025-01-27 03:45:41.901435+00	2025-01-27 03:45:41.901435+00	989f45bf-9e50-4315-823c-0f9907714ebc
d09b89ce-b6fa-46f9-9046-eeec478af94d	d09b89ce-b6fa-46f9-9046-eeec478af94d	{"sub": "d09b89ce-b6fa-46f9-9046-eeec478af94d", "email": "mattdehaas28@gmail.com", "username": "Matt", "email_verified": true, "phone_verified": false}	email	2025-02-04 09:29:50.284228+00	2025-02-04 09:29:50.284287+00	2025-02-04 09:29:50.284287+00	ecf04bf5-f381-4f26-882c-81af9b865af9
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."instances" ("id", "uuid", "raw_base_config", "created_at", "updated_at") FROM stdin;
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."sessions" ("id", "user_id", "created_at", "updated_at", "factor_id", "aal", "not_after", "refreshed_at", "user_agent", "ip", "tag") FROM stdin;
d4992329-1172-449e-893c-27b247f1708d	486835a4-f89b-4069-a477-a2a4c0eb0b8c	2025-02-02 21:29:07.162894+00	2025-02-05 02:42:27.694113+00	\N	aal1	\N	2025-02-05 02:42:27.694039	python-httpx/0.28.1	128.189.69.250	\N
fa3418a5-c751-4ab8-ae0b-8e22bd52b6dd	d09b89ce-b6fa-46f9-9046-eeec478af94d	2025-02-04 09:46:21.684083+00	2025-02-05 03:45:13.907159+00	\N	aal1	\N	2025-02-05 03:45:13.907082	python-httpx/0.28.1	206.87.99.7	\N
0e157af5-2b7e-4262-b97e-6d90e47ce980	d09b89ce-b6fa-46f9-9046-eeec478af94d	2025-02-05 03:55:27.039627+00	2025-02-06 22:56:41.759446+00	\N	aal1	\N	2025-02-06 22:56:41.759375	python-httpx/0.28.1	206.87.98.147	\N
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."mfa_amr_claims" ("session_id", "created_at", "updated_at", "authentication_method", "id") FROM stdin;
fa3418a5-c751-4ab8-ae0b-8e22bd52b6dd	2025-02-04 09:46:21.685916+00	2025-02-04 09:46:21.685916+00	otp	af29a446-6cc7-4449-aab1-206d56ae7202
0e157af5-2b7e-4262-b97e-6d90e47ce980	2025-02-05 03:55:27.047352+00	2025-02-05 03:55:27.047352+00	otp	da3b04a4-ab2c-45bd-af09-d206fa4ee0fb
d4992329-1172-449e-893c-27b247f1708d	2025-02-02 21:29:07.165223+00	2025-02-02 21:29:07.165223+00	otp	9ac53646-ffaa-48dc-b5ea-8c3ba31285b3
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."mfa_factors" ("id", "user_id", "friendly_name", "factor_type", "status", "created_at", "updated_at", "secret", "phone", "last_challenged_at", "web_authn_credential", "web_authn_aaguid") FROM stdin;
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."mfa_challenges" ("id", "factor_id", "created_at", "verified_at", "ip_address", "otp_code", "web_authn_session_data") FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."one_time_tokens" ("id", "user_id", "token_type", "token_hash", "relates_to", "created_at", "updated_at") FROM stdin;
a88c3727-d638-4d3e-94e1-80bf939b33b7	486835a4-f89b-4069-a477-a2a4c0eb0b8c	recovery_token	54c52c2a7c9980733fdd81b472d2b17d88e7a367767efa10433121ac	rileywheadon@gmail.com	2025-02-06 18:42:40.365296	2025-02-06 18:42:40.365296
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."refresh_tokens" ("instance_id", "id", "token", "user_id", "revoked", "created_at", "updated_at", "parent", "session_id") FROM stdin;
00000000-0000-0000-0000-000000000000	53	GKBfsk9l7FqhZIjUvajy9Q	486835a4-f89b-4069-a477-a2a4c0eb0b8c	t	2025-02-02 21:29:07.163668+00	2025-02-03 05:02:11.011609+00	\N	d4992329-1172-449e-893c-27b247f1708d
00000000-0000-0000-0000-000000000000	54	5RVAmhIc3CV85S0uFfOw0Q	486835a4-f89b-4069-a477-a2a4c0eb0b8c	t	2025-02-03 05:02:11.01632+00	2025-02-03 06:05:40.453172+00	GKBfsk9l7FqhZIjUvajy9Q	d4992329-1172-449e-893c-27b247f1708d
00000000-0000-0000-0000-000000000000	55	vGcCa0WJ5041uqbtCPQZRQ	486835a4-f89b-4069-a477-a2a4c0eb0b8c	t	2025-02-03 06:05:40.460464+00	2025-02-03 17:25:05.276936+00	5RVAmhIc3CV85S0uFfOw0Q	d4992329-1172-449e-893c-27b247f1708d
00000000-0000-0000-0000-000000000000	56	ZfWq-qVY7YCVUOFljOC6-A	486835a4-f89b-4069-a477-a2a4c0eb0b8c	t	2025-02-03 17:25:05.285559+00	2025-02-03 22:37:11.085247+00	vGcCa0WJ5041uqbtCPQZRQ	d4992329-1172-449e-893c-27b247f1708d
00000000-0000-0000-0000-000000000000	57	VwLBVHzp9SHWRqckcGzxGQ	486835a4-f89b-4069-a477-a2a4c0eb0b8c	t	2025-02-03 22:37:11.09189+00	2025-02-04 07:40:21.195064+00	ZfWq-qVY7YCVUOFljOC6-A	d4992329-1172-449e-893c-27b247f1708d
00000000-0000-0000-0000-000000000000	58	Qn0NqGZyXprLiXVTrbJxGQ	486835a4-f89b-4069-a477-a2a4c0eb0b8c	t	2025-02-04 07:40:21.209755+00	2025-02-04 09:24:12.223437+00	VwLBVHzp9SHWRqckcGzxGQ	d4992329-1172-449e-893c-27b247f1708d
00000000-0000-0000-0000-000000000000	62	YPAtbohpJ7DM3hxUMPctOw	d09b89ce-b6fa-46f9-9046-eeec478af94d	t	2025-02-04 09:46:21.684759+00	2025-02-04 11:04:02.392727+00	\N	fa3418a5-c751-4ab8-ae0b-8e22bd52b6dd
00000000-0000-0000-0000-000000000000	59	F1QXOa-yLr4QMV5Hq3V6OA	486835a4-f89b-4069-a477-a2a4c0eb0b8c	t	2025-02-04 09:24:12.225781+00	2025-02-04 21:12:22.295779+00	Qn0NqGZyXprLiXVTrbJxGQ	d4992329-1172-449e-893c-27b247f1708d
00000000-0000-0000-0000-000000000000	63	R6M_g1IgLaiHcjrhGG0j-w	d09b89ce-b6fa-46f9-9046-eeec478af94d	t	2025-02-04 11:04:02.394221+00	2025-02-04 21:38:39.782639+00	YPAtbohpJ7DM3hxUMPctOw	fa3418a5-c751-4ab8-ae0b-8e22bd52b6dd
00000000-0000-0000-0000-000000000000	64	dP07C5KXAfsXTxJpJwU7gw	486835a4-f89b-4069-a477-a2a4c0eb0b8c	t	2025-02-04 21:12:22.300745+00	2025-02-04 22:12:18.816636+00	F1QXOa-yLr4QMV5Hq3V6OA	d4992329-1172-449e-893c-27b247f1708d
00000000-0000-0000-0000-000000000000	66	OkMS-BGBTcY7_lYjR-rjzg	486835a4-f89b-4069-a477-a2a4c0eb0b8c	t	2025-02-04 22:12:18.817831+00	2025-02-04 23:14:17.394776+00	dP07C5KXAfsXTxJpJwU7gw	d4992329-1172-449e-893c-27b247f1708d
00000000-0000-0000-0000-000000000000	67	oWNqmmyHCv6tOTElLpNmwQ	486835a4-f89b-4069-a477-a2a4c0eb0b8c	t	2025-02-04 23:14:17.396063+00	2025-02-05 00:38:26.493657+00	OkMS-BGBTcY7_lYjR-rjzg	d4992329-1172-449e-893c-27b247f1708d
00000000-0000-0000-0000-000000000000	68	lp_Gvz7vgu7ogiJ970KHew	486835a4-f89b-4069-a477-a2a4c0eb0b8c	t	2025-02-05 00:38:26.494253+00	2025-02-05 01:39:55.304295+00	oWNqmmyHCv6tOTElLpNmwQ	d4992329-1172-449e-893c-27b247f1708d
00000000-0000-0000-0000-000000000000	65	o-Fu18N31Q61KDJ-90oqgg	d09b89ce-b6fa-46f9-9046-eeec478af94d	t	2025-02-04 21:38:39.783928+00	2025-02-05 01:44:36.443289+00	R6M_g1IgLaiHcjrhGG0j-w	fa3418a5-c751-4ab8-ae0b-8e22bd52b6dd
00000000-0000-0000-0000-000000000000	69	Z5F1_6YzqQHQt_ER8-p35w	486835a4-f89b-4069-a477-a2a4c0eb0b8c	t	2025-02-05 01:39:55.306767+00	2025-02-05 02:42:27.681019+00	lp_Gvz7vgu7ogiJ970KHew	d4992329-1172-449e-893c-27b247f1708d
00000000-0000-0000-0000-000000000000	71	KJ2r0375Gdcv0y7gBDoHNQ	486835a4-f89b-4069-a477-a2a4c0eb0b8c	f	2025-02-05 02:42:27.68881+00	2025-02-05 02:42:27.68881+00	Z5F1_6YzqQHQt_ER8-p35w	d4992329-1172-449e-893c-27b247f1708d
00000000-0000-0000-0000-000000000000	70	ixW2c20srwuDqfH4mK1x5A	d09b89ce-b6fa-46f9-9046-eeec478af94d	t	2025-02-05 01:44:36.445029+00	2025-02-05 02:45:13.040733+00	o-Fu18N31Q61KDJ-90oqgg	fa3418a5-c751-4ab8-ae0b-8e22bd52b6dd
00000000-0000-0000-0000-000000000000	72	asSzyLj5s1Nl3lgonlbalg	d09b89ce-b6fa-46f9-9046-eeec478af94d	t	2025-02-05 02:45:13.042351+00	2025-02-05 03:45:13.901545+00	ixW2c20srwuDqfH4mK1x5A	fa3418a5-c751-4ab8-ae0b-8e22bd52b6dd
00000000-0000-0000-0000-000000000000	73	XLL0IlzdcNFn7p4_23t7kg	d09b89ce-b6fa-46f9-9046-eeec478af94d	f	2025-02-05 03:45:13.903068+00	2025-02-05 03:45:13.903068+00	asSzyLj5s1Nl3lgonlbalg	fa3418a5-c751-4ab8-ae0b-8e22bd52b6dd
00000000-0000-0000-0000-000000000000	74	TU_P5LxxQkB6meSdlX8eXQ	d09b89ce-b6fa-46f9-9046-eeec478af94d	t	2025-02-05 03:55:27.043797+00	2025-02-05 04:56:16.27623+00	\N	0e157af5-2b7e-4262-b97e-6d90e47ce980
00000000-0000-0000-0000-000000000000	75	4NNckULhqTpmMSbsRkPcKw	d09b89ce-b6fa-46f9-9046-eeec478af94d	t	2025-02-05 04:56:16.277296+00	2025-02-05 06:22:14.550558+00	TU_P5LxxQkB6meSdlX8eXQ	0e157af5-2b7e-4262-b97e-6d90e47ce980
00000000-0000-0000-0000-000000000000	76	zexVUSL7x1xIvGRdzPnsXQ	d09b89ce-b6fa-46f9-9046-eeec478af94d	t	2025-02-05 06:22:14.552198+00	2025-02-05 07:22:15.815432+00	4NNckULhqTpmMSbsRkPcKw	0e157af5-2b7e-4262-b97e-6d90e47ce980
00000000-0000-0000-0000-000000000000	77	AE4vHW_CmnzJD_RSSiH4Gg	d09b89ce-b6fa-46f9-9046-eeec478af94d	t	2025-02-05 07:22:15.824739+00	2025-02-05 08:22:23.138375+00	zexVUSL7x1xIvGRdzPnsXQ	0e157af5-2b7e-4262-b97e-6d90e47ce980
00000000-0000-0000-0000-000000000000	78	AZK72lJNryiqWO2UJUqNuA	d09b89ce-b6fa-46f9-9046-eeec478af94d	t	2025-02-05 08:22:23.140567+00	2025-02-05 20:14:20.887001+00	AE4vHW_CmnzJD_RSSiH4Gg	0e157af5-2b7e-4262-b97e-6d90e47ce980
00000000-0000-0000-0000-000000000000	79	soe_4abqVCVzQbP--ZDOsw	d09b89ce-b6fa-46f9-9046-eeec478af94d	t	2025-02-05 20:14:20.897104+00	2025-02-05 23:13:34.89286+00	AZK72lJNryiqWO2UJUqNuA	0e157af5-2b7e-4262-b97e-6d90e47ce980
00000000-0000-0000-0000-000000000000	80	-uivpUfJscDX8ZiokJITGQ	d09b89ce-b6fa-46f9-9046-eeec478af94d	t	2025-02-05 23:13:34.896865+00	2025-02-06 21:56:43.439226+00	soe_4abqVCVzQbP--ZDOsw	0e157af5-2b7e-4262-b97e-6d90e47ce980
00000000-0000-0000-0000-000000000000	81	IxyvM027issODRcqGxmpPw	d09b89ce-b6fa-46f9-9046-eeec478af94d	t	2025-02-06 21:56:43.448483+00	2025-02-06 22:56:41.749899+00	-uivpUfJscDX8ZiokJITGQ	0e157af5-2b7e-4262-b97e-6d90e47ce980
00000000-0000-0000-0000-000000000000	82	KxJU8-U_h7J9MPK-HpSFfQ	d09b89ce-b6fa-46f9-9046-eeec478af94d	f	2025-02-06 22:56:41.754717+00	2025-02-06 22:56:41.754717+00	IxyvM027issODRcqGxmpPw	0e157af5-2b7e-4262-b97e-6d90e47ce980
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."sso_providers" ("id", "resource_id", "created_at", "updated_at") FROM stdin;
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."saml_providers" ("id", "sso_provider_id", "entity_id", "metadata_xml", "metadata_url", "attribute_mapping", "created_at", "updated_at", "name_id_format") FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."saml_relay_states" ("id", "sso_provider_id", "request_id", "for_email", "redirect_to", "created_at", "updated_at", "flow_state_id") FROM stdin;
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY "auth"."sso_domains" ("id", "sso_provider_id", "domain", "created_at", "updated_at") FROM stdin;
\.


--
-- Data for Name: key; Type: TABLE DATA; Schema: pgsodium; Owner: supabase_admin
--

COPY "pgsodium"."key" ("id", "status", "created", "expires", "key_type", "key_id", "key_context", "name", "associated_data", "raw_key", "raw_key_nonce", "parent_key", "comment", "user_data") FROM stdin;
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."user" ("id", "username", "email", "created_at", "last_poll_created", "next_poll_allowed", "is_admin") FROM stdin;
3	rileywheadon	rileywheadon@gmail.com	2025-01-27 03:50:25.724999+00	2025-02-04 23:09:27.433111+00	2025-02-04 23:09:27.433111+00	t
4	Matt	mattdehaas28@gmail.com	2025-02-04 09:30:18.041384+00	2025-02-05 07:06:20.112982+00	2025-02-05 07:06:20.112982+00	t
\.


--
-- Data for Name: poll; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."poll" ("id", "created_at", "creator_id", "question", "poll_type", "is_pinned", "is_anonymous", "is_active") FROM stdin;
4	2025-01-30 00:56:04.731321+00	3	test choose one	CHOOSE_ONE	f	f	t
5	2025-01-30 00:56:14.235043+00	3	test choose many	CHOOSE_MANY	f	f	t
6	2025-01-30 00:56:20.963009+00	3	test scale	NUMERIC_SCALE	f	f	t
7	2025-01-30 00:56:29.865793+00	3	test ranked	RANKED_POLL	f	f	t
8	2025-01-30 00:56:39.129359+00	3	test tier list	TIER_LIST	f	f	t
9	2025-02-01 06:25:20.611231+00	3	number one best poll	RANKED_POLL	f	f	t
10	2025-02-01 07:42:19.099697+00	3	duplicate choose one	CHOOSE_ONE	f	f	t
11	2025-02-01 07:42:26.554681+00	3	duplicate choos emany	CHOOSE_MANY	f	f	t
12	2025-02-01 07:42:32.697859+00	3	euplicate scale	NUMERIC_SCALE	f	f	t
13	2025-02-01 07:42:41.98717+00	3	adslfaj	RANKED_POLL	f	f	t
14	2025-02-01 07:42:49.482675+00	3	fuckin tier	TIER_LIST	f	f	t
15	2025-02-02 21:13:13.388078+00	3	test the cooldown	CHOOSE_ONE	f	f	t
16	2025-02-02 21:15:41.160778+00	3	aldskfja	CHOOSE_ONE	f	f	t
17	2025-02-02 21:16:54.301368+00	3	another one	CHOOSE_ONE	f	f	t
18	2025-02-02 21:17:55.470567+00	3	pls	CHOOSE_MANY	f	f	t
19	2025-02-02 21:19:13.153364+00	3	alsfdkja	CHOOSE_ONE	f	f	t
21	2025-02-02 21:27:53.260659+00	3	THIS POLL SHOULD BE ANONYMOUS	NUMERIC_SCALE	f	t	t
22	2025-02-02 21:28:01.955873+00	3	THIS POLL SHOULD BE LOCKED	NUMERIC_SCALE	f	f	f
23	2025-02-03 03:59:40.263692+00	3	this poll is in UBC	NUMERIC_SCALE	f	f	t
24	2025-02-03 05:37:36.084634+00	3	cock and balls	NUMERIC_SCALE	f	f	t
25	2025-02-03 06:52:32.636837+00	3	anon in ubc	NUMERIC_SCALE	f	t	t
26	2025-02-04 10:00:21.179002+00	4	Deubg	CHOOSE_ONE	f	f	t
27	2025-02-04 22:02:57.18513+00	3	study spots on campus	TIER_LIST	f	f	t
20	2025-02-02 21:27:43.760005+00	3	THIS POLL SHOULD BE PINNED	NUMERIC_SCALE	t	f	t
28	2025-02-04 23:03:12.559773+00	3	test endpoints	NUMERIC_SCALE	f	f	t
29	2025-02-04 23:09:27.253752+00	3	test endpoints	NUMERIC_SCALE	f	f	t
30	2025-02-05 07:06:19.948615+00	4	Test Scale Input	NUMERIC_SCALE	f	f	t
\.


--
-- Data for Name: answer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."answer" ("id", "poll_id", "answer") FROM stdin;
7	4	1
8	4	2
9	4	3
10	5	1
11	5	2
12	5	3
13	7	1
14	7	2
15	7	3
16	8	1
17	8	2
18	8	3
19	9	fry
20	9	burger
21	9	yes
22	9	no
23	9	rapist
24	10	a
25	10	b
26	11	a
27	11	b
28	13	bab
29	13	asdkfj
30	13	asld
31	14	asl
32	14	a
33	15	a
34	15	b
35	16	sada
36	16	absd
37	17	a
38	17	b
39	18	a
40	18	b
41	19	sdk
42	19	fdkj
43	26	adsfa
44	26	fsdfasd
45	27	ikb basement
46	27	nest
47	27	allard
48	27	ICICS
49	27	ridington room
50	27	koerner
51	27	sauder
52	29	asdlkfj
53	29	babs
54	30	Hello
55	30	There
\.


--
-- Data for Name: board; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."board" ("id", "name", "primary") FROM stdin;
7	UBC	f
1	All	t
\.


--
-- Data for Name: comment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."comment" ("id", "created_at", "poll_id", "user_id", "parent_id", "comment") FROM stdin;
87	2025-02-03 00:26:17.391799+00	14	3	\N	this comment is also inappropriate
88	2025-02-03 04:29:11.868805+00	17	3	\N	nigger
92	2025-02-03 06:20:27.643669+00	4	3	\N	aa
93	2025-02-03 06:20:36.046274+00	4	3	\N	asdfasdf
94	2025-02-03 06:20:38.467584+00	4	3	\N	asdfa
95	2025-02-03 06:20:40.604626+00	4	3	\N	1231
96	2025-02-03 06:20:43.205751+00	4	3	\N	1212512
16	2025-01-31 05:30:59.354512+00	4	3	\N	test comment
97	2025-02-03 06:20:45.613151+00	4	3	\N	12312312
98	2025-02-03 06:20:48.184746+00	4	3	\N	12512512
99	2025-02-03 06:20:50.227882+00	4	3	\N	asdfadsf
23	2025-01-31 06:00:59.54462+00	4	3	\N	asdfasdfasdf
100	2025-02-03 06:20:52.526601+00	4	3	\N	1212412
25	2025-01-31 06:45:09.561831+00	4	3	\N	aa
101	2025-02-03 06:20:54.499883+00	4	3	\N	asdfasdf
27	2025-01-31 06:46:43.457732+00	4	3	\N	aaga
28	2025-01-31 06:48:02.884815+00	4	3	\N	aasd
102	2025-02-03 17:54:40.841219+00	23	3	\N	penis
103	2025-02-03 17:54:46.445668+00	23	3	102	dick
104	2025-02-05 00:06:23.618149+00	29	3	\N	Test comment
105	2025-02-05 00:10:19.26832+00	29	3	\N	another one
106	2025-02-05 00:10:48.663639+00	29	3	\N	aaldskfajsdf
107	2025-02-05 00:11:54.002101+00	29	3	\N	test
108	2025-02-05 00:12:04.465493+00	29	3	\N	asdfadsf
109	2025-02-05 00:12:18.002767+00	29	3	\N	asflasdkfj
110	2025-02-05 01:15:29.038241+00	29	3	109	test reply
69	2025-02-02 01:13:30.878504+00	14	3	\N	asdlfkja
70	2025-02-02 01:13:33.393018+00	14	3	\N	asdlfkja
71	2025-02-02 01:13:51.34859+00	14	3	\N	gagaga
72	2025-02-02 01:14:28.541856+00	14	3	\N	gagaga
74	2025-02-02 01:14:55.054808+00	13	3	\N	test
75	2025-02-02 01:15:10.728917+00	11	3	\N	babababa
\.


--
-- Data for Name: comment_report; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."comment_report" ("id", "created_at", "comment_id", "receiver_id", "creator_id", "handled") FROM stdin;
5	2025-02-03 04:29:14.858192+00	88	3	3	f
4	2025-02-03 00:26:19.963767+00	87	3	3	f
\.


--
-- Data for Name: response; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."response" ("id", "created_at", "user_id", "poll_id") FROM stdin;
1	2025-01-30 02:22:50.267293+00	3	4
2	2025-01-30 02:24:11.259437+00	3	4
3	2025-01-30 02:26:47.316371+00	3	4
4	2025-01-30 02:27:35.350151+00	3	4
5	2025-01-30 02:28:03.618818+00	3	4
6	2025-01-30 02:29:11.531953+00	3	4
7	2025-01-30 02:30:09.12758+00	3	4
8	2025-01-30 02:30:42.633791+00	3	4
9	2025-01-30 02:31:22.958382+00	3	4
10	2025-01-30 02:33:06.829386+00	3	4
11	2025-01-30 02:41:44.890946+00	3	4
12	2025-01-30 02:42:07.874083+00	3	4
13	2025-01-30 02:43:57.462892+00	3	4
14	2025-01-30 02:45:24.03153+00	3	4
15	2025-01-30 02:47:18.906309+00	3	4
16	2025-01-30 02:48:27.039419+00	3	4
17	2025-01-30 02:48:56.413876+00	3	4
18	2025-01-30 02:49:29.839166+00	3	4
19	2025-01-30 02:50:34.045487+00	3	4
20	2025-01-30 02:51:23.505179+00	3	4
21	2025-01-30 02:54:01.327607+00	3	5
22	2025-01-30 02:54:14.704303+00	3	5
23	2025-01-30 02:54:21.372698+00	3	5
24	2025-01-30 03:22:23.152259+00	3	6
25	2025-01-30 03:26:08.683306+00	3	6
26	2025-01-30 03:27:02.491169+00	3	6
27	2025-01-30 03:27:10.981476+00	3	6
28	2025-01-30 03:35:22.637051+00	3	7
29	2025-01-30 03:36:18.954576+00	3	7
30	2025-01-30 03:37:29.965821+00	3	7
31	2025-01-30 03:37:46.913602+00	3	7
32	2025-01-30 03:37:55.547843+00	3	7
33	2025-01-30 03:38:57.625295+00	3	7
34	2025-01-30 03:39:19.387788+00	3	7
35	2025-01-30 03:39:57.52913+00	3	7
36	2025-01-30 03:40:24.957379+00	3	7
37	2025-01-30 03:40:39.383533+00	3	7
38	2025-01-30 03:41:09.631569+00	3	7
39	2025-01-30 03:41:27.09729+00	3	7
40	2025-01-30 03:41:33.340508+00	3	7
41	2025-01-30 03:41:40.119877+00	3	7
42	2025-01-30 03:42:23.668645+00	3	7
43	2025-01-30 03:42:59.423616+00	3	7
44	2025-01-30 03:43:36.352266+00	3	7
45	2025-01-30 03:44:56.454166+00	3	7
46	2025-01-30 03:45:52.663942+00	3	7
47	2025-01-30 03:46:16.290056+00	3	6
48	2025-01-30 03:46:48.78316+00	3	7
49	2025-01-30 03:48:25.589723+00	3	7
50	2025-01-30 03:48:59.160404+00	3	7
51	2025-01-30 03:52:49.669737+00	3	7
52	2025-01-30 03:53:08.865782+00	3	7
53	2025-01-30 03:53:24.142094+00	3	7
54	2025-01-30 03:53:42.367105+00	3	7
55	2025-01-30 03:53:52.995037+00	3	7
56	2025-01-30 03:59:43.047884+00	3	7
57	2025-01-30 04:00:10.95673+00	3	8
58	2025-01-30 04:00:26.909091+00	3	8
59	2025-01-30 04:01:38.391932+00	3	8
60	2025-01-30 04:01:54.512666+00	3	8
61	2025-01-30 04:03:37.840897+00	3	8
62	2025-01-30 04:03:40.087732+00	3	8
63	2025-01-30 04:04:06.161709+00	3	8
64	2025-01-30 04:04:37.492007+00	3	8
65	2025-01-30 05:41:04.524899+00	3	4
66	2025-01-30 05:41:34.592091+00	3	4
67	2025-01-30 05:42:05.395136+00	3	5
68	2025-01-30 05:42:14.022134+00	3	6
69	2025-01-30 05:42:23.60736+00	3	7
70	2025-01-30 05:42:24.784716+00	3	7
71	2025-01-30 05:42:50.184385+00	3	7
72	2025-01-30 05:43:01.948815+00	3	7
73	2025-01-30 05:43:23.021194+00	3	7
74	2025-01-30 05:43:36.489756+00	3	8
75	2025-01-30 05:43:51.39444+00	3	8
76	2025-01-31 00:14:35.888328+00	3	4
77	2025-01-31 00:16:03.079144+00	3	4
78	2025-01-31 00:16:49.107651+00	3	4
79	2025-01-31 00:19:55.07502+00	3	5
80	2025-01-31 00:23:22.064225+00	3	5
81	2025-01-31 00:27:52.771843+00	3	7
82	2025-01-31 00:29:08.888637+00	3	8
83	2025-01-31 00:29:21.251595+00	3	7
84	2025-01-31 00:29:32.110291+00	3	6
85	2025-01-31 00:29:44.191135+00	3	5
90	2025-02-01 07:27:25.78443+00	3	4
91	2025-02-01 07:27:52.132768+00	3	4
92	2025-02-01 07:28:58.547633+00	3	4
93	2025-02-01 07:30:11.970174+00	3	4
94	2025-02-01 07:30:22.080319+00	3	5
95	2025-02-01 07:30:38.363347+00	3	6
96	2025-02-01 07:31:22.097774+00	3	6
97	2025-02-01 07:31:36.093029+00	3	7
105	2025-02-01 07:36:55.245725+00	3	9
106	2025-02-01 07:37:42.880441+00	3	9
107	2025-02-01 07:37:50.579982+00	3	9
108	2025-02-01 07:39:28.588364+00	3	9
109	2025-02-01 07:40:34.763889+00	3	9
110	2025-02-01 07:41:22.949649+00	3	9
111	2025-02-01 07:41:53.843198+00	3	9
112	2025-02-01 07:43:00.478706+00	3	4
113	2025-02-01 07:43:11.455644+00	3	10
114	2025-02-01 07:44:06.434111+00	3	10
115	2025-02-01 07:45:00.697492+00	3	10
116	2025-02-01 07:45:08.846413+00	3	11
117	2025-02-01 07:45:16.303357+00	3	12
118	2025-02-01 07:45:26.124575+00	3	13
119	2025-02-01 07:45:33.724617+00	3	14
120	2025-02-01 23:59:27.209241+00	3	14
121	2025-02-03 06:06:23.051066+00	3	20
122	2025-02-03 06:06:46.631111+00	3	20
123	2025-02-03 06:07:11.026069+00	3	20
124	2025-02-03 06:07:18.374605+00	3	6
125	2025-02-03 06:07:37.197699+00	3	24
126	2025-02-03 06:07:41.314298+00	3	24
127	2025-02-03 06:07:49.668229+00	3	24
128	2025-02-03 06:07:58.437519+00	3	19
129	2025-02-03 06:08:02.967577+00	3	18
130	2025-02-03 06:08:11.690477+00	3	14
131	2025-02-03 06:14:41.643875+00	3	14
132	2025-02-03 06:15:47.603302+00	3	14
133	2025-02-03 06:18:17.532984+00	3	14
134	2025-02-03 06:18:50.87641+00	3	14
135	2025-02-03 06:20:23.010003+00	3	4
136	2025-02-03 17:49:41.205343+00	3	25
137	2025-02-03 17:53:13.595907+00	3	23
138	2025-02-03 17:55:48.729399+00	3	25
139	2025-02-03 17:55:54.221384+00	3	25
140	2025-02-04 08:15:15.946485+00	3	8
141	2025-02-04 08:15:36.578069+00	3	20
142	2025-02-04 08:17:20.155308+00	3	20
143	2025-02-04 10:08:17.143074+00	4	26
144	2025-02-04 10:08:21.671792+00	4	26
145	2025-02-04 10:08:25.959941+00	4	26
146	2025-02-04 10:08:31.009545+00	4	26
147	2025-02-04 10:09:28.310007+00	4	20
148	2025-02-04 10:09:42.859592+00	4	4
149	2025-02-04 10:10:05.65377+00	4	7
150	2025-02-04 10:10:30.360433+00	4	5
151	2025-02-04 10:10:48.990018+00	4	6
152	2025-02-04 10:11:06.867278+00	4	9
153	2025-02-04 11:45:51.040421+00	4	4
154	2025-02-04 21:37:55.848809+00	3	20
155	2025-02-04 21:38:44.158294+00	3	20
156	2025-02-04 22:03:36.292179+00	3	27
157	2025-02-04 22:38:21.437658+00	3	27
158	2025-02-04 23:03:26.154038+00	3	28
159	2025-02-04 23:09:38.951617+00	3	29
160	2025-02-05 01:59:24.888284+00	4	8
161	2025-02-05 02:02:40.14137+00	4	8
162	2025-02-05 02:09:24.136755+00	3	29
163	2025-02-05 02:10:14.397704+00	3	29
164	2025-02-05 02:10:26.425873+00	3	28
165	2025-02-05 02:10:33.110501+00	3	29
166	2025-02-05 02:11:13.19031+00	3	28
167	2025-02-05 02:11:35.273335+00	3	29
168	2025-02-05 02:13:25.342526+00	3	29
169	2025-02-05 02:13:39.172499+00	3	29
170	2025-02-05 02:14:50.283222+00	4	6
171	2025-02-05 02:15:01.510921+00	4	29
172	2025-02-05 02:15:58.659985+00	3	28
173	2025-02-05 02:16:02.832908+00	3	29
174	2025-02-05 02:16:07.357869+00	3	29
175	2025-02-05 02:16:16.756656+00	3	29
176	2025-02-05 02:16:38.539678+00	3	28
177	2025-02-05 02:17:15.955439+00	4	29
178	2025-02-05 02:17:32.901245+00	4	29
179	2025-02-05 02:18:05.714885+00	4	29
180	2025-02-05 02:18:23.463583+00	3	29
181	2025-02-05 02:19:00.293436+00	3	29
182	2025-02-05 02:19:05.033547+00	4	29
183	2025-02-05 02:19:40.679116+00	4	29
184	2025-02-05 02:19:40.919186+00	3	29
185	2025-02-05 02:19:50.245014+00	3	28
186	2025-02-05 02:19:51.791614+00	4	29
187	2025-02-05 02:20:26.004263+00	3	25
188	2025-02-05 02:20:26.909243+00	4	29
189	2025-02-05 02:20:37.315193+00	4	20
190	2025-02-05 02:21:02.574303+00	4	20
191	2025-02-05 02:21:02.926142+00	3	25
192	2025-02-05 02:21:19.863356+00	3	25
193	2025-02-05 02:21:29.281331+00	4	20
194	2025-02-05 02:21:32.660399+00	3	25
195	2025-02-05 02:21:47.898876+00	4	20
196	2025-02-05 02:22:22.690037+00	3	28
197	2025-02-05 02:22:28.576467+00	4	20
198	2025-02-05 02:22:42.845767+00	3	28
199	2025-02-05 02:22:48.482568+00	4	20
200	2025-02-05 02:23:04.346636+00	4	20
201	2025-02-05 02:23:08.23953+00	3	29
202	2025-02-05 02:23:13.760498+00	3	28
203	2025-02-05 02:23:48.04059+00	3	28
204	2025-02-05 02:24:22.124298+00	4	20
205	2025-02-05 02:24:45.801823+00	3	25
206	2025-02-05 02:25:03.807289+00	4	20
207	2025-02-05 02:28:13.201707+00	4	20
208	2025-02-05 02:28:20.710297+00	4	20
209	2025-02-05 02:29:05.419503+00	4	29
210	2025-02-05 02:29:07.935747+00	4	28
211	2025-02-05 02:29:42.560269+00	4	29
212	2025-02-05 02:31:42.049141+00	4	29
213	2025-02-05 02:31:50.074635+00	4	29
214	2025-02-05 02:33:39.417048+00	4	29
215	2025-02-05 02:33:44.658062+00	4	20
216	2025-02-05 02:35:31.454092+00	4	29
217	2025-02-05 02:38:58.515757+00	4	29
218	2025-02-05 02:39:06.001978+00	4	20
219	2025-02-05 02:40:33.845549+00	4	29
220	2025-02-05 02:45:26.376039+00	4	4
221	2025-02-05 02:48:54.957233+00	4	5
222	2025-02-05 02:49:13.977345+00	4	4
223	2025-02-05 02:49:18.889364+00	4	4
224	2025-02-05 02:49:26.397401+00	4	4
225	2025-02-05 02:49:38.281569+00	4	4
226	2025-02-05 02:49:47.412987+00	4	4
227	2025-02-05 02:50:34.554467+00	4	4
228	2025-02-05 02:51:17.550497+00	4	4
229	2025-02-05 02:51:27.680816+00	4	4
230	2025-02-05 02:51:35.449572+00	4	4
231	2025-02-05 02:52:05.494438+00	4	4
232	2025-02-05 02:52:20.461007+00	4	4
233	2025-02-05 02:52:29.488349+00	4	4
234	2025-02-05 02:52:42.599727+00	4	4
235	2025-02-05 02:53:08.486133+00	4	4
236	2025-02-05 02:53:21.869533+00	4	4
237	2025-02-05 02:54:12.41049+00	4	4
238	2025-02-05 02:59:12.593553+00	4	4
239	2025-02-05 02:59:41.389644+00	4	4
240	2025-02-05 03:03:46.392611+00	4	4
241	2025-02-05 03:04:05.832157+00	4	4
242	2025-02-05 03:04:20.020706+00	4	4
243	2025-02-05 03:04:42.197575+00	4	4
244	2025-02-05 03:05:24.377748+00	4	4
245	2025-02-05 03:05:33.957666+00	4	4
246	2025-02-05 03:06:17.587785+00	4	4
247	2025-02-05 03:07:15.253547+00	4	4
248	2025-02-05 03:08:34.340677+00	4	4
249	2025-02-05 03:09:51.265624+00	4	4
250	2025-02-05 03:10:21.196904+00	4	4
251	2025-02-05 03:10:31.958275+00	4	4
252	2025-02-05 03:10:58.301388+00	4	4
253	2025-02-05 03:11:14.037909+00	4	4
254	2025-02-05 03:12:09.093242+00	4	4
255	2025-02-05 03:13:16.418483+00	4	4
256	2025-02-05 03:13:26.759283+00	4	4
257	2025-02-05 03:13:37.466645+00	4	4
258	2025-02-05 03:13:48.288933+00	4	4
259	2025-02-05 03:13:57.488117+00	4	4
260	2025-02-05 03:14:06.915108+00	4	4
261	2025-02-05 03:14:15.14921+00	4	4
262	2025-02-05 03:14:58.797769+00	4	20
263	2025-02-05 03:21:22.932041+00	4	20
264	2025-02-05 03:25:51.789034+00	4	20
265	2025-02-05 03:29:26.157922+00	4	20
266	2025-02-05 03:29:54.552841+00	4	20
267	2025-02-05 03:30:38.062588+00	4	20
268	2025-02-05 03:30:54.228409+00	4	20
269	2025-02-05 03:31:43.211264+00	4	20
270	2025-02-05 03:31:58.162481+00	4	20
271	2025-02-05 03:33:00.995451+00	4	20
272	2025-02-05 03:36:11.766409+00	4	20
273	2025-02-05 03:37:12.880615+00	4	20
274	2025-02-05 03:41:46.868045+00	4	20
275	2025-02-05 03:42:49.645865+00	4	20
276	2025-02-05 03:43:23.91003+00	4	20
277	2025-02-05 03:45:17.153235+00	4	20
278	2025-02-05 03:46:36.830701+00	4	20
279	2025-02-05 03:47:14.528157+00	4	20
280	2025-02-05 03:48:11.081406+00	4	20
281	2025-02-05 03:48:30.054574+00	4	20
282	2025-02-05 03:49:41.944544+00	4	20
283	2025-02-05 03:50:04.955139+00	4	20
284	2025-02-05 03:50:19.885754+00	4	20
285	2025-02-05 03:55:34.526412+00	4	20
286	2025-02-05 04:04:07.140741+00	4	20
287	2025-02-05 04:04:20.87934+00	4	20
288	2025-02-05 04:04:50.055304+00	4	20
289	2025-02-05 04:05:36.011408+00	4	20
290	2025-02-05 04:05:54.119638+00	4	20
291	2025-02-05 04:06:02.113029+00	4	20
292	2025-02-05 04:06:20.002731+00	4	20
293	2025-02-05 04:06:55.706244+00	4	20
294	2025-02-05 04:08:03.383708+00	4	20
295	2025-02-05 04:08:17.143708+00	4	20
296	2025-02-05 04:09:30.082879+00	4	20
297	2025-02-05 04:09:41.116268+00	4	20
298	2025-02-05 04:09:50.66535+00	4	20
299	2025-02-05 04:10:44.234533+00	4	20
300	2025-02-05 04:10:47.742402+00	4	20
301	2025-02-05 04:13:55.144505+00	4	20
302	2025-02-05 04:14:00.135644+00	4	20
303	2025-02-05 04:14:07.622446+00	4	20
304	2025-02-05 04:14:18.008947+00	4	20
305	2025-02-05 04:14:23.843894+00	4	20
306	2025-02-05 04:15:30.783249+00	4	20
307	2025-02-05 04:15:33.954157+00	4	20
308	2025-02-05 04:15:52.294206+00	4	20
309	2025-02-05 04:15:54.899846+00	4	20
310	2025-02-05 04:15:57.05417+00	4	4
311	2025-02-05 04:16:01.87575+00	4	7
312	2025-02-05 04:16:04.357303+00	4	29
313	2025-02-05 04:16:27.178797+00	4	9
314	2025-02-05 04:16:33.157252+00	4	8
315	2025-02-05 04:18:37.90576+00	4	20
316	2025-02-05 04:18:40.40144+00	4	20
317	2025-02-05 04:19:34.374446+00	4	20
318	2025-02-05 04:19:37.202506+00	4	20
319	2025-02-05 04:19:39.951284+00	4	20
320	2025-02-05 04:19:42.547258+00	4	4
321	2025-02-05 04:19:46.102744+00	4	7
322	2025-02-05 04:19:49.478701+00	4	29
323	2025-02-05 04:19:52.686365+00	4	28
324	2025-02-05 04:19:56.186228+00	4	5
325	2025-02-05 04:20:00.914138+00	4	6
326	2025-02-05 04:20:36.655821+00	4	20
327	2025-02-05 04:20:41.804263+00	4	20
328	2025-02-05 04:20:55.528791+00	4	20
329	2025-02-05 04:22:02.250259+00	4	20
330	2025-02-05 04:22:10.11586+00	4	20
331	2025-02-05 04:25:48.872192+00	4	20
332	2025-02-05 04:25:52.036312+00	4	20
333	2025-02-05 04:25:55.862018+00	4	4
334	2025-02-05 04:26:00.281154+00	4	7
335	2025-02-05 04:26:23.818574+00	4	29
336	2025-02-05 04:26:53.826189+00	4	20
337	2025-02-05 04:26:57.467903+00	4	20
338	2025-02-05 04:27:00.215514+00	4	20
339	2025-02-05 04:29:05.022125+00	4	20
340	2025-02-05 04:29:16.884041+00	4	20
341	2025-02-05 04:29:50.45962+00	4	20
342	2025-02-05 04:30:16.660883+00	4	20
343	2025-02-05 04:30:36.19493+00	4	20
344	2025-02-05 04:30:59.585491+00	4	20
345	2025-02-05 04:31:14.175803+00	4	20
346	2025-02-05 04:31:30.103555+00	4	20
347	2025-02-05 04:33:05.585052+00	4	20
348	2025-02-05 04:33:09.175872+00	4	20
349	2025-02-05 04:33:18.989091+00	4	20
350	2025-02-05 04:33:22.113378+00	4	20
351	2025-02-05 04:33:24.771038+00	4	20
352	2025-02-05 04:33:32.067118+00	4	20
353	2025-02-05 04:33:35.871852+00	4	20
354	2025-02-05 04:33:43.823153+00	4	20
355	2025-02-05 04:33:59.637336+00	4	20
356	2025-02-05 04:34:02.39095+00	4	20
357	2025-02-05 04:34:32.561006+00	4	20
358	2025-02-05 04:34:35.066612+00	4	20
359	2025-02-05 04:34:48.519591+00	4	20
360	2025-02-05 04:34:51.253257+00	4	20
361	2025-02-05 04:35:00.147653+00	4	20
362	2025-02-05 04:35:04.115884+00	4	20
363	2025-02-05 04:35:09.238878+00	4	20
364	2025-02-05 04:35:22.607301+00	4	20
365	2025-02-05 04:36:02.725533+00	4	20
366	2025-02-05 04:37:12.962275+00	4	4
367	2025-02-05 04:37:16.989062+00	4	7
368	2025-02-05 04:37:20.115673+00	4	29
369	2025-02-05 04:37:24.854769+00	4	28
370	2025-02-05 04:37:28.517308+00	4	5
371	2025-02-05 04:38:37.297337+00	4	20
372	2025-02-05 04:38:40.574647+00	4	4
373	2025-02-05 04:38:44.008684+00	4	7
374	2025-02-05 04:38:49.244179+00	4	29
375	2025-02-05 04:38:54.04588+00	4	28
376	2025-02-05 04:38:58.791952+00	4	5
377	2025-02-05 04:39:04.772533+00	4	9
378	2025-02-05 04:50:20.821878+00	4	4
379	2025-02-05 04:50:25.703233+00	4	7
380	2025-02-05 04:50:32.869656+00	4	29
381	2025-02-05 04:54:22.932361+00	4	20
382	2025-02-05 04:54:27.347911+00	4	4
383	2025-02-05 04:54:31.382373+00	4	20
384	2025-02-05 04:55:27.801876+00	4	20
385	2025-02-05 04:55:43.825046+00	4	4
386	2025-02-05 04:55:48.447895+00	4	7
387	2025-02-05 04:55:53.726323+00	4	29
388	2025-02-05 04:55:58.009725+00	4	28
389	2025-02-05 04:56:17.821932+00	4	20
390	2025-02-05 04:56:20.542429+00	4	20
391	2025-02-05 04:56:23.07556+00	4	20
392	2025-02-05 04:59:27.947041+00	4	20
393	2025-02-05 04:59:32.889604+00	4	29
394	2025-02-05 05:46:18.378718+00	4	20
395	2025-02-05 05:46:27.578392+00	4	4
396	2025-02-05 06:22:16.225168+00	4	20
397	2025-02-05 06:22:22.321972+00	4	4
398	2025-02-05 06:22:30.812019+00	4	4
399	2025-02-05 06:27:31.930119+00	4	20
400	2025-02-05 06:27:54.074251+00	4	20
401	2025-02-05 06:27:57.020557+00	4	20
402	2025-02-05 06:28:02.727297+00	4	20
403	2025-02-05 06:28:05.484505+00	4	20
404	2025-02-05 06:28:18.489922+00	4	20
405	2025-02-05 06:29:29.784294+00	4	20
406	2025-02-05 06:29:34.599038+00	4	7
407	2025-02-05 06:32:33.769589+00	4	20
408	2025-02-05 06:33:47.004784+00	4	20
409	2025-02-05 06:34:13.402091+00	4	20
410	2025-02-05 06:34:16.856379+00	4	20
411	2025-02-05 06:34:33.214517+00	4	20
412	2025-02-05 06:34:36.896755+00	4	20
413	2025-02-05 06:34:58.337897+00	4	20
414	2025-02-05 06:36:52.294327+00	4	20
415	2025-02-05 06:36:59.872126+00	4	20
416	2025-02-05 06:37:15.825484+00	4	20
417	2025-02-05 06:37:27.524024+00	4	20
418	2025-02-05 06:39:57.320494+00	4	20
419	2025-02-05 06:40:01.703338+00	4	20
420	2025-02-05 06:40:32.312317+00	4	20
421	2025-02-05 06:41:00.747738+00	4	20
422	2025-02-05 06:41:03.878712+00	4	20
423	2025-02-05 06:41:09.553753+00	4	20
424	2025-02-05 06:41:45.759772+00	4	20
425	2025-02-05 06:41:50.808672+00	4	20
426	2025-02-05 06:42:00.864575+00	4	20
427	2025-02-05 06:42:14.826362+00	4	20
428	2025-02-05 06:43:33.150476+00	4	20
429	2025-02-05 06:43:41.673584+00	4	20
430	2025-02-05 06:43:47.279906+00	4	4
431	2025-02-05 06:44:18.550015+00	4	20
432	2025-02-05 06:44:21.799904+00	4	20
433	2025-02-05 06:44:28.710368+00	4	4
434	2025-02-05 06:44:34.504563+00	4	20
435	2025-02-05 06:44:41.819147+00	4	7
436	2025-02-05 06:44:51.743465+00	4	9
437	2025-02-05 06:45:48.723031+00	4	20
438	2025-02-05 06:45:52.216823+00	4	4
439	2025-02-05 06:45:55.455665+00	4	7
440	2025-02-05 06:45:59.579332+00	4	29
441	2025-02-05 06:46:03.371905+00	4	28
442	2025-02-05 06:46:07.008717+00	4	6
443	2025-02-05 06:46:10.41195+00	4	9
444	2025-02-05 06:46:19.145556+00	4	20
445	2025-02-05 06:46:20.718677+00	4	20
446	2025-02-05 06:46:21.881496+00	4	20
447	2025-02-05 06:46:25.268473+00	4	20
448	2025-02-05 06:46:28.61002+00	4	20
449	2025-02-05 06:46:31.602534+00	4	20
450	2025-02-05 06:46:41.619415+00	4	20
451	2025-02-05 06:47:13.705019+00	4	20
452	2025-02-05 06:47:17.273153+00	4	20
453	2025-02-05 06:47:20.882205+00	4	20
454	2025-02-05 06:47:23.865762+00	4	20
455	2025-02-05 06:47:27.243687+00	4	4
456	2025-02-05 06:47:31.249161+00	4	20
457	2025-02-05 06:47:33.798238+00	4	4
458	2025-02-05 06:48:30.628929+00	4	20
459	2025-02-05 06:48:53.031106+00	4	20
460	2025-02-05 06:49:03.251537+00	4	20
461	2025-02-05 06:49:51.670361+00	4	20
462	2025-02-05 06:49:57.087157+00	4	20
463	2025-02-05 06:50:02.647398+00	4	20
464	2025-02-05 06:50:07.107597+00	4	20
465	2025-02-05 06:50:16.129592+00	4	20
466	2025-02-05 06:50:42.357649+00	4	20
467	2025-02-05 06:51:20.721614+00	4	20
468	2025-02-05 06:51:28.815951+00	4	20
469	2025-02-05 06:51:37.098924+00	4	20
470	2025-02-05 06:51:40.354409+00	4	20
471	2025-02-05 06:51:44.013051+00	4	4
472	2025-02-05 06:53:19.100611+00	4	20
473	2025-02-05 06:53:22.477588+00	4	20
474	2025-02-05 06:53:25.749981+00	4	20
475	2025-02-05 06:53:28.681043+00	4	20
476	2025-02-05 06:59:53.610772+00	4	20
477	2025-02-05 07:00:09.919553+00	4	20
478	2025-02-05 07:00:16.601365+00	4	20
479	2025-02-05 07:00:23.960035+00	4	20
480	2025-02-05 07:00:27.805984+00	4	4
481	2025-02-05 07:00:32.670925+00	4	4
482	2025-02-05 07:04:33.898733+00	4	20
483	2025-02-05 07:05:19.751201+00	4	20
484	2025-02-05 07:06:33.394444+00	4	4
485	2025-02-05 07:06:38.193097+00	4	7
486	2025-02-05 07:07:06.539042+00	4	20
487	2025-02-05 07:13:36.328622+00	4	20
488	2025-02-05 07:13:40.203821+00	4	20
489	2025-02-05 07:14:52.35108+00	4	20
490	2025-02-05 07:14:54.935881+00	4	20
491	2025-02-05 07:15:47.86151+00	4	20
492	2025-02-05 07:18:11.496681+00	4	20
493	2025-02-05 07:18:14.68599+00	4	20
494	2025-02-05 07:18:18.002335+00	4	20
495	2025-02-05 07:21:36.955048+00	4	20
496	2025-02-05 07:22:16.983872+00	4	20
497	2025-02-05 07:22:20.217217+00	4	20
498	2025-02-05 07:24:41.323151+00	4	20
499	2025-02-05 07:24:44.876778+00	4	20
500	2025-02-05 07:24:48.237552+00	4	20
501	2025-02-05 07:25:26.344473+00	4	20
502	2025-02-05 07:25:29.039243+00	4	20
503	2025-02-05 07:25:31.113949+00	4	20
504	2025-02-05 07:25:34.001923+00	4	4
505	2025-02-05 07:25:52.642744+00	4	4
506	2025-02-05 07:25:54.902164+00	4	20
507	2025-02-05 07:27:52.176257+00	4	20
508	2025-02-05 07:27:59.017739+00	4	20
509	2025-02-05 07:28:01.537649+00	4	20
510	2025-02-05 07:28:03.982349+00	4	4
511	2025-02-05 07:28:09.113408+00	4	7
512	2025-02-05 07:28:15.08873+00	4	29
513	2025-02-05 07:34:21.456448+00	4	20
514	2025-02-05 07:34:41.777929+00	4	20
515	2025-02-05 07:34:46.841378+00	4	4
516	2025-02-05 07:34:51.778671+00	4	7
517	2025-02-05 07:34:58.771188+00	4	29
518	2025-02-05 07:49:37.473409+00	4	20
519	2025-02-05 07:51:42.643706+00	4	20
520	2025-02-05 07:51:58.158246+00	4	20
521	2025-02-05 07:52:07.788646+00	4	4
522	2025-02-05 07:53:12.711809+00	4	20
523	2025-02-05 07:53:17.20703+00	4	4
524	2025-02-05 07:53:22.469058+00	4	7
525	2025-02-05 07:54:06.055226+00	4	20
526	2025-02-05 07:54:09.632882+00	4	20
527	2025-02-05 07:54:16.773909+00	4	20
528	2025-02-05 07:54:23.668292+00	4	4
529	2025-02-05 07:54:32.343829+00	4	20
530	2025-02-05 07:54:46.852336+00	4	20
531	2025-02-05 07:54:50.898247+00	4	20
532	2025-02-05 07:54:55.103529+00	4	4
533	2025-02-05 07:55:11.525834+00	4	7
534	2025-02-05 07:55:49.132954+00	4	8
535	2025-02-05 07:56:49.784664+00	4	20
536	2025-02-05 07:56:54.150302+00	4	20
537	2025-02-05 07:56:56.525351+00	4	20
538	2025-02-05 07:56:59.800788+00	4	4
539	2025-02-05 07:57:06.224956+00	4	7
540	2025-02-05 07:57:15.789359+00	4	20
541	2025-02-05 08:02:28.965809+00	4	20
542	2025-02-05 08:02:36.916679+00	4	20
543	2025-02-05 08:03:34.171891+00	4	20
544	2025-02-05 08:03:44.109364+00	4	20
545	2025-02-05 08:03:48.735657+00	4	20
546	2025-02-05 08:03:54.363145+00	4	20
547	2025-02-05 08:04:26.362706+00	4	20
548	2025-02-05 08:04:35.306819+00	4	20
549	2025-02-05 08:06:26.035894+00	4	20
550	2025-02-05 08:06:29.146888+00	4	20
551	2025-02-05 08:06:46.224639+00	4	20
552	2025-02-05 08:10:46.006642+00	4	20
553	2025-02-05 08:11:07.330308+00	4	4
554	2025-02-05 08:20:36.968121+00	4	20
555	2025-02-05 08:22:22.369618+00	4	4
556	2025-02-05 08:23:40.577116+00	4	7
557	2025-02-05 08:23:58.700596+00	4	4
558	2025-02-05 08:24:04.02497+00	4	7
559	2025-02-05 08:24:17.348435+00	4	4
560	2025-02-05 08:24:24.267097+00	4	7
561	2025-02-05 08:24:43.425884+00	4	20
562	2025-02-05 08:24:46.764188+00	4	7
563	2025-02-05 08:25:00.961339+00	4	7
564	2025-02-05 08:26:46.957285+00	4	7
565	2025-02-05 08:27:27.271375+00	4	7
566	2025-02-05 08:27:37.455492+00	4	7
567	2025-02-05 08:27:47.212693+00	4	7
568	2025-02-05 08:27:57.196053+00	4	7
569	2025-02-05 08:29:07.331124+00	4	7
570	2025-02-05 08:29:30.695846+00	4	7
571	2025-02-05 08:30:28.413505+00	4	7
572	2025-02-05 08:31:14.137796+00	4	7
573	2025-02-05 08:31:30.205424+00	4	7
574	2025-02-05 08:31:58.331033+00	4	7
575	2025-02-05 08:32:31.81265+00	4	20
576	2025-02-05 08:32:35.477991+00	4	7
577	2025-02-05 08:35:51.353174+00	4	7
578	2025-02-05 08:36:58.700834+00	4	7
579	2025-02-05 08:37:17.050905+00	4	7
580	2025-02-05 08:37:31.384677+00	4	7
581	2025-02-05 08:37:40.590049+00	4	4
582	2025-02-05 08:37:43.574459+00	4	7
583	2025-02-05 08:38:46.601412+00	4	7
584	2025-02-05 08:38:51.870903+00	4	20
585	2025-02-05 08:39:27.376114+00	4	7
586	2025-02-05 08:39:36.579375+00	4	7
587	2025-02-05 08:39:51.636739+00	4	7
588	2025-02-05 08:39:55.781616+00	4	4
589	2025-02-05 08:40:00.016496+00	4	20
590	2025-02-05 08:40:34.65623+00	4	7
591	2025-02-05 08:41:02.694761+00	4	7
592	2025-02-05 08:41:07.121252+00	4	20
593	2025-02-05 08:41:24.947273+00	4	20
594	2025-02-05 08:41:29.111081+00	4	20
595	2025-02-05 08:41:37.78753+00	4	20
596	2025-02-05 08:42:09.700849+00	4	20
597	2025-02-05 08:42:13.793897+00	4	7
598	2025-02-05 08:42:16.847718+00	4	4
599	2025-02-05 08:42:21.13532+00	4	20
600	2025-02-05 08:43:21.461067+00	4	7
601	2025-02-05 08:43:33.932489+00	4	20
602	2025-02-05 08:44:57.878517+00	4	8
603	2025-02-05 20:14:26.541458+00	4	30
604	2025-02-05 20:15:54.420218+00	4	20
605	2025-02-05 20:16:05.264535+00	4	20
606	2025-02-05 20:16:09.822757+00	4	20
607	2025-02-05 20:16:12.53708+00	4	30
608	2025-02-05 20:16:17.651856+00	4	29
609	2025-02-05 20:16:21.84603+00	4	28
610	2025-02-05 20:16:52.097723+00	4	20
611	2025-02-05 20:17:09.680991+00	4	30
612	2025-02-05 20:17:17.669558+00	4	29
613	2025-02-05 20:17:29.188914+00	4	20
614	2025-02-05 20:17:33.267577+00	4	30
615	2025-02-05 20:17:37.710555+00	4	20
616	2025-02-05 20:21:14.386383+00	4	20
617	2025-02-05 20:21:44.305858+00	4	20
618	2025-02-05 20:22:06.162492+00	4	20
619	2025-02-05 20:22:14.620138+00	4	20
620	2025-02-05 20:22:37.755836+00	4	30
621	2025-02-05 20:22:43.985099+00	4	20
622	2025-02-05 20:22:53.629331+00	4	20
623	2025-02-05 20:23:33.394875+00	4	20
624	2025-02-05 20:23:43.579031+00	4	20
625	2025-02-05 20:23:54.547176+00	4	20
626	2025-02-05 20:23:59.374968+00	4	20
627	2025-02-05 20:24:13.925897+00	4	20
628	2025-02-05 20:24:24.086386+00	4	30
629	2025-02-05 20:24:26.707308+00	4	20
630	2025-02-05 20:24:48.850757+00	4	20
631	2025-02-05 20:24:58.981678+00	4	20
632	2025-02-05 20:25:08.729494+00	4	30
633	2025-02-05 20:25:16.985897+00	4	20
634	2025-02-05 20:25:21.370699+00	4	20
635	2025-02-05 20:25:26.768655+00	4	20
636	2025-02-05 20:25:55.280774+00	4	20
637	2025-02-05 20:26:04.399505+00	4	20
638	2025-02-05 20:26:09.273373+00	4	20
639	2025-02-05 20:26:12.93366+00	4	20
640	2025-02-05 20:26:16.662806+00	4	20
641	2025-02-05 20:26:28.12992+00	4	20
642	2025-02-05 20:26:32.395714+00	4	30
643	2025-02-05 20:26:39.877033+00	4	20
644	2025-02-05 20:27:00.967327+00	4	20
645	2025-02-05 20:27:51.431208+00	4	20
646	2025-02-05 20:30:33.826168+00	4	20
647	2025-02-05 20:31:42.169847+00	4	20
648	2025-02-05 20:31:47.768955+00	4	20
649	2025-02-05 20:31:58.289764+00	4	20
650	2025-02-05 20:32:08.862597+00	4	20
651	2025-02-05 20:32:24.118527+00	4	20
652	2025-02-05 20:32:28.11927+00	4	20
653	2025-02-05 20:32:53.301315+00	4	20
654	2025-02-05 20:33:18.997934+00	4	20
655	2025-02-05 20:33:27.108797+00	4	20
656	2025-02-05 20:33:35.809585+00	4	20
657	2025-02-05 20:33:45.618859+00	4	20
658	2025-02-05 20:35:16.085575+00	4	20
659	2025-02-05 20:36:48.119339+00	4	20
660	2025-02-05 20:36:52.383702+00	4	20
661	2025-02-05 20:37:07.036819+00	4	20
662	2025-02-05 20:37:28.425352+00	4	20
663	2025-02-05 20:37:39.994144+00	4	20
664	2025-02-05 20:37:46.984327+00	4	20
665	2025-02-05 20:37:49.569979+00	4	30
666	2025-02-05 20:40:37.756631+00	4	20
667	2025-02-05 20:41:36.854419+00	4	20
668	2025-02-05 20:47:29.298525+00	4	30
669	2025-02-05 20:48:18.566906+00	4	27
670	2025-02-05 20:48:36.027755+00	4	26
671	2025-02-05 20:53:26.430596+00	4	20
672	2025-02-05 20:53:31.491045+00	4	20
673	2025-02-05 20:53:39.66603+00	4	4
674	2025-02-05 20:53:55.143459+00	4	7
675	2025-02-05 20:54:06.667475+00	4	8
676	2025-02-05 20:54:27.602359+00	4	20
677	2025-02-05 20:56:18.271012+00	4	20
678	2025-02-05 20:56:51.570615+00	4	20
679	2025-02-05 20:57:13.576059+00	4	20
680	2025-02-05 20:57:22.984424+00	4	20
681	2025-02-05 20:57:30.616284+00	4	20
682	2025-02-05 20:57:39.23704+00	4	20
683	2025-02-05 20:57:49.931707+00	4	20
684	2025-02-05 20:57:52.959967+00	4	4
685	2025-02-05 20:57:56.841971+00	4	7
686	2025-02-05 20:58:03.810562+00	4	8
687	2025-02-05 21:01:42.897923+00	4	20
688	2025-02-05 21:02:08.163773+00	4	20
689	2025-02-05 21:09:56.957948+00	4	4
690	2025-02-05 23:13:38.864184+00	4	4
691	2025-02-05 23:24:26.635424+00	4	4
692	2025-02-06 21:58:53.801423+00	4	20
693	2025-02-06 21:59:03.669114+00	4	20
694	2025-02-06 22:01:08.899506+00	4	20
695	2025-02-06 22:01:54.950092+00	4	20
696	2025-02-06 22:02:06.769199+00	4	20
697	2025-02-06 22:06:02.965231+00	4	20
698	2025-02-06 22:06:14.373317+00	4	20
699	2025-02-06 22:06:17.573298+00	4	20
700	2025-02-06 22:09:15.531608+00	4	20
701	2025-02-06 22:16:16.671019+00	4	20
702	2025-02-06 22:16:38.215065+00	4	20
703	2025-02-06 22:17:15.087034+00	4	20
704	2025-02-06 22:19:14.630817+00	4	20
705	2025-02-06 22:19:22.212849+00	4	20
706	2025-02-06 22:19:33.669796+00	4	20
707	2025-02-06 22:19:40.172905+00	4	20
708	2025-02-06 22:19:50.526023+00	4	20
709	2025-02-06 22:20:41.493252+00	4	20
710	2025-02-06 22:27:45.911848+00	4	20
711	2025-02-06 22:28:26.202388+00	4	20
712	2025-02-06 22:28:29.771568+00	4	20
713	2025-02-06 22:28:35.359437+00	4	20
714	2025-02-06 22:28:56.209326+00	4	20
715	2025-02-06 22:28:59.573141+00	4	20
716	2025-02-06 22:30:58.755479+00	4	20
717	2025-02-06 22:31:23.835887+00	4	20
718	2025-02-06 22:32:41.391575+00	4	20
719	2025-02-06 22:32:48.814491+00	4	20
720	2025-02-06 22:32:56.767167+00	4	20
721	2025-02-06 22:33:05.699186+00	4	4
722	2025-02-06 22:33:10.000776+00	4	7
723	2025-02-06 22:33:35.087109+00	4	4
724	2025-02-06 22:33:40.625251+00	4	20
725	2025-02-06 22:34:18.974443+00	4	20
726	2025-02-06 22:34:29.43495+00	4	20
727	2025-02-06 22:34:38.954638+00	4	20
728	2025-02-06 22:35:21.146489+00	4	20
729	2025-02-06 22:35:27.746524+00	4	20
730	2025-02-06 22:35:41.207037+00	4	20
731	2025-02-06 22:36:37.343045+00	4	20
732	2025-02-06 22:36:46.073458+00	4	20
733	2025-02-06 22:41:33.823475+00	4	20
734	2025-02-06 22:42:30.034427+00	4	20
735	2025-02-06 22:42:42.472198+00	4	20
736	2025-02-06 22:43:24.963158+00	4	20
737	2025-02-06 22:44:05.564785+00	4	20
738	2025-02-06 22:45:06.173337+00	4	20
739	2025-02-06 22:45:33.232274+00	4	20
740	2025-02-06 22:45:58.249656+00	4	20
741	2025-02-06 22:46:26.773856+00	4	20
742	2025-02-06 22:49:23.045156+00	4	20
743	2025-02-06 22:49:49.047218+00	4	20
744	2025-02-06 22:50:18.915451+00	4	20
745	2025-02-06 22:51:23.50371+00	4	20
746	2025-02-06 22:51:53.591227+00	4	20
747	2025-02-06 22:52:04.88325+00	4	20
748	2025-02-06 22:52:41.405172+00	4	20
749	2025-02-06 22:53:17.821808+00	4	20
750	2025-02-06 22:54:00.924309+00	4	20
751	2025-02-06 22:56:44.575447+00	4	20
752	2025-02-06 22:57:17.714119+00	4	20
753	2025-02-06 22:57:32.14367+00	4	20
754	2025-02-06 23:00:11.149436+00	4	20
755	2025-02-06 23:02:15.427238+00	4	8
756	2025-02-06 23:09:54.520385+00	4	8
757	2025-02-06 23:10:32.05056+00	4	8
\.


--
-- Data for Name: discrete_response; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."discrete_response" ("id", "response_id", "answer_id") FROM stdin;
1	1	7
2	2	7
3	3	8
4	4	9
5	5	9
6	6	9
7	7	9
8	8	7
9	9	8
10	10	7
11	13	9
12	14	7
13	15	7
14	16	7
15	17	7
16	18	7
17	19	9
18	20	7
19	21	10
20	21	12
21	22	10
22	22	12
23	23	11
24	65	8
25	66	8
26	67	11
27	67	12
28	76	7
29	77	7
30	78	7
31	79	10
32	79	12
33	80	10
34	80	12
35	85	11
37	90	8
38	91	8
39	92	9
40	93	7
41	94	11
42	94	12
43	112	7
44	113	25
45	114	24
46	115	25
47	116	26
48	116	27
49	128	41
50	129	39
51	129	40
52	135	9
53	143	43
54	144	43
55	145	43
56	146	44
57	148	8
58	150	11
59	153	7
60	220	7
61	221	12
62	222	7
63	223	9
64	224	9
65	225	8
66	226	7
67	227	9
68	228	7
69	229	7
70	230	9
71	231	8
72	232	8
73	233	9
74	234	7
75	235	9
76	236	8
77	237	8
78	238	9
79	239	7
80	240	8
81	241	8
82	242	7
83	243	9
84	244	7
85	245	8
86	246	7
87	247	9
88	248	7
89	249	8
90	250	9
91	251	8
92	252	8
93	253	9
94	254	7
95	255	8
96	256	7
97	257	8
98	258	8
99	259	8
100	260	9
101	261	7
102	310	9
103	320	9
104	324	11
105	324	12
106	333	7
107	366	9
108	370	10
109	372	9
110	376	11
111	378	7
112	382	7
113	385	9
114	395	7
115	397	7
116	398	9
117	430	8
118	433	7
119	438	9
120	455	7
121	457	8
122	471	8
123	480	7
124	481	9
125	484	9
126	504	8
127	505	7
128	510	8
129	515	8
130	521	9
131	523	7
132	528	7
133	532	7
134	538	7
135	553	7
136	555	9
137	557	8
138	559	8
139	581	8
140	588	8
141	598	8
142	670	44
143	673	8
144	684	9
145	689	9
146	690	7
147	691	8
148	721	8
149	723	7
\.


--
-- Data for Name: dislike; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."dislike" ("id", "created_at", "user_id", "comment_id") FROM stdin;
116	2025-02-02 04:09:00.441165+00	3	72
117	2025-02-02 04:09:02.025252+00	3	70
118	2025-02-03 06:18:59.547337+00	3	87
120	2025-02-05 00:08:16.62815+00	3	104
\.


--
-- Data for Name: like; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."like" ("id", "created_at", "user_id", "comment_id") FROM stdin;
128	2025-02-02 04:09:01.170353+00	3	71
129	2025-02-02 04:09:03.567289+00	3	69
\.


--
-- Data for Name: numeric_response; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."numeric_response" ("id", "response_id", "value") FROM stdin;
1	24	47
2	25	42
3	26	64
4	27	78
5	47	44
6	68	30
7	84	0
8	95	72
9	96	37
10	117	41
11	121	53
12	122	47
13	123	36
14	124	54
15	125	48
16	126	66
17	127	34
18	136	42
19	137	36
20	138	27
21	139	76
22	141	54
23	142	61
24	147	6
25	151	38
26	154	69
27	155	33
28	158	35
29	159	20
30	162	27
31	163	65
32	164	29
33	165	23
34	166	33
35	167	20
36	168	18
37	169	19
38	170	28
39	171	86
40	172	44
41	173	24
42	174	42
43	175	59
44	176	9
45	177	70
46	178	0
47	179	0
48	180	65
49	181	50
50	182	0
51	183	0
52	184	49
53	185	45
54	186	0
55	187	60
56	188	23
57	189	7
58	190	0
59	191	54
60	192	78
61	193	0
62	194	32
63	195	0
64	196	35
65	197	0
66	198	26
67	199	0
68	200	0
69	201	76
70	202	17
71	203	68
72	204	0
73	205	19
74	206	41
75	207	0
76	208	0
77	209	0
78	210	0
79	211	0
80	212	0
81	213	0
82	214	0
83	215	0
84	216	0
85	217	0
86	218	0
87	219	0
88	262	4
89	263	24
90	264	15
91	265	0
92	266	0
93	267	0
94	268	0
95	269	0
96	270	0
97	271	52
98	272	0
99	273	0
100	274	0
101	275	0
102	276	0
103	277	0
104	278	0
105	279	0
106	280	0
107	281	0
108	282	27
109	283	0
110	284	0
111	285	12
112	286	0
113	287	0
114	288	0
115	289	0
116	290	0
117	291	0
118	292	0
119	293	0
120	294	0
121	295	0
122	296	33
123	297	100
124	298	81
125	299	0
126	300	0
127	301	0
128	302	0
129	303	0
130	304	0
131	305	0
132	306	0
133	307	0
134	308	0
135	309	0
136	312	0
137	315	0
138	316	0
139	317	0
140	318	0
141	319	0
142	322	33
143	323	51
144	325	38
145	326	0
146	327	0
147	328	0
148	329	26
149	330	0
150	331	0
151	332	0
152	335	56
153	336	0
154	337	0
155	338	0
156	339	0
157	340	0
158	341	0
159	342	0
160	343	0
161	344	0
162	345	0
163	346	0
164	347	0
165	348	0
166	349	0
167	350	0
168	351	0
169	352	0
170	353	0
171	354	0
172	355	0
173	356	0
174	357	0
175	358	0
176	359	0
177	360	0
178	361	0
179	362	0
180	363	0
181	364	0
182	365	0
183	368	0
184	369	51
185	371	27
186	374	64
187	375	52
188	380	63
189	381	0
190	383	0
191	384	0
192	387	54
193	388	0
194	389	0
195	390	0
196	391	0
197	392	0
198	393	98
199	394	0
200	396	0
201	399	0
202	400	0
203	401	0
204	402	0
205	403	0
206	404	0
207	405	0
208	407	0
209	408	0
210	409	0
211	410	0
212	411	0
213	412	0
214	413	0
215	414	0
216	415	0
217	416	0
218	417	0
219	418	0
220	419	0
221	420	0
222	421	0
223	422	0
224	423	0
225	424	0
226	425	84
227	426	0
228	427	0
229	428	0
230	429	0
231	431	0
232	432	0
233	434	0
234	437	0
235	440	46
236	441	55
237	442	40
238	444	0
239	445	0
240	446	0
241	447	0
242	448	0
243	449	0
244	450	0
245	451	0
246	452	0
247	453	0
248	454	0
249	456	0
250	458	0
251	459	0
252	460	0
253	461	0
254	462	0
255	463	0
256	464	0
257	465	0
258	466	0
259	467	0
260	468	33
261	469	39
262	470	0
263	472	0
264	473	0
265	474	0
266	475	0
267	476	0
268	477	0
269	478	0
270	479	0
271	482	0
272	483	0
273	486	0
274	487	0
275	488	0
276	489	0
277	490	0
278	491	0
279	492	0
280	493	0
281	494	0
282	495	0
283	496	0
284	497	0
285	498	0
286	499	0
287	500	0
288	501	0
289	502	0
290	503	0
291	506	0
292	507	0
293	508	0
294	509	0
295	512	100
296	513	0
297	514	0
298	517	66
299	518	0
300	519	0
301	520	0
302	522	0
303	525	0
304	526	0
305	527	0
306	529	0
307	530	0
308	531	0
309	535	0
310	536	0
311	537	0
312	540	0
313	541	0
314	542	0
315	543	0
316	544	0
317	545	0
318	546	0
319	547	0
320	548	0
321	549	0
322	550	0
323	551	0
324	552	0
325	554	0
326	561	0
327	575	0
328	584	0
329	589	78
330	592	0
331	593	0
332	594	0
333	595	0
334	596	0
335	599	0
336	601	0
337	603	0
338	604	0
339	605	0
340	606	0
341	607	0
342	608	37
343	609	0
344	610	0
345	611	0
346	612	0
347	613	0
348	614	73
349	615	0
350	616	0
351	617	0
352	618	0
353	619	0
354	620	0
355	621	0
356	622	0
357	623	0
358	624	0
359	625	0
360	626	0
361	627	0
362	628	0
363	629	0
364	630	0
365	631	0
366	632	0
367	633	0
368	634	0
369	635	0
370	636	0
371	637	0
372	638	0
373	639	0
374	640	0
375	641	0
376	642	0
377	643	0
378	644	43
379	645	46
380	646	0
381	647	0
382	648	0
383	649	0
384	650	0
385	651	0
386	652	0
387	653	0
388	654	0
389	655	0
390	656	0
391	657	0
392	658	0
393	659	0
394	660	0
395	661	0
396	662	0
397	663	0
398	664	0
399	665	0
400	666	0
401	667	0
402	668	0
403	671	46
404	672	0
405	676	0
406	677	0
407	678	0
408	679	0
409	680	0
410	681	0
411	682	0
412	683	0
413	687	68
414	688	0
415	692	60
416	693	0
417	694	31
418	695	0
419	696	0
420	697	0
421	698	0
422	699	0
423	700	0
424	701	0
425	702	0
426	703	0
427	704	0
428	705	0
429	706	0
430	707	0
431	708	0
432	709	0
433	710	0
434	711	0
435	712	0
436	713	0
437	714	0
438	715	0
439	716	0
440	717	0
441	718	0
442	719	0
443	720	0
444	724	0
445	725	0
446	726	0
447	727	0
448	728	0
449	729	0
450	730	0
451	731	0
452	732	0
453	733	0
454	734	0
455	735	0
456	736	0
457	737	0
458	738	0
459	739	0
460	740	0
461	741	0
462	742	0
463	743	0
464	744	0
465	745	0
466	746	0
467	747	0
468	748	0
469	749	0
470	750	0
471	751	0
472	752	0
473	753	0
474	754	0
\.


--
-- Data for Name: poll_board; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."poll_board" ("id", "poll_id", "board_id") FROM stdin;
4	4	1
5	5	1
6	6	1
7	7	1
8	8	1
9	9	1
10	10	1
11	11	1
12	12	1
13	13	1
14	14	1
15	15	1
16	16	1
17	17	1
18	18	1
19	19	1
20	20	1
21	21	1
22	22	1
23	23	1
24	23	7
25	24	1
26	25	1
27	25	7
28	26	1
29	27	1
30	27	7
31	28	1
32	28	7
33	29	1
34	29	7
35	30	1
\.


--
-- Data for Name: poll_report; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."poll_report" ("id", "created_at", "poll_id", "receiver_id", "creator_id", "handled") FROM stdin;
3	2025-02-03 03:32:04.533023+00	20	3	3	f
1	2025-02-02 02:36:27.801738+00	14	3	3	f
\.


--
-- Data for Name: ranked_response; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."ranked_response" ("id", "response_id", "answer_id", "rank") FROM stdin;
1	36	13	1
2	36	14	2
3	36	15	3
4	37	13	1
5	37	14	2
6	37	15	3
7	38	13	1
8	38	14	2
9	38	15	3
10	39	13	1
11	39	14	2
12	39	15	3
13	40	13	1
14	40	14	2
15	40	15	3
16	41	13	1
17	41	14	2
18	41	15	3
19	42	13	1
20	42	14	2
21	42	15	3
22	43	13	1
23	43	14	2
24	43	15	3
25	44	13	1
26	44	14	2
27	44	15	3
28	45	13	1
29	45	14	2
30	45	15	3
31	46	13	1
32	46	14	2
33	46	15	3
34	48	13	1
35	48	14	2
36	48	15	3
37	49	13	1
38	49	14	2
39	49	15	3
40	50	13	1
41	50	14	2
42	50	15	3
43	51	13	1
44	51	14	2
45	51	15	3
46	52	13	1
47	52	14	2
48	52	15	3
49	53	13	1
50	53	14	2
51	53	15	3
52	54	13	1
53	54	14	2
54	54	15	3
55	55	15	1
56	55	13	2
57	55	14	3
58	56	14	1
59	56	13	2
60	56	15	3
61	69	13	1
62	69	14	2
63	69	15	3
64	70	13	1
65	70	14	2
66	70	15	3
67	71	13	1
68	71	14	2
69	71	15	3
70	72	13	1
71	72	14	2
72	72	15	3
73	73	13	1
74	73	14	2
75	73	15	3
76	81	15	1
77	81	13	2
78	81	14	3
79	83	15	1
80	83	14	2
81	83	13	3
82	97	13	1
83	97	15	2
84	97	14	3
120	105	19	1
121	105	20	2
122	105	21	3
123	105	22	4
124	105	23	5
125	106	19	1
126	106	20	2
127	106	21	3
128	106	22	4
129	106	23	5
130	107	19	1
131	107	20	2
132	107	21	3
133	107	22	4
134	107	23	5
135	108	19	1
136	108	20	2
137	108	21	3
138	108	22	4
139	108	23	5
140	109	19	1
141	109	20	2
142	109	21	3
143	109	22	4
144	109	23	5
145	110	19	1
146	110	20	2
147	110	21	3
148	110	22	4
149	110	23	5
150	111	19	1
151	111	20	2
152	111	22	3
153	111	21	4
154	111	23	5
155	118	28	1
156	118	29	2
157	118	30	3
158	149	15	1
159	149	13	2
160	149	14	3
161	152	23	1
162	152	19	2
163	152	20	3
164	152	22	4
165	152	21	5
166	311	14	1
167	311	13	2
168	311	15	3
169	313	23	1
170	313	19	2
171	313	22	3
172	313	21	4
173	313	20	5
174	321	15	1
175	321	13	2
176	321	14	3
177	334	14	1
178	334	13	2
179	334	15	3
180	367	15	1
181	367	14	2
182	367	13	3
183	373	15	1
184	373	14	2
185	373	13	3
186	377	19	1
187	377	22	2
188	377	21	3
189	377	23	4
190	377	20	5
191	379	15	1
192	379	13	2
193	379	14	3
194	386	14	1
195	386	15	2
196	386	13	3
197	406	15	1
198	406	14	2
199	406	13	3
200	435	14	1
201	435	15	2
202	435	13	3
203	436	20	1
204	436	22	2
205	436	23	3
206	436	19	4
207	436	21	5
208	439	14	1
209	439	15	2
210	439	13	3
211	443	21	1
212	443	23	2
213	443	22	3
214	443	19	4
215	443	20	5
216	485	15	1
217	485	14	2
218	485	13	3
219	511	13	1
220	511	14	2
221	511	15	3
222	516	14	1
223	516	13	2
224	516	15	3
225	524	14	1
226	524	15	2
227	524	13	3
228	533	13	1
229	533	15	2
230	533	14	3
231	539	13	1
232	539	14	2
233	539	15	3
234	556	13	1
235	556	14	2
236	556	15	3
237	558	14	1
238	558	15	2
239	558	13	3
240	560	14	1
241	560	13	2
242	560	15	3
243	562	14	1
244	562	15	2
245	562	13	3
246	563	14	1
247	563	15	2
248	563	13	3
249	564	14	1
250	564	15	2
251	564	13	3
252	565	13	1
253	565	15	2
254	565	14	3
255	566	15	1
256	566	13	2
257	566	14	3
258	567	14	1
259	567	15	2
260	567	13	3
261	568	14	1
262	568	15	2
263	568	13	3
264	569	15	1
265	569	13	2
266	569	14	3
267	570	15	1
268	570	14	2
269	570	13	3
270	571	14	1
271	571	15	2
272	571	13	3
273	572	15	1
274	572	14	2
275	572	13	3
276	573	14	1
277	573	15	2
278	573	13	3
279	574	15	1
280	574	14	2
281	574	13	3
282	576	15	1
283	576	14	2
284	576	13	3
285	577	14	1
286	577	15	2
287	577	13	3
288	578	15	1
289	578	13	2
290	578	14	3
291	579	13	1
292	579	14	2
293	579	15	3
294	580	13	1
295	580	15	2
296	580	14	3
297	582	13	1
298	582	15	2
299	582	14	3
300	583	14	1
301	583	15	2
302	583	13	3
303	585	13	1
304	585	14	2
305	585	15	3
306	586	13	1
307	586	14	2
308	586	15	3
309	587	14	1
310	587	13	2
311	587	15	3
312	590	14	1
313	590	13	2
314	590	15	3
315	591	15	1
316	591	13	2
317	591	14	3
318	597	13	1
319	597	15	2
320	597	14	3
321	600	14	1
322	600	15	2
323	600	13	3
324	674	13	1
325	674	14	2
326	674	15	3
327	685	13	1
328	685	15	2
329	685	14	3
330	722	15	1
331	722	13	2
332	722	14	3
\.


--
-- Data for Name: tiered_response; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "public"."tiered_response" ("id", "response_id", "answer_id", "tier") FROM stdin;
1	57	16	1
2	57	17	4
3	57	18	6
4	58	16	6
5	58	18	6
6	58	17	6
7	59	18	3
8	59	16	6
9	59	17	6
10	60	18	3
11	60	17	6
12	60	16	6
13	61	18	1
14	61	16	3
15	61	17	4
16	62	18	1
17	62	16	3
18	62	17	4
19	63	17	5
20	63	18	5
21	63	16	6
22	64	17	3
23	64	18	5
24	64	16	5
25	74	16	3
26	74	17	3
27	74	18	3
28	75	16	2
29	75	17	2
30	75	18	2
31	82	17	1
32	82	16	6
33	82	18	6
34	119	32	2
35	119	31	6
36	120	31	1
37	120	32	2
38	130	32	3
39	130	31	5
40	131	31	2
41	131	32	4
42	132	31	5
43	132	32	6
44	133	31	2
45	133	32	5
46	134	32	6
47	134	31	6
48	140	16	2
49	140	17	4
50	140	18	6
51	156	49	1
52	156	47	2
53	156	51	3
54	156	46	4
55	156	50	5
56	156	45	6
57	156	48	6
58	157	51	1
59	157	47	3
60	157	46	4
61	157	49	5
62	157	48	5
63	157	45	6
64	157	50	6
65	160	16	6
66	160	17	6
67	160	18	6
68	161	17	3
69	161	16	4
70	161	18	6
71	314	18	4
72	314	17	5
73	314	16	6
74	534	18	3
75	534	16	3
76	534	17	3
77	602	17	4
78	602	18	4
79	602	16	4
80	669	51	2
81	669	48	3
82	669	45	4
83	669	46	4
84	669	50	4
85	669	49	5
86	669	47	6
87	675	17	4
88	675	18	6
89	675	16	6
90	686	17	4
91	686	18	5
92	686	16	6
93	755	16	3
94	755	17	5
95	755	18	6
96	756	18	4
97	756	17	4
98	756	16	6
99	757	18	4
100	757	17	5
101	757	16	5
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY "storage"."buckets" ("id", "name", "owner", "created_at", "updated_at", "public", "avif_autodetection", "file_size_limit", "allowed_mime_types", "owner_id") FROM stdin;
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY "storage"."objects" ("id", "bucket_id", "name", "owner", "created_at", "updated_at", "last_accessed_at", "metadata", "version", "owner_id", "user_metadata") FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY "storage"."s3_multipart_uploads" ("id", "in_progress_size", "upload_signature", "bucket_id", "key", "version", "owner_id", "created_at", "user_metadata") FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY "storage"."s3_multipart_uploads_parts" ("id", "upload_id", "size", "part_number", "bucket_id", "key", "etag", "owner_id", "version", "created_at") FROM stdin;
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY "vault"."secrets" ("id", "name", "description", "secret", "key_id", "nonce", "created_at", "updated_at") FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('"auth"."refresh_tokens_id_seq"', 82, true);


--
-- Name: key_key_id_seq; Type: SEQUENCE SET; Schema: pgsodium; Owner: supabase_admin
--

SELECT pg_catalog.setval('"pgsodium"."key_key_id_seq"', 1, false);


--
-- Name: board_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."board_id_seq"', 9, true);


--
-- Name: comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."comment_id_seq"', 110, true);


--
-- Name: comment_report_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."comment_report_id_seq"', 6, true);


--
-- Name: discrete_response_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."discrete_response_id_seq"', 149, true);


--
-- Name: dislike_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."dislike_id_seq"', 120, true);


--
-- Name: like_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."like_id_seq"', 130, true);


--
-- Name: numeric_response_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."numeric_response_id_seq"', 474, true);


--
-- Name: poll_answer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."poll_answer_id_seq"', 55, true);


--
-- Name: poll_board_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."poll_board_id_seq"', 35, true);


--
-- Name: poll_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."poll_id_seq"', 30, true);


--
-- Name: poll_report_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."poll_report_id_seq"', 3, true);


--
-- Name: ranked_response_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."ranked_response_id_seq"', 332, true);


--
-- Name: response_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."response_id_seq"', 757, true);


--
-- Name: tiered_response_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."tiered_response_id_seq"', 101, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."user_id_seq"', 4, true);


--
-- PostgreSQL database dump complete
--

RESET ALL;
