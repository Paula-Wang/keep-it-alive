BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "flame" (
    "id" bigserial PRIMARY KEY,
    "currentHolder" text NOT NULL,
    "isAlive" boolean NOT NULL
);


--
-- MIGRATION VERSION FOR keep_it_alive
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('keep_it_alive', '20260922171552186', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260922171552186', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260910193913364-string-rate-limit-keys', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260910193913364-string-rate-limit-keys', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260824182354731', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182354731', "timestamp" = now();


COMMIT;
