__author__ = 'Cramer'

from data import queries

def get_reviews_list(cur, user_id):
    cur.execute('''
                SELECT row_number() OVER (ORDER BY r.creation_date asc) as review_num,
                       r.review_id,
                       t.title,
                       to_char(r.creation_date, 'MM/DD/YYYY') creation_date,
                       (select count(review_like_id)
                        from   review_likes
                        where  review_id = r.review_id
                        and    end_date is null) num_likes
                FROM   reviews r
                JOIN   editions e USING (edition_id)
                JOIN   titles t   USING (title_id)
                WHERE  r.user_id = (select user_id
                                    from   users
                                    where  username = %s
                                   )
                AND    r.end_date is null
                ORDER  BY creation_date asc
                ''', (user_id,))

    reviews_list = []
    for review_num, review_id, title, creation_date, num_likes in cur:
        reviews_list.append({'review_num': review_num, 'review_id': review_id, 'title': title, 'creation_date': creation_date, 'num_likes': num_likes})
    return reviews_list

def get_reviews_pg_cnt(cur, user_id):
    cur.execute('''
                SELECT count(r.review_id) / 50 + 1
                FROM   reviews r
                WHERE  r.user_id = (select user_id
                                    from   users
                                    where  username = %s)
                AND    r.end_date is null
                ''', (user_id,))
    r = cur.fetchone()
    review_count = r[0]
    return review_count

def get_user_review(cur, review_id):
    cur.execute('''
                SELECT r.review_id,
                       r.user_id reviewer,
                       r.edition_id,
                       r.spoilers,
                       to_char(r.creation_date, 'MM/DD/YYYY'),
                       t.title,
                       r.review_text
                FROM   reviews r
                JOIN   editions e USING (edition_id)
                JOIN   titles t USING (title_id)
                WHERE  r.review_id = %s
                AND    r.end_date is null
                ''', (review_id,))
    review_info = cur.fetchone()
    if review_info is None:
        return None

    review_id, reviewer, edition_id, spoilers, creation_date, title, review_text = review_info

    return {'review_id': review_id,
            'reviewer': reviewer,
            'edition_id': edition_id,
            'spoilers': spoilers,
            'creation_date': creation_date,
            'title': title,
            'review_text': review_text}

def delete_review(cur, review_id):
    cur.execute('''
                UPDATE reviews
                SET    end_date = current_date
                WHERE  review_id = %s
                ''', (review_id,))

def get_author_names(cur, review_id):
    cur.execute('''
                SELECT a.author_name
                FROM   authors a
                JOIN   editions_authors ea USING (author_id)
                JOIN   reviews r USING (edition_id)
                WHERE  r.review_id = %s
                ''', (review_id,))
    author_list = []
    for (author_name,) in cur:
        author_list.append(author_name)
    return author_list

def get_likes(cur, review_id, user_id):
    cur.execute('''
                SELECT count(review_like_id)
                FROM   review_likes
                WHERE  review_id = %s
                AND    liked_by = %s
                AND    end_date is null
                ''', (review_id, user_id))
    r = cur.fetchone()
    like_count = r[0]
    return like_count

def like_review(cur, review_id, user_id):
    cur.execute('''
                INSERT INTO review_likes (review_id, liked_by, creation_date, created_by, last_update_date, last_update_by, end_date)
                VALUES                   (%s, %s, current_timestamp, %s, current_timestamp, %s, null)
                ''', (review_id, user_id, user_id, user_id))

def unlike_review(cur, review_id, user_id):
    cur.execute('''
                UPDATE review_likes
                SET    end_date = current_date
                WHERE  review_id = %s
                AND    liked_by = %s
                ''', (review_id, user_id))