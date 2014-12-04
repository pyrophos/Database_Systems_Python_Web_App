__author__ = 'Cramer'

from data import queries

def get_follower_pg_cnt(cur, user_id):
    cur.execute('''
                SELECT count(f.user_id) / 50 + 1
                FROM   follows f
                WHERE  f.follows in (select user_id
                                     from   users
                                     where  username = %s
                                    )
                AND    f.end_date is null
                ''', (user_id,))
    (follower_page_count,) = cur.fetchone()
    return follower_page_count

def get_followee_pg_cnt(cur, user_id):
    cur.execute('''
                SELECT count(f.follows) / 50 + 1
                FROM   follows f
                WHERE  f.user_id in (select user_id
                                    from   users
                                    where  username = %s
                                   )
                AND    f.end_date is null
                ''', (user_id,))
    (followee_page_count,) = cur.fetchone()
    return followee_page_count

def get_followers(cur, page, uid):
    cur.execute('''
                SELECT u.username, u.user_id, f.follows
                FROM   users u
                JOIN   follows f on u.user_id = f.user_id
                WHERE  f.follows in (select user_id
                                    from   users
                                    where  username = %s
                                   )
                AND    f.end_date is null
                ORDER BY u.username asc
                LIMIT 50 offset %s
                ''', (uid, ((page - 1) * 50)))
    followers_list = []
    for username, user_id, follows in cur:
        followers_list.append({'follower': username, 'uid': user_id, 'follows': follows})
    return followers_list

def get_followees(cur, page, user_id):
    cur.execute('''
                SELECT u.username uname, u.user_id uid, f.user_id follower
                FROM   users u
                JOIN   follows f on u.user_id = f.follows
                WHERE  f.user_id in (select a.user_id
                                    from   users a
                                    where  a.username = %s
                                   )
                AND    f.end_date is null
                ORDER BY u.username asc
                LIMIT 50 offset %s
                ''', (user_id, ((page - 1) * 50)))
    followees_list = []
    for uname, uid, follower in cur:
        followees_list.append({'follows': uname, 'uid': uid, 'follower': follower})
    return followees_list

def follow_user(cur, user_id, follows):
    cur.execute('''
                INSERT INTO follows (user_id, follows, creation_date, created_by, last_update_date, last_update_by, end_date)
                VALUES              (%s, %s, current_timestamp, 1, current_timestamp, 1, null)
                ''', (user_id, follows))

def unfollow(cur, user_id, unfollows):
    cur.execute('''
                UPDATE follows
                SET    end_date = current_date
                WHERE  user_id = (select a.user_id
                                    from   users a
                                    where  a.username = %s
                                   )
                AND    follows = (select b.user_id
                                    from   users b
                                    where  b.username = %s
                                   )
                ''', (user_id, unfollows))

def get_follow_status(cur, user_id, follower):
    cur.execute('''
                SELECT   COUNT(1) as count
                FROM     follows
                WHERE    user_id = (select a.user_id
                                    from   users a
                                    where  a.username = %s)
                AND      follows = (select b.user_id
                                    from   users b
                                    where  b.username = %s)
                AND      end_date is null
                ''', (user_id, follower))
    f = cur.fetchone()
    follower_check = f[0]

    return follower_check


