__author__ = 'Cramer'

def get_friend_activity(cur, user_id):
    cur.execute('''
                SELECT x.category,
                       x.friend,
                       x.other_person,
                       to_char(x.creation_date, 'MM/DD/YYYY') creation_date,
                       x.object,
                       x.generic_field_1
                FROM (SELECT
                        'REVIEW'   category,
                        u.username friend,
                        NULL       other_person,
                        r.creation_date,
                        t.title AS object,
                        r.review_id generic_field_1
                      FROM reviews r
                        JOIN editions e USING (edition_id)
                        JOIN titles t USING (title_id)
                        JOIN users u USING (user_id)
                      WHERE r.user_id IN (SELECT
                                            f.follows
                                          FROM follows f
                                          WHERE f.user_id = %s)
                      AND r.end_date IS NULL
                      UNION
                      SELECT
                        'REVIEW_LIKE' category,
                        u.username    friend,
                        u2.username    other_person,
                        rl.creation_date,
                        t.title AS    object,
                        r.review_id generic_field_1
                      FROM review_likes rl
                        JOIN users u ON rl.liked_by = u.user_id
                        JOIN reviews r USING (review_id)
                        JOIN users u2 ON r.user_id = u2.user_id
                        JOIN editions e USING (edition_id)
                        JOIN titles t USING (title_id)
                      WHERE rl.liked_by IN (SELECT
                                              f.follows
                                            FROM follows f
                                            WHERE f.user_id = %s)
                      AND rl.end_date is null
                      UNION
                      SELECT 'FOLLOW' category,
                             u.username friend,
                             u2.username other_person,
                             f.creation_date,
                             null as object,
                             null generic_field_1
                      FROM   follows f
                      JOIN   users u on f.user_id = u.user_id
                      JOIN   users u2 on f.follows = u2.user_id
                      WHERE  f.user_id in (select f2.follows
                                           from follows f2
                                           where f2.user_id = %s)
                      AND    f.end_date is null
                      UNION
                      SELECT 'LIST' category,
                             u.username friend,
                             null other_person,
                             l.creation_date,
                             l.list_title as object,
                             l.list_id generic_field_1
                      FROM   lists l
                      JOIN   users u on l.created_by = u.user_id
                      WHERE  l.created_by in (select f.follows
                                              from   follows f
                                              where  f.user_id = %s)
                      AND    l.end_date is null
                      UNION
                      SELECT 'LIST_LIKE' category,
                             u.username friend,
                             u2.username other_person,
                             ll.creation_date,
                             l.list_title as object,
                             l.list_id generic_field_1
                      FROM   list_likes ll
                      JOIN   users u on ll.liked_by = u.user_id
                      JOIN   lists l USING (list_id)
                      JOIN   users u2 on l.created_by = u2.user_id
                      WHERE  ll.liked_by in (select f.follows
                                            from   follows f
                                            where  f.user_id = %s)
                      AND    ll.end_date is null
                      UNION
                      SELECT 'LOG' category,
                             u.username friend,
                             null other_person,
                             rl.creation_date,
                             t.title as object,
                             t.title_id generic_field_1
                      FROM   reading_log rl
                      JOIN   users u on rl.user_id = u.user_id
                      JOIN   editions e USING (edition_id)
                      JOIN   titles t USING (title_id)
                      WHERE  rl.user_id in (select f.follows
                                            from   follows f
                                            where  f.user_id = %s)
                      UNION
                      SELECT 'RATING' category,
                             u.username friend,
                             t.title other_person,
                             r.creation_date,
                             r.rating::varchar as object,
                             t.title_id generic_field_1
                      FROM   ratings r
                      JOIN   users u on r.rater_id = u.user_id
                      JOIN   editions e on r.edition_id = e.edition_id
                      JOIN   titles t on e.title_id = t.title_id
                      WHERE  r.rater_id in (select f.follows
                                            from   follows f
                                            where  f.user_id = %s)
                ) x
                ORDER BY x.creation_date desc
                LIMIT 100
                ''', (user_id, user_id, user_id, user_id, user_id, user_id, user_id))
    activity_list = []
    for category, friend, other_person, creation_date, object, generic_field_1 in cur:
        activity_list.append({'category': category, 'friend': friend,
                              'other_person': other_person, 'creation_date': creation_date,
                              'object': object, 'generic_field_1': generic_field_1})
    return activity_list
