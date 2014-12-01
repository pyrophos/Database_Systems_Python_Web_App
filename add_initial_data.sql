
-- Lets add some initial data --

--- Roles ---
INSERT INTO roles (description, creation_date, last_update_date, end_date )
VALUES ('admin', current_date, current_timestamp, null);

INSERT INTO roles (description, creation_date, last_update_date, end_date )
VALUES ('user', current_date, current_timestamp, null);

--- Users ---
INSERT INTO users (username, password, email, dob, user_role, start_date, last_login, end_date)
VALUES ('admin', '$2a$12$k02bvqdEfj1oralyGJ6Hs.4f3KJBZre33/vbL9EZ9E/yPj/tBntAO', 'admin@admin.y', current_date, 1 , current_date, current_timestamp, null);

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


COMMIT;

