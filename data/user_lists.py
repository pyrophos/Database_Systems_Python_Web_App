__author__ = 'Michael'


def get_all_user_list(cur, user_id):
    """
    Get all lists user_id has stored in database .
    :param cur: the database cursor
    :return: a list of dictionaries of article IDs and titles
    """

    cur.execute('''
        SELECT list_id, list_title
        FROM lists
        WHERE created_by = %s
    ''', (user_id, ))
    user_list = []
    for list_id, list_title in cur:
         user_list.append({'list_id': list_id, 'list_title': list_title})
    return  user_list

def add_list(cur, user_id, title, description, isPublic):
    cur.execute('''
        INSERT INTO lists (list_title, list_description, public_list, creation_date, created_by,
          last_update_date, last_update_by, end_date)
        VALUES ( %s, %s, %s, current_timestamp , %s, current_timestamp , %s, null)
    ''', ( title, description, isPublic, user_id, user_id))

def get_books_in_list(cur, list_id):
    cur.execute('''
    SELECT title
    FROM titles JOIN editions USING (title_id)
    JOIN list_contents USING (edition_id)
    WHERE list_id = %s
    ''', (list_id, ))

    book_list = []
    for title in cur:
        book_list.append({'title': title})
    return book_list

def delete_list(cur, list_id):
    cur.execute('''
    DELETE FROM lists
    WHERE list_id = %s;
    ''', (list_id,))