CREATE TABLE "identities" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "users_id" integer, "provider" varchar(255), "uid" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar(255), "password_hash" varchar(255), "password_salt" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "name" varchar(255));
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20120316143814');

INSERT INTO schema_migrations (version) VALUES ('20120316144326');

INSERT INTO schema_migrations (version) VALUES ('20120319153913');

INSERT INTO schema_migrations (version) VALUES ('20120319154255');

INSERT INTO schema_migrations (version) VALUES ('20120319163837');
