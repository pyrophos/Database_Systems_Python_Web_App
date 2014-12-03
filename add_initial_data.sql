
-- Lets add some initial data --

--- Roles ---
INSERT INTO roles (description, creation_date, last_update_date, end_date )
VALUES ('admin', current_date, current_timestamp, null);

INSERT INTO roles (description, creation_date, last_update_date, end_date )
VALUES ('user', current_date, current_timestamp, null);


--- Users ---
INSERT INTO users (username, password, email, dob, user_role, start_date, last_login, end_date)
VALUES ('admin', '$2a$12$k02bvqdEfj1oralyGJ6Hs.4f3KJBZre33/vbL9EZ9E/yPj/tBntAO', 'admin@admin.y', current_date, 1 , current_date, current_timestamp, null);

INSERT INTO users (username, password, email, dob, user_role, start_date, last_login, end_date)
VALUES ('Bob', '$2a$12$k02bvqdEfj1oralyGJ6Hs.4f3KJBZre33/vbL9EZ9E/yPj/tBntAO', 'bob@example.com', current_date, 2 , current_date, current_timestamp, null);

INSERT INTO users (username, password, email, dob, user_role, start_date, last_login, end_date)
VALUES ('Jane', '$2a$12$k02bvqdEfj1oralyGJ6Hs.4f3KJBZre33/vbL9EZ9E/yPj/tBntAO', 'jane@example.com', current_date, 2 , current_date, current_timestamp, null);

INSERT INTO users (username, password, email, dob, user_role, start_date, last_login, end_date)
VALUES ('Mike', '$2a$12$k02bvqdEfj1oralyGJ6Hs.4f3KJBZre33/vbL9EZ9E/yPj/tBntAO', 'mike@example.com', current_date, 2 , current_date, current_timestamp, null);


--- Authors ---
INSERT INTO authors (author_name, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES ('William Shakerspear', current_timestamp, 1, current_timestamp, 1, null);

INSERT INTO authors (author_name, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES ('Brian Eno', current_timestamp, 1, current_timestamp, 1, null);

INSERT INTO authors (author_name, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES ('Billy Corgan', current_timestamp, 1, current_timestamp, 1, null);

INSERT INTO authors (author_name, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES ('Cheech and Chong', current_timestamp, 1, current_timestamp, 1, null);


--- Categories ---
INSERT INTO categories (cat_description, creation_date, created_by , last_update_date , last_update_by, end_date)
VALUES ('Horror', current_date, 1 , current_date, 1, null);

INSERT INTO categories (cat_description, creation_date, created_by , last_update_date , last_update_by, end_date)
VALUES ('Comedy', current_date, 1 , current_date, 1, null);

INSERT INTO categories (cat_description, creation_date, created_by , last_update_date , last_update_by, end_date)
VALUES ('Childrens', current_date, 1 , current_date, 1, null);

INSERT INTO categories (cat_description, creation_date, created_by , last_update_date , last_update_by, end_date)
VALUES ('Scientific', current_date, 1 , current_date, 1, null);

INSERT INTO categories (cat_description, creation_date, created_by , last_update_date , last_update_by, end_date)
VALUES ('Fiction', current_date, 1 , current_date, 1, null);

INSERT INTO categories (cat_description, creation_date, created_by , last_update_date , last_update_by, end_date)
VALUES ('Nonfiction', current_date, 1 , current_date, 1, null);


--- Book Titles ---
INSERT INTO titles (title, description, orig_pub_year, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES ('Demo Book 1', 'This is a demonstration book', 2014, current_date, 1, current_timestamp, 1, null);

INSERT INTO titles (title, description, orig_pub_year, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES ('Demo Book 2', 'This is a demonstration book', 2014, current_date, 1, current_timestamp, 1, null);

INSERT INTO titles (title, description, orig_pub_year, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES ('Demo Book 3', 'This is a demonstration book', 2014, current_date, 1, current_timestamp, 1, null);

INSERT INTO titles (title, description, orig_pub_year, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES ('Moby Dick', 'A crazy man chases a whale', 1901, current_date, 1, current_timestamp , 1, null);


--- Book Title Categories ---
INSERT INTO titles_categories (title_id, category_id, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES (1, 1, current_date, 1, current_timestamp, 1, null);

INSERT INTO titles_categories (title_id, category_id, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES (1, 2, current_date, 1, current_timestamp, 1, null);

INSERT INTO titles_categories (title_id, category_id, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES (2, 1, current_date, 1, current_timestamp, 1, null);

INSERT INTO titles_categories (title_id, category_id, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES (3, 3, current_date, 1, current_timestamp, 1, null);

INSERT INTO titles_categories (title_id, category_id, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES (3, 2, current_date, 1, current_timestamp, 1, null);

INSERT INTO titles_categories (title_id, category_id, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES (3, 1, current_date, 1, current_timestamp, 1, null);


--- Publishers ---
INSERT INTO publishers (pub_name, pub_location, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES ('Demo Publisher 1', 'Austin, TX', current_timestamp, 1, current_timestamp, 1, null);

INSERT INTO publishers (pub_name, pub_location, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES ('Demo Publisher 2', 'Austin, TX', current_timestamp, 1, current_timestamp, 1, null);

INSERT INTO publishers (pub_name, pub_location, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES ('Demo Publisher 3', 'Austin, TX', current_timestamp, 1, current_timestamp, 1, null);

INSERT INTO publishers (pub_name, pub_location, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES ('Demo Publisher 4', 'Austin, TX', current_timestamp, 1, current_timestamp, 1, null);


--- Editions ---
INSERT INTO editions (ISBN, title_id, page_count, pub_date, default_ed, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES ('10000000000000000000', 1, null, null, null, current_timestamp, 1, current_timestamp, 1, null);

INSERT INTO editions (ISBN, title_id, page_count, pub_date, default_ed, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES ('20000000000000000000', 2, null, null, null, current_timestamp, 1, current_timestamp, 1, null);

INSERT INTO editions (ISBN, title_id, page_count, pub_date, default_ed, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES ('30000000000000000000', 3, null, null, null, current_timestamp, 1, current_timestamp, 1, null);

--- editions_publishers ---
INSERT INTO editions_publishers (edition_id, publisher_id, created_by, creation_date, last_update_by, last_update_date, end_date)
VALUES (1, 1, 1, current_timestamp, 1, current_timestamp, null);

INSERT INTO editions_publishers (edition_id, publisher_id, created_by, creation_date, last_update_by, last_update_date, end_date)
VALUES (1, 2, 1, current_timestamp, 1, current_timestamp, null);

INSERT INTO editions_publishers (edition_id, publisher_id, created_by, creation_date, last_update_by, last_update_date, end_date)
VALUES (2, 3, 1, current_timestamp, 1, current_timestamp, null);

INSERT INTO editions_publishers (edition_id, publisher_id, created_by, creation_date, last_update_by, last_update_date, end_date)
VALUES (3, 4, 1, current_timestamp, 1, current_timestamp, null);


--- lists ---
INSERT INTO lists (list_title, list_description, public_list, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES ('Demo List 1', 'List description which is very longggggggggggggggggg', '1', current_timestamp, 1, current_timestamp, 1, null);

INSERT INTO lists (list_title, list_description, public_list, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES ('Demo List 2', 'List description which is very longggggggggggggggggg', '1', current_timestamp, 1, current_timestamp, 1, null);

INSERT INTO lists (list_title, list_description, public_list, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES ('Demo List 3', 'List description which is very longggggggggggggggggg', '1', current_timestamp, 1, current_timestamp, 1, null);


--- ratings ---
INSERT INTO ratings (rater_id, edition_id, rating, creation_date, last_update_date, last_update_by, end_date)
VALUES (1, 1, 3, current_timestamp, current_timestamp, 1, null);

INSERT INTO ratings (rater_id, edition_id, rating, creation_date, last_update_date, last_update_by, end_date)
VALUES (2, 1, 3, current_timestamp, current_timestamp, 1, null);

INSERT INTO ratings (rater_id, edition_id, rating, creation_date, last_update_date, last_update_by, end_date)
VALUES (2, 1, 3, current_timestamp, current_timestamp, 1, null);

INSERT INTO ratings (rater_id, edition_id, rating, creation_date, last_update_date, last_update_by, end_date)
VALUES (2, 1, 3, current_timestamp, current_timestamp, 1, null);

INSERT INTO ratings (rater_id, edition_id, rating, creation_date, last_update_date, last_update_by, end_date)
VALUES (2, 1, 3, current_timestamp, current_timestamp, 1, null);


--- reviews ---
INSERT INTO reviews (user_id, edition_id, review_text, spoilers, creation_date, last_update_date, last_update_by, end_date)
VALUES (2, 1, 'I do not, would not, could not, like green eggs and ham sam-i-am!', 'N', current_timestamp, current_timestamp, 1, null);

INSERT INTO reviews (user_id, edition_id, review_text, spoilers, creation_date, last_update_date, last_update_by, end_date)
VALUES (2, 1, 'It was great!', 'N', current_timestamp, current_timestamp, 1, null);

INSERT INTO reviews (user_id, edition_id, review_text, spoilers, creation_date, last_update_date, last_update_by, end_date)
VALUES (3, 1, 'It was so-so...', 'N', current_timestamp, current_timestamp, 1, null);

INSERT INTO reviews (user_id, edition_id, review_text, spoilers, creation_date, last_update_date, last_update_by, end_date)
VALUES (2, 1, 'I hated this book, dont read it!', 'N', current_timestamp, current_timestamp, 1, null);


--- reading_log ---
INSERT INTO reading_log (user_id, edition_id, read_start_date, read_end_date, rating_id, review_id, creation_date, last_update_date, last_update_by, end_date)
VALUES (1, 1, current_date, current_date, 1, 1, current_timestamp, current_timestamp, 1, null);

INSERT INTO reading_log (user_id, edition_id, read_start_date, read_end_date, rating_id, review_id, creation_date, last_update_date, last_update_by, end_date)
VALUES (2, 1, current_date, current_date, 3, 1, current_timestamp, current_timestamp, 1, null);

INSERT INTO reading_log (user_id, edition_id, read_start_date, read_end_date, rating_id, review_id, creation_date, last_update_date, last_update_by, end_date)
VALUES (3, 1, current_date, current_date, 2, 1, current_timestamp, current_timestamp, 1, null);


--- review_likes ---
INSERT INTO review_likes (review_id, liked_by, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES (1, 1, current_timestamp, 1, current_timestamp, 1, null);

INSERT INTO review_likes (review_id, liked_by, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES (2, 2, current_timestamp, 1, current_timestamp, 1, null);

INSERT INTO review_likes (review_id, liked_by, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES (3, 3, current_timestamp, 1, current_timestamp, 1, null);


--- list_contents ---
INSERT INTO list_contents (list_id, edition_id, created_by, content_comments, creation_date, last_update_by, last_update_date, end_date)
VALUES (1, 1, 1, 'This is a comment', current_timestamp, 1, current_timestamp, null);

INSERT INTO list_contents (list_id, edition_id, created_by, content_comments, creation_date, last_update_by, last_update_date, end_date)
VALUES (2, 1, 1, 'This is a comment', current_timestamp, 1, current_timestamp, null);

INSERT INTO list_contents (list_id, edition_id, created_by, content_comments, creation_date, last_update_by, last_update_date, end_date)
VALUES (3, 1, 1, 'This is a comment', current_timestamp, 1, current_timestamp, null);



--- list_likes ---
INSERT INTO list_likes (list_id, liked_by, creation_date, last_update_by, last_update_date, end_date)
VALUES (1, 1, current_timestamp, 1, current_timestamp, null);

INSERT INTO list_likes (list_id, liked_by, creation_date, last_update_by, last_update_date, end_date)
VALUES (1, 2, current_timestamp, 1, current_timestamp, null);

INSERT INTO list_likes (list_id, liked_by, creation_date, last_update_by, last_update_date, end_date)
VALUES (2, 3, current_timestamp, 1, current_timestamp, null);

INSERT INTO list_likes (list_id, liked_by, creation_date, last_update_by, last_update_date, end_date)
VALUES (2, 3, current_timestamp, 1, current_timestamp, null);

INSERT INTO list_likes (list_id, liked_by, creation_date, last_update_by, last_update_date, end_date)
VALUES (3, 4, current_timestamp, 1, current_timestamp, null);


--- editions_authors ---
INSERT INTO editions_authors (edition_id, author_id, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES (1, 1, current_timestamp, 1, current_timestamp, 1, null);

INSERT INTO editions_authors (edition_id, author_id, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES (1, 2, current_timestamp, 1, current_timestamp, 1, null);

INSERT INTO editions_authors (edition_id, author_id, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES (1, 3, current_timestamp, 1, current_timestamp, 1, null);

INSERT INTO editions_authors (edition_id, author_id, creation_date, created_by, last_update_date, last_update_by, end_date)
VALUES (1, 4, current_timestamp, 1, current_timestamp, 1, null);

COMMIT;

