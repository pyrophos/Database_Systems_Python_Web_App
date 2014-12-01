#!/usr/bin/env python

import json
import easypg

with open('authors.json') as af:
    author_ids = {}
    with easypg.cursor() as cur:
        for line in af:
            author = json.loads(line.strip())
            author_key = author['key']
            print 'found author', author_key
            cur.execute('''
            INSERT INTO authors(author_name, creation_date, created_by, last_update_date, last_update_by)
            VALUES (%s, CURRENT_TIMESTAMP, 1, CURRENT_TIMESTAMP, 1)
            RETURNING author_id
                ''',(author['name'],))
            tid = cur.fetchone()#get article id from insert
            author_ids[author_key]= tid

with open('works.json') as af:
    for line in af:
        work = json.loads(line.strip())
        work_key = work['key']
        print 'found work', work_key
        # put the work in your database


with open('books.json') as af:
    book_ids= {}
    with easypg.cursor() as cur:
        for line in af:
            book = json.loads(line.strip())
            book_key = book['key']
            print 'found book', book_key
            cur.execute('''
            INSERT INTO titles(title, creation_date, created_by, last_update_date, last_update_by)
            VALUES (%s, CURRENT_TIMESTAMP, 1, CURRENT_TIMESTAMP, 1)
            RETURNING title_id
                ''',(book['title'],))
            tid = cur.fetchone()#get article id from insert
            book_ids[book_key]= tid
