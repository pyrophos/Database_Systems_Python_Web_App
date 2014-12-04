__author__ = 'Michael'

def get_title(cur, tid):
    cur.execute('''
        SELECT title, description, isbn, pub_date, page_count,
               author_name, edition_name, default_ed
        FROM titles
        JOIN editions USING (title_id)
        JOIN editions_authors USING (edition_id)
        JOIN authors USING (author_id)
        WHERE edition_id = %s
        ''', (tid,))
    # there will be 0 or 1 results
    result = cur.fetchone()
    if result is None:
        return None
    # Unpack the results
    title, description, isbn, pub_date, page_count, author_name, \
    edition_name, default_ed = result

    cur.execute('''
    SELECT cat_description
    FROM titles
    JOIN titles_categories USING (title_id)
    JOIN categories using (category_id)
    JOIN editions USING (title_id)
    WHERE edition_id = %s
            ''', (tid,))

    categories = []

    for (cat) in cur:
        categories.append(cat)

    cur.execute('''
    SELECT pub_name
    FROM publishers JOIN editions_publishers USING(publisher_id)
    JOIN editions USING(edition_id)
    WHERE edition_id = %s
        ''', (tid,))

    result = cur.fetchone()
    if result is None:
        return None
    # Unpack the results
    pub_name = result

    return {'title': title,
            'description': description,
            # 'created': creation_date,
            # 'created_by': created_by,
            'isbn': isbn,
            'pages': page_count,
            'authors': author_name,
            'edition': edition_name,
            'categories': categories,
            'def_ed': default_ed,
            'publisher': pub_name
            }
