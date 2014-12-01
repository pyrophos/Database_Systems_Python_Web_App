
CREATE TABLE roles (
  role_id          SERIAL PRIMARY KEY,
  description      VARCHAR(200) NOT NULL UNIQUE,
  creation_date    TIMESTAMP NOT NULL,
  last_update_date TIMESTAMP NOT NULL ,
  end_date         DATE
);


CREATE TABLE users (
  user_id     SERIAL PRIMARY KEY ,
  username    VARCHAR(20) NOT NULL UNIQUE,
  password    VARCHAR(60) NOT NULL ,
  email       VARCHAR(50) NOT NULL UNIQUE ,
  dob         DATE NOT NULL ,
  user_role   INTEGER NOT NULL REFERENCES roles,
  start_date  TIMESTAMP NOT NULL ,
  last_login  TIMESTAMP,
  end_date    DATE
);

CREATE TABLE follows (
  follow_id        SERIAL PRIMARY KEY ,
  user_id          INTEGER NOT NULL REFERENCES users,
  follows          INTEGER NOT NULL REFERENCES users,
  creation_date    TIMESTAMP NOT NULL ,
  created_by       INTEGER NOT NULL REFERENCES users,
  last_update_date TIMESTAMP NOT NULL ,
  last_update_by   INTEGER NOT NULL REFERENCES users,
  end_date         DATE
);

CREATE TABLE titles (
  title_id         SERIAL PRIMARY KEY ,
  title            VARCHAR(2000) NOT NULL ,
  description      VARCHAR(5000) ,
  orig_pub_year    INTEGER ,
  creation_date    TIMESTAMP NOT NULL ,
  created_by       INTEGER NOT NULL REFERENCES users,
  last_update_date TIMESTAMP NOT NULL ,
  last_update_by   INTEGER NOT NULL REFERENCES users,
  end_date         DATE
);

CREATE TABLE categories (
  category_id      SERIAL PRIMARY KEY ,
  cat_description  VARCHAR(200) NOT NULL ,
  creation_date    TIMESTAMP NOT NULL ,
  created_by       INTEGER NOT NULL REFERENCES users,
  last_update_date TIMESTAMP NOT NULL ,
  last_update_by   INTEGER NOT NULL REFERENCES users,
  end_date         DATE
);

CREATE TABLE titles_categories (
  title_cat_id     SERIAL PRIMARY KEY ,
  title_id         INTEGER NOT NULL REFERENCES titles ,
  category_id      INTEGER NOT NULL REFERENCES categories ,
  creation_date    TIMESTAMP NOT NULL ,
  created_by       INTEGER NOT NULL REFERENCES users ,
  last_update_date TIMESTAMP NOT NULL ,
  last_update_by   INTEGER NOT NULL REFERENCES users ,
  end_date         DATE
);

CREATE TABLE publishers (
  publisher_id     SERIAL PRIMARY KEY ,
  pub_name         VARCHAR(300) NOT NULL UNIQUE ,
  pub_location     VARCHAR(200) ,
  creation_date    TIMESTAMP NOT NULL ,
  created_by       INTEGER NOT NULL REFERENCES users ,
  last_update_date TIMESTAMP NOT NULL ,
  last_update_by   INTEGER NOT NULL REFERENCES users ,
  end_date         DATE
);

CREATE TABLE editions (
  edition_id       SERIAL PRIMARY KEY ,
  ISBN             VARCHAR(20) UNIQUE ,
  title_id         INTEGER NOT NULL REFERENCES titles ,
  page_count       INTEGER ,
  pub_date         DATE ,
  default_ed       VARCHAR(1) ,
  creation_date    TIMESTAMP NOT NULL ,
  created_by       INTEGER NOT NULL REFERENCES users ,
  last_update_date TIMESTAMP NOT NULL ,
  last_update_by   INTEGER NOT NULL REFERENCES users ,
  end_date         DATE
);

CREATE TABLE editions_publishers (
  ed_pub_id        SERIAL PRIMARY KEY ,
  edition_id       INTEGER NOT NULL REFERENCES editions ,
  publisher_id     INTEGER NOT NULL REFERENCES publishers ,
  created_by       INTEGER NOT NULL REFERENCES users ,
  creation_date    TIMESTAMP NOT NULL ,
  last_update_by   INTEGER NOT NULL REFERENCES users ,
  last_update_date TIMESTAMP ,
  end_date         DATE
);

CREATE TABLE authors (
  author_id        SERIAL PRIMARY KEY ,
  author_name      VARCHAR(500) NOT NULL ,
  creation_date    TIMESTAMP NOT NULL ,
  created_by       INTEGER NOT NULL REFERENCES users ,
  last_update_date TIMESTAMP ,
  last_update_by   INTEGER NOT NULL REFERENCES users ,
  end_date         DATE
);

CREATE TABLE editions_authors (
  ed_auth_id       SERIAL PRIMARY KEY ,
  edition_id       INTEGER NOT NULL REFERENCES editions ,
  author_id        INTEGER NOT NULL REFERENCES authors ,
  creation_date    TIMESTAMP NOT NULL ,
  created_by       INTEGER NOT NULL REFERENCES users ,
  last_update_date TIMESTAMP ,
  last_update_by   INTEGER NOT NULL REFERENCES users ,
  end_date         DATE
);

CREATE TABLE ratings (
  rating_id        SERIAL PRIMARY KEY ,
  rater_id         INTEGER NOT NULL REFERENCES users ,
  edition_id       INTEGER NOT NULL REFERENCES editions ,
  rating           INTEGER CHECK (rating < 6) NOT NULL ,
  creation_date    TIMESTAMP NOT NULL ,
  last_update_date TIMESTAMP ,
  last_update_by   INTEGER NOT NULL REFERENCES users ,
  end_date         DATE
);

CREATE TABLE reviews (
  review_id        SERIAL PRIMARY KEY ,
  user_id          INTEGER NOT NULL REFERENCES users ,
  edition_id       INTEGER NOT NULL REFERENCES editions ,
  review_text      TEXT ,
  spoilers         VARCHAR(1) NOT NULL DEFAULT 'N',
  creation_date    TIMESTAMP NOT NULL ,
  last_update_date TIMESTAMP ,
  last_update_by   INTEGER NOT NULL REFERENCES users ,
  end_date         DATE
);

CREATE TABLE reading_log (
  log_id           SERIAL PRIMARY KEY ,
  user_id          INTEGER NOT NULL REFERENCES users ,
  edition_id       INTEGER NOT NULL REFERENCES editions ,
  read_start_date  DATE ,
  read_end_date    DATE ,
  rating_id        INTEGER REFERENCES ratings ,
  review_id        INTEGER REFERENCES reviews ,
  creation_date    TIMESTAMP NOT NULL ,
  last_update_date TIMESTAMP ,
  last_update_by   INTEGER NOT NULL REFERENCES users,
  end_date         DATE
);

CREATE TABLE review_likes (
  review_like_id   SERIAL PRIMARY KEY ,
  review_id        INTEGER NOT NULL REFERENCES reviews ,
  liked_by         INTEGER NOT NULL REFERENCES users ,
  creation_date    TIMESTAMP NOT NULL ,
  created_by       INTEGER NOT NULL REFERENCES users ,
  last_update_date TIMESTAMP ,
  last_update_by   INTEGER NOT NULL REFERENCES users ,
  end_date         DATE
);

CREATE TABLE lists (
  list_id          SERIAL PRIMARY KEY ,
  list_title       VARCHAR(200) ,
  list_description VARCHAR(2000) ,
  public_list      VARCHAR(1) ,
  creation_date    TIMESTAMP NOT NULL ,
  created_by       INTEGER NOT NULL REFERENCES users ,
  last_update_date TIMESTAMP ,
  last_update_by   INTEGER NOT NULL REFERENCES users ,
  end_date         DATE
);

CREATE TABLE list_contents (
  list_content_id  SERIAL PRIMARY KEY ,
  list_id          INTEGER NOT NULL REFERENCES lists ,
  edition_id       INTEGER NOT NULL REFERENCES editions ,
  created_by       INTEGER NOT NULL REFERENCES users ,
  content_comments TEXT ,
  creation_date    TIMESTAMP ,
  last_update_by   INTEGER NOT NULL REFERENCES users ,
  last_update_date TIMESTAMP ,
  end_date         DATE
);

CREATE TABLE list_likes (
  list_like_id     SERIAL PRIMARY KEY ,
  list_id          INTEGER NOT NULL REFERENCES lists ,
  liked_by         INTEGER NOT NULL REFERENCES users ,
  creation_date    TIMESTAMP ,
  last_update_by   INTEGER NOT NULL REFERENCES users ,
  last_update_date TIMESTAMP ,
  end_date         DATE
);

CREATE TABLE table_lkups (
  table_lkup_id    SERIAL PRIMARY KEY ,
  table_name       VARCHAR(50) ,
  creation_date    TIMESTAMP ,
  created_by       INTEGER NOT NULL REFERENCES users ,
  last_update_date TIMESTAMP ,
  last_update_by   INTEGER NOT NULL REFERENCES users ,
  end_date         DATE
);

CREATE TABLE mod_log (
  mod_log_id       SERIAL PRIMARY KEY ,
  user_id          INTEGER NOT NULL REFERENCES users ,
  table_lkup_id    INTEGER NOT NULL REFERENCES table_lkups ,
  table_pk_id      INTEGER NOT NULL ,
  action           VARCHAR(50) ,
  creation_date    TIMESTAMP
);

CREATE VIEW editions_ratings_view AS
  (SELECT
            e.edition_id,
            t.title,
            avg(r.rating)      AVG_RATING,
            count(r.rating_id) NUMBER_OF_RATINGS
   FROM     editions e
   JOIN     titles t ON e.title_id = t.title_id
   JOIN     ratings r ON e.edition_id = r.edition_id
   GROUP BY e.edition_id, t.title
   ORDER BY AVG_RATING, NUMBER_OF_RATINGS
  );

CREATE VIEW titles_ratings_view AS
  (SELECT
            t.title_id,
            t.title,
            avg(r.rating) AVG_RATING,
            count(r.rating_id) NUMBER_OF_RATINGS
   FROM     titles t
   JOIN     editions e on t.title_id = e.title_id
   JOIN     ratings r on e.edition_id = r.edition_id
   GROUP BY t.title_id, t.title
   ORDER BY AVG_RATING, NUMBER_OF_RATINGS
  );

CREATE INDEX users_username_idx ON users(username);
CREATE INDEX users_email_idx ON users(email);
CREATE INDEX users_last_login_idx ON users(last_login);
CREATE INDEX users_end_date_idx ON users(end_date);

CREATE INDEX follows_user_idx ON follows(user_id);
CREATE INDEX follows_follows_idx ON follows(follow_id);
CREATE INDEX follows_end_date_idx ON follows(end_date);

CREATE INDEX titles_title_idx ON titles(lower(title));
CREATE INDEX titles_orig_pub_yr_idx ON titles(orig_pub_year);
CREATE INDEX titles_end_date_idx ON titles(end_date);

CREATE INDEX categories_desc_idx ON categories(cat_description);
CREATE INDEX categories_end_date_idx ON categories(end_date);

CREATE INDEX tit_cat_title_idx ON titles_categories(title_id);
CREATE INDEX tit_cat_cat_idx ON titles_categories(category_id);
CREATE INDEX tit_cat_end_date_idx ON titles_categories(end_date);

CREATE INDEX publishers_pub_name_idx ON publishers(lower(pub_name));
CREATE INDEX publishers_pub_location_idx ON publishers(pub_location);
CREATE INDEX publishers_end_date_idx ON publishers(end_date);

CREATE INDEX editions_ISBN_idx ON editions(ISBN);
CREATE INDEX editions_title_id_idx ON editions(title_id);
CREATE INDEX editions_pud_date_idx ON editions(pub_date);
CREATE INDEX editions_default_idx ON editions(default_ed);
CREATE INDEX editions_end_date_idx ON editions(end_date);

CREATE INDEX ed_pub_edition_id_idx ON editions_publishers(edition_id);
CREATE INDEX ed_pub_pub_id_idx ON editions_publishers(publisher_id);
CREATE INDEX ed_pub_end_date_idx ON editions_publishers(end_date);

CREATE INDEX authors_name_idx ON authors(lower(author_name));
CREATE INDEX authors_end_date_idx ON authors(end_date);

CREATE INDEX ed_auth_ed_id_idx ON editions_authors(edition_id);
CREATE INDEX ed_auth_auth_id_idx ON editions_authors(author_id);
CREATE INDEX ed_auth_end_date_idx ON editions_authors(end_date);

CREATE INDEX ratings_rater_idx ON ratings(rater_id);
CREATE INDEX ratings_ed_idx ON ratings(edition_id);
CREATE INDEX ratings_rating_idx ON ratings(rating);
CREATE INDEX ratings_end_date_idx ON ratings(end_date);

CREATE INDEX reviews_user_idx ON reviews(user_id);
CREATE INDEX reviews_ed_idx ON reviews(edition_id);
CREATE INDEX reviews_spoilers_idx ON reviews(spoilers);
CREATE INDEX reviews_end_date_idx ON reviews(end_date);

CREATE INDEX reading_log_user_idx ON reading_log(user_id);
CREATE INDEX reading_log_ed_idx ON reading_log(edition_id);
CREATE INDEX reading_log_read_st_idx ON reading_log(read_start_date);
CREATE INDEX reading_log_read_end_idx ON reading_log(read_end_date);
CREATE INDEX reading_log_rating_idx ON reading_log(rating_id);
CREATE INDEX reading_log_review_idx ON reading_log(review_id);
CREATE INDEX reading_log_end_date_idx ON reading_log(end_date);

CREATE INDEX review_likes_review_idx ON review_likes(review_id);
CREATE INDEX review_likes_liked_idx ON review_likes(liked_by);
CREATE INDEX review_likes_end_date_idx ON review_likes(end_date);

CREATE INDEX lists_title_idx ON lists(lower(list_title));
CREATE INDEX lists_public_idx ON lists(public_list);
CREATE INDEX lists_end_date_idx ON lists(end_date);

CREATE INDEX list_contents_list_idx ON list_contents(list_id);
CREATE INDEX list_contents_ed_idx ON list_contents(edition_id);
CREATE INDEX list_contents_created_idx ON list_contents(created_by);
CREATE INDEX list_contents_end_date_idx ON list_contents(end_date);

CREATE INDEX list_likes_list_idx ON list_likes(list_id);
CREATE INDEX list_likes_liked_idx ON list_likes(liked_by);
CREATE INDEX list_likes_end_date_idx ON list_likes(end_date);

CREATE INDEX mod_log_user_idx ON mod_log(user_id);
CREATE INDEX mod_log_table_idx ON mod_log(table_lkup_id);
CREATE INDEX mod_log_pk_idx ON mod_log(table_pk_id);
CREATE INDEX mod_log_action_idx ON mod_log(action);
CREATE INDEX mod_log_create_date_idx ON mod_log(creation_date);


COMMIT;
ANALYZE;


